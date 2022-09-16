## Load libaries
library(rofi)
library(dplyr)
library(labelled)
library(table1)
library(printr, quietly=TRUE)
library(DiagrammeR)
library(miceadds) ## To make sourcing functions/ work
library(trelliscope) ## To aid in making diagrams that work in .docx 

## Sources all my functions, which are basically just code broken up into smaller parts
## It looks like previous students put everything in one file (?), if you would prefer that let me know! No big deal to change
## I did it like this to make it easier for me to see the overall workflow.
source_function_path <- "~/R/trauma-severity-ofi/functions/"
source.all(source_function_path, grepstring="*", print.source = FALSE)

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

merged_data <- merge_data(datasets)


## Step 3: Clean data, see functions/clean_data.r

cd <- clean_data(merged_data)


## Step 4: Table 1. Patient demographics.

t1 <- make_table_one(cd)
