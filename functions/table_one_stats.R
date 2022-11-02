
table_one_stats <- function(df) {
  
  ##
  ## overall demographics
  ##
  
  demo <- c()
  total <- as.numeric(nrow(df))

  ## age  
  demo['age.med'] <- median(df$age)
  age.iqr <- quantile(df$age)
  demo['age.iqr'] <- paste0(age.iqr[2], '-', age.iqr[4])

  ## gender  
  demo['pc.male'] <- round(nrow(df[df$gender == 1,]) / total * 100, digits = 1)

  ## injury type  
  demo['pc.blunt'] <- round(nrow(df[df$dom.inj == 1,]) / total * 100, digits = 1)

  ## 30 day mortality  
  demo['mort.missing'] <- sum(is.na(df$survival)) + nrow(df[df$survival == 999 & !is.na(df$survival),])
  total.has.survival <- total - as.numeric(demo['mort.missing'])
  total.dead <- nrow(df[df$survival == 1 & !is.na(df$survival),])
  demo['mort'] <- round(total.dead / total.has.survival * 100, digits = 1) ## percentage 30 day mortality of patients that have survival data

  ## % needing ICU care
  demo['icu.missing'] <- sum(is.na(df$care.level)) + nrow(df[df$care.level == 999 & !is.na(df$care.level),])
  total.has.care.level <- total - as.numeric(demo['icu.missing'])
  total.icu <- nrow(df[df$care.level == 5 & !is.na(df$care.level),])
  demo['icu'] <- round(total.icu / total.has.care.level * 100, digits = 1) ## percentage with ICU as highest level of care of the patients that have care level data
  
  ## ISS
  demo['iss'] <- median(df$iss)
  iss.iqr <- quantile(df$iss)
  demo['iss.iqr'] <- paste0(iss.iqr[2], '-', iss.iqr[4])
  
  
  ##
  ## ofi stats
  ##
  
  ofi.descr <- c()
  ofi.descr['ofi.true'] <- nrow(df[df$ofi == 1,])
  ofi.descr['ofi.false'] <- nrow(df[df$ofi == 0,])
  ofi.descr['pc.ofi.true'] <- round(as.numeric(ofi.descr['ofi.true']) / total * 100, digits = 1)
  
  ## 
  ## scores stats
  ##
  
  scores.descr <- c()
  scores.descr['t.med'] <- round(median(df$triss), digits = 2)
  t.iqr <- quantile(df$triss)
  t.iqr <- lapply(t.iqr, round, digits = 2)
  scores.descr['t.iqr'] <- paste0(t.iqr[2], '-', t.iqr[4])
  
  scores.descr['n.med'] <- round(median(df$normit), digits = 2)
  n.iqr <- quantile(df$normit)
  n.iqr <- lapply(n.iqr, round, digits = 2)
  scores.descr['n.iqr'] <- paste0(n.iqr[2], '-', n.iqr[4])

  scores.descr['p.med'] <- round(median(df$ps), digits = 2)
  p.iqr <- quantile(df$ps)
  p.iqr <- lapply(p.iqr, round, digits = 2)
  scores.descr['p.iqr'] <- paste0(p.iqr[2], '-', p.iqr[4])
  
  ## 
  ## ofi mortality
  ## 
  
  df.ofi.mort <- df[df$survival == 1 & !is.na(df$survival),]
  ofi.descr['ofi.mort'] <- round(nrow(df.ofi.mort[df.ofi.mort$ofi == 1,]) / total.has.survival * 100, digits = 1)
  
  ret <- list(demo = demo, ofi.descr = ofi.descr, scores.descr = scores.descr)
  
  return(ret)
}