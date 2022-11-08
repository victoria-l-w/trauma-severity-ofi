## All values that are necessary: iss, niss, age, dom.inj, gcs, sbp, rr, asa, pre.gcs if ed.gcs == 99

prep_data <- function(df, numbers = FALSE) {
  
  df$ofi <- create_ofi(df)
  
  ## Kept some possibly unnecessary variables in case they're interesting to have in table one
  ## Didn't interact with any of the ofi-adjacent variables like VK_avslutad because it seems as though create_ofi handles all of that
  df <- df[,c("pt_Gender",
              "res_survival",
              "host_care_level",
              "inj_dominant",
              "ofi", "Fr1.12",
              "pt_asa_preinjury",
              "ISS",
              "NISS",
              "ed_gcs_sum",
              "ed_rr_value",
              "ed_sbp_value",
              "pre_gcs_sum",
              "pt_age_yrs"
              )]
  
  df <- df %>% rename(gender = pt_Gender,
                      survival = res_survival,
                      care.level = host_care_level,
                      dom.inj = inj_dominant,
                      doa = Fr1.12, 
                      asa = pt_asa_preinjury,
                      iss = ISS,
                      niss = NISS,
                      ed.gcs = ed_gcs_sum,
                      ed.rr = ed_rr_value,
                      ed.sbp = ed_sbp_value,
                      pre.gcs = pre_gcs_sum,
                      age = pt_age_yrs
                      )
  
  ## Storing the inclusion/exclusion counts at each step
  exclusion <- data.frame (step  = c("original"),
                    included = c(nrow(df)),
                    excluded = c(0))
  
  ## OFI exclusion

  df <- df %>% filter (!is.na(ofi))
  exclusion[nrow(exclusion) + 1,] <- c("ofi", nrow(df), exclusion[1,2] - nrow(df))
  
  ## Age exclusion
  
  df <- df %>% filter (age >= 15 | is.na(df$asa))
  exclusion[nrow(exclusion) + 1,] <- c("age", nrow(df), as.numeric(exclusion[2,2]) - nrow(df))
  
  ## DOA exclusion
  
  df <- df %>% filter(is.na(doa)|doa != 1)
  df <- df %>% filter (ed.sbp != 0 | ed.rr != 0 | ed.gcs != 3 | is.na(ed.sbp) | is.na(ed.rr) | is.na(ed.gcs))
  exclusion[nrow(exclusion) + 1,] <- c("doa", nrow(df), as.numeric(exclusion[3,2]) - nrow(df))
  
  ## Recording data on each missing parameter
  na.data <- c(
    gcs = sum(is.na(df$ed.gcs)) + nrow(df[df$ed.gcs == 999 & !is.na(df$ed.gcs),]),
    asa = sum(is.na(df$asa)) + nrow(df[df$asa == 999 & !is.na(df$asa),]),
    rr = sum(is.na(df$ed.rr)) + nrow(df[df$ed.rr == 0 & !is.na(df$ed.rr),]),
    sbp = sum(is.na(df$ed.sbp)) + nrow(df[df$ed.sbp == 0 & !is.na(df$ed.sbp),]),
    dominj = sum(is.na(df$dom.inj)) + nrow(df[df$dom.inj == 999 & !is.na(df$dom.inj),]),
    age = sum(is.na(df$age)),
    iss = sum(is.na(df$iss)),
    niss = sum(is.na(df$niss)),
    gender = sum(is.na(df$gender)) + nrow(df[df$gender == 999 & !is.na(df$gender),])
  )
                                            
  ## Parameter exclusion
  df <- df %>% filter_at(vars(iss, niss, age, ed.gcs, dom.inj, ed.sbp, ed.rr, asa, gender),all_vars(!is.na(.)))
  df <- df %>% filter(dom.inj != 999 & asa != 999 & ed.gcs != 999 & gender != 999)
  
  ## Either ed.gcs or pre.gcs should have a usable GCS. ed.gcs == 999 and NA were removed earlier 
  n <- nrow(df) ## to track how many are removed for missing a prehosp gcs
  
  v <- c(3:15)
  df <- df %>% filter(pre.gcs %in% v | ed.gcs %in% v)
  
  na.data["gcs"] <- na.data["gcs"] + n - nrow(df) ## adding missing pre.gcs when edgcs == 99 to missing parameter count
  exclusion[nrow(exclusion) + 1,] <- c("parameters", nrow(df), as.numeric(exclusion[4,2]) - nrow(df))
  
  ##
  ## Exclusion: totals
  ##
  
  exclusion[nrow(exclusion) + 1,] <- c("total", nrow(df), as.numeric(exclusion[1,2]) - nrow(df))
  exclusion[nrow(exclusion) + 1,] <- c("post-ofi", 0, as.numeric(exclusion[3,3]) + as.numeric(exclusion[4,3]) + as.numeric(exclusion[5,3]))
  
  ##
  ## Cleaning
  ## 
  
  df$ofi[df$ofi == "Yes"] <- 1
  df$ofi[df$ofi == "No"] <- 0
  df$ofi <- as.numeric(df$ofi)
  
  df$gcs <- with(df, ifelse (df$ed.gcs==99, pre.gcs, ed.gcs)) ## Make a new gcs variable that takes into account ed.gcs = 99 

  ## 
  ## Testing
  ## 
  
  assert_that(noNA(df$ofi))
  ofi.test <- c(1, 0)
  assert_that(are_equal(ofi.test, unique(df$ofi)))

  out <- list(df = df, exclusion = exclusion, na.data = na.data)
  message("The dataset has been prepared.")
  return(out)
}
