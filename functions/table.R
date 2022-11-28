table <- function(data, type = "", t = t, n = n, p = p) {
  
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
  
  if(type == "main") {
    
    test <- function(x) {
      c(paste0(x[['or']], " (", x[['or.ci.lo']], " - ", x[['or.ci.hi']], ") [", x[['or.p']], "]"),
        paste0(x[['auc']], " (", x[['auc.ci.lo']], " - ", x[['auc.ci.hi']], ")"),
        paste0(x[['ici']], " (", x[['ici.ci']][1], " - ", x[['ici.ci']][2], ")"),
        paste0(x[['acc.max']], " (", x[['acc.ci']][1], " - ", x[['acc.ci']][2], ")")
      )
    }
    
    stats <- c(paste0('OR (95% CI) <br>[p-value]'), "AUC (95% CI)", "ICI (95% CI)", "Accuracy (95% CI)")
    triss <- test(t)
    normit <- test(n)
    ps <- test(p)

    
    tib <- tibble(" " = stats, "TRISS" = triss, "NORMIT" = normit, "PS" = ps)

    out <- tib %>% gt() %>%
      tab_options(data_row.padding = px(4)) %>% 
      fmt_markdown(columns = everything())
      #tab_style(
      #  style = cell_text(align = "left", indent = px(10)),
      #  locations = cells_body(columns = statistic, rows = statistic == "CI")
      #) %>%
      #tab_style(
      #  style = cell_text(align = "left", indent = px(10)),
      #  locations = cells_body(columns = statistic, rows = statistic == "p-value")
      #) %>%
      #tab_style(
      #  style = cell_borders(
      #    sides = c("bottom"),
      #    color = NULL,
      #  ),
      #  locations = cells_body(
      #    columns = everything(),
      #    rows = c(1, 2, 4, 6, 8)
      #  )
      #) %>%
      #cols_width(
      #  statistic ~ px(100),
      #  everything() ~ px(100),
      #) %>%
      #cols_label(
      #  statistic = "",
      #) %>%
      #cols_align(
      #  align = c("left"),
      #  columns = everything()
      #)
    
    return(out)
    
  }
  
}


## pred.data <- data.frame(score = seq(min(df$score), max(df$score), len=500))
## pred.data$ofi <- predict(model, pred.data, type = "response")
## jpeg(file="images/logreg.jpeg")
## plot(ofi ~ score, df)
## lines(ofi ~ score, pred.data, lwd=2, col="green")
## dev.off()