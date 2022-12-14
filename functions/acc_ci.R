acc_ci_bs <- function(df, index) {
  
  sample <- df[index,]
  pred <- prediction(sample$score, sample$ofi)
  acc.class <- performance(pred, measure = "acc")
  acc <- acc.class@y.values[[1]][max(which(acc.class@x.values[[1]] >= 0.5))]
  
  return(acc)
}

acc_ci <- function(df, boot.no) {
  results <- boot(data = df, statistic = acc_ci_bs, R = boot.no)
  ci <- boot.ci(boot.out = results, conf = 0.95, type=c("norm"))
  
  out <- signif(c(ci[['normal']][2], ci[['normal']][3]), digits = 2)
  
  return(out)
}