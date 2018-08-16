rankall <- function(outcome, num = "best") {
        # Read outcome data
        df <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
        
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
        
        #extract hospital name, state, and outcome% for all states
        df <- df[,c(2, 7, cnum)] 
        colnames(df) <- c("Name", "State", "Rate") #rename columns
        df$Rate <- suppressWarnings(as.numeric(df$Rate)) #coerce numeric class on outcome%
        df <- df[complete.cases(df$Rate),] # remove NAs
        
        
        ## For each state, find the hospital of the given rank
        ## Return a data frame with the hospital names and the
        ## (abbreviated) state name
        
        result <- vector()
        states <- levels(factor(df$State)) #create vector with state abbreviations
        for (s in states){ #iterate over state abbreviations
                df.state <- subset(df, df$State == s) #create a smaller df for state (probably a way to do this with apply)
                df.state <- df.state[order(df.state$Rate, df.state$Name),] #order by name and rate
                
                #determine hospital names from num (rank)
                if (num == "best"){
                        sel.name <- df.state$Name[1]
                }else if (num == "worst"){ 
                        sel.name <- df.state$Name[nrow(df.state)]
                }else if (num <= nrow(df.state)){
                        sel.name <- df.state$Name[num]
                }else {
                        sel.name <- NA
                }
                result <- append(result, sel.name) #append hospital name to result vector
        }

        outputdf <- data.frame(hospital = result, state = states) #build df, note:result and states must be in same order
        rownames(outputdf) <- states
        return(outputdf)
}    
        # > source("rankall.R")
        # > head(rankall("heart attack", 20), 10)
        # AK AL AR
        # hospital state
        # <NA>    AK
        # D W MCMILLAN MEMORIAL HOSPITAL    AL
        # ARKANSAS METHODIST MEDICAL CENTER    AR
        # 4
        # AZ JOHN C LINCOLN DEER VALLEY HOSPITAL    AZ
        # CA
        # CO
        # CT
        # DC
        # DE
        # FL
        # SHERMAN OAKS HOSPITAL    CA
        # SKY RIDGE MEDICAL CENTER    CO
        # MIDSTATE MEDICAL CENTER    CT
        # <NA>    DC
        # <NA>    DE
        # SOUTH FLORIDA BAPTIST HOSPITAL    FL
        # > tail(rankall("pneumonia", "worst"), 3)
        # hospital state
        # WI MAYO CLINIC HEALTH SYSTEM - NORTHLAND, INC    WI
        # WV                     PLATEAU MEDICAL CENTER    WV
        # WY           NORTH BIG HORN HOSPITAL DISTRICT    WY
        # > tail(rankall("heart failure"), 10)
        # hospital state
        # TN                         WELLMONT HAWKINS COUNTY MEMORIAL HOSPITAL    TN
        # TX                                        FORT DUNCAN MEDICAL CENTER    TX
        # UT VA SALT LAKE CITY HEALTHCARE - GEORGE E. WAHLEN VA MEDICAL CENTER    UT
        # VA
        # VI
        # VT
        # WA
        # WI
        # WV
        # WY
        # SENTARA POTOMAC HOSPITAL    VA
        # GOV JUAN F LUIS HOSPITAL & MEDICAL CTR    VI
        # SPRINGFIELD HOSPITAL    VT
        # HARBORVIEW MEDICAL CENTER    WA
        # AURORA ST LUKES MEDICAL CENTER    WI
        # FAIRMONT GENERAL HOSPITAL    WV
        # CHEYENNE VA MEDICAL CENTER    WY
