#1. Plot the 30-day mortality rates for heart attack
outcome <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
head(outcome)
outcome[, 11] <- as.numeric(outcome[, 11])
hist(outcome[, 11])

#2.Finding the best hospital in a state
best <- function(state, outcome) {
        ## Read outcome data
        df <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
        
        ## Check that state and outcome are valid
        if state !in df[,7]{stop (cat(state, " not found!"))}
        if outcome !in c(“heart attack”, “heart failure”, “pneumonia”){stop (cat("Please choose an outcome: “heart attack”, “heart failure”, or “pneumonia”.))}
        if outcome !in df[,7]{stop (cat(outcome, " not found!"))}
        
        ## Return hospital name in that state with lowest 30-day death rate
}