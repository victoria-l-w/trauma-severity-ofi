## Libraries I tried to install but failed: rsvg/diagrammersvg, kableextra
library(rofi)
library(dplyr)
library(labelled)
library(table1)
library(printr, quietly=TRUE)
library(DiagrammeR)
library(caret)

noacsr::source_all_functions()

datasets <- import_data(test = TRUE)

## Make dataset names that match merge_data() requirements
datasets[['swetrau']] <- datasets$swetrau_scrambled
datasets[['fmp']] <- datasets$fmp_scrambled
datasets[['atgarder']] <- datasets$atgarder_scrambled
datasets[['problem']] <- datasets$problem_scrambled
datasets[['kvalgranskning2014.2017']] <- datasets$kvalgranskning2014.2017_scrambled

merged.data <- merge_data(datasets)

merged.data$ofi <- create_ofi(merged.data)

cleaned.data <- clean_data(merged.data)

## This returns data on how many patients are kept and excluded at each step 
inclusion.counts <- clean_data(merged.data, numbers = TRUE)

## add scores [all the as.numeric()s just made things work better]
cleaned.data$rts <- apply(cleaned.data, 1, make_rts)
cleaned.data$triss <- apply(cleaned.data, 1, make_triss)
cleaned.data$normit <- apply(cleaned.data, 1, make_normit)

