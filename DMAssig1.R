bank <-read.csv("~/Documents/BIA715/bank_data.csv",header=TRUE)
names(bank)
#Partition data

set.seed(3973098)
ind <- sample(2,nrow(bank),replace =T,prob=c(0.8,0.2))
train <- bank[ind==1,]
vali <- bank[ind==2,]

set.seed(3973098)
obs <- nrow(bank)
nsample <- ceiling(0.7*obs)
banksample <- sample(1:obs,size=nsample,replace=F)
sample <- bank[banksample,]
#dividing data
ntrain <-ceiling(0.7*nsample)
trainsample <- sample(1:nsample,size=ntrain,replace=F)
training <- sample[trainsample,]

valadation <- sample[-trainsample,]

log1p(bank)
# Subset data in R
setdata<-subset(bank, adbdda=0)

?subset.data.frame
install.packages("LOGAN")
install.packages("dplyr")