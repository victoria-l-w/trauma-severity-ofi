## Load libaries
library(rofi)
library(dplyr)
library(labelled)
library(table1)
library(printr, quietly=TRUE)
library(DiagrammeR)
library(purrr)

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

cleaned.data <- clean_data(merged.data)
exclusion.numbers <- clean_data(merged.data, numbers = TRUE)

## add rts scores
cleaned.data <- make_rts(cleaned.data)

## add triss
cleaned.data <- make_triss(cleaned.data)

## Step : Table 1. Patient demographics.

## t1 <- make_table_one(cleaned.data)
