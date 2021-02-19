# 0.Load your libraries
library(readr)
library(magrittr)
library(caret)
library(broom)
library(dplyr)
library(ggplot2)
library(lattice)
library(psych)  #correlation test

# 1.Read data into R with read.csv2 from readr package
BD <- read.csv2("~/Documents/BIA715/bank_data.csv",header=TRUE, sep=",")

# 2.set seed to your student number
set.seed(3916746)

# 3.split the data into train and test
train_index = sample(c(T, F), nrow(BD), replace = TRUE, c(0.6667, 0.3333))

bank_train <- BD[train_index,]
bank_test <- BD[!train_index,]

# 4.partition datap
partition_index = sample(c(T, F), nrow(bank_train), replace = TRUE, c(0.7, 0.3))

train_set <- bank_train[partition_index,]
validation_set <- bank_train[!partition_index,]

# 5.Select features or build new feature
# remove all observations with values less than zero for the variable "adbbda" 
# change invest to an integer
train_set_clean <- train_set %>% filter(adbdda > 0) %>% mutate(invest = as.integer(invest))

# 6.Transformation of independant variables
x <- train_set_clean %>% select(atmct:savbal) %>% log1p()
y <- train_set_clean %>% select(acquire)
train_data <- cbind(y,x)

# 7.remove na's
train_data.omit = na.omit(train_data)

# 8.model
model.null = glm(acquire ~ 1, 
                 data=train_data.omit,
                 family = binomial(link="logit")
)

model.full = glm(acquire ~ atmct + adbdda + ddatot + ddadep + income + invest + 
                   atres + savbal,
                 data=train_data.omit,
                 family = binomial(link="logit")
)

step(model.null,
     scope = list(upper=model.full),
     direction="both",
     test="Chisq",
     data=Data)

final_model <- glm(acquire ~ atmct + adbdda + ddadep + income + invest + savbal,
                   data = train_data.omit, family = binomial)

summary(final_model)
plot(final_model)

# 9.predict the training set
train_prediction <- predict(final_model,train_data.omit, type = "response")
train_prediction <- ifelse(train_prediction > 0.5, 1, 0)
sum(train_prediction == train_data.omit$acquire)/length(train_prediction)
#Answer [1] 0.8369883

# 10.Validation data
# 10.1 make invest integer
val_set_clean <- validation_set %>% filter(adbdda > 0) %>% mutate(invest = as.integer(invest))

# 10.2 Transformation of independant variables
xval <- val_set_clean %>% select(atmct:savbal) %>% log1p()
yval <- val_set_clean %>% select(acquire)
val_data <- cbind(yval,xval)

# 10.2 predict validation data
val_prediction <- predict(final_model, val_data,  type = "response")
val_prediction <- ifelse(val_prediction > 0.5, 1, 0)
sum(val_prediction == val_data$acquire)/length(val_prediction)
#Answer [1] 0.8373288
