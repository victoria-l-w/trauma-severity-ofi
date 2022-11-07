acc_ci_bs <- function(df, index) {
  
  sample <- df[index,]
  model <- glm(ofi ~ score, family = "binomial", data = sample)
  pred.model <- predict(model, type="response")
  pred <- prediction(pred.model, sample$ofi)
  acc <- performance(pred, measure = "acc")
  ind <- which.max( slot(acc, "y.values")[[1]] ) ## find the index of the highest accuracy
  acc.max <- slot(acc, "y.values")[[1]][ind] ## stores the highest accuracy
  
  return(acc.max)
}

acc_ci <- function(df, boot.no) {
  results <- boot(data = df, statistic = acc_ci_bs, R = boot.no)
  plot(results)
  acc.ci <- boot.ci(boot.out = results, conf = 0.95, type="all")
  return(acc.ci)
}