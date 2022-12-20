table <- function(data, type = "", t = t, n = n, p = p) {

  if(type == "incomplete") {
    
    names <- c("GCS", "ASA", "RR", "Systolic BP", "Dominant Injury Type", "Age", "ISS", "NISS", "Gender")
    out <- tibble("Parameter" = names, "Total no. cases missing parameter" = data)
    
    
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
    
    out <- tibble(" " = comparisons, "AUC difference (95% CI)" = auc, "ICI difference (95% CI)" = ici, "Accuracy difference (95% CI)" = acc)
    
    return(out)  
  }
  
  if(type == "main") {
    
    test <- function(x) {
      c(paste0(x[['or']], " (", x[['or.ci.lo']], " - ", x[['or.ci.hi']], ") [", x[['or.p']], "]"),
        paste0(x[['auc']], " (", x[['auc.ci.lo']], " - ", x[['auc.ci.hi']], ")"),
        paste0(x[['ici']], " (", x[['ici.ci']][1], " - ", x[['ici.ci']][2], ")"),
        paste0(x[['acc']], " (", x[['acc.ci']][1], " - ", x[['acc.ci']][2], ")")
      )
    }
    
    stats <- c(paste0('OR (95% CI) <br>[p-value]'), "AUC (95% CI)", "ICI (95% CI)", "Accuracy (95% CI)")
    triss <- test(t)
    normit <- test(n)
    ps <- test(p)

    
    tib <- tibble(" " = stats, "TRISS" = triss, "NORMIT" = normit, "PS" = ps)

    out <- tib %>% gt() %>%
      tab_options(data_row.padding = px(4)) %>% 
      fmt_markdown(columns = everything()) %>%
      tab_header(
        title = "Table 3: Summary of results"
      )
    
    return(out)
    
  }
  
}


## pred.data <- data.frame(score = seq(min(df$score), max(df$score), len=500))
## pred.data$ofi <- predict(model, pred.data, type = "response")
## jpeg(file="images/logreg.jpeg")
## plot(ofi ~ score, df)
## lines(ofi ~ score, pred.data, lwd=2, col="green")
## dev.off()
