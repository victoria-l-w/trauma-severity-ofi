## Age
## iss, Niss, pt_age_yrs, dom.inj, ed_gcs_sum, ed_sbp_value, ed_rr_value, pt_asa_preinjury, ofi, pt_asa_preinjury

make_table_one <- function(cd) {
  
  ## Renaming data labels
  
  cd$gender <- factor(
    cd$gender,
    levels = c(1, 2),
    labels = c("Male", "Female")
  )
  
  cd$survival <- factor(
    cd$survival,
    levels = c(1, 2),
    labels = c("Yes", "No")
  )
  
  cd$care.level <- factor(
    cd$care.level,
    levels = c(1,2,3,4,5), 
    labels = c("Emergency Department", "General Ward", "Operating Theatre", "High Dependency Unit", "Intensive Care Unit")
  )
  
  cd$dom.inj <- factor(
    cd$dom.inj,
    levels = c(1, 2),
    labels = c("Blunt", "Penetrating"),
  )
  
  cd$ofi <- factor(
    cd$ofi,
    levels = c("Yes", "No"),
    labels = c("Opportunity for improvement", "No opportunities for improvement"),
  )
  
  cd$asa <- factor(
    cd$asa,
    levels = c(1,2,3,4),
    labels = c(1,2,3,4)
  )
  
  ## Renaming column labels
  var_label(cd) <- list (
    age = "Age (years)",
    gender = "Gender",
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
    rts = "Revised Trauma Score"
  )
  
  ## Making table one
  ## vars2 <- c("pt_age_yrs", "gender", "survival", "care.level", "ISS", "NISS", "dom.inj", "ed_gcs_sum", "ed_rr_value", "ed_sbp_value", "pt_asa_preinjury", "ofi")
  table1(~ age + gender + survival + care.level + iss + niss + dom.inj + gcs + ed_rr + ed_sbp + asa + rts | ofi, 
         data=cd, overall = FALSE, render.categorical="FREQ (PCTnoNA%)", footnote="Patient demographics", output = "html", droplevels=TRUE)
}