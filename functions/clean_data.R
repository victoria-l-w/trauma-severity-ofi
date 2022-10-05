## All values that are necessary:
## ISS, pt_age_yrs, inj_dominant, ed_gcs_sum, ed_sbp_value, ed_rr_value, NISS, pt_asa_preinjury
## pre_gcs_value if ed_gcs_sum == 99

clean_data <- function(dirty.data, numbers = FALSE) {
  
  ## Only select relevant variables for the data frame
  ## Kept some possibly unnecessary variables in case they're interesting to have in table one
  ## Also didn't interact with any of the ofi-adjacent variables like VK_avslutad because it seems as though create_ofi handles all of that
  cleaned.data <- dirty.data[,c("pt_Gender", "res_survival", "host_care_level", "inj_dominant", "ofi", "Fr1.12", "pt_asa_preinjury", "ISS", "NISS", "ed_gcs_sum", "ed_rr_value", "ed_sbp_value", "pre_gcs_sum", "pt_age_yrs")]
  
  ## Storing the inclusion/exclusion counts at each step so I can use those later
  original.count <- nrow(cleaned.data)
  inclusion.counts <- data.frame (step  = c("original"),
                    included = c(original.count),
                    excluded = c(0)
                                  )
  
  ## Exclusion where OFI is NA
  cleaned.data <- cleaned.data %>% filter (ofi != "NA")


  ## Convert OFI values to 0 & 1 to make it easier later
  cleaned.data$ofi[cleaned.data$ofi == "Yes"] <- 1
  cleaned.data$ofi[cleaned.data$ofi == "No"] <- 0
  
  ## Add ofi inclusion/exclusion counts
  ofi.kept <- nrow(cleaned.data)
  ofi.excluded <- original.count - ofi.kept
  inclusion.counts[nrow(inclusion.counts) + 1,] = c("ofi", ofi.kept, ofi.excluded)
  
  ## Exclude all rows where age <15 
  cleaned.data <- cleaned.data %>% filter (pt_age_yrs >= 15)
  
  ## Add age inclusion/exclusion counts
  age.kept <- nrow(cleaned.data)
  age.excluded <- ofi.kept - age.kept
  inclusion.counts[nrow(inclusion.counts) + 1,] = c("age", age.kept, age.excluded)
  
  ## DOA exclusion
  ## Using [] and not filter() to remove DOA = true, because filter() removes NA, and I'm not sure how NA/999 should be handled
  ## To ask: do I even need to remove DOA at all?
  cleaned.data <- cleaned.data[cleaned.data$Fr1.12 != 1,]
  
  doa.kept <- nrow(cleaned.data)
  doa.excluded <- age.kept - doa.kept
  inclusion.counts[nrow(inclusion.counts) + 1,] = c("doa", doa.kept, doa.excluded)

  ## Parameters exclusion (parameters where NA/0/999 in required fields)
  ## Not 100% sure if really need to remove sbp/rr == 0
  cleaned.data <- cleaned.data %>% filter_at(vars(ISS, NISS, pt_age_yrs, ed_gcs_sum, inj_dominant, ed_sbp_value, ed_rr_value, pt_asa_preinjury),all_vars(!is.na(.)))
  cleaned.data <- cleaned.data %>% filter(inj_dominant != 999 & ed_sbp_value > 0 & ed_rr_value > 0 & pt_asa_preinjury != 999 & ed_gcs_sum != 999)
  
  
  ## Either ed_gcs or pre_gcs should have a usable GCS. ed_gcs == 99 and NA was removed earlier 
  v <- c(3:15)
  cleaned.data <- cleaned.data %>% filter(pre_gcs_sum %in% v | ed_gcs_sum %in% v)
  
  ## Make a new gcs variable that takes into account ed_gcs_sum = 99 
  cleaned.data$gcs <- with (cleaned.data, ifelse (cleaned.data$ed_gcs_sum==99, pre_gcs_sum, ed_gcs_sum))
  
  param.kept <- nrow(cleaned.data)
  param.excluded <- doa.kept - param.kept
  inclusion.counts[nrow(inclusion.counts) + 1,] = c("parameters", param.kept, param.excluded)
  
  ## Total exclusion counts
  total.excluded <- original.count - param.kept
  inclusion.counts[nrow(inclusion.counts) + 1,] = c("total", param.kept, total.excluded)
  
  ## Testing OFI worked out right
  assert_that(noNA(cleaned.data$ofi))
  ofi.test <- c("1", "0")
  assert_that(are_equal(ofi.test, unique(cleaned.data$ofi)))

  if (numbers == TRUE) {
    return (inclusion.counts)
  } else {
  return (cleaned.data)
  }
}
