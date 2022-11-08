acc_delta_bs <- function(df, index) {
  
  sample <- df[index,]
  
  model <- glm(ofi ~ score1, family = "binomial", data = sample)
  pred.model <- predict(model, type="response")
  pred <- prediction(pred.model, sample$ofi)
  acc.1 <- performance(pred, measure = "acc")
  acc.max.1 <- max(acc.1@y.values[[1]])
  acc.max.1 <- as.numeric(acc.max.1)
  
  model <- glm(ofi ~ score2, family = "binomial", data = sample)
  pred.model <- predict(model, type="response")
  pred <- prediction(pred.model, sample$ofi)
  acc.2 <- performance(pred, measure = "acc")
  acc.max.2 <- max(acc.2@y.values[[1]])
  acc.max.2 <- as.numeric(acc.max.2)
  
  delta <- as.numeric(acc.max.1 - acc.max.2)
  
  return(delta)
}

acc_delta_ci <- function(df, boot.no) {
  results <- boot(data = df, statistic = acc_delta_bs, R = boot.no)
  ci <- boot.ci(boot.out = results, conf = 0.95, type=c("norm"))
  
  out <- round(c(ci[['normal']][2], ci[['normal']][3]), digits = 2)
  
  return(out)
}