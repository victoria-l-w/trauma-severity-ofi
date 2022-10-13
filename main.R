## Libraries I tried to install but failed: rsvg/diagrammersvg, kableextra
## Todo:
## table1
## finish unit tests
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
library(webshot)

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
pd <- prep_data(df)
df <- pd[['df']]
counts <- pd[['counts']] ## stores inclusion counts

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
t.auc <- round(t.stats[['auc']], digits = 2)
t.auc.ci <- round(t.stats[['auc.ci']], digits = 2)
## very confusing because level = 0.95 gives "97.5" and "2.5" in the output? at least i can easily change this later
t.or <- exp(cbind("or" = coef(t.model), confint.default(t.model, level = 0.90)))
t.or <- round(t.or[2,], digits = 2)
t.perf <- t.stats[['perf']]
t.acc <- t.stats[['acc']]

## normit
n.stats <- make_stats(df.normit)
n.model <- n.stats[['model']]
n.auc <- round(n.stats[['auc']], digits = 2)
n.auc.ci <- round(n.stats[['auc.ci']], digits = 2)
n.or <- exp(cbind("or" = coef(n.model), confint.default(n.model, level = 0.90)))
n.or <- round(n.or[2,])
n.perf <- n.stats[['perf']]
n.acc <- n.stats[['acc']]

## things that can be plotted
## models: plot(t.model)
## roc: plot(t.roc)
## accuracy: plot(t.acc)

table.one <- make_table_one(df)

## make some numbers to quote in results bc i dont see a way to extract them from table1
numbers <- table_one_stats(df)
