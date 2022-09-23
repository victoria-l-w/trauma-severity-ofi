## Ps = 1/(1 + e^-b)
## b = (0.5562 * T-RTS) - 4.3234 * (age+1/100)^3 + ASA 
## blabla figure 1 here 
## https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5813212/

make_normit <- function(input.data) {
  
  lookup.normit <- data.frame(
    asa = c(1, 2, 3, 4),
    coeff1 = c(-0.0713, -0.0565, -0.0487, -0.0081),
    coeff2 = c(0.6266, -0.2142, -0.8971, -3.8746)
    )
  
  n.niss <- as.numeric(input.data["NISS"])
  n.rts <- as.numeric(input.data["rts"])
  n.asa <- as.numeric(input.data["pt_asa_preinjury"])
  n.age <- as.numeric(input.data["pt_age_yrs"])
  n.coeffs <- lookup.normit[lookup.normit$asa == n.asa,]
    
  niss.val <- (n.niss * n.coeffs$coeff1) + n.coeffs$coeff2
  
  b <- (0.5562 * n.rts) - (4.3234 * ((n.age + 1)/100)^3) + niss.val
    
  n.score <- 1 / (1 + exp(b * -1))
  
  return(n.score)
  
 }