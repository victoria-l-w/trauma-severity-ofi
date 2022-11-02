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
                      age = pt_age_yrsg
                      )
  
  ## Storing the inclusion/exclusion counts at each step so I can use those later
  original.count <- nrow(df)
  inclusion.counts <- data.frame (step  = c("original"),
                    included = c(original.count),
                    excluded = c(0)
                                  )
  ## Exclusion: ofi

  df <- df %>% filter (ofi != "NA")
  
  ## So what I'm doing is:
  ## After every exclusion counting the new number of rows, then comparing it with the previous number of rows to see how many were excluded
  ofi.kept <- nrow(df)
  ofi.excluded <- original.count - ofi.kept
  inclusion.counts[nrow(inclusion.counts) + 1,] = c("ofi", ofi.kept, ofi.excluded)
  
  ## Exclusion: age
  
  ## df <- df %>% filter (age >= 15)
  
  age.kept <- nrow(df)
  age.excluded <- ofi.kept - age.kept
  inclusion.counts[nrow(inclusion.counts) + 1,] = c("age", age.kept, age.excluded)
  
  ## Exclusion: doa
  
  df <- df %>% filter(is.na(doa)|doa != 1)
  df <- df %>% filter (ed.sbp != 0 & ed.rr != 0 & ed.gcs != 3)
  
  doa.kept <- nrow(df)
  doa.excluded <- age.kept - doa.kept
  inclusion.counts[nrow(inclusion.counts) + 1,] = c("doa", doa.kept, doa.excluded)

  ## Exclusion: parameters
  
  ## Jonatan wanted me to make a table of exactly how many were missing for each parameter
  m.gcs <- sum(is.na(df$ed.gcs)) + nrow(df[df$ed.gcs == 999 & !is.na(df$ed.gcs),]) ## This does not take into account patients removed where GCS == 99 & there's no prehospital GCS, fix later
  m.asa <- sum(is.na(df$asa)) + nrow(df[df$asa == 999 & !is.na(df$asa),])
  m.rr <- sum(is.na(df$ed.rr)) + nrow(df[df$ed.rr == 0 & !is.na(df$ed.rr),])
  m.sbp <- sum(is.na(df$ed.sbp)) + nrow(df[df$ed.sbp == 0 & !is.na(df$ed.sbp),])
  m.dominj <- sum(is.na(df$dom.inj)) + nrow(df[df$dom.inj == 999 & !is.na(df$dom.inj),])
  m.age <- sum(is.na(df$age))
  m.iss <- sum(is.na(df$iss))
  m.niss <- sum(is.na(df$niss))
  m.gender <- sum(is.na(df$gender)) + nrow(df[df$gender == 999 & !is.na(df$gender),])
  m.names <- c("GCS", "ASA", "RR", "SBP", "Dominant injury type", "Age", "ISS", "NISS", "Gender")
  m.numbers <- c(m.gcs, m.asa, m.rr, m.sbp, m.dominj, m.age, m.iss, m.niss, m.gender)
  missing <- tibble("Required parameter" = m.names, "Total no. cases without required parameter" = m.numbers)

  df <- df %>% filter_at(vars(iss, niss, age, ed.gcs, dom.inj, ed.sbp, ed.rr, asa, gender),all_vars(!is.na(.)))
  df <- df %>% filter(dom.inj != 999 & asa != 999 & ed.gcs != 999 & gender != 999)
  
  ## Either ed.gcs or pre.gcs should have a usable GCS. ed.gcs == 999 and NA was removed earlier 
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
  ## Cleaning
  ## 
  
  df$ofi[df$ofi == "Yes"] <- 1
  df$ofi[df$ofi == "No"] <- 0

  ## 
  ## Testing
  ## 
  
  assert_that(noNA(df$ofi))
  ofi.test <- c("1", "0")
  assert_that(are_equal(ofi.test, unique(df$ofi)))

  ret <- list(df = df, counts = inclusion.counts, missing = missing)

  return(ret)
}
