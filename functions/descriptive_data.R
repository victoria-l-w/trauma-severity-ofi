## manually calculating some of the stats found in table one

descriptive_data <- function(df) {

  total <- as.numeric(nrow(df))

  ## some medians 
  dd <- c(
    "age" = median(df$age), 
    "age.lo" = quantile(df$age)[[2]], 
    "age.hi" = quantile(df$age)[[4]], 
    "iss" = median(df$iss),
    "iss.lo" = quantile(df$iss)[[2]], 
    "iss.hi" = quantile(df$iss)[[4]], 
    "ofi.true" = nrow(df[df$ofi == 1,]),
    "ofi.false" = nrow(df[df$ofi == 0,]),
    "t.med" = median(df$triss),
    "t.lo" = quantile(df$triss)[[2]], 
    "t.hi" = quantile(df$triss)[[4]], 
    "n.med" = median(df$normit),
    "n.lo" = quantile(df$normit)[[2]], 
    "n.hi" = quantile(df$normit)[[4]], 
    "p.med" = median(df$ps),
    "p.lo" = quantile(df$ps)[[2]], 
    "p.hi" = quantile(df$ps)[[4]]
  )   
  
  dd <- sapply(dd, round, digits = 2)
  
  ## some percentages
  pc <- c(
    "ofi.pc" = as.numeric(nrow(df[df$ofi == 1,])) / total * 100, ## ofi as % true
    "male" = nrow(df[df$gender == 1,]) / total * 100, ## gender as % male
    "blunt" = nrow(df[df$dom.inj == 1,]) / total * 100 ## injury type as % blunt
  )
  
  pc <- sapply(pc, round, digits = 1)
  dd <- append(dd, pc)

  
  dd['survival.na'] <- sum(is.na(df$survival)) + nrow(df[df$survival == 999 & !is.na(df$survival),]) ## # cases missing survival data
  survival.not.na <- total - as.numeric(dd['survival.na']) ## # cases that have survival data
  deceased <- nrow(df[df$survival == 1 & !is.na(df$survival),]) ## # cases deceased in 30 days
  dd['mort'] <- round(deceased / survival.not.na * 100, digits = 1) ## 30-day mortality as % in cases where data is not missing

  dd['care.na'] <- sum(is.na(df$care.level)) + nrow(df[df$care.level == 999 & !is.na(df$care.level),]) ## # cases missing care level data
  care.not.na <- total - as.numeric(dd['care.na']) ## # cases that have care level data
  total.icu <- nrow(df[df$care.level == 5 & !is.na(df$care.level),]) ## # cases that were in the ICU
  dd['icu'] <- round(total.icu / care.not.na * 100, digits = 1) ## % cases with ICU as highest level of care in cases where data is not missing

  ## In cases where death occurred within 30 days, at least one OFI was found in % of cases.
  df.ofi.mort <- df[df$survival == 1 & !is.na(df$survival),]
  dd['ofi.mort'] <- round(nrow(df.ofi.mort[df.ofi.mort$ofi == 1,]) / survival.not.na * 100, digits = 1)
  
  message("Descriptive data created")
  return(dd)
}