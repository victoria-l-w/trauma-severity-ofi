start.time <- Sys.time()

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

## TODO
## something else for boot.ci so I can run multiple stats in one bootstrap?

noacsr::source_all_functions()

set.seed(1112)

datasets <- import_data(test = TRUE)

## make dataset names that match merge_data() requirements
datasets[['swetrau']] <- datasets$swetrau_scrambled
datasets[['fmp']] <- datasets$fmp_scrambled
datasets[['atgarder']] <- datasets$atgarder_scrambled
datasets[['problem']] <- datasets$problem_scrambled
datasets[['kvalgranskning2014.2017']] <- datasets$kvalgranskning2014.2017_scrambled

## prepare data
df <- merge_data(datasets)
pd <- prep_data(df) ## returns a list with the prepared dataset, inclusion counts, and missing parameters
df <- pd[['df']]
exclusion <- pd[['exclusion']] ## inclusion/exclusion counts
na.data <- pd[['na.data']] ## missing parameters

## apply scores
df$rts <- apply(df, 1, make_rts) ## make_rts.R
df$triss <- apply(df, 1, make_triss) ## make_triss.R
df$normit <- apply(df, 1, make_normit) ## make_normit.R
df$ps <- apply(df, 1, make_ps) ## make_ps.R

## get descriptive stats
table.one <- table_one(df) ## table_one.R
dd <- descriptive_data(df) ## descriptive_data.R

## get results
results <- results(df, bootstrap = TRUE) ## results.R
t <- results[['t']]
n <- results[['n']]
p <- results[['p']]
d <- results[['delta']]

## done
end.time <- Sys.time()
time.elapsed <- round(difftime(end.time, start.time, units = "mins"), digits = 2)
message(paste0("Done! Time elapsed: ", time.elapsed, " minutes."))
