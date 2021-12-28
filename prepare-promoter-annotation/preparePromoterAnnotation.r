#!/usr/bin/env Rscript

################################################
################################################
## REQUIREMENTS                               ##
################################################
################################################

## Prepare annotation.rds for proActiv
## - ANNOTATION GTF FILE

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

gtf.file      <- strsplit(grep('--gtf*', args, value = TRUE), split = '=')[[1]][[2]]
output.tag    <- strsplit(grep('--output_tag*', args, value = TRUE), split = '=')[[1]][[2]]

################################################
################################################
## Run preparePromoterAnnotation              ##
################################################
################################################
promoterAnnotation <- preparePromoterAnnotation(file = gtf.file,
                                                species = 'Homo_sapiens')
saveRDS(promoterAnnotation, file = paste0(output.tag,'.rds'))
