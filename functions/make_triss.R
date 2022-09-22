## Ps = 1 / (1 + e^/b)
## where b = b0 + b1(RTS) + b2(ISS) + b3(A)
## A = age, A <= 54 -> 0, A > 54 -> 1
## coefficients https://www.mdcalc.com/calc/10404/trauma-score-injury-severity-score-triss#evidence
## inj_dominant: 1 = blunt, 2 = penetrating

make_triss <- function(input.data) {
  
  triss.coeff <- data.frame(
    inj.type = c(1, 2),
    b0 = c(-1.2470, -0.6029),
    b1 = c(0.9544, 1.1430),
    b2 = c(-0.0768, -0.1516),
    b3 = c(-1.9052, -2.6676)
  )
  
  for (i in 1:nrow(input.data)) {
    
    ## assign value for age
    age <- input.data$pt_age_yrs[i]
    if (age > 54) {age.value <- 1} else {age.value <- 0}
    
    triss.b0 <- triss.coeff$b0[input.data$inj_dominant[i] == triss.coeff$inj.type]
    triss.b1 <- triss.coeff$b1[input.data$inj_dominant[i] == triss.coeff$inj.type]
    triss.b2 <- triss.coeff$b2[input.data$inj_dominant[i] == triss.coeff$inj.type]
    triss.b3 <- triss.coeff$b3[input.data$inj_dominant[i] == triss.coeff$inj.type]
    
    b <- triss.b0 + (triss.b1 * input.data$RTS[i]) + (triss.b2 * input.data$ISS[i]) + (triss.b3 * age.value)
    
    triss.ps <- 1 / (1 + exp(b * -1))
    
    input.data$triss[i] <- triss.ps
  }
  
  return(input.data)
}