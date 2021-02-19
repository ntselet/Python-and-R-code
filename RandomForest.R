# Read Data
leads = read.csv('leads3.csv',sep=";")
str(leads)
leads$LeadResponse <- as.factor(leads$LeadResponse)
table(leads$LeadResponse)

# Data Partition
set.seed(123)
ind <- sample(2, nrow(leads), replace = TRUE, prob = c(0.8, 0.2))
train <- leads[ind==1,]
test <- leads[ind==2,]

# Random Forest
library(randomForest)
set.seed(222)
rf <- randomForest(LeadResponse~., data =train,
                   ntree = 30,
                   mtry = 4,
                   importance = TRUE,
                   proximity = TRUE)
print(rf)
attributes(rf)

library(randomForest)
set.seed(222)
rf <- randomForest(LeadResponse~., data =test,
                   ntree = 500,
                   mtry = 4,
                   importance = TRUE,
                   proximity = TRUE)
print(rf)
# Prediction & Confusion Matrix - train data
install.packages("caret")
install.packages("e1071")
library(caret)
p1 <- predict(rf, train)
confusionMatrix(p1, train$LeadResponse)

# # Prediction & Confusion Matrix - test data
p2 <- predict(rf, test)
confusionMatrix(p2, test$LeadResponse)

# Error rate of Random Forest
plot(rf)

# Tune mtry
t <- tuneRF(train[,-1], train[,1],
            stepFactor = 0.5,
            plot = TRUE,
            ntreeTry = 300,
            trace = TRUE,
            improve = 0.05)

# No. of nodes for the trees
hist(treesize(rf),
     main = "No. of Nodes for the Trees",
     col = "green")

# Variable Importance
varImpPlot(rf,
           sort = T,
           n.var = 10,
           main = "Top 10 - Variable Importance")
importance(rf)
varUsed(rf)

# Partial Dependence Plot
partialPlot(rf, train, Age, "1")

# Extract Single Tree
getTree(rf, 1, labelVar = TRUE)

# Multi-dimensional Scaling Plot of Proximity Matrix
MDSplot(rf, train$LeadResponse)
