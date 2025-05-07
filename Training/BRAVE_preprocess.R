
# Parse command-line arguments
args <- commandArgs(trailingOnly = TRUE)

# Input arguments
name <- args[1]
#column_name <- args[2]
#cutoff <- as.numeric(args[3])


filename<-paste("./data/",args[1],"_fold1_testing.csv", sep = "")
data_all <- read.csv(file= filename, header=TRUE)
response_b12 <- data_all$ic50
response_b12 <-as.numeric(response_b12)
filename<-paste("./emb_esm2_1280/",args[1],"/",data_all$virus[1], "_representations_33_np.csv", sep = "" )
temp<-read.table(file=filename, header = FALSE,sep = ",")
predictors_b12 <-temp
for(i in 2:nrow(data_all))
{
  filename<-paste("./emb_esm2_1280/",args[1],"/",data_all$virus[i], "_representations_33_np.csv", sep = "" )
  temp<-read.table(file=filename, header = FALSE,sep = ",")
  predictors_b12 <- cbind(predictors_b12,temp)
}
filename<-paste("./data/",args[1],"_fold1_training.csv", sep = "")
data_all <- read.csv(file=filename, header=TRUE)
temp <- data_all$ic50
temp <-as.numeric(temp)
response_b12 <- c(response_b12,temp)
for(i in 1:nrow(data_all))
{
  filename<-paste("./emb_esm2_1280/",args[1],"/",data_all$virus[i], "_representations_33_np.csv", sep = "" )
  temp<-read.table(file=filename, header = FALSE,sep = ",")
  predictors_b12 <- cbind(predictors_b12,temp)
}
filename<-paste("./emb_esm2_1280/",args[1],".rda", sep = "" )
save(response_b12,predictors_b12,file = filename )


