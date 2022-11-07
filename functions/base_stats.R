base_stats <-function(df) {
  
  model <- glm(ofi ~ score, family="binomial", data = df)
  
  ## Sets up prediction and performance objects
  pred.model<- predict(model, type="response")
  pred <- prediction(pred.model, df$ofi)
  
  ## roc/auc
  roc <- roc(ofi ~ score, data = df) ## pROC
  auc <- auc(roc)
  auc.ci <- round(ci.auc(roc), digits = 2)
  
  ## Console output: >With at least 1000 observations, using mgcv::gam instead of loess to calculate ICI.
  ici <- ici(pred.model, df$ofi)
  ici <- round(ici, digits = 2)
  
  ## Accuracy things
  acc <- performance(pred, measure = "acc") ## plottable
  ind <- which.max(slot(acc, "y.values")[[1]] ) ## find the index of the highest accuracy
  acc.max <- slot(acc, "y.values")[[1]][ind] ## stores the highest accuracy
  acc.max <- round(acc.max, digits = 2)
  cutoff <- slot(acc, "x.values")[[1]][ind] ## stores the cutoff at the highest accuracy
  cutoff <- round(cutoff, digits = 2)
  acc.nrs <- c(acc.max = acc.max, co = cutoff) ## make a vector to return
  
  ## makes a vector with the OR and the upper/lower bounds of the CI
  sum <- summary(model)
  or <- round(exp(sum$coefficients[2,1]), digits = 2)
  or.ci <- round(exp(confint.default(model, level = 0.90)), digits = 2)
  or.p <- round(sum$coefficients[2,4], digits = 2) ## Taking the p-value from glm()
  
  ## Summary of the things I should now have:
  ## model = the logistic regression model
  ## roc = the ROC
  ## auc = the AUC for the ROC
  ## auc.ci = the CI for the AUC
  ## acc = the highest accuracy + the cutoff at that accuracy
  ## ici = a number for ICI
  ## or = a vector containing the OR and the CI 
  ## or.ci = 95% CI of the OR
  ## or.p = the p-value for the OR 
  ## acc.nrs = the accuracy and cutoff at the highest accuracy
  
  ## return all the stats that we've created as a single list; this seemed more efficient than having multiple different functions that do similar things
  stats.ret <- list(
    model = model, 
    roc = roc, 
    auc = auc, 
    acc = acc, 
    ici = ici, 
    auc.ci = auc.ci, 
    or = or, 
    or.ci = or.ci,
    or.p = or.p, 
    acc.nrs = acc.nrs 
  )
  
  return(stats.ret)
}
