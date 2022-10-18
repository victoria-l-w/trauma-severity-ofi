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

## cast to numeric to avoid Problems
df$ofi <- as.numeric(df$ofi)
df$triss <- as.numeric(df$triss)
df$normit <- as.numeric(df$normit)

## some subsetted data to make be friendly to stats functions
## this means my stats functions can be generic in case i add scores later
t.df <- df[, c("ofi", "triss")] %>% rename(score = triss)
n.df <- df[, c("ofi", "normit")] %>% rename(score = normit)

## make_stats returns a named list with all the things i want; see stats.R
t.stats <- make_stats(t.df)
t.or <- t.stats[['or']]
t.or <- t.or[2,]
n.stats <- make_stats(n.df)
n.or <- n.stats[['or']]
n.or <- n.or[2,]

## descriptive data
table.one <- make_table_one(df)
numbers <- table_one_stats(df) ## some manually generated descriptive statistics

## plots to be used in manuscript
t.plot.roc <- plot(t.stats[['perf']], main="TRISS Receiver Operating Characteristic Curve", colorize = TRUE)
t.plot.acc <- plot(t.stats[['acc']], main="TRISS Accuracy")
n.plot.roc <- plot(n.stats[['perf']], main="TRISS Receiver Operating Characteristic Curve", colorize = TRUE)
n.plot.acc <- plot(n.stats[['acc']], main="TRISS Accuracy")