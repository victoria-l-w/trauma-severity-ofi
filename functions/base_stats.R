base_stats <-function(df) {
  
  model <- glm(ofi ~ score, family="binomial", data = df)
  pred.model<- predict(model, type="response")
  pred <- prediction(pred.model, df$ofi)
  
  ## OR
  sum <- summary(model)
  or <- exp(sum$coefficients[2,1])
  or.ci <- exp(confint.default(model, level = 0.90))
  or.ci.lo <- or.ci[2,1]
  or.ci.hi <- or.ci[2,2]
  or.p <- format(signif(sum$coefficients[2,4], 1), scientific = FALSE)
  
  ## ROC/AUC with pROC
  roc <- suppressMessages(roc(ofi ~ score, data = df))
  auc <- auc(roc)
  auc.ci <- ci.auc(roc)
  auc.ci.lo <- auc.ci[1]
  auc.ci.hi <- auc.ci[3]
  
  ## Console output: >With at least 1000 observations, using mgcv::gam instead of loess to calculate ICI.
  ici <- suppressMessages(ici(pred.model, df$ofi))
  ici <- ici
  
  ## accuracy max + cutoff
  acc <- performance(pred, measure = "acc") ## plottable
  ind <- which.max(slot(acc, "y.values")[[1]]) ## find the index of the highest accuracy
  acc.max <- slot(acc, "y.values")[[1]][ind] ## stores the highest accuracy
  acc.max <- acc.max[[1]]
  acc.co <- slot(acc, "x.values")[[1]][ind] ## stores the cutoff at the highest accuracy
  acc.co <- acc.co[[1]]
  
  numerics <- c(
    auc = auc, 
    ici = ici, 
    auc.ci.lo = auc.ci.lo,
    auc.ci.hi = auc.ci.hi,
    or = or, 
    or.ci.lo = or.ci.lo,
    or.ci.hi = or.ci.hi,
    acc.max = acc.max,
    acc.co = acc.co
  )
  
  numerics <- lapply(numerics, as.numeric)
  numerics <- lapply(numerics, signif, digits = 2)
  
  out <- list(
    model = model, 
    roc = roc, 
    acc = acc,
    or.p = or.p
  )
  
  out <- append(out, numerics)
  
  return(out)
}
