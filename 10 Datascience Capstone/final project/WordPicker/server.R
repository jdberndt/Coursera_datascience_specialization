#load packages
library(shiny)
library(dplyr)
library(stringr)

#load data
ngrams_dt <- readRDS("ngrams_dt.rds")

#initialize objects
trigram = character(); bigram = character(); unigram = character()

#define reactive functions
shinyServer(function(input, output) {
   
         output$choices <- renderTable({
                #parse query text and collapse into ngrams
                  query <- str_split(input$query, boundary("word"), simplify = T)
                  len.query <- length(query)
                  if (len.query == 0){return(NULL)}
                  if (len.query < 3){
                          quadrigram <- NA
                  }else{
                          quadrigram <- paste(query[(len.query-3):len.query], collapse="_")
                  }
                  if (len.query < 2){
                          trigram <- NA
                  }else{
                          trigram <- paste(query[(len.query-2):len.query], collapse="_")
                  }       
                  if (len.query < 1){
                          bigram <- NA
                  }else{
                          bigram <- paste(query[(len.query-1):len.query], collapse="_")
                  }
                  unigram <- query[len.query]

                #compare to data table of corpus ngrams to find at least matches
                  results <- ngrams_dt[[1]][F,]
                  results <- ngrams_dt$Pentagrams%>%filter(query.phrase == quadrigram)
                  if (nrow(results)<10){
                          moreresults <- ngrams_dt$Quadrigrams%>%filter(query.phrase == trigram)
                          results <- rbind(results, moreresults)
                  }
                  if (nrow(results)<10){
                          moreresults <- ngrams_dt$Trigrams%>%filter(query.phrase == bigram)
                          results <- rbind(results, moreresults)
                  }
                  if (nrow(results)<10){
                          moreresults <- ngrams_dt$Bigrams%>%filter(query.phrase == unigram)
                          results <- rbind(results, moreresults)
                  }
                  if (input$nostop == T){
                    results <- results%>%filter(!predicted.word %in% ngrams_dt$stopwords)
                  }
                  if (input$noprofanity == T){
                          results <- results%>%filter(!predicted.word %in% ngrams_dt$profanity)
                  }
                  
                  if (is.na(results[1, 2])) {
                          return("no prediction found")
                  } else{
                          results[1:10, c(1, 2, 4)]
                  }
                                  
          })
  
})
