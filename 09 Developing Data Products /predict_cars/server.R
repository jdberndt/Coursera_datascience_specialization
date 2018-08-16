
library(shiny)
library(caret)
library(ggplot2)
library(randomForest)
library(elasticnet)


shinyServer(function(input, output) {
        
        set.seed(1234)
        mdl <- reactive ({
                #takes input from covariates check boxes and converts to formula
               covarstring <- paste0("mpg~", input$covars[1])
                if (length(input$covars >1)){
                        for (i in 2:length(input$covars)){
                                covarstring <- paste(covarstring, input$covars[i], sep = "+")
                        }
                }
                #uses formula calculated above and model type from user to train model
                train(as.formula(covarstring), data=mtcars, method=input$method)  

        })
        
        #predicts mpg using model
        pred <- reactive({predict(mdl(), mtcars)})
        
        #creates plot using predicted mpg and actual mpg, fits linear regression line
        output$carsplot <- renderPlot({
                qplot(mtcars$mpg, pred())+
                        geom_smooth(method = "lm", color = "red")+
                        labs(x = "known values (mpg)", y = "predicted values (mpg)")
               
        })
        
        #extracts out put from model
        output$mdlstats <- renderPrint({mdl()})

        
})
