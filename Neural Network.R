leads = read.csv('leads3.csv',sep=";")



# Taking care of missing data
leads$Age = ifelse(is.na(leads$Age),
                   ave(leads$Age, FUN = function(x) mean(x, na.rm = TRUE)),
                   leads$Age)
leads$INCOME = ifelse(is.na(leads$INCOME),
                      ave(leads$INCOME, FUN = function(x) mean(x, na.rm = TRUE)),
                      leads$INCOME)


# Encoding categorical data
leads$Gender = factor(leads$Gender,
                      levels = c('Female', 'Male'),
                      labels = c(0,1))

#Min-Max Normalization
leads$INCOME <- (leads$INCOME - min(leads$INCOME))/ (max(leads$INCOME)-min(leads$INCOME))
leads$Age <- (leads$Age - min(leads$Age))/(max(leads$Age)-min(leads$Age))
leads$MaritalStatus <- (leads$MaritalStatus - min(leads$MaritalStatus))/(max(leads$MaritalStatus)-min(leads$MaritalStatus))
leads$StoreCards <- (leads$StoreCards - min(leads$StoreCards))/(max(leads$StoreCards)-min(leads$StoreCards))
leads$CreditScore <- (leads$CreditScore - min(leads$CreditScore))/(max(leads$CreditScore)-min(leads$CreditScore))

hist(leads$Age)
#Splitting the leads into the Training set and Test set
set.seed(222)
split = sample.split(leads$LeadResponse, SplitRatio = 0.8)
training_set = subset(leads, split == TRUE)
test_set = subset(leads, split == FALSE)

leads$LeadResponse <- as.factor(leads$LeadResponse)
leads$CreditScore<-  as.factor(leads$CreditScore)
xtabs(~LeadResponse + CreditScore, data=leads)
#install.packages("neuralnet")
library(neuralnet)
set.seed(3313)
n <- neuralnet(LeadResponse ~INCOME+Age+Gender+CreditScore+StoreCards+MaritalStatus, data=training_set,
                hidden =1,
                err.fct ="ce",
                linear.output=TRUE)
plot(n)

#Prediction
output <- compute(n,training_set[,-1])
head(output$net.result)
head(training_set[1,])

#Misclassification Error
output <- compute(n,training_set[ ,-1])
p1 <- output$net.result
pred1 <- ifelse(p1>0.5, 1, 0)
tabe1 <- table(pred1,training_set$LeadResponse)
tabe1
1-sum(diag(tabe1))/sum(tabe1)

output <- compute(n,test[,-1])
p2 <- output$net.result
pred2 <- ifelse(p2 >0.5,1,0)
tab2 <- table(pred2,test_set$LeadResponse)
tab2
1-sum(diag(tab2))/sum(tab2)
   
p2<- predict(mymodeltes,test_set, type='response')
pred2 <- ifelse(p2>0.5, 1, 0)
tab2 <-table(Predicted =pred2,actual = test_set$LeadResponse)
tab2 




               
plot(n)
str(leads)

#Random Forest

install.packages("randomForest")
library(randomForest)
set.seed(222)
rf <- randomForest(LeadResponse~.,data=training_set)
print(rf)

rf$confusion

