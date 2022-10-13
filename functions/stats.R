## no clue what im doing here
## shamelessly copied from the internet

make_stats <-function(df) {

  ## make a bunch of numbers and models
  model <- glm(ofi ~ score, family="binomial", data = df)
  pred_model<- predict(model, type="response")
  pred <- prediction(pred_model, df$ofi)
  
  ## this is the roc?
  perf <- performance(pred, "tpr", "fpr")
  auc <- unlist(slot(performance(pred, "auc"), "y.values"))
  acc <- performance(pred, measure = "acc")
  ici <- ici(pred_model, df$ofi)
  
  ## return all the stats that we've created as a single list; this seemed more efficient than having multiple different functions that do similar things
  stats.ret <- list(model = model, perf = perf, auc = auc, acc = acc, ici = ici)
  
  return(stats.ret)
}
