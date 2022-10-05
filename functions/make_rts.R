## RTS = (0.2908 x RR) + (0.7326 x SBP) + (0.9368 x GCS), where RR/SBP/GCS = numerical values assigned based on a range
## GCS: 3 = 0, 4-5 = 1, 6-8 = 2, 9-12 = 3, 13-15 = 4
## SBP: 0 = 0, 1-49 = 1, 50-75 = 2, 76-89 = 3, >89 = 4
## RR: 0 = 0, 1-5 = 1, 6-9 = 2, >29 = 3, 10-29 = 4

make_rts <- function (input.data) {
  
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

  ## Cast variables to numeric to ensure they can be used for calculations
  gcs <- as.numeric(input.data["gcs"])
  rr <- as.numeric(input.data["ed_rr_value"])
  sbp <- as.numeric(input.data["ed_sbp_value"])

  ## Select the appropriate score value for each parameter
  gcs.rts <-  lookup.rts$score.value[gcs >= lookup.rts$GCSmin & gcs <= lookup.rts$GCSmax]
  sbp.rts <-  lookup.rts$score.value[sbp >= lookup.rts$SBPmin & sbp <= lookup.rts$SBPmax]
  rr.rts <-   lookup.rts$score.value[rr >= lookup.rts$RRmin & rr <= lookup.rts$RRmax]
  
  ## Calculate RTS!
  rts.val <- (rr.rts * 0.2908) + (sbp.rts * 0.7326) + (gcs.rts * 0.9368)
  
  assertthat::assert_that(length(rts.val) == 1)
  
  return(rts.val)
  
}