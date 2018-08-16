require(caret, ggplot2, Hmisc)

#input radio buttons to select model type and variables to include
#output graph and summary statistics for model performance


mdl <- train(mpg~., data=mtcars, method="rf")
qplot(mtcars$mpg, predict(mdl, mtcars))+geom_smooth(method = "lm", color = "red")

#regression methods = c("lm", "lasso", "enet")
#return RMSE 



#categorical methods = c("rf", "gbm", "lda")
#ask for bin size
#return Accuracy
