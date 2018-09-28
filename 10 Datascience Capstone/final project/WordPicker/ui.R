library(shiny)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("WordPicker"),
  h5("PRO EDITION"),
  br(),
  br(),
  
  # Sidebar with text box input
  sidebarLayout(
    sidebarPanel(
            textInput("query", "Enter a phrase:", "this is an example"),
            checkboxInput("nostop", "Filter stopwords?"),
            checkboxInput("noprofanity", "Filter profanity?"),
            br(),
            h5("Click to visit our partner websites:"),
            a(href="https://www.coursera.org/specializations/jhu-data-science", "Coursera datascience specialization"),
            br(),
            a(href="https://www.microsoft.com/en-us/swiftkey?activetab=pivot_1%3aprimaryr2", "Swiftkey")
    ),
    
    # Shows word choices
    mainPanel(
           tableOutput("choices"),
           br(),
           h5("Probabilites are calculated \"in class\" with respect to the length of the query phrase, i.e. \"stupid back-off\", and are not adjusted for the removal of stopwords or profanity.")
    )
  )
))
