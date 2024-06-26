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
library(kableExtra)
library(DiagrammeRsvg)
library(rsvg)
library(mvbutils)
library(gridExtra)
library(ggpubr)
library(bookdown)
library(kableExtra)
library(pandoc)
library(flextable)

noacsr::source_all_functions()

set.seed(1112)

datasets <- import_data()

extract.named(prep_data(datasets)) ## creates the prepared dataset, inclusion counts, and missing parameters

table.one <- table_one(df) ## table_one.R
dd <- descriptive_data(df) ## descriptive_data.R
extract.named(results(df, bootstrap = TRUE, boot.no = 1000)) ## results.R

## make figures
##roc_x3(t, n, p)
##acc_x3(t, n, p)
##glm_x3(df)
##save_png(exclusion_flowchart(exclusion), "exclusion")
##save_png(ofi_diagram(), "ofi")

## done
end.time <- Sys.time()
time.elapsed <- round(difftime(end.time, start.time, units = "mins"), digits = 2)
message(paste0("Done! Time elapsed: ", time.elapsed, " minutes."))
