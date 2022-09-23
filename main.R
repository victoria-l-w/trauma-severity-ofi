## Load libaries
library(rofi)
library(dplyr)
library(labelled)
library(table1)
library(printr, quietly=TRUE)
library(DiagrammeR)

## list of libraries i tried to install but failed, mb try again later
## rsvg/diagrammersvg, kableextra

## reminder: needs to be .R i.e. capital R 
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

## This excludes NAs, 999s, etc that I want to keep
## Where ed_gcs_sum is 99 it takes pre_gcs_sum
## The pt's GCS (either their ED value or their prehosp value where ED = 99 ) is stored in $gcs
## This also makes a "small" table that only keeps variables I'm interested in keeping

cleaned.data <- clean_data(merged.data)

## This (in a very ugly way) returns data on how many patients are kept and excluded at each step 
inclusion.counts <- clean_data(merged.data, numbers = TRUE)

## add scores
cleaned.data <- make_rts(cleaned.data)
cleaned.data <- make_triss(cleaned.data)
cleaned.data <- make_normit(cleaned.data)




