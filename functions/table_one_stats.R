
table_one_stats <- function(df) {

  numbers <- c()
  numbers['ofi.true'] <- nrow(df[df$ofi == 1,])
  numbers['ofi.false'] <- nrow(df[df$ofi == 0,])
  numbers['mean.age'] <- round(mean(df$age), digits = 1)
  numbers['pc.male'] <- round(nrow(df[df$gender == 1,]) / nrow(df) * 100, digits = 1)
  numbers['t.mean'] <- round(mean(df$triss), digits = 2)
  numbers['n.mean'] <- round(mean(df$normit), digits = 2)

  t.numbers <- df %>% group_by(ofi) %>%
    summarise(mean = round(mean(triss), digits = 2))
  
  numbers['t.ofi.t'] <- t.numbers[2,2]
  numbers['t.ofi.f'] <- t.numbers[1,2]
  
  n.numbers <- df %>% group_by(ofi) %>%
    summarise(mean = round(mean(normit), digits = 2))
  
  numbers['n.ofi.t'] <- n.numbers[2,2]
  numbers['n.ofi.f'] <- n.numbers[1,2]
  
  return(numbers)
}