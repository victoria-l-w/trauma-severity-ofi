## TRiss formula: Ps = 1 / (1 + e^/b)
## Where b = b0 + b1(RTS) + b2(iss) + b3(A)
## A = age, A <= 54 -> 0, A > 54 -> 1
## Coefficients taken from: https://www.mdcalc.com/calc/10404/trauma-score-injury-severity-score-triss#evidence

make_triss <- function(input.data) {
  
  ## Saving the coefficients for later
  lookup <- data.frame(
    inj.type = c(1, 2),
    b0 = c(-1.2470, -0.6029),
    b1 = c(0.9544, 1.1430),
    b2 = c(-0.0768, -0.1516),
    b3 = c(-1.9052, -2.6676)
  )
  
  ## Cast variables to numeric to ensure they can be used for calculations
  t.dom.inj <- as.numeric(input.data["dom.inj"])
  t.rts <- as.numeric(input.data["rts"])
  t.iss <- as.numeric(input.data["iss"])
  t.age <- as.numeric(input.data["age"])
  
  ## Assign the coefficient for age
  if (t.age > 54) {age.val <- 1} else {age.val <- 0}

  ## Select the appropriate coefficients based on dom.inj
  t.coeff <- lookup[lookup$inj.type == t.dom.inj,]
  
  ## Calculate TRISS!
  b <- t.coeff$b0 + (t.coeff$b1 * t.rts) + (t.coeff$b2 * t.iss) + (t.coeff$b3 * age.val)
  t.val <- 1 / (1 + exp(b * -1))

  ## Ensure a score was actually calculated
  ## Because, for example, if dom.inj is a number other than 1 or 2, R will silently return an empty vector
  assertthat::assert_that(length(t.val) == 1)
  
  return(t.val)
}