## this function combines all the various statistics/bootstrapping functions i have
## see results.md for a list of all the variables created in this function
## bootstrap TRUE/FALSE to turn off long loading times when testing things

results <-function(df, bootstrap = FALSE) {
  
  ## some subsetted data to be friendly to stats functions
  df.t <- df[, c("ofi", "triss")] %>% rename(score = triss)
  df.n <- df[, c("ofi", "normit")] %>% rename(score = normit)
  df.p <- df[, c("ofi", "ps")] %>% rename(score = ps)
  df.tn <- df[, c("ofi", "triss", "normit")] %>% rename(score1 = triss, score2 = normit)
  df.tp <- df[, c("ofi", "triss", "ps")] %>% rename(score1 = triss, score2 = ps)
  df.np <- df[, c("ofi", "normit", "ps")] %>% rename(score1 = normit, score2 = ps)
  
  ## make "base" stats i.e. non-bootstrapped functions; see base_results.R
  t <- base_stats(df.t)
  n <- base_stats(df.n)
  p <- base_stats(df.p)
  
  if (bootstrap == TRUE) {
    message("Bootstrapping enabled")
    boot.no <- 50
    message(paste0("# of bootstrap samples: ", boot.no))
    
    ## acc_ci.R
    t <- list.append(t, "acc.ci" = acc_ci(df.t, boot.no))
    n <- list.append(n, "acc.ci" = acc_ci(df.n, boot.no))
    p <- list.append(p, "acc.ci" = acc_ci(df.p, boot.no))
    message("Accuracy CIs computed")
    
    ## ici_ci.R
    t <- list.append(t, "ici.ci" = ici_ci(df.t, boot.no))
    n <- list.append(n, "ici.ci" = ici_ci(df.n, boot.no))
    p <- list.append(p, "ici.ci" = ici_ci(df.p, boot.no))
    message("ICI CIs computed")
    
    ## auc_delta.R
    auc.tn <- auc_delta(t[['roc']], n[['roc']]) ## TRISS AUC - NORMIT AUC
    auc.tp <- auc_delta(t[['roc']], p[['roc']]) ## TRISS AUC - PS AUC
    auc.np <- auc_delta(n[['roc']], p[['roc']]) ## NORMIT AUC - PS AUC
    message("AUC deltas + CIs computed")
    d.auc <- list(tn = auc.tn, tp = auc.tp, np = auc.np)
    
    acc.tn <- t[['acc.max']] - n[['acc.max']]
    acc.tp <- t[['acc.max']] - p[['acc.max']]
    acc.np <- n[['acc.max']] - p[['acc.max']]
    message("Accuracy deltas computed")
    
    ## acc_delta_ci.R
    acc.tn.ci <- acc_delta_ci(df.tn, boot.no)
    acc.tp.ci <- acc_delta_ci(df.tp, boot.no)
    acc.np.ci <- acc_delta_ci(df.np, boot.no)
    message("Accuracy delta CIs computed")
    d.acc <- list(tn = acc.tn, tn.ci = acc.tn.ci, tp = acc.tp, tp.ci = acc.tp.ci, np = acc.np, np.ci = acc.np.ci)
    
    ici.tn <- t[['ici']] - n[['ici']]
    ici.tp <- t[['ici']] - p[['ici']]
    ici.np <- n[['ici']] - p[['ici']]
    message("ICI deltas computed")
    
    ## ici_delta_ci.R
    ici.tn.ci <- ici_delta_ci(df.tn, boot.no)
    ici.tp.ci <- ici_delta_ci(df.tp, boot.no)
    ici.np.ci <- ici_delta_ci(df.np, boot.no)
    message("ICI delta CIs computed")
    d.ici <- list(tn = ici.tn, tn.ci = ici.tn.ci, tp = ici.tp, tp.ci = ici.tp.ci, np = ici.np, np.ci = ici.np.ci)
    
    delta <- list(
      auc = d.auc,
      acc = d.acc, 
      ici = d.ici
    )
      
    out <- list(
      "t" = t, 
      "n" = n, 
      "p" = p,
      "delta" = delta
    )
      
  } else {
    message("Bootstrapping disabled; no CIs or deltas")
    out <- list(
      "t" = t, 
      "n" = n, 
      "p" = p
    )
    }

  message("Results completed")
  return(out)
}
