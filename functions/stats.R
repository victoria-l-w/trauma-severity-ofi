make_stats <-function(df) {

  model <- glm(ofi ~ score, family="binomial", data = df)
  
  ## Sets up prediction and performance objects
  pred.model<- predict(model, type="response")
  pred <- prediction(pred.model, df$ofi)

  perf <- performance(pred, "tpr", "fpr") ## ROC
  auc <- unlist(slot(performance(pred, "auc"), "y.values")) ## AUC
  auc <- round(auc, digits = 2)
  proc <- roc(ofi ~ score, data = df) ## This is so I can use the pROC package to calculate AUC CI
  auc.ci <- round(ci.auc(proc), digits = 2)
  
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
  ## confint.default is confusing because when I do level=0.95, the output says "97.5%" and "2.5%"
  ## So I changed it to 0.90 because then it gives 95%/5%
  ## Really not sure if this is the correct function to use or if I'm using it correctly
  or <- round(exp(cbind("or" = coef(model), confint.default(model, level = 0.90))), digits = 2)
  or.p <- round(summary(model)$coefficients[2,4], digits = 2) ## Taking the p-value from glm()
  
  ## Summary of the things I should now have:
  ## model = the logistic regression model
  ## perf = the ROC
  ## auc = the AUC for the ROC
  ## auc.ci = the CI for the AUC
  ## acc = a plottable accuracy/cutoff
  ## ici = a number for ICI
  ## or = a vector containing the OR and the CI 
  ## or.p = the p-value for the OR 
  ## acc.nrs = the accuracy and cutoff at the highest accuracy
  
  ## return all the stats that we've created as a single list; this seemed more efficient than having multiple different functions that do similar things
  stats.ret <- list(model = model, perf = perf, auc = auc, acc = acc, ici = ici, auc.ci = auc.ci, or = or, or.p = or.p, acc.nrs = acc.nrs)
  return(stats.ret)
}
