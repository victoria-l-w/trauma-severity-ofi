## Source: https://journals.lww.com/jtrauma/Fulltext/2010/04000/Trauma_and_Injury_Severity_Score__TRISS_.2.aspx
## Using the "imputed NTDB" coefficients as they were recommended
## I can't see a coefficient that is directly for RTS so I substituted the formula for RTS into the TRISS formula

make_triss <- function(input.data) {
  
  ## Cast variables to numeric to ensure they can be used for calculations
  dom.inj <- as.numeric(input.data["dom.inj"])
  iss <- as.numeric(input.data["iss"])
  age <- as.numeric(input.data["age"])
  gcs <- as.numeric(input.data["gcs"])
  sbp <- as.numeric(input.data["ed.sbp"])
  rr <- as.numeric(input.data["ed.rr"])
  
  if (dom.inj == 1) { ## 1 = blunt
    b0 <- 1.6494 ## intercept
    b1 <- 0.0095 ## RR
    b2 <- 0.4260 ## SBP
    b3 <- 0.6307 ## GCS
    b4 <- -0.0795 ## ISS
    b5 <- -1.6216 ## Age
  } else {
    b0 <- -0.5757
    b1 <- 0.1517
    b2 <- 0.5237
    b3 <- 0.8310
    b4 <- -0.0872
    b5 <- -0.8714
  }
  
  b1 <- as.numeric(b1)
  b2 <- as.numeric(b2)
  b3 <- as.numeric(b3)
  b4 <- as.numeric(b4)
  b5 <- as.numeric(b5)
  
  ## Assign the coefficient for age
  if (age > 54) {age.val <- 1} else {age.val <- 0}
  
  ## Saving the parameter scores for later
  lookup.rts <- data.frame(
    score.value = 0:4,
    GCSmin  = c(3, 4, 6, 9, 13),
    GCSmax = c(3, 5, 8, 12, 15),
    SBPmin = c(0, 1, 50, 76, 90),
    SBPmax = c(0, 49, 75, 89, 10000),
    RRmin  = c(0, 1, 6, 30, 10),
    RRmax = c(0, 5, 9, 10000, 29)
  )
  
  ## Select the appropriate RTS value for each parameter
  r.gcs <-  lookup.rts$score.value[gcs >= lookup.rts$GCSmin & gcs <= lookup.rts$GCSmax]
  r.sbp <-  lookup.rts$score.value[sbp >= lookup.rts$SBPmin & sbp <= lookup.rts$SBPmax]
  r.rr <-   lookup.rts$score.value[rr >= lookup.rts$RRmin & rr <= lookup.rts$RRmax]
  
  ## Calculating TRISS
  b <- b0 + (r.rr * 0.2908 * b1) + (r.sbp * 0.7326 * b2) + (r.gcs * 0.9368 * b3) + (iss * b4) + (age.val * b5)
  out <- 1 / (1 + exp(b * -1))
  
  out <- as.numeric(out)
  assertthat::assert_that(length(out) == 1)
  
  return(out)
}