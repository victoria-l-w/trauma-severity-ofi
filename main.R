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

## Step 1: Import data

datasets <- import_data(test = TRUE)

## Step 2: Merge data

## Make dataset names that match merge_data() requirements
datasets[['swetrau']] <- datasets$swetrau_scrambled
datasets[['fmp']] <- datasets$fmp_scrambled
datasets[['atgarder']] <- datasets$atgarder_scrambled
datasets[['problem']] <- datasets$problem_scrambled
datasets[['kvalgranskning2014.2017']] <- datasets$kvalgranskning2014.2017_scrambled

merged.data <- merge_data(datasets)

## Step 3: Create OFI variable

merged.data$ofi <- create_ofi(merged.data)

## Step 3: Clean data, see functions/clean_data.r

cleaned.data <- clean_data(merged.data)

## Step 4: Table 1. Patient demographics.

t1 <- make_table_one(cleaned.data)
