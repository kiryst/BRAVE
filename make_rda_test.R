
rm(list=ls())

library(tidyverse)
library(Biostrings)
library(pROC)
library(data.table)
library(nestedcv)
library(caret)
library(randomForest)
library(glmnet)

args <- commandArgs(trailingOnly=TRUE)

#args <- c("b12_testing.fasta", "/data/SBIS/tatsiana/LBUM/test/b12/emb_esm2_1280/", "b12_output.csv","b12.RData")

args[1]   # input fasta file of test sequences

args[2]   # path to esm csv files

args[3] # output save file

args[4] # load model

load(args[4])

fasta_sequences <- readAAStringSet(args[1])
virus_name <- names(fasta_sequences)[1]

filename<-paste(args[2],virus_name,"_representations_33_np.csv", sep = "" )
temp<-read.table(file=filename, header = FALSE,sep = ",")
predictors_b12 <-temp

for (i in 2:length(fasta_sequences))
{
	virus_name <- names(fasta_sequences)[i]
	filename<-paste(args[2],virus_name, "_representations_33_np.csv", sep = "" )
	temp<-read.table(file=filename, header = FALSE,sep = ",")
	predictors_b12 <- cbind(predictors_b12,temp)
}

test<-t(predictors_b12)

rownames(test)<-NULL
colnames(test) <- c(1:dim(test)[[2]])
preds <- predict(res, newdata = test, type = "response")
preds_prob <- predict(res, newdata = test, type = "prob")
# Create a data frame with virus_id and prediction
output_df <- data.frame(
    virus_id = names(fasta_sequences),
    prediction = preds,
    probability = preds_prob
)

# Write the data frame to a CSV file
write.csv(output_df, file = args[3], row.names = FALSE)

