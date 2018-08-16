rankhospital <- function(state, outcome, num = "best") {
        # Read outcome data
        df <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
        
        # Check that state is valid
        if (!(state %in% df[,7])) {stop("invalid state")} 
        
        # Check if outcome is valid and determine column number
        if (outcome == "heart attack"){
                cnum <- 11
        } else if (outcome == "heart failure"){
                cnum <- 17
        } else if (outcome == "pneumonia"){        
                cnum <- 23
        } else {
                stop("invalid outcome")
        }
        
        #reduce and determine rank order df
        df.state <- df[df[,7] == state, c(2, cnum)] #extract hospital name and outcome% for state
        colnames(df.state) <- c("Name", "Rate") # rename columns
        df.state$Rate <- suppressWarnings(as.numeric(df.state$Rate)) #coerce numeric class on outcome%
        df.state <- df.state[complete.cases(df.state$Rate),] # remove NAs
        df.state <- df.state[order(df.state$Rate, df.state$Name),] #order by Rate then Hospital name 
        
        #determine rank from num
        if (num == "best"){
                r <- 1
        }else if (num == "worst"){
                r <- nrow(df.state)
        }else if (num > nrow(df.state)){
                stop(NA)
        }else {
                r <- num
        }
        # Return hospital name in that state with the given rank 30-day death rate
        return(df.state[r, 1])
}

# > source("rankhospital.R")
# > rankhospital("TX", "heart failure", 4)
# [1] "DETAR HOSPITAL NAVARRO"
# > rankhospital("MD", "heart attack", "worst")
# 3
# [1] "HARFORD MEMORIAL HOSPITAL"
# > rankhospital("MN", "heart attack", 5000)
# [1] NA