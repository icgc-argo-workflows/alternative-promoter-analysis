#!/usr/bin/env Rscript

################################################
################################################
## REQUIREMENTS                               ##
################################################
################################################

## AGGREGATOR OF proActiv outputs
## - aggregate the proActiv_count.csv outputs of the
##   same condition

################################################
################################################
## LOAD LIBRARY                               ##
################################################
################################################

################################################
################################################
## PARSE COMMAND-LINE PARAMETERS              ##
################################################
################################################
args = commandArgs(trailingOnly=TRUE)

dir     <- strsplit(grep('--dir*', args, value = TRUE), split = '=')[[1]][[2]]

################################################
################################################
## RUN proActiv                               ##
################################################
################################################
csv_list <- list.files(dir, pattern= "*_proActiv_count.csv")
##output the following merged matricies for downstream analysis
outfns <-c("transcript_mean_merged.csv","gene_mean_merged.csv",
           "promoter_class_merged.csv","absolute_activity_merged.csv")
for (i in 1:length(outfns)){
    for (j in 1:length(csv_list)){
        df <- read.table(file.path(dir,csv_list[j]), header=TRUE, sep=",")
        if (j == 1){
            original_colnames <- colnames(df)
            index <- length(original_colnames)-4
            print(original_colnames)
            original_colnames <- original_colnames[1:index]
            merged_df <- df[,1:index]
            merged_df <- data.frame(merged_df,df[index+1])
            updated_colnames <- c(original_colnames, csv_list[j])
            colnames(merged_df) <- updated_colnames
        } else {
            to_add_col <- df[,c(1,index+i)]
            colnames(to_add_col) <- c(colnames(to_add_col)[1],csv_list[j])
            merged_df <- merge(merged_df,to_add_col,by="promoterId")
        }
    }
    write.table(merged_df, file = outfns[i],
                sep = ",", quote = FALSE, row.names = FALSE)
}
