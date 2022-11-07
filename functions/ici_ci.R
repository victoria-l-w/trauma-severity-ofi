ici_ci_bs <- function(df, index) {
  
  sample <- df[index,]
  model <- glm(ofi ~ score, family = "binomial", data = sample)
  pred.model <- predict(model, type="response")
  ici <- ici(pred.model, sample$ofi)
  
  return(ici)
}

ici_ci <- function(df) {
  results <- boot(data = df, statistic = ici_ci_bs, R = 2000)
  plot(results)
  ici.ci <- boot.ci(boot.out = results, conf = 0.95, type="all")
  return(ici.ci)
}
