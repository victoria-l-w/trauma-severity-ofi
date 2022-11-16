auc_delta <- function(roc1, roc2) {
  
  roctest <- roc.test(roc1, roc2, method="delong") ## has to be forced or it will try to bootstrap; bootstrap doesnt give a CI
  
  delta <- signif(roctest[['estimate']][[1]] - roctest[['estimate']][[2]], 2)
  ci.lo <- signif(roctest[['conf.int']][[1]], 2)
  ci.hi <- signif(roctest[['conf.int']][[2]], 2)
  p <- format(signif(roctest[['p.value']], 1), scientific = FALSE)
  
  out <- c(delta, ci.lo, ci.hi, p)
  return(out)
}