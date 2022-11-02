auc_delta <- function(roc1, roc2) {
  
  roctest <- roc.test(roc1, roc2, method="delong") ## has to be forced or it will try to bootstrap; bootstrap doesnt give a CI
  
  diff <- roctest[['estimate']][[1]] - roctest[['estimate']][[2]]
  ci.low <- roctest[['conf.int']][[1]]
  ci.hi <- roctest[['conf.int']][[2]]
  p <- roctest[['p.value']]
  
  ci.diff <- c(diff = diff, ci.low = ci.low, ci.hi = ci.hi, p = p)
  return(ci.diff)
}