## Libraries I tried to install but failed: rsvg/diagrammersvg, kableextra, phantomjs
## todo
## rocr accuracy ici auc
## ci = bootstrap?
## id = abbrev of input data
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

noacsr::source_all_functions()

datasets <- import_data(test = TRUE)

## Make dataset names that match merge_data() requirements
datasets[['swetrau']] <- datasets$swetrau_scrambled
datasets[['fmp']] <- datasets$fmp_scrambled
datasets[['atgarder']] <- datasets$atgarder_scrambled
datasets[['problem']] <- datasets$problem_scrambled
datasets[['kvalgranskning2014.2017']] <- datasets$kvalgranskning2014.2017_scrambled

md <- merge_data(datasets)

md$ofi <- create_ofi(md)

cd <- clean_data(md)

## This returns data on how many patients are kept and excluded at each step 
inclusion.counts <- clean_data(md, numbers = TRUE)

## add scores
cd$rts <- apply(cd, 1, make_rts)
cd$triss <- apply(cd, 1, make_triss)
cd$normit <- apply(cd, 1, make_normit)

## cast to numeric to avoid Problems
cd$ofi <- as.numeric(cd$ofi)
cd$triss <- as.numeric(cd$triss)
cd$normit <- as.numeric(cd$normit)

## some subsetted data
df.triss <- cd[, c("ofi", "triss")]
df.triss <- df.triss %>% rename(score = triss)
df.normit <- cd[, c("ofi", "normit")]
df.normit <- df.normit %>% rename(score = normit)

## make_stats returns a named list with all the things i want; then assign all list members to individual variables for ease of use later
## triss
t.stats <- make_stats(df.triss)
t.model <- t.stats[['model']]
t.perf <- t.stats[['perf']]
t.auc <- t.stats[['auc']]
t.acc <- t.stats[['acc']]
t.ici <- t.stats[['ici']]

## normit
n.stats <- make_stats(df.normit)
n.model <- n.stats[['model']]
n.perf <- n.stats[['perf']]
n.auc <- n.stats[['auc']]
n.acc <- n.stats[['acc']]
n.ici <- n.stats[['ici']]

## things that can be plotted
## models: plot(t.model)
## accuracy: plot(t.acc)

## table.one <- make_table_one(cd)
