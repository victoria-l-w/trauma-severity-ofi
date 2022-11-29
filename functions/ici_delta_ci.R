ici_delta_bs <- function(df, index) {
  
  sample <- df[index,]
  
  ici1 <- suppressMessages(ici1(sample$score, sample$ofi))
  ici1 <- as.numeric(ici1)
  
  ici2 <- suppressMessages(ici2(sample$score, sample$ofi))
  ici2 <- as.numeric(ici2)
  
  delta <- ici1 - ici2
  
  return(delta)
}

ici_delta_ci <- function(df, boot.no) {
  results <- boot(data = df, statistic = ici_delta_bs, R = boot.no)
  ci <- boot.ci(boot.out = results, conf = 0.95, type=c("norm"))
  
  out <- signif(c(ci[['normal']][2], ci[['normal']][3]), 2)
  
  return(out)
}
