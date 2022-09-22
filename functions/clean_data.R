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
  
  ## Get the total number of rows that we begin with, so I can count how many patients have been removed later
  included.numbers <- c(original = nrow(cleaned.data))
  
  ## Remove cases where OFI is NA
  cleaned.data <- cleaned.data %>% filter (ofi != "NA")
  
  ## this is about to get very ugly
  included.numbers["ofi"] <- nrow(cleaned.data)
  
  ## Remove where age <15 
  cleaned.data <- cleaned.data %>% filter (pt_age_yrs >= 15)
  included.numbers["age"] <- nrow(cleaned.data)
  
  ## Remove DOA, not sure what to do if NA/999
  cleaned.data <- cleaned.data %>% filter (Fr1.12 != 1)
  included.numbers["doa"] <- nrow(cleaned.data)  

  ## Remove rows with NA in required fields
  cleaned.data <- cleaned.data %>% filter_at(vars(ISS, NISS, pt_age_yrs, ed_gcs_sum, inj_dominant, ed_sbp_value, ed_rr_value, pt_asa_preinjury),all_vars(!is.na(.)))
  
  ## Remove rows where required values are unknown or 0 (doa)
  cleaned.data <- cleaned.data %>% filter(inj_dominant != 999 & ed_sbp_value > 0 & ed_rr_value > 0 & pt_asa_preinjury != 999 & ed_gcs_sum != 999)
  
  ## Need either an ED GCS or a prehosp GCS, already removed all where ed_gcs_sum = 999 or NA
  v <- c(3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13)
  cleaned.data <- cleaned.data %>% filter(pre_gcs_sum %in% v | ed_gcs_sum %in% v)
  included.numbers["parameters"] <- nrow(cleaned.data)
  
  ## make a new gcs variable that takes into account ed_gcs_sum = 99 
  cleaned.data$gcs <- with (cleaned.data, ifelse (cleaned.data$ed_gcs_sum==99, pre_gcs_sum, ed_gcs_sum))
  
  ## make numbers of patients excluded at every step in a in a very roundabout fashion
  excluded.numbers <- c(ofi = included.numbers["original"] - included.numbers["ofi"])
  excluded.numbers["age"] <- included.numbers["ofi"] - included.numbers["age"]
  excluded.numbers["doa"] <- included.numbers["age"] - included.numbers["doa"]
  excluded.numbers["parameters"] <- included.numbers["doa"] - included.numbers["parameters"]

  if (numbers == TRUE) {
    return (excluded.numbers)
  } else {
  return (cleaned.data)
  }
}
