

# Importing the leads
leads = read.csv('leads3.csv',sep=";")
#leads = leads[3:6]

leads$LeadResponse <- as.factor(leads$LeadResponse)
leads$CreditScore<- as.factor(leads$CreditScore)

xtabs(~LeadResponse + CreditScore, data=leads)


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

leads$MaritalStatus = factor(leads$MaritalStatus,
                           levels = c('Single', 'Married','Divorced','Widowed'),
                           labels = c(0, 1,2,3))


#Splitting the leads into the Training set and Test set
#install.packages('caTools')
library(caTools)
set.seed(2465)
split = sample.split(leads$LeadResponse, SplitRatio = 0.8)
training_set = subset(leads, split == TRUE)
test_set = subset(leads, split == FALSE)

#Model
mymodeltr <- glm(formula=LeadResponse ~ INCOME + Age  + Gender + MaritalStatus +CreditScore + StoreCards, data= training_set, family= 'binomial')
summary(mymodeltr)
mymodeltes <- glm(LeadResponse ~ INCOME + Age  + Gender + MaritalStatus +CreditScore + StoreCards, data= test_set, family= 'binomial')
summary(mymodeltes)



#predict
p1<- predict(mymodeltr,training_set, type='response')
p2<- predict(mymodeltes,test_set, type='response')
head(p2)
head(training_set)

y <- -9.590e-02+-1.139e-05 +-1.852e-02 +5.613e-01+1.348e-01+ 1.293e+00 

exp(y)/1 + exp(y)

lm.fit <- lm(LeadResponse ~., data=leads)
#par(mfrow=c(2,2))
plot(lm.fit)

lm(formula = LeadResponse ~ ., data = leads)

lm(formula= LeadResponse ~ INCOME + Age  + Gender + MaritalStatus +CreditScore + StoreCards, data= leads) #, family= 'binomial')

hist(leads$Gender)

#Misclassification error - training_set
pred1 <- ifelse(p1>0.5, 1, 0)
tab1 <-table(Predicted =pred1,actual =training_set$LeadResponse)
tab1 


1-sum(diag(tab1))/sum(tab1)

p2<- predict(mymodeltes,test_set, type='response')
pred2 <- ifelse(p2>0.5, 1, 0)
tab2 <-table(Predicted =pred2,actual = test_set$LeadResponse)
tab2 
1-sum(diag(tab2))/sum(tab2)

#Goodness of fit test_set

with (mymodeltr, pchisq(null.deviance - deviance, df.null- df.residual, lower.tail=F))


plot(mymodel)


# Feature Scaling
training_set[,1:2] = scale(training_set[,1:2] )
test_set[,1:2]  = scale(test_set[,1:2])

# Fitting Logistic Regression to the Training set
classifier = glm(formula = LeadResponse ~ .,
                 family = binomial,
                 data = training_set)

# Predicting the Test set results
prob_pred = predict(classifier, type = 'response', newdata = test_set[-3])
y_pred = ifelse(prob_pred > 0.5, 1, 0)

# Making the Confusion Matrix
cm = table(test_set[, 3], y_pred > 0.5)

# Visualising the Training set results
library(ElemStatLearn)
set = training_set
X1 = seq(min(set[, 1]) - 1, max(set[, 1]) + 1, by = 0.01)
X2 = seq(min(set[, 2]) - 1, max(set[, 2]) + 1, by = 0.01)
grid_set = expand.grid(X1, X2)
colnames(grid_set) = c('Age', 'INCOME')
prob_set = predict(classifier, type = 'LeadResponse', newdata = grid_set)
y_grid = ifelse(prob_set > 0.5, 1, 0)
plot(set[, -3],
     main = 'Logistic Regression (Training set)',
     xlab = 'Age', ylab = 'INCOME',
     xlim = range(X1), ylim = range(X2))
contour(X1, X2, matrix(as.numeric(y_grid), length(X1), length(X2)), add = TRUE)
points(grid_set, pch = '.', col = ifelse(y_grid == 1, 'springgreen3', 'tomato'))
points(set, pch = 21, bg = ifelse(set[, 3] == 1, 'green4', 'red3'))

# Visualising the Test set results
library(ElemStatLearn)
set = test_set
X1 = seq(min(set[, 1]) - 1, max(set[, 1]) + 1, by = 0.01)
X2 = seq(min(set[, 2]) - 1, max(set[, 2]) + 1, by = 0.01)
grid_set = expand.grid(X1, X2)
colnames(grid_set) = c('Age', 'INCOME')
prob_set = predict(classifier, type = 'LeadResponse', newdata = grid_set)
y_grid = ifelse(prob_set > 0.5, 1, 0)
plot(set[, -3],
     main = 'Logistic Regression (Test set)',
     xlab = 'Age', ylab = 'INCOME',
     xlim = range(X1), ylim = range(X2))
contour(X1, X2, matrix(as.numeric(y_grid), length(X1), length(X2)), add = TRUE)
points(grid_set, pch = '.', col = ifelse(y_grid == 1, 'springgreen3', 'tomato'))
points(set, pch = 21, bg = ifelse(set[, 3] == 1, 'green4', 'red3'))