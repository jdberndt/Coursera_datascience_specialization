#2.Finding the best hospital in a state
best <- function(state, outcome) {
        
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
        
        # Return hospital name in that state with lowest 30-day death rate
        df.state <- df[df[,7] == state, c(2,7,cnum)] #extract relevant rows and columns
        df.state[,3] <- suppressWarnings(as.numeric(df.state[,3])) #coerce numerical class on outcome percent
        min_val <- min(df.state[,3], na.rm = TRUE) #find min outcome percent
        df.min <- subset(df.state, df.state[,3] == min_val) #subset df.state by min value for outcome
        df.sorted <- df.min[order(df.min[,1]),] #sort df.min by Hospital.name
        return(df.sorted[1,1])
}

#https://d396qusza40orc.cloudfront.net/rprog%2Fdata%2FProgAssignment3-data.zip

# Expected outcomes:
# > best("TX", "heart attack")
# [1] "CYPRESS FAIRBANKS MEDICAL CENTER"
# > best("TX", "heart failure")
# [1] "FORT DUNCAN MEDICAL CENTER"
# > best("MD", "heart attack")
# [1] "JOHNS HOPKINS HOSPITAL, THE"
# > best("MD", "pneumonia")
# [1] "GREATER BALTIMORE MEDICAL CENTER"
# > best("BB", "heart attack")
# Error in best("BB", "heart attack") : invalid state
# > best("NY", "hert attack")
# Error in best("NY", "hert attack") : invalid outcome