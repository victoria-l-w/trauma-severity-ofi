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

noacsr::source_all_functions()

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

## some subsetted data to make be friendly to stats functions
## this means my stats functions can be generic in case i add scores later
df.t <- df[, c("ofi", "triss")] %>% rename(score = triss)
df.n <- df[, c("ofi", "normit")] %>% rename(score = normit)
df.p <- df[, c("ofi", "ps")] %>% rename(score = ps)

## make_stats returns a named list with all the things i want; see stats.R
stats.t <- make_stats(df.t)
or.t <- stats.t[['or']]
or.t <- or.t[2,]
stats.n <- make_stats(df.n)
or.n <- stats.n[['or']]
or.n <- or.n[2,]
stats.p <- make_stats(df.p)
or.p <- stats.p[['or']]
or.p <- or.p[2,]

## differences between AUC
aucdiff.tn <- auc_delta(stats.t[['roc']], stats.n[['roc']]) ## TRISS AUC - NORMIT AUC
aucdiff.tp <- auc_delta(stats.t[['roc']], stats.p[['roc']]) ## TRISS AUC - PS AUC
aucdiff.np <- auc_delta(stats.n[['roc']], stats.p[['roc']]) ## NORMIT AUC - PS AUC

## comparison of AUC
auc.tbl.names <- c("TRISS - NORMIT", "TRISS - PS", "NORMIT - PS")
auc.tbl.diff <- c(aucdiff.tn['diff'], aucdiff.tp['diff'], aucdiff.np['diff'])
auc.tbl.ci <- c(aucdiff.tn['ci'], aucdiff.tp['ci'], aucdiff.np['ci'])
auc.tbl.p <- c(aucdiff.tn['p'], aucdiff.tp['p'], aucdiff.np['p'])
auc.tbl <- tibble("Comparison" = auc.tbl.names, "Difference in AUC" = auc.tbl.diff, "95% CI" = auc.tbl.ci, "p-value", "auc.tbl.p")

## clean the dataset
df$triss <- round(df$triss, digits = 2)
df$normit <- round(df$normit , digits = 2)
df$ps <- round(df$ps , digits = 2)


## descriptive data
table.one <- make_table_one(df)
descr.stats <- table_one_stats(df) ## some manually generated descriptive statistics
demo <- descr.stats[['demo']]
ofi.descr <- descr.stats[['ofi.descr']]
scores.descr <- descr.stats[['scores.descr']]


