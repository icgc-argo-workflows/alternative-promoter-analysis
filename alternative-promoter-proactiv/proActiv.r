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

junction_file <- strsplit(grep('--junction_file*', args, value = TRUE), split = '=')[[1]][[2]]
condition     <- strsplit(grep('--condition*', args, value = TRUE), split = '=')[[1]][[2]]
annotation    <- strsplit(grep('--annotation*', args, value = TRUE), split = '=')[[1]][[2]]


################################################
################################################
## RUN proActiv                               ##
################################################
################################################
promoterAnnotation <- readRDS(annotation)
result <- proActiv(files = junction_file, condition = condition, 
                   promoterAnnotation = promoterAnnotation)
result <- result[complete.cases(assays(result)$promoterCounts),]
result_tab <- rowData(result)
str(result_tab)
result_tab$txId <- sapply(result_tab$txId,paste,collapse=";")
countData <- data.frame(result_tab, assays(result)$promoterCounts)
sampleName <- strsplit(junction_file, split = '\\.')[[1]][1]
countOutputName <- paste0(sampleName,"_proActiv_count.csv")
write.table(countData, file = countOutputName,
            sep = "\t", quote = FALSE, row.names = FALSE)
