auc_delta <- function(roc1, roc2) {
  
  roctest <- roc.test(roc1, roc2, method="delong") ## has to be forced or it will try to bootstrap; bootstrap doesnt give a CI
  
  diff <- round(roctest[['estimate']][[1]] - roctest[['estimate']][[2]], digits = 2)
  ci.low <- round(roctest[['conf.int']][[1]], digits = 2)
  ci.hi <- round(roctest[['conf.int']][[2]], digits = 2)
  ci <- paste0(ci.low, '-', ci.hi)
  p <- round(roctest[['p.value']], digits = 2)
  
  ci.diff <- c(diff = diff, ci = ci, p = p)
  return(ci.diff)
}