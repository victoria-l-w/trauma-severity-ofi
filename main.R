## Load 
library("rofi")
library("dplyr")
library(labelled)
library(table1)
library(printr, quietly=TRUE)
source("functions/clean_data.r")
source("functions/make_table_one.r")
noacsr::source_all_functions()


## Step 1: Import data
datasets <- import_data(test = TRUE)

## Step 2: Merge data? 
## I did this ugly workaround to make the merge_data function in the rofi package work, but perhaps I'm not supposed to use this function
## It works tho! Testing it for now, I can do something else later if necessary

## Make dataset names that match merge_data() requirements (lol)
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

