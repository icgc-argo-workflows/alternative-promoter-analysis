#!/usr/bin/env Rscript

################################################
################################################
## REQUIREMENTS                               ##
################################################
################################################

## Estimation of Promoter Activity from RNA-Seq data
## - ALIGNED READS IN STAR JUNCTION FILE FORMAT
## - ANNOTATION GTF FILE (optional)
## - THE PACKAGE BELOW NEED TO BE AVAILABLE TO LOAD WHEN RUNNING R

################################################
################################################
## LOAD LIBRARY                               ##
################################################
################################################
library(proActiv)

################################################
################################################
## PARSE COMMAND-LINE PARAMETERS              ##
################################################
################################################
args = commandArgs(trailingOnly=TRUE)

samplesheet   <- strsplit(grep('--samplesheet*', args, value = TRUE), split = '=')[[1]][[2]]
annotation    <- strsplit(grep('--annotation*', args, value = TRUE), split = '=')[[1]][[2]]

################################################
################################################
## RUN proActiv                               ##
################################################
################################################
sample_tab <- read.csv(samplesheet,header=TRUE)
files <- sample_tab$input_file
condition <- sample_tab$condition
promoterAnnotation <- readRDS(annotation)
result <- proActiv(files = files, condition = condition,
                   promoterAnnotation = promoterAnnotation)
result <- result[complete.cases(assays(result)$promoterCounts),]
result_tab <- rowData(result)
str(result_tab)
result_tab$txId <- sapply(result_tab$txId,paste,collapse=";")
countData <- data.frame(result_tab, assays(result)$promoterCounts)
write.table(countData, file = "proActiv_count.csv",
            sep = "\t", quote = FALSE, row.names = FALSE)
