## Ps = 1/(1 + e^-b)
## b = (0.5562 * T-RTS) - 4.3234 * (age+1/100)^3 + ASA 
## blabla figure 1 here 
## https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5813212/

make_normit <- function(input.data) {
  
  normit.asa.coeff <- data.frame(
    asa = c(1, 2, 3, 4),
    coeff1 = c(-0.0713, -0.0565, -0.0487, -0.0081),
    coeff2 = c(0.6266, -0.2142, -0.8971, -3.8746)
  )
  
  for (i in 1:nrow(input.data)) {
    
    niss.value <- (input.data$NISS[i] * normit.asa.coeff$coeff1[input.data$pt_asa_preinjury[i] == normit.asa.coeff$asa]) + normit.asa.coeff$coeff2[input.data$pt_asa_preinjury[i] == normit.asa.coeff$asa]
    
    b <- (0.5562 * input.data$RTS[i]) - (4.3234 * ((input.data$pt_age_yrs[i] + 1)/100)^3) + niss.value
    
    input.data$normit[i] <- 1 / (1 + exp(b * -1))
  }
  
  return(input.data)
  
}