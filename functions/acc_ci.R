acc_ci_bs <- function(df, index) {
  
  sample <- df[index,]
  model <- glm(ofi ~ score, family = "binomial", data = sample)
  pred.model <- predict(model, type="response")
  pred <- prediction(pred.model, sample$ofi)
  acc <- performance(pred, measure = "acc")
  acc.max <- max(acc@y.values[[1]])
  
  return(acc.max)
}

acc_ci <- function(df, boot.no) {
  results <- boot(data = df, statistic = acc_ci_bs, R = boot.no)
  ci <- boot.ci(boot.out = results, conf = 0.95, type=c("norm"))
  
  out <- round(c(ci[['normal']][2], ci[['normal']][3]), digits = 2)

  return(out)
}