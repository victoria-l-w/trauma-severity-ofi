table <- function(data, type = "") {
  
  if(type == "incomplete") {
    
    names <- c("GCS", "ASA", "RR", "Systolic BP", "Dominant Injury Type", "Age", "ISS", "NISS", "Gender")
    tib <- tibble("Parameter" = names, "Total no. cases missing parameter" = data)
    out <- tib %>% gt() %>% tab_header(
      title = "Table 1. Paramaters that were missing in cases excluded for incomplete data"
    )
    
    return(out)
  }

  if(type == "or.plot") {
    nrs <- data.frame(
      score = c("TRISS, NORMIT, PS"),
      or = c(data[['t']][['or']], data[['n']][['or']], data[['p']][['or']]),
      lower = c(data[['t']][['or.ci.lo']], data[['n']][['or.ci.lo']], data[['p']][['or.ci.lo']]),
      upper = c(data[['t']][['or.ci.hi']], data[['n']][['or.ci.hi']], data[['p']][['or.ci.hi']])
    )
    
    out <- ggplot(nrs, aes(x = factor(score), y = or)) + geom_point() + geom_errorbar(aes(ymin = lower, ymax = upper)) + labs(title = "Figure 8. Comparison of Odds Ratios.")
    return(out)
  }
  

}