acc_delta_bs <- function(df, index) {
  
  sample <- df[index,]
  
  pred1 <- prediction(sample$score1, sample$ofi)
  acc.class1 <- performance(pred1, measure = "acc")
  acc1 <- acc.class1@y.values[[1]][max(which(acc.class1@x.values[[1]] >= 0.5))]
  
  pred2 <- prediction(sample$score2, sample$ofi)
  acc.class2 <- performance(pred2, measure = "acc")
  acc2 <- acc.class2@y.values[[1]][max(which(acc.class2@x.values[[1]] >= 0.5))]
  
  delta <- as.numeric(acc1 - acc2)
  
  return(delta)
}

acc_delta_ci <- function(df, boot.no) {
  results <- boot(data = df, statistic = acc_delta_bs, R = boot.no)
  ci <- boot.ci(boot.out = results, conf = 0.95, type=c("norm"))
  
  out <- c(ci[['normal']][2], ci[['normal']][3])
  
  return(out)
}