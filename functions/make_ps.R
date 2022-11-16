## Coefficients from Figure 1 here: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5813212/
## i.e. NORMIT 2

make_normit <- function(input.data) {
  
  lookup <- data.frame(
    asa = c(1, 2, 3, 4),
    b1 = c(-0.0713, -0.0565, -0.0487, -0.0081),
    b2 = c(0.6266, -0.2142, -0.8971, -3.8746)
  )
  
  ## Cast variables to numeric to ensure they can be used for calculations  
  n.niss <- as.numeric(input.data["niss"])
  n.rts <- as.numeric(input.data["rts"])
  n.asa <- as.numeric(input.data["asa"])
  n.age <- as.numeric(input.data["age"])
  
  ## Select the appropriate coefficients based on asa
  coef <- lookup[lookup$asa == n.asa,]
  
  ## Calculate NORMIT!
  niss.val <- (n.niss * coef$b1) + coef$b2
  b <- (0.5562 * n.rts) - (4.3234 * ((n.age + 1)/100)^3) + niss.val
  out <- 1 / (1 + exp(b * -1))
  
  out <- as.numeric(out)
  assertthat::assert_that(length(out) == 1)
  
  return(out)
  
}