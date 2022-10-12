## Libraries I tried to install but failed: rsvg/diagrammersvg, kableextra
## Gmish integrated calibration index ici
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

cd$ofi <- as.numeric(cd$ofi)
cd$triss <- as.numeric(cd$triss)
cd$normit <- as.numeric(cd$normit)

## triss+normit in one model or do seperately?
triss.model <- make_model(cd, score = "triss")
normit.model <- make_model(cd, score = "normit")

triss.perf <- make_roc(model = triss.model, cd)
plot(triss.perf, colorize = TRUE)
triss.auc <- make_roc(model = triss.model, cd, auc = TRUE)
triss.ici <- make_ici(model = triss.model, cd)

normit.perf <- make_roc(model = normit.model, cd)
plot(normit.perf, colorize = TRUE)
normit.auc <- make_roc(model = normit.model, cd, auc = TRUE)
normit.ici <- make_ici(model = normit.model, cd)

