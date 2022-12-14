plot_glm <- function(df, type) {
  
  model <- glm(ofi ~ score, family="binomial", data = df)
  pred <- predict(model, type = "response")
  pred_df <- data.frame(score = df$score, pred)
  
  plot <- ggplot(df, aes(x = score, y = ofi)) +
    geom_point() +
    geom_smooth(method = "glm", 
                method.args = list(family = "binomial"),
                se = FALSE) +
    geom_point(data = pred_df, aes(x = score, y = pred), colour = "#5FD4AB") +
    geom_hline(data = data.frame(c(0.25, 0.50, 0.75)),
               aes(yintercept = c(0.25, 0.50, 0.75)),
               colour = "darkgrey", linetype = "dashed") +
    labs(x = paste0(type), y = "OFI")
  return(plot)
}

glm_x3 <- function(df) {
  df.t <- df[, c("ofi", "triss")] %>% rename(score = triss)
  df.n <- df[, c("ofi", "normit")] %>% rename(score = normit)
  df.p <- df[, c("ofi", "ps")] %>% rename(score = ps)
  
  t <- plot_glm(df.t, "TRISS")
  n <- plot_glm(df.n, "NORMIT")
  p <- plot_glm(df.p, "PS")
  x3 <- grid.arrange(t, n, p, ncol = 3)
  x3 <- annotate_figure(x3, top = text_grob("Figure x: Probability of OFI vs probability of survival", size = 12))
  ggsave(x3, filename = "images/glm.png",height = 667, width = 2001, units = "px")
}

plot_roc <- function(x, type) {
  plot <- ggroc(x[['roc']], colour = "#5FD4AB") + ggtitle(paste0(type, " (AUC = ", x[['auc']], ")")) + theme(plot.title = element_text(size=12))
  return(plot)
}

roc_x3 <- function(t, n, p) {
  t.plot <- plot_roc(t, type = "TRISS")
  n.plot <- plot_roc(n, type = "NORMIT")
  p.plot <- plot_roc(p, type = "PS")
  x3 <- grid.arrange(t.plot, n.plot, p.plot, ncol = 3)
  x3 <- annotate_figure(x3, top = text_grob("Figure x: Receiver Operating Curves", size = 12))
  ggsave(x3, filename = "images/roc.png",height = 667, width = 2001, units = "px")
}

plot_acc <- function(data, type) {
  df <- data.frame(
    x = c(data[['acc.plot']]@x.values[[1]]),
    y = c(data[['acc.plot']]@y.values[[1]]))
  
  df <- df[-1,]
  
  plot <- ggplot(df, aes(x = x, y = y)) +
    geom_path(colour = "#5FD4AB", linewidth = 0.5) +
    labs(x = "Cutoff", y = "Accuracy") +
    ggtitle(paste0(type)) + 
    theme(plot.title = element_text(size=12))
  return(plot)
}

acc_x3 <- function(t, n, p){
  t.plot <- plot_acc(t, "TRISS")
  n.plot <- plot_acc(n, "NORMIT")
  p.plot <- plot_acc(p, "PS")
  x3 <- grid.arrange(t.plot, n.plot, p.plot, ncol = 3)
  x3 <- annotate_figure(x3, top = text_grob("Figure x: Accuracy at all cutoffs", size = 12))
  ggsave(x3, filename = "images/acc.png",height = 667, width = 2001, units = "px")
  
}




plots <- function(type = "", data) {
  
  if(type == "or") {
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

  
}