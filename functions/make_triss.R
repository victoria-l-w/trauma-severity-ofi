## TRISS formula: Ps = 1 / (1 + e^/b)
## Where b = b0 + b1(RTS) + b2(ISS) + b3(A)
## A = age, A <= 54 -> 0, A > 54 -> 1
## Coefficients taken from: https://www.mdcalc.com/calc/10404/trauma-score-injury-severity-score-triss#evidence

make_triss <- function(input.data) {
  
  ## Saving the coefficients for later
  lookup.triss <- data.frame(
    inj.type = c(1, 2),
    b0 = c(-1.2470, -0.6029),
    b1 = c(0.9544, 1.1430),
    b2 = c(-0.0768, -0.1516),
    b3 = c(-1.9052, -2.6676)
  )
  
  ## Cast variables to numeric to ensure they can be used for calculations
  t.inj.dom <- as.numeric(input.data["inj_dominant"])
  t.rts <- as.numeric(input.data["rts"])
  t.iss <- as.numeric(input.data["ISS"])
  t.age <- as.numeric(input.data["pt_age_yrs"])
  
  ## Assign the coefficient for age
  if (t.age > 54) {age.val <- 1} else {age.val <- 0}

  ## Select the appropriate coefficients based on inj_dominant
  t.coeff <- lookup.triss[lookup.triss$inj.type == t.inj.dom,]
  
  ## Calculate TRISS!
  b <- t.coeff$b0 + (t.coeff$b1 * t.rts) + (t.coeff$b2 * t.iss) + (t.coeff$b3 * age.val)
  t.score <- 1 / (1 + exp(b * -1))

  return(t.score)
}