## Age
## iss, Niss, pt_age_yrs, dom.inj, ed_gcs_sum, ed.sbp_value, ed.rr_value, pt_asa_preinjury, ofi, pt_asa_preinjury

make_table_one <- function(cd) {
  
  ## Renaming data labels
  
  df$gender <- factor(
    df$gender,
    levels = c(1, 2),
    labels = c("Male", "Female")
  )
  
  df$survival <- factor(
    df$survival,
    levels = c(1, 2),
    labels = c("Yes", "No")
  )
  
  df$care.level <- factor(
    df$care.level,
    levels = c(1,2,3,4,5), 
    labels = c("Emergency Department", "General Ward", "Operating Theatre", "High Dependency Unit", "Intensive Care Unit")
  )
  
  df$dom.inj <- factor(
    df$dom.inj,
    levels = c(1, 2),
    labels = c("Blunt", "Penetrating"),
  )
  
  df$ofi <- factor(
    df$ofi,
    levels = c("1", "0"),
    labels = c("Opportunity for improvement", "No opportunities for improvement"),
  )
  
  df$asa <- factor(
    df$asa,
    levels = c(1,2,3,4),
    labels = c(1,2,3,4)
  )
  
  ## Renaming column labels
  var_label(df) <- list (
    age = "Age — yrs",
    gender = "Sex",
    survival = "30 day survival",
    care.level = "Highest level of care",
    iss = "ISS",
    niss = "NISS",
    dom.inj = "Dominating Type of Injury",
    gcs = "GCS",
    ed.rr = "Respiratory Rate",
    ed.sbp = "Systolic blood pressure (mmHg)",
    asa = "ASA score",
    ofi = "Opportunity for improvement",
    rts = "Revised Trauma Score",
    triss = "TRISS",
    normit = "NORMIT",
    ps = "PS"
  )
  
  
  ## Making table one
  ## Removed care.level and survival bc of missing data, not sure if to include that
  vars2 <- c("age", "gender", "iss", "niss", "dom.inj", "gcs", "ed.rr", "ed.sbp", "asa", "ofi", "rts", "triss", "normit", "ps")
  table.1 <- table1(~ age + gender + iss + niss + dom.inj + gcs + ed.rr + ed.sbp + asa + rts + triss + normit + ps | ofi, 
                    data = df[,vars2], 
                    overall = "Total", 
                    render.categorical = "FREQ (PCTnoNA%)", 
                    caption = "Table 2. Characteristics of participants."
                    )
  
}