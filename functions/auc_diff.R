

auc_diff <- function(roc1, roc2) {
  
  roctest <- roc.test(roc1, roc2, method="delong")
  
  diff <- roctest[['estimate']][[1]] - roctest[['estimate']][[2]]
  ci.low <- roctest[['conf.int']][[1]]
  ci.hi <- roctest[['conf.int']][[2]]
  
  ci.diff <- c(diff, ci.low, ci.hi)
  return(ci.diff)
}