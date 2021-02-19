read data 
rm(list = ls())
setwd("G:/My Drive/Chantelle Bambie/")
bank_data <- read.csv("bank_data.csv", sep=";")

bank_data <-read.csv("~/Documents/BIA715/bank_data.csv",header=TRUE, sep=",")
names(bank_data)

library(dplyr)


# log1p transformation
log1p(bank_data)

for(x in 2:ncol(bank_data))
{
  bank_data[,x] <- log1p(bank_data[,x])
  bank_data[,x] <- ifelse(bank_data[,x]==-Inf,NA,bank_data[,x])
}
rm(x)
#removing NAs
bank_data <- na.omit(bank_data)

bank_data <- bank_data %>% dplyr::mutate(acquire = as.numeric(acquire))

set.seed(3973098) 

# selecting my data
bank_data <- bank_data[sample(1:nrow(bank_data),2000,replace = F),]



# Partitioning 70:30
train <- sample(1:nrow(bank_data), 2000*0.7 , replace = FALSE)
training <- bank_data[train,]
validation <- bank_data[-train,]

# full logistic regression:
logistic_reg <- glm(acquire~ atmct+adbdda+ddatot+ddadep+income+invest+atres+savbal, family = binomial(link = "logit"), data = training)


training <- training %>% mutate(predicted = round(predict(logistic_reg,type = "response")))

misclass_rate_training = sum(training$acquire!=training$predicted)/nrow(training)
misclass_rate_training


validation <- validation %>% mutate(predicted = round(predict(logistic_reg,newdata = validation,type = "response")))

misclass_rate_validation = sum(validation$acquire!=validation$predicted)/nrow(validation)
misclass_rate_validation