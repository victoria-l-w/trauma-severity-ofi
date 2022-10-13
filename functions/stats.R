make_stats <-function(df) {

  ## https://stat.ethz.ch/pipermail/r-help/2010-January/225327.html
  ## Even though ROC curves don't shed much light on the problem, the area 
  ## under the ROC is useful because it is the Wilcoxon-type concordance 
  ## probability.  Denoting it by C, 2*(C-.5) is Somers' Dxy rank correlation 
  ## between predictions and binary Y.  You can get the standard error of Dxy 
  ## from the Hmisc package rcorr.cens function, and backsolve for s.e. of C 
  ## hence get a confidence interval for C.  This uses U-statistics and is 
  ## fairly assumption-free.
  
  ## make a bunch of numbers and models
  model <- glm(ofi ~ score, family="binomial", data = df)
  pred.model<- predict(model, type="response")
  pred <- prediction(pred.model, df$ofi)

  perf <- performance(pred, "tpr", "fpr")
  
  auc <- unlist(slot(performance(pred, "auc"), "y.values"))
  acc <- performance(pred, measure = "acc")
  ici <- ici(pred.model, df$ofi)
  
  proc <- roc(ofi ~ score, data = df)
  auc.ci <- ci.auc(proc)
  
  ## return all the stats that we've created as a single list; this seemed more efficient than having multiple different functions that do similar things
  stats.ret <- list(model = model, perf = perf, auc = auc, acc = acc, ici = ici, auc.ci = auc.ci)
  
  return(stats.ret)
}
