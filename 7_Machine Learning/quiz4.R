#1
library(ElemStatLearn)
data(vowel.train)
data(vowel.test)

vowel.train$y <- as.factor(vowel.train$y)
vowel.test$y <- as.factor(vowel.test$y)

set.seed(33833)
# Fit (1) a random forest predictor relating the factor variable y to the remaining variables 
fit <- train(y~., data=vowel.train, method="rf")
# boosted predictor using the "gbm" method
fit2 <- train(y~.,method="gbm", data=vowel.train, verbose=F)

# What are the accuracies for the two approaches on the test data set?
pred1 <- predict(fit, vowel.test)
pred2 <- predict(fit2, vowel.test)

confusionMatrix(pred1, vowel.test$y)
confusionMatrix(pred2, vowel.test$y)

# What is the accuracy among the test set samples where the two methods agree?
pred12 <- pred1
is.na(pred12[pred1!=pred2]) <- T
confusionMatrix(pred12, vowel.test$y)

#2 blending
# Load the Alzheimer's data using the following commands

library(caret)
library(gbm)
set.seed(3433)

library(AppliedPredictiveModeling)
data(AlzheimerDisease)
adData = data.frame(diagnosis,predictors)

inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]

training = adData[ inTrain,]
testing = adData[-inTrain,]

set.seed(62433)
# Set the seed to 62433 and predict diagnosis with all the other variables using a random forest ("rf"),
# boosted trees ("gbm") and linear discriminant analysis ("lda") model. 
fit1 <- train(diagnosis~., data=training, method="rf")
fit2 <- train(diagnosis~., data=training, method="gbm")
fit3 <- train(diagnosis~., data=training, method="lda")

# predict on the testing set
pred1<-predict(fit1, testing);
pred2<-predict(fit2, testing);
pred3<-predict(fit3, testing);

# Stack the predictions together using random forests ("rf")
predDF<- data.frame(pred1, pred2, pred3, diagnosis=testing$diagnosis)
stackFit<- train(diagnosis~., method="rf", data=predDF)
combPred<- predict(stackFit, predDF)

# What is the resulting accuracy on the test set? Is it better or worse than each 
# of the individual predictions?
confusionMatrix(combPred, testing$diagnosis)
confusionMatrix(pred1, testing$diagnosis)
confusionMatrix(pred2, testing$diagnosis)
confusionMatrix(pred3, testing$diagnosis)

# 3
# Load the concrete data with the commands:
set.seed(3523)
library(AppliedPredictiveModeling)
data(concrete)
inTrain = createDataPartition(concrete$CompressiveStrength, p = 3/4)[[1]]
training = concrete[ inTrain,]
testing = concrete[-inTrain,]

# Set the seed to 233 and fit a lasso model to predict Compressive Strength. Which variable is 
# the last coefficient to be set to zero as the penalty increases? (Hint: it may be useful to 
# look up ?plot.enet).
set.seed(233)
fit <- train(CompressiveStrength~., data=training, method="lasso")
fit2 <- enet(as.matrix(training[,-9]), training$CompressiveStrength, lambda = 0)
plot.enet(fit2, xvar="penalty")

# 4 forecast
# Load the data on the number of visitors to the instructors blog from here:
#     https://d396qusza40orc.cloudfront.net/predmachlearn/gaData.csv
# Using the commands:
setwd("d:/Grag/R/R-studio/Coursera/7_Machine Learning/")
library(lubridate) # For year() function below
dat = read.csv("gaData.csv")
training = dat[year(dat$date) < 2012,]
testing = dat[(year(dat$date)) > 2011,]
tstrain = ts(training$visitsTumblr)

# Fit a model using the bats() function in the forecast package to the training time series. 
# Then forecast this model for the remaining time points. For how many of the testing points 
# is the true value within the 95% prediction interval bounds?
library(forecast)
fit <- bats(y=tstrain)

#forecast
forc <- forecast(fit, level = 95, h=235)
plot(forc)
length(forc$lower)
length(testing$visitsTumblr)

sum(testing$visitsTumblr>=forc$lower & testing$visitsTumblr<=forc$upper)/length(forc$lower)

#5
# Load the concrete data with the commands:

set.seed(3523)
library(AppliedPredictiveModeling)
data(concrete)
inTrain = createDataPartition(concrete$CompressiveStrength, p = 3/4)[[1]]
training = concrete[ inTrain,]
testing = concrete[-inTrain,]

# Set the seed to 325 and fit a support vector machine using the e1071 package to predict 
# Compressive Strength using the default settings. Predict on the testing set. What is the RMSE?
set.seed(325)
fit <- svm(CompressiveStrength~., data = training)
pred <- predict(fit, newdata=testing)
RMSE(pred, testing$CompressiveStrength)
