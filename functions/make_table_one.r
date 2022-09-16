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
    ofi = "Opportunity for improvement"
  )

  
  ## Not being used
  ## rndr <- function(x, name, ...) {
  ##  if (!is.numeric(x)) return(render.categorical.default(x))
  ##  what <- switch(name,
  ##                 pt_age_years = "Mean (SD)",
  ##                 ISS  = "Mean (SD)")
  ##  parse.abbrev.render.code(c("", what))(x)
  ## }


  ## Fixing weird rounding issues + removing mean from table
  my.render.cont <- function(x) {
    with(stats.default(x), 
         c("",
           
           "Median (Min, Max)" = sprintf("%s (%s, %s)",
                                         round_pad(MEDIAN, 0), 
                                         round_pad(MIN, 0), 
                                         round_pad(MAX, 0)))
    )
  }

  ## Making table one
  vars2 <- c("pt_age_yrs", "pt_Gender", "res_survival", "host_care_level", "ISS", "NISS", "inj_dominant", "ed_gcs_sum", "ed_rr_value", "ed_sbp_value", "pt_asa_preinjury", "ofi")
  t1 <- table1(~ pt_age_yrs + pt_Gender + res_survival + host_care_level + ISS + NISS + inj_dominant + ed_gcs_sum + ed_rr_value + ed_sbp_value + pt_asa_preinjury | ofi, 
               data=cd[,vars2], overall = FALSE, render.categorical="FREQ (PCTnoNA%)", render.continuous = my.render.cont)

  return(t1)
}