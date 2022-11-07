## this function combines all the various statistics/bootstrapping functions i have
## and returns a list that contains a list with results for each model + each set of deltas

results <-function(df = df, boot.no = boot.no) {
  
  ## to make it easy to change whilst testing
  boot.no <- 1500
  message(paste0("Bootstrap number: ", boot.no))

  ## some subsetted data to make be friendly to stats functions
  df.t <- df[, c("ofi", "triss")] %>% rename(score = triss)
  df.n <- df[, c("ofi", "normit")] %>% rename(score = normit)
  df.p <- df[, c("ofi", "ps")] %>% rename(score = ps)
  df.tn <- df[, c("ofi", "triss", "normit")] %>% rename(score1 = triss, score2 = normit)
  df.tp <- df[, c("ofi", "triss", "ps")] %>% rename(score1 = triss, score2 = ps)
  df.np <- df[, c("ofi", "normit", "ps")] %>% rename(score1 = normit, score2 = ps)
  
  ## make "base" stats i.e. non-bootstrapped functions
  stats.t <- base_stats(df.t)
  stats.n <- base_stats(df.n)
  stats.p <- base_stats(df.p)
  message("Base stats calculated")
  
  ## bootstrapping CIs for accuracy + ici
  ## commented out for the time being because it takes 15+ mins
  ## stats.t <- list.append(stats.t, "acc.ci" = acc_ci(df.t, boot.no))
  ## stats.n <- list.append(stats.n, "acc.ci" = acc_ci(df.n, boot.no))
  ## stats.p <- list.append(stats.p, "acc.ci" = acc_ci(df.p, boot.no))
  ## message("Accuracy CIs calculated")
  
  ## stats.t <- list.append(stats.t, "ici.ci" = ici_ci(df.t, boot.no))
  ## stats.n <- list.append(stats.n, "ici.ci" = ici_ci(df.n, boot.no))
  ## stats.p <- list.append(stats.p, "ici.ci" = ici_ci(df.p, boot.no))
  ## message("ICI CIs calculated")
  
  ## calculating deltas
  ## auc
  auc.tn <- auc_delta(stats.t[['roc']], stats.n[['roc']]) ## TRISS AUC - NORMIT AUC
  auc.tp <- auc_delta(stats.t[['roc']], stats.p[['roc']]) ## TRISS AUC - PS AUC
  auc.np <- auc_delta(stats.n[['roc']], stats.p[['roc']]) ## NORMIT AUC - PS AUC
  delta.auc <- list(tn = auc.tn, tp = auc.tp, np = auc.np)
  message("AUC delta calculated")
  
  ## accuracy delta
  acc.tn <- stats.t[['acc.nrs']][['acc.max']] - stats.n[['acc.nrs']][['acc.max']]
  acc.tp <- stats.t[['acc.nrs']][['acc.max']] - stats.p[['acc.nrs']][['acc.max']]
  acc.np <- stats.n[['acc.nrs']][['acc.max']] - stats.p[['acc.nrs']][['acc.max']]

  ## accuracy delta CIs
  ## acc.tn.ci <- acc_delta_ci(df.tn, boot.no)
  ## acc.tp.ci <- acc_delta_ci(df.tp, boot.no)
  ## acc.np.ci <- acc_delta_ci(df.np, boot.no)
  
  ## delta.acc <- list(tn = acc.tn, tn.ci = acc.tn.ci, tp = acc.tp, tp.ci = acc.tp.ci, np = acc.np, np.ci = acc.np.ci)
  ## message("Accuracy CIs calculated")
  
  ## ici delta
  ici.tn <- stats.t[['ici']] - stats.n[['ici']]
  ici.tp <- stats.t[['ici']] - stats.p[['ici']]
  ici.np <- stats.n[['ici']] - stats.p[['ici']]
  
  ## ici delta CIs
  ## ici.tn.ci <- ici_delta_ci(df.tn, boot.no)
  ## ici.tp.ci <- ici_delta_ci(df.tp, boot.no)
  ## ici.np.ci <- ici_delta_ci(df.np, boot.no)
  
  ## delta.ici <- list(tn = ici.tn, tn.ci = ici.tn.ci, tp = ici.tp, tp.ci = ici.tp.ci, np = ici.np, np.ci = ici.np.ci)
  ## message("ICI delta CIs calculated")
  
  
  ## deltas <- list(auc = delta.auc, acc = delta.acc, ici = delta.ici)
  
  ## Each model should now have a list "stats.[model]" that contains:
  ## model = the logistic regression model
  ## roc = the ROC
  ## auc = the AUC for the ROC
  ## auc.ci = the CI for the AUC
  ## acc = the highest accuracy + the cutoff at that accuracy
  ## ici = a number for ICI
  ## or = a vector containing the OR and the CI 
  ## or.p = the p-value for the OR 
  ## acc.nrs = the accuracy and cutoff at the highest accuracy
  
  ## return all the stats that we've created as a single list; this seemed more efficient than having multiple different functions that do similar things
  stats.ret <- list("stats.t" = stats.t, "stats.n" = stats.n, "stats.p" = stats.p)
  return(stats.ret)
}
