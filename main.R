## Libraries I tried to install but failed: rsvg/diagrammersvg, kableextra, phantomjs
## Todo: CI for AUC
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

noacsr::source_all_functions()

datasets <- import_data(test = TRUE)

## Make dataset names that match merge_data() requirements
datasets[['swetrau']] <- datasets$swetrau_scrambled
datasets[['fmp']] <- datasets$fmp_scrambled
datasets[['atgarder']] <- datasets$atgarder_scrambled
datasets[['problem']] <- datasets$problem_scrambled
datasets[['kvalgranskning2014.2017']] <- datasets$kvalgranskning2014.2017_scrambled

## setup data + store how many included/excluded
df <- merge_data(datasets)
pd <- prep_data(df)
df <- pd[['df']]
counts <- pd[['counts']]

## add scores
df$rts <- apply(df, 1, make_rts)
df$triss <- apply(df, 1, make_triss)
df$normit <- apply(df, 1, make_normit)

## cast to numeric to avoid Problems
df$ofi <- as.numeric(df$ofi)
df$triss <- as.numeric(df$triss)
df$normit <- as.numeric(df$normit)

## some subsetted data to make be friendly to stats functions
df.triss <- df[, c("ofi", "triss")]
df.triss <- df.triss %>% rename(score = triss)
df.normit <- df[, c("ofi", "normit")]
df.normit <- df.normit %>% rename(score = normit)

## make_stats returns a named list with all the things i want; then assign all list members to individual variables for ease of use later
## triss
t.stats <- make_stats(df.triss)
t.model <- t.stats[['model']]
t.model.vals <- c(coeff = coef(summary(t.model))[2,1], pval = coef(summary(t.model))[2,4])
t.roc <- t.stats[['perf']]
t.roc.vals <- c(auc = t.stats[['auc']], auc.ci = t.stats[['auc.ci']], ici = t.stats[['ici']])
t.acc <- t.stats[['acc']]
plot(t.roc)

## normit
n.stats <- make_stats(df.normit)
n.model <- n.stats[['model']]
n.model.vals <- c(coeff = coef(summary(n.model))[2,1], pval = coef(summary(n.model))[2,4])
n.roc <- n.stats[['perf']]
n.roc.vals <- c(auc = n.stats[['auc']], auc.ci = n.stats[['auc.ci']], ici = n.stats[['ici']])
n.acc <- n.stats[['acc']]

## things that can be plotted
## models: plot(t.model)
## roc: plot(t.roc)
## accuracy: plot(t.acc)

## table.one <- make_table_one(cd)
