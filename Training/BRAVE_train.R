rm(list=ls())

library(nestedcv)
library(caret) 
library(doParallel)
library(readr)
library(pROC)

#######################

setwd(".")

# Set variables

n.cores <- 2

registerDoParallel(n.cores)


args <- commandArgs(trailingOnly=TRUE)

args[1]   		# input rda and filter files
column_name <- args[2] 	# ic50 or ic80
cutoff <- as.numeric(args[3]) # ic50/80 sensitivity cutoff
filename<-paste("./emb_esm2_1280/",args[1], ".rda", sep = "" )


load(filename)



response_b12 <-as.numeric(response_b12)
predictors_b12<-t(predictors_b12)
colnames(predictors_b12)<-c(1:dim(predictors_b12)[[2]])
X<-predictors_b12
rownames(X)<-NULL


#################################################################################################

input_directory <- "./data/"
test_input_filename1 <- paste(input_directory,args[1],"_fold1_testing.csv", sep = "")
train_input_filename1 <- paste(input_directory, args[1], "_fold1_training.csv", sep = "")

b12_fold1_testing <- read_csv(test_input_filename1)
b12_fold1_training <- read_csv(train_input_filename1)
df<-rbind(b12_fold1_testing, b12_fold1_training)

#----------------------------------------------------------------

test_input_filename2 <- paste("./data/",args[1],"_fold2_testing.csv", sep = "")
test_input_filename3 <- paste("./data/",args[1],"_fold3_testing.csv", sep = "")
test_input_filename4 <- paste("./data/",args[1],"_fold4_testing.csv", sep = "")
test_input_filename5 <- paste("./data/",args[1],"_fold5_testing.csv", sep = "")

b12_fold2_testing <- read_csv(test_input_filename2)
b12_fold3_testing <- read_csv(test_input_filename3)
b12_fold4_testing <- read_csv(test_input_filename4)
b12_fold5_testing <- read_csv(test_input_filename5)

matching_indices_T1 <- match(b12_fold1_testing$"virus_id", df$"virus_id")
matching_indices_T2 <- match(b12_fold2_testing$"virus_id", df$"virus_id")
matching_indices_T3 <- match(b12_fold3_testing$"virus_id", df$"virus_id")
matching_indices_T4 <- match(b12_fold4_testing$"virus_id", df$"virus_id")
matching_indices_T5 <- match(b12_fold5_testing$"virus_id", df$"virus_id")

out_folds<-list(fold1=matching_indices_T1, fold2=matching_indices_T2, fold3=matching_indices_T3, fold4=matching_indices_T4, fold5=matching_indices_T5)

#----------------------------------------------------------------

# Create folds
df$phenotype <- ifelse(df[[column_name]] >= cutoff, 1, 0)
y <- as.factor(df$phenotype)
Binary_Y <- factor(y, levels = c(1, 0), labels = c("Resistant", "Sensitive"))
Binary_Y <- relevel(Binary_Y, ref = "Sensitive")

nvar<-100000
sq_nvar<-sqrt(nvar)

ranger_tune_grid <- expand.grid(mtry = c(2, 3, 4, 5, 6, 7, sq_nvar), 

                                splitrule = c("variance", "extratrees"),

                                min.node.size = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10))



res <- nestcv.train(

    Binary_Y, X,

    method = "ranger", 

    outer_folds = out_folds,

    filterFUN = ttest_filter,

    filter_options = list(nfilter = nvar),

    outer_train_predict = TRUE,

    n_inner_folds = 5,

    savePredictions = "final",

    finalCV = TRUE,

    trControl = trainControl(

        method = "cv",

        number = 5,

        classProbs = TRUE,

        summaryFunction = twoClassSummary,

        search = "grid"

    ),

    metric = "ROC",

    tuneGrid = ranger_tune_grid

)



folds_list<-res$outer_folds

output<-res$output

a1<-df$virus_id[out_folds[[1]]]
a2<-df$virus_id[out_folds[[2]]]
a3<-df$virus_id[out_folds[[3]]]
a4<-df$virus_id[out_folds[[4]]]
a5<-df$virus_id[out_folds[[5]]]

r1<-res$outer_result[[1]]$preds
r2<-res$outer_result[[2]]$preds
r3<-res$outer_result[[3]]$preds
r4<-res$outer_result[[4]]$preds
r5<-res$outer_result[[5]]$preds

res1<-data.frame(a1, r1)
res2<-data.frame(a2, r2)
res3<-data.frame(a3, r3)
res4<-data.frame(a4, r4)
res5<-data.frame(a5, r5)


colnames(res1)[1]<-"virus_id"
colnames(res2)[1]<-"virus_id"
colnames(res3)[1]<-"virus_id"
colnames(res4)[1]<-"virus_id"
colnames(res5)[1]<-"virus_id"

res_on_folds<-list(res1=res1, res2=res2, res3=res3, res4=res4, res5=res5)


#------------------------------------------------------------------------------------------------
output_directory <- "./data/"

output_filename <- paste(output_directory, args[1], ".RData",  sep = "")



save(res_on_folds, res, file=output_filename)
