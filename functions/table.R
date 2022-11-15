table <- function(data, type = "") {
  
  if(type == "incomplete") {
    
    names <- c("GCS", "ASA", "RR", "Systolic BP", "Dominant Injury Type", "Age", "ISS", "NISS", "Gender")
    tib <- tibble("Parameter" = names, "Total no. cases missing parameter" = data)
    out <- tib %>% gt() %>% tab_header(
      title = "Table 1. Parameters that were missing in cases excluded for incomplete data"
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
    
    out <- ggplot(nrs, aes(x = factor(score), y = or)) + 
      geom_point(position=position_dodge(.9)) + 
      geom_errorbar(aes(ymin = lower, ymax = upper), position=position_dodge(.9), width = .25) + 
      labs(
        title = "Figure 8. Comparison of Odds Ratios.",
        y = "Odds Ratio",
        x = "Model"
      )
    return(out)
  }
  
  if(type == "deltas") {
    comparisons <- c("TRISS - NORMIT", "TRISS - PS", "NORMIT - PS")
    auc <- c(
      paste0(data[['auc']][['tn']][1]," (", data[['auc']][['tn']][[2]], "-", data[['auc']][['tn']][[3]], ")"),
      paste0(data[['auc']][['tp']][1]," (", data[['auc']][['tp']][[2]], "-", data[['auc']][['tp']][[3]], ")"),
      paste0(data[['auc']][['np']][1]," (", data[['auc']][['np']][[2]], "-", data[['auc']][['np']][[3]], ")")
    )
    ici <- c(
      paste0(data[['ici']][['tn']]," (", data[['ici']][['tn']][[1]], "-", data[['ici']][['tn']][[1]], ")"),
      paste0(data[['ici']][['tp']]," (", data[['ici']][['tp']][[1]], "-", data[['ici']][['tp']][[1]], ")"),
      paste0(data[['ici']][['np']]," (", data[['ici']][['np']][[1]], "-", data[['ici']][['np']][[1]], ")")  
    )
    acc <- c(
      paste0(data[['acc']][['tn']]," (", data[['acc']][['tn']][[1]], "-", data[['acc']][['tn']][[1]], ")"),
      paste0(data[['acc']][['tp']]," (", data[['acc']][['tp']][[1]], "-", data[['acc']][['tp']][[1]], ")"),
      paste0(data[['acc']][['np']]," (", data[['acc']][['np']][[1]], "-", data[['acc']][['np']][[1]], ")")
    )
    
    tib <- tibble("Scores compared" = comparisons, "AUC difference (95% CI)" = auc, "ICI difference (95% CI)" = ici, "Accuracy difference (95% CI)" = acc)
    out <- tib %>% gt() %>% tab_header(
      title = "Table x. Comparison of model results"
    )
    return(out)  
  }
  
}