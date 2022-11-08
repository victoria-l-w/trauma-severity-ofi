auc_delta <- function(roc1, roc2) {
  
  roctest <- roc.test(roc1, roc2, method="delong") ## has to be forced or it will try to bootstrap; bootstrap doesnt give a CI
  
  delta <- round(roctest[['estimate']][[1]] - roctest[['estimate']][[2]], digits = 2)
  ci.lo <- round(roctest[['conf.int']][[1]], digits = 2)
  ci.hi <- round(roctest[['conf.int']][[2]], digits = 2)
  p <- round(roctest[['p.value']], digits = 2)
  
  out <- c(delta, ci.lo, ci.hi, p)
  return(out)
}