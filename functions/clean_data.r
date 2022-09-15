## All values that are necessary:
##  For TRISS: ISS, pt_age_years, inj_dominant (blunt or penetrating), RTS: ed_gcs_sum (GCS on arrival at hosp), ed_sbp_value (systolic BP), ed_rr_value (RR)
##  For NORMIT: NISS, pt_age_years, pt_asa_preinjury, RTS: ed_gcs_sum (GCS on arrival at hosp), ed_sbp_value (systolic BP), ed_rr_value (RR)
##  For OFI: VK_avslutad, problemomrade_.FMP
##  Interpretation of OFI stuff:
##  VK_avslutad -- Whether quality review was done ja/nej
##  Problemomrade_.FMP -- Whether there was OFI, OK = no OFI
##  tra_Dodsfallanalysgenomford -- Maybe?? Difference between this and VK_avslutad?

clean_data <- function(dirty_data) {

  ## Remove rows with NA in required fields
  cleaned_data <- dirty_data %>% filter_at(vars(ISS, NISS, pt_age_yrs, inj_dominant, ed_gcs_sum, ed_sbp_value, ed_rr_value, pt_asa_preinjury, VK_avslutad, Problemomrade_.FMP),all_vars(!is.na(.)))
  
  ## Remove cases with no quality review (?, unclear if it's only VK_avslutad or also tra_Dodsfallsanalysgenomford, ask about this)
  cleaned_data <- cleaned_data %>% filter(VK_avslutad == 'Ja' | VK_avslutad == 'ja')
  
  ## Remove rows where required values are unknown & filter away age groups. Systolic blood pressure should prolly be >0, unless the patient is DOA? Same for RR.
  cleaned_data <- cleaned_data %>% filter(inj_dominant != 999 & ed_gcs_sum != 999 & ed_sbp_value > 0 & ed_rr_value > 0 & pt_asa_preinjury != 999 & pt_age_yrs >= 15)
  
  ## Question to look into: It sounds like NORMIT allows for GCS to be replaced with prehosp GCS when intubated, but the same is not the case for TRISS (?). Keep intubated pts (coded as 99 here) for NORMIT analysis or remove so that the populations will be the same for both TRISS and NORMIT?
  
  return (cleaned_data)
}
