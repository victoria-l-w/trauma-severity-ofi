## All values that are necessary:
##  For TRISS: ISS, pt_age_yrs, inj_dominant (blunt or penetrating), RTS: ed_gcs_sum (GCS on arrival at hosp), ed_sbp_value (systolic BP), ed_rr_value (RR)
##  For NORMIT: NISS, pt_age_yrs, pt_asa_preinjury, RTS: ed_gcs_sum (GCS on arrival at hosp), ed_sbp_value (systolic BP), ed_rr_value (RR)
##  Add numbers for numbers excluded at each step 
##  So need to return a list? HMMMMM
##  For GCS = 99, take prehosp value, (?) exclude if no prehosp value

clean_data <- function(dirty.data, numbers = FALSE) {
  
  ## Make table smaller overall, kept some ?unnecessary value in case they're possibly interesting to have in tableone
  ## Also didn't interact with any of the ofi-adjacent variables like VK_avslutad bc it seems as tho create_ofi handles all of that
  cleaned.data <- dirty.data[,c("pt_Gender", "res_survival", "host_care_level", "inj_dominant", "ofi", "Fr1.12", "pt_asa_preinjury", "ISS", "NISS", "ed_gcs_sum", "ed_rr_value", "ed_sbp_value", "pre_gcs_sum", "pt_age_yrs")]
  
  ## Storing the inclusion/exclusion counts at each step so I can redovisa those later
  ## (This is probably a very stupid way to do this)
  original.count <- nrow(cleaned.data)
  inclusion.counts <- data.frame (step  = c("original"),
                    included = c(original.count),
                    excluded = c(0)
  )
  
  ## OFI exclusion
  cleaned.data <- cleaned.data %>% filter (ofi != "NA")
  
  ## OFI exclusion counts
  ofi.kept <- nrow(cleaned.data)
  ofi.excluded <- original.count - ofi.kept
  inclusion.counts[nrow(inclusion.counts) + 1,] = c("ofi", ofi.kept, ofi.excluded)
  
  ## Age exclusion
  cleaned.data <- cleaned.data %>% filter (pt_age_yrs >= 15)
  
  ## Age exclusion counts
  age.kept <- nrow(cleaned.data)
  age.excluded <- ofi.kept - age.kept
  inclusion.counts[nrow(inclusion.counts) + 1,] = c("age", age.kept, age.excluded)
  
  ## Using [] and not filter() to remove DOA = true, because filter() removes NA
  ## And I'm not sure how NA/999 should be handled
  ## Do I even need to remove DOA at all? <- Ask about these things
  cleaned.data <- cleaned.data[cleaned.data$Fr1.12 != 1,]
  
  ## DOA exclusion counts
  doa.kept <- nrow(cleaned.data)
  doa.excluded <- age.kept - doa.kept
  inclusion.counts[nrow(inclusion.counts) + 1,] = c("doa", doa.kept, doa.excluded)

  ## Remove rows with NA in required fields
  cleaned.data <- cleaned.data %>% filter_at(vars(ISS, NISS, pt_age_yrs, ed_gcs_sum, inj_dominant, ed_sbp_value, ed_rr_value, pt_asa_preinjury),all_vars(!is.na(.)))
  
  ## Remove rows where required values are unknown or 0 (doa?)
  ## Not 100% certain I should remove sbp=0 or rr=0 
  cleaned.data <- cleaned.data %>% filter(inj_dominant != 999 & ed_sbp_value > 0 & ed_rr_value > 0 & pt_asa_preinjury != 999 & ed_gcs_sum != 999)
  
  ## Need either an ED GCS or a prehosp GCS, already removed all where ed_gcs_sum = 999 or NA
  v <- c(3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13)
  cleaned.data <- cleaned.data %>% filter(pre_gcs_sum %in% v | ed_gcs_sum %in% v)
  
  ## make a new gcs variable that takes into account ed_gcs_sum = 99 
  cleaned.data$gcs <- with (cleaned.data, ifelse (cleaned.data$ed_gcs_sum==99, pre_gcs_sum, ed_gcs_sum))
  
  ## Parameters exclusion counts
  param.kept <- nrow(cleaned.data)
  param.excluded <- doa.kept - param.kept
  inclusion.counts[nrow(inclusion.counts) + 1,] = c("parameters", param.kept, param.excluded)
  
  ## Total exclusion counts
  total.excluded <- original.count - param.kept
  inclusion.counts[nrow(inclusion.counts) + 1,] = c("total", param.kept, total.excluded)  

  if (numbers == TRUE) {
    return (inclusion.counts)
  } else {
  return (cleaned.data)
  }
}
