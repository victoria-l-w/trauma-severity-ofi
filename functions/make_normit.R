## I used figure 1 here: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5813212/

make_normit <- function(input.data) {
  
  lookup <- data.frame(
    asa = c(1, 2, 3, 4),
    coeff1 = c(-0.0713, -0.0565, -0.0487, -0.0081),
    coeff2 = c(0.6266, -0.2142, -0.8971, -3.8746)
    )

  ## Cast variables to numeric to ensure they can be used for calculations  
  n.niss <- as.numeric(input.data["niss"])
  n.rts <- as.numeric(input.data["rts"])
  n.asa <- as.numeric(input.data["asa"])
  n.age <- as.numeric(input.data["age"])
  
  ## Select the appropriate coefficients based on asa
  n.coeffs <- lookup[lookup$asa == n.asa,]
  
  ## Calculate NORMIT!
  niss.val <- (n.niss * n.coeffs$coeff1) + n.coeffs$coeff2
  b <- (0.5562 * n.rts) - (4.3234 * ((n.age + 1)/100)^3) + niss.val
  n.val <- 1 / (1 + exp(b * -1))
  
  assertthat::assert_that(length(n.val) == 1)
  return(n.val)
  
 }