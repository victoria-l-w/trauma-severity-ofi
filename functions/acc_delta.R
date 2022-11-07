acc_delta_bs <- function(df, index) {
  
  sample <- df[index,]
  
  model <- glm(ofi ~ score1, family = "binomial", data = sample)
  pred.model <- predict(model, type="response")
  pred <- prediction(pred.model, sample$ofi)
  acc <- performance(pred, measure = "acc")
  ind <- which.max(slot(acc, "y.values")[[1]] ) ## find the index of the highest accuracy
  acc.1 <- slot(acc, "y.values")[[1]][ind] ## stores the highest accuracy
  acc.1 <- as.numeric(acc.1)
  
  model <- glm(ofi ~ score2, family = "binomial", data = sample)
  pred.model <- predict(model, type="response")
  pred <- prediction(pred.model, sample$ofi)
  acc <- performance(pred, measure = "acc")
  ind <- which.max( slot(acc, "y.values")[[1]] ) ## Find the index of the highest accuracy
  acc.2 <- slot(acc, "y.values")[[1]][ind] ## Stores the highest accuracy
  acc.2 <- as.numeric(acc.2)
  
  ## deltas
  delta <- as.numeric(acc.1 - acc.2)
  
  return(delta)
}

acc_delta_ci <- function(df, boot.no) {
  results <- boot(data = df, statistic = acc_delta_bs, R = boot.no)
  delta.ci <- boot.ci(boot.out = results, conf = 0.95, type="all")
  
  return(delta.ci)
}