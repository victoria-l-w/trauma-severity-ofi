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

## exclusion data
counts <- pd[['counts']] ## inclusion/exclusion counts
missing <- pd[['missing']] ## nr of rows with missing data for each parameter

## add scores
df$rts <- apply(df, 1, make_rts)
df$triss <- apply(df, 1, make_triss)
df$normit <- apply(df, 1, make_normit)
df$ps12 <- apply(df, 1, make_ps12)

## cast to numeric to avoid Problems
df$ofi <- as.numeric(df$ofi)
df$triss <- as.numeric(df$triss)
df$normit <- as.numeric(df$normit)
df$ps12 <- as.numeric(df$ps12)

## some subsetted data to make be friendly to stats functions
## this means my stats functions can be generic in case i add scores later
df.t <- df[, c("ofi", "triss")] %>% rename(score = triss)
df.n <- df[, c("ofi", "normit")] %>% rename(score = normit)
df.p <- df[, c("ofi", "ps12")] %>% rename(score = ps12)

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
aucdiff.tp <- auc_delta(stats.t[['roc']], stats.p[['roc']]) ## TRISS AUC - PS12 AUC
aucdiff.np <- auc_delta(stats.n[['roc']], stats.p[['roc']]) ## NORMIT AUC - PS12 AUC

## descriptive data
table.one <- make_table_one(df)
numbers <- table_one_stats(df) ## some manually generated descriptive statistics
