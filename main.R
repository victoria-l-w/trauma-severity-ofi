start.time <- Sys.time()

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
library(rlist)
library(ggplot2)
## library(kableExtra)
## library(DiagrammeRsvg)
## library(rsvg)
library(mvbutils)

## TODO
## something else for boot.ci so I can run multiple stats in one bootstrap?
## ci.boot level 0.90 or 0.95
## ask if ok normit 2
## how to present delta statistics?
## delta OR? 
## p-values???
## fix rounding of OR p value?
## why is max accuracy the exact same for all 3?
## find sources about ps12

noacsr::source_all_functions()

set.seed(1112)

datasets <- import_data(test = TRUE)

datasets[['swetrau']] <- datasets$swetrau_scrambled
datasets[['fmp']] <- datasets$fmp_scrambled
datasets[['atgarder']] <- datasets$atgarder_scrambled
datasets[['problem']] <- datasets$problem_scrambled
datasets[['kvalgranskning2014.2017']] <- datasets$kvalgranskning2014.2017_scrambled

extract.named(prep_data(datasets)) ## creates the prepared dataset, inclusion counts, and missing parameters

table.one <- table_one(df) ## table_one.R
dd <- descriptive_data(df) ## descriptive_data.R
extract.named(results(df, bootstrap = TRUE, boot.no = 25)) ## results.R

## done
end.time <- Sys.time()
time.elapsed <- round(difftime(end.time, start.time, units = "mins"), digits = 2)
message(paste0("Done! Time elapsed: ", time.elapsed, " minutes."))
