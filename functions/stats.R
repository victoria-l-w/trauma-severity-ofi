make_stats <-function(df) {

  model <- glm(ofi ~ score, family="binomial", data = df)
  
  ## Sets up prediction and performance objects
  pred.model<- predict(model, type="response")
  pred <- prediction(pred.model, df$ofi)
  
  roc <- roc(ofi ~ score, data = df) ## pROC
  auc <- auc(roc)
  auc.ci <- round(ci.auc(roc), digits = 2)

  ## The console output of this says that it uses "mgcv::gam instead of loess to calculate ICI"
  ici <- ici(pred.model, df$ofi)
  ici <- round(ici, digits = 2)

  ## Accuracy things
  acc <- performance(pred, measure = "acc") ## This is plottable
  ind <- which.max( slot(acc, "y.values")[[1]] ) ## Find the index of the highest accuracy
  acc.max <- slot(acc, "y.values")[[1]][ind] ## Stores the highest accuracy
  acc.max <- round(acc.max, digits = 2)
  cutoff <- slot(acc, "x.values")[[1]][ind] ## Stores the cutoff at the highest accuracy
  cutoff <- round(cutoff, digits = 2)
  acc.nrs <- c(acc.max = acc.max, co = cutoff) ## Make a vector to return
  
  ## This makes a vector with the OR and the upper/lower bounds of the CI
  or <- round(exp(cbind("or" = coef(model), confint.default(model, level = 0.90))), digits = 2)
  or.p <- round(summary(model)$coefficients[2,4], digits = 2) ## Taking the p-value from glm()
  
  ## Summary of the things I should now have:
  ## model = the logistic regression model
  ## roc = the ROC
  ## auc = the AUC for the ROC
  ## auc.ci = the CI for the AUC
  ## acc = a plottable accuracy/cutoff
  ## ici = a number for ICI
  ## or = a vector containing the OR and the CI 
  ## or.p = the p-value for the OR 
  ## acc.nrs = the accuracy and cutoff at the highest accuracy
  
  ## return all the stats that we've created as a single list; this seemed more efficient than having multiple different functions that do similar things
  stats.ret <- list(model = model, roc = roc, auc = auc, acc = acc, ici = ici, auc.ci = auc.ci, or = or, or.p = or.p, acc.nrs = acc.nrs)
  return(stats.ret)
}
