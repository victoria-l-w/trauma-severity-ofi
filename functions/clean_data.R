## All values that are necessary:
##  For TRISS: ISS, pt_age_years, inj_dominant (blunt or penetrating), RTS: ed_gcs_sum (GCS on arrival at hosp), ed_sbp_value (systolic BP), ed_rr_value (RR)
##  For NORMIT: NISS, pt_age_years, pt_asa_preinjury, RTS: ed_gcs_sum (GCS on arrival at hosp), ed_sbp_value (systolic BP), ed_rr_value (RR)
##  For OFI: VK_avslutad, problemomrade_.FMP
##  Interpretation of OFI stuff:
##  VK_avslutad -- Whether quality review was done ja/nej
##  Problemomrade_.FMP -- Whether there was OFI, OK = no OFI
##  tra_Dodsfallanalysgenomford -- 
##  Add numbers for numbers excluded at each step 
##  So need to return a list? HMMMMM
## For GCS = 99, take prehosp value, (?) exclude if no prehosp value

clean_data <- function(dirty.data) {
  
  ## Remove rows with NA in required fields
  cleaned.data <- dirty.data %>% filter_at(vars(ISS, NISS, pt_age_yrs, inj_dominant, ed_gcs_sum, ed_sbp_value, ed_rr_value, pt_asa_preinjury, Problemomrade_.FMP),all_vars(!is.na(.)))
  
  ## Remove cases where OFI is NA
  cleaned.data <- cleaned.data %>% filter (ofi != "NA")
  
  ## Remove rows where required values are unknown & filter away age groups. Systolic blood pressure should prolly be >0, unless the patient is DOA? Same for RR.
  cleaned.data <- cleaned.data %>% filter(inj_dominant != 999 & ed_gcs_sum != 999 & ed_sbp_value > 0 & ed_rr_value > 0 & pt_asa_preinjury != 999 & pt_age_yrs >= 15)
  
  return (cleaned.data)
}
