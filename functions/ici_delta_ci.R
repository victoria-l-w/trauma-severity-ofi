ici_delta_bs <- function(df, index) {
  
  sample <- df[index,]
  
  model <- glm(ofi ~ score1, family = "binomial", data = sample)
  pred.model <- predict(model, type="response")
  ici.1 <- suppressMessages(ici(pred.model, sample$ofi))
  ici.1 <- as.numeric(ici.1)
  
  model <- glm(ofi ~ score2, family = "binomial", data = sample)
  pred.model <- predict(model, type="response")
  ici.2 <- suppressMessages(ici(pred.model, sample$ofi))
  ici.2 <- as.numeric(ici.2)
  
  delta <- ici.1 - ici.2
  
  return(delta)
}

ici_delta_ci <- function(df, boot.no) {
  results <- boot(data = df, statistic = ici_delta_bs, R = boot.no)
  ci <- boot.ci(boot.out = results, conf = 0.95, type=c("norm"))
  
  out <- round(c(ci[['normal']][2], ci[['normal']][3]), digits = 2)
  
  return(out)
}