## https://www.tarn.ac.uk/Content.aspx?c=1895

make_ps <- function (input.data) {
  
  ## Cast variables to numeric to ensure they can be used for calculations  
  ed.gcs <- as.numeric(input.data["ed.gcs"])
  gcs <- as.numeric(input.data["gcs"] )
  age <- as.numeric(input.data["age"])
  gender <- as.numeric(input.data["gender"])
  iss <- as.numeric(input.data["iss"])
  
  b0 <- 4.9146
  
  ## ed.gcs == 99 -> intubated
  if (ed.gcs == 99) {gcs.val <- -2.31186} ## b6
  else { 
    if (ed.gcs >= 13) {gcs.val <- 0} ## b1
    else if (ed.gcs >= 9) {gcs.val <- -1.27734} ## b2
    else if (ed.gcs >= 5) {gcs.val <- -1.68936} ## b3
    else if (ed.gcs >= 4) {gcs.val <- -2.52661} # b4
    else {gcs.val <- -3.62339} #b5
  }
  
  ## coefficient for gender
  if (gender == 1) {gender.val <- 0} # b9
  else {gender.val <- -0.024416} #b10
  
  
  ## coefficient for age; ignored coefficients for ages <15
  if (age > 74) {age.val <- -3.01315} ## b18
  else if (age > 64) {age.val <- -1.74081} ## b17
  else if (age > 54) {age.val <- -0.995816} ## b16
  else if (age > 44) {age.val <- -0.557926} ## b15
  else if (age > 15) {age.val <- 0} ## b14
  else {age.val <- 0.210467} ## b13
  
  if (gender == 2) {
    if (age > 74) {gen.age.val <- 0.299887} ## b26
    else if (age > 64) {gen.age.val <- 0.081554} ## b25
    else if (age > 54) {gen.age.val <- -0.085054} ## b24
    else if (age > 44) {gen.age.val <- 0.003235} ## b23
    else if (age > 15) {gen.age.val <- 0} ## b22
    else {gen.age.val <- -0.23219} ## b21
  } else {gen.age.val <- 0} ## 0 if male
  
  ## Cast variables to numeric to ensure they can be used for calculations
  gcs.val <- as.numeric(gcs.val)
  gender.val <- as.numeric(gender.val)
  age.val <- as.numeric(age.val)
  gen.age.val <- as.numeric(gen.age.val)
  
  ## Calculate the coefficients based on ISS
  if (iss == 0) {
    iss1 <- -0.8636 * -3.000163 ## b7
    iss2 <- -0.2933 * -2.74522 ## b8
  } else {
    iss1 <- sqrt(10/iss) - 0.8636
    iss1 <- iss1 * -3.000163 ## b7
    iss2 <- log(iss/10) - 0.2933
    iss2 <- iss2 * -2.74522 ## b8
  }
  
  iss1 <- as.numeric(iss1)
  iss2 <- as.numeric(iss2)
  
  iss.val <- iss1 + iss2
  iss.val <- as.numeric(iss.val)
  
  ## Calculate ps
  b <- b0 + gcs.val + gender.val + age.val + gen.age.val + iss.val
  b <- as.numeric(b)
  out <- exp(b) / (1 + exp(b))
  
  out <- as.numeric(out)
  assertthat::assert_that(length(out) == 1)
  
  return(out)
  
}