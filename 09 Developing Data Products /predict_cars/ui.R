
library(shiny)


shinyUI(fluidPage(
  
  # Application title
  titlePanel("Predict MPG using the Motor Trends cars dataset"),
  
  # Sidebar (all input is collected in the sidbar)  
  sidebarLayout(
    sidebarPanel(
        h3("Choose a model method:"),
        radioButtons("method", "", choiceNames = c("OLS regression", "lasso regression", 
                                "random forest"), choiceValues = c("lm", "lasso", "rf"), selected = "lm"),
        br(),
        h3("Choose the predictors:"),
        checkboxGroupInput("covars", "", names(mtcars[-1]), selected = names(mtcars[-1])),
        submitButton("Submit")
    ),
    
    # MainPanel (creates tabs and displays outputs)
    mainPanel(
            tabsetPanel(
                tabPanel("Instructions", br(), 
                        h3("Objective:"),
                        h4("To create a prediction engine for the mtcars data."),
                        br(),
                        h3("Instructions:"),
                        h4("Select a model type and the covariates to include in the model."),
                        br(),
                        h3("Outcome:"),
                        h4("The plot tab shows a plot of the known and predicted values from the training data. The line is a linear regression between the predicted and known values for mpg. The model info tab shows the model stats."), 
                        br(),
                        h4("Note: There is no testing dataset included; so, you are looking at the in sample error.")),
                tabPanel("Plot", br(), plotOutput("carsplot")),
                tabPanel("Model info", br(), verbatimTextOutput("mdlstats"))
            )
    )
  )
))
