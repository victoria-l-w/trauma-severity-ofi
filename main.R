## Libraries I tried to install but failed: rsvg/diagrammersvg, kableextra
library(rofi)
library(dplyr)
library(labelled)
library(table1)
library(printr, quietly=TRUE)
library(DiagrammeR)
library(testthat)
library(assertthat)
library(tidyverse)
library(ROCR)
library(caret)
library(caTools)
library(gmish)
library(pROC)
library(gt)
library(gtsummary)
library(boot)
library('rlist')

noacsr::source_all_functions()

set.seed(1112)

datasets <- import_data(test = TRUE)

## Make dataset names that match merge_data() requirements
datasets[['swetrau']] <- datasets$swetrau_scrambled
datasets[['fmp']] <- datasets$fmp_scrambled
datasets[['atgarder']] <- datasets$atgarder_scrambled
datasets[['problem']] <- datasets$problem_scrambled
datasets[['kvalgranskning2014.2017']] <- datasets$kvalgranskning2014.2017_scrambled

## setup data
df <- merge_data(datasets)
pd <- prep_data(df) ## returns a list with the prepped dataset, inclusion counts, and missing parameters
df <- pd[['df']]

## eligibility counts
eligibility <- pd[['eligibility']] ## inclusion/exclusion counts
post.ofi.exclusion <- as.numeric(eligibility[3,3]) + as.numeric(eligibility[4,3]) + as.numeric(eligibility[5,3])
  
## missing data
incomplete.data.tbl <- gt(pd[['incomplete.data']]) ## table nr of rows with missing data for each parameter
incomplete.data.tbl <- incomplete.data.tbl %>%
  tab_header(title = "Table 1. Total no. missing data for each variable in cases excluded for incomplete data")

## add scores
df$rts <- apply(df, 1, make_rts)
df$triss <- apply(df, 1, make_triss)
df$normit <- apply(df, 1, make_normit)
df$ps <- apply(df, 1, make_ps12)

## cast to numeric to avoid Problems
df$ofi <- as.numeric(df$ofi)
df$triss <- as.numeric(df$triss)
df$normit <- as.numeric(df$normit)
df$ps <- as.numeric(df$ps)

## get results, see stats.R
results <- results(df)
results.t <- results[['stats.t']]

## clean the dataset now i'm done with calculations
df$triss <- round(df$triss, digits = 2)
df$normit <- round(df$normit , digits = 2)
df$ps <- round(df$ps , digits = 2)


## comparison of AUC
##auc.tbl.names <- c("TRISS - NORMIT", "TRISS - PS", "NORMIT - PS")
##auc.tbl.diff <- c(aucdiff.tn['diff'], aucdiff.tp['diff'], aucdiff.np['diff'])
##auc.tbl.ci <- c(aucdiff.tn['ci'], aucdiff.tp['ci'], aucdiff.np['ci'])
##auc.tbl.p <- c(aucdiff.tn['p'], aucdiff.tp['p'], aucdiff.np['p'])
##auc.tbl <- tibble("Comparison" = auc.tbl.names, "Difference in AUC" = auc.tbl.diff, "95% CI" = auc.tbl.ci, "p-value", "auc.tbl.p")

## descriptive data
## table.one <- make_table_one(df)
## descr.stats <- table_one_stats(df) ## some manually generated descriptive statistics
## demo <- descr.stats[['demo']]
## ofi.descr <- descr.stats[['ofi.descr']]
## scores.descr <- descr.stats[['scores.descr']]


message("Done!")
