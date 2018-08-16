#Question 1
library(caret)
library(ElemStatLearn)
data(vowel.train)
data(vowel.test)

vowel.train$y <- as.factor(vowel.train$y)
vowel.test$y <- as.factor(vowel.test$y)
set.seed(33833)
mdrf <- train(y~., method="rf", data = vowel.train)
mdgbm <- train(y~., method="gbm", data = vowel.train)
predrf <- predict(mdrf, vowel.test)
confusionMatrix(predrf, vowel.test$y)
predgbm <- predict(mdgbm, vowel.test)
confusionMatrix(predgbm, vowel.test$y)
predboth <- predrf[predrf==predgbm]
vowel.test.sub <- vowel.test[predrf==predgbm, ]
confusionMatrix(predboth, vowel.test.sub$y)
#answer: rf=0.5887, gbm=0.513, both=0.6211
#actual values: 0.6082, 0.5152, 0.6361

#Question 2
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
rf <- train(diagnosis~., data = training, method = "rf")
predrf <- predict(rf, testing)
confusionMatrix(predrf, testing$diagnosis) #0.7927
rf #0.830

set.seed(62433)
gbm <- train(diagnosis~., data = training, method = "gbm")
predgbm <- predict(gbm, testing)
confusionMatrix(predgbm, testing$diagnosis) #0.7805, 0.8049
gbm #0.851

set.seed(62433)
lda <- train(diagnosis~., data = training, method = "lda")
predlda <- predict(lda, testing)
confusionMatrix(predlda, testing$diagnosis) #0.7683
lda #0.704

predtrainingDF <- data.frame(diagnosis = training$diagnosis, rf = predict(rf, training), gbm = predict(gbm, training), lda = predict(lda, training))
set.seed(62433)
allmdls <- train(diagnosis~., method = "rf", data = predtrainingDF)
newtestdf <- data.frame(diagnosis = testing$diagnosis, rf = predrf, gbm = predgbm, lda = predlda)
predall <- predict(allmdls, newtestdf)
confusionMatrix(predall, newtestdf$diagnosis) #0.8171
allmdls #1.0
#answer: 0.80 better than lda and rf, same as gbm


#Question 3
set.seed(3523)
library(AppliedPredictiveModeling)
data(concrete)
inTrain = createDataPartition(concrete$CompressiveStrength, p = 3/4)[[1]]
training = concrete[ inTrain,]
testing = concrete[-inTrain,]
set.seed(223)
lassomdl <- train(CompressiveStrength~., method ="lasso", training)
plot.enet(lassomdl$finalModel, xvar = "penalty", use.color = T)
#answer: Cement

#Question 4
library(lubridate) # For year() function below
library(forecast)
download.file("https://d396qusza40orc.cloudfront.net/predmachlearn/gaData.csv", destfile = "gaData.csv", method = "curl")
dat = read.csv("gaData.csv")
training = dat[year(dat$date) < 2012,]
testing = dat[(year(dat$date)) > 2011,]
tstrain = ts(training$visitsTumblr)
tsmdl <- bats(y = tstrain)
tspredict <- forecast(tsmdl, 235)
count <- as.numeric(0)
for (i in 1:nrow(testing)){
        if(testing$visitsTumblr[i] > tspredict$lower[i,2] & 
                    testing$visitsTumblr[i] < tspredict$upper[i,2]){
                count <- count + 1
        }
}        
count*100/nrow(testing)
#answer: 96%

#Question 5
set.seed(3523)
library(AppliedPredictiveModeling)
data(concrete)
inTrain = createDataPartition(concrete$CompressiveStrength, p = 3/4)[[1]]
training = concrete[ inTrain,]
testing = concrete[-inTrain,]
set.seed(325)
svmmdl <- svm(CompressiveStrength~., training)
predSVM <- predict(svmmdl, testing)
sqrt(mean((predSVM - testing$CompressiveStrength)^2))
#answer: 6.72