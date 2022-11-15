ici_bs <- function(df, index) {
  
  sample <- df[index,]
  
  model <- glm(ofi ~ score, family = "binomial", data = sample)
  pred.model <- predict(model, type="response")
  ici <- suppressMessages(ici(pred.model, sample$ofi))
  ici <- as.numeric(ici)
  
  return(ici)
}

ici_ci <- function(df, boot.no) {
  results <- boot(data = df, statistic = ici_bs, R = boot.no)
  ci <- boot.ci(boot.out = results, conf = 0.95, type=c("norm"))
  
  out <- signif(c(ci[['normal']][2], ci[['normal']][3]), digits = 2)
  
  return(out)
}
