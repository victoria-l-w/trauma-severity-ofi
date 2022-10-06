## no clue what im doing here
## shamelessly copied from the internet

make_model <- function(input, score) {
  if (score == "triss") {model <- glm(ofi ~ triss, family="binomial", data = input)} 
  else if (score == "normit") {model <- glm(ofi ~ normit, family="binomial", data = input)}
  return(model)
}

make_roc <- function(model, id, auc = FALSE) {
  pred_model<- predict(model, type="response")
  pred <- prediction(pred_model, id$ofi)
  perf <- performance(pred, "tpr", "fpr")
  auc.ret <- unlist(slot(performance(pred, "auc"), "y.values"))
  
  if(auc == TRUE) {return(auc.ret)} else {return(perf)}
}

make_ici <- function(model, id) {
  pred_model<- predict(model, type="response")
  ici <- ici(pred_model, id$ofi)
  return(ici)
}