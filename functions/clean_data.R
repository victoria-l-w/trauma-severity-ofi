## All values that are necessary: iss, niss, age, dom.inj, gcs, sbp, rr, asa, pre.gcs if ed.gcs == 99

clean_data <- function(df, numbers = FALSE) {
  
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
  
  ## Renaming some columns to make it easier for me to remember/more standardised
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
                      age = pt_age_yrs,
                      )
  
  ## Storing the inclusion/exclusion counts at each step so I can use those later
  original.count <- nrow(df)
  inclusion.counts <- data.frame (step  = c("original"),
                    included = c(original.count),
                    excluded = c(0)
                                  )
  ##
  ## Exclusion: ofi
  ##
  df <- df %>% filter (ofi != "NA")

  ## Convert ofu values to 0 & 1 to make it easier later
  df$ofi[df$ofi == "Yes"] <- 1
  df$ofi[df$ofi == "No"] <- 0
  
  ## Add ofi inclusion/exclusion counts
  ofi.kept <- nrow(df)
  ofi.excluded <- original.count - ofi.kept
  inclusion.counts[nrow(inclusion.counts) + 1,] = c("ofi", ofi.kept, ofi.excluded)
  
  ##
  ## Exclusion: age
  ##
  
  df <- df %>% filter (age >= 15)
  
  age.kept <- nrow(df)
  age.excluded <- ofi.kept - age.kept
  inclusion.counts[nrow(inclusion.counts) + 1,] = c("age", age.kept, age.excluded)
  
  ##
  ## Exclusion: doa
  ##
  
  df <- df %>% filter(is.na(doa)|doa != 1)
  
  doa.kept <- nrow(df)
  doa.excluded <- age.kept - doa.kept
  inclusion.counts[nrow(inclusion.counts) + 1,] = c("doa", doa.kept, doa.excluded)

  ##
  ## Exclusion: parameters
  ## 
  
  ## Not 100% sure if really need to remove sbp/rr == 0
  df <- df %>% filter_at(vars(iss, niss, age, ed.gcs, dom.inj, ed.sbp, ed.rr, asa),all_vars(!is.na(.)))
  df <- df %>% filter(dom.inj != 999 & ed.sbp > 0 & ed.rr > 0 & asa != 999 & ed.gcs != 999)
  
  ## Either ed.gcs or pre.gcs should have a usable GCS. ed.gcs == 99 and NA was removed earlier 
  v <- c(3:15)
  df <- df %>% filter(pre.gcs %in% v | ed.gcs %in% v)
  
  ## Make a new gcs variable that takes into account ed.gcs = 99 
  df$gcs <- with(df, ifelse (df$ed.gcs==99, pre.gcs, ed.gcs))
  
  param.kept <- nrow(df)
  param.excluded <- doa.kept - param.kept
  inclusion.counts[nrow(inclusion.counts) + 1,] = c("parameters", param.kept, param.excluded)
  
  ##
  ## Exclusion: totals
  ##
  
  total.excluded <- original.count - param.kept
  inclusion.counts[nrow(inclusion.counts) + 1,] = c("total", param.kept, total.excluded)
  
  ## 
  ## Testing
  ## 
  
  assert_that(noNA(df$ofi))
  ofi.test <- c("1", "0")
  assert_that(are_equal(ofi.test, unique(df$ofi)))

  if (numbers == TRUE) {
    return (inclusion.counts)
  } else {
  return (df)
  }
}
