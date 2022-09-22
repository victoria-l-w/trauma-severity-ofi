## RTS = (0.2908 x RR) + (0.7326 x SBP) + (0.9368 x GCS), where RR/SBP/GCS = numerical values assigned based on a range
## GCS: 3 = 0, 4-5 = 1, 6-8 = 2, 9-12 = 3, 13-15 = 4
## SBP: 0 = 0, 1-49 = 1, 50-75 = 2, 76-89 = 3, >89 = 4
## RR: 0 = 0, 1-5 = 1, 6-9 = 2, >29 = 3, 10-29 = 4
## THIS IS A VERY UGLY WAY TO DO THIS, george dont copy this lmao

make_rts <- function (input.data) {
  lookup.table.RTS <- data.frame(
    score.value = 0:4,
    GCSmin  = c(3, 4, 6, 9, 13),
    GCSmax = c(3, 5, 8, 12, 15),
    SBPmin = c(0, 1, 50, 76, 90),
    SBPmax = c(0, 49, 75, 89, 10000),
    RRmin  = c(0, 1, 6, 30, 10),
    RRmax = c(0, 5, 9, 10000, 29)
    )

  ## Assign RTS score values
  for (i in 1:nrow(input.data)) {
    input.data$gcs.rts.val[i] <- lookup.table.RTS$score.value[input.data$gcs[i] >= lookup.table.RTS$GCSmin & input.data$gcs[i] <= lookup.table.RTS$GCSmax]
    input.data$sbp.rts.val[i] <- lookup.table.RTS$score.value[input.data$ed_sbp_value[i] >= lookup.table.RTS$SBPmin & input.data$ed_sbp_value[i] <= lookup.table.RTS$SBPmax]
    input.data$rr.rts.val[i] <- lookup.table.RTS$score.value[input.data$ed_rr_value[i] >= lookup.table.RTS$RRmin & input.data$ed_rr_value[i] <= lookup.table.RTS$RRmax]
    }

input.data$RTS <- (input.data$rr.rts.val * 0.2908) + (input.data$sbp.rts.val * 0.7326) + (input.data$gcs.rts.val * 0.9368)

return(input.data)

}