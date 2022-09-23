## Age
## ISS, NISS, pt_age_yrs, inj_dominant, ed_gcs_sum, ed_sbp_value, ed_rr_value, pt_asa_preinjury, ofi, pt_asa_preinjury

make_table_one <- function(cd) {
  
  ## Renaming data labels
  
  cd$pt_Gender <- factor(
    cd$pt_Gender,
    levels = c(1, 2),
    labels = c("Male", "Female")
  )
  
  cd$res_survival <- factor(
    cd$res_survival,
    levels = c(1, 2),
    labels = c("Yes", "No")
  )
  
  cd$host_care_level <- factor(
    cd$host_care_level,
    levels = c(1,2,3,4,5), 
    labels = c("Emergency Department", "General Ward", "Operating Theatre", "High Dependency Unit", "Intensive Care Unit")
  )
  
  cd$inj_dominant <- factor(
    cd$inj_dominant,
    levels = c(1, 2),
    labels = c("Blunt", "Penetrating"),
  )
  
  cd$ofi <- factor(
    cd$ofi,
    levels = c("Yes", "No"),
    labels = c("Opportunity for improvement", "No opportunities for improvement"),
  )
  
  cd$pt_asa_preinjury <- factor(
    cd$pt_asa_preinjury,
    levels = c(1,2,3,4),
    labels = c(1,2,3,4)
  )
  
  ## Renaming column labels
  var_label(cd) <- list (
    pt_age_yrs = "Age (years)",
    pt_Gender = "Gender",
    res_survival = "30 day survival",
    host_care_level = "Highest level of care",
    ISS = "ISS",
    NISS = "NISS",
    inj_dominant = "Dominating Type of Injury",
    ed_gcs_sum = "GCS",
    ed_rr_value = "Respiratory Rate",
    ed_sbp_value = "Systolic blood pressure (mmHg)",
    pt_asa_preinjury = "ASA score",
    ofi = "Opportunity for improvement",
    RTS = "Revised Trauma Score"
  )
  
  ## Making table one
  ## vars2 <- c("pt_age_yrs", "pt_Gender", "res_survival", "host_care_level", "ISS", "NISS", "inj_dominant", "ed_gcs_sum", "ed_rr_value", "ed_sbp_value", "pt_asa_preinjury", "ofi")
  table1(~ pt_age_yrs + pt_Gender + res_survival + host_care_level + ISS + NISS + inj_dominant + ed_gcs_sum + ed_rr_value + ed_sbp_value + pt_asa_preinjury + RTS | ofi, 
         data=cd, overall = FALSE, render.categorical="FREQ (PCTnoNA%)", footnote="Patient demographics", output = "html", droplevels=TRUE)
}