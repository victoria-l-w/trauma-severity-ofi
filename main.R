## Libraries I tried to install but failed: rsvg/diagrammersvg, kableextra
## Gmisc integrated calibration index ici
## ROCR
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
## inclusion.counts <- clean_data(md, numbers = TRUE)
## add scores [all the as.numeric()s just made things work better]
cd$rts <- apply(cd, 1, make_rts)
cd$triss <- apply(cd, 1, make_triss)
cd$normit <- apply(cd, 1, make_normit)

## no clue wat im doing
## shamelessly copied from the internet

cd$ofi <- as.factor(cd$ofi)
cd$triss <- as.numeric(cd$triss)
cd$normit <- as.numeric(cd$normit)

## triss+normit or do seperately?
model <- glm(ofi ~ triss, family="binomial", data = cd)

## plots the auc maybe? 
pred_model<- predict(model, type="response")
pred <- prediction(pred_model, cd$ofi)
perf <- performance(pred, "tpr", "fpr")
plot(perf, colorize=TRUE)

auc <- unlist(slot(performance(pred, "auc"), "y.values"))

## prediction <- prediction()

## auc(roc)
