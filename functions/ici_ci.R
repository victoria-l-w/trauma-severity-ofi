ici_delta_bs <- function(df, index) {
  
  sample <- df[index,]
  
  model <- glm(ofi ~ score1, family = "binomial", data = sample)
  pred.model <- predict(model, type="response")
  ici.1 <- ici(pred.model, sample$ofi)
  ici.1 <- as.numeric(ici.1)
  
  model <- glm(ofi ~ score2, family = "binomial", data = sample)
  pred.model <- predict(model, type="response")
  ici.2 <- ici(pred.model, sample$ofi)
  ici.2 <- as.numeric(ici.2)
  
  delta <- ici.1 - ici.2
  
  return(delta)
}

ici_delta_ci <- function(df, boot.no) {
  results <- boot(data = df, statistic = ici_delta_bs, R = boot.no)
  plot(results)
  ici.ci <- boot.ci(boot.out = results, conf = 0.95, type="all")
  return(ici.ci)
}
