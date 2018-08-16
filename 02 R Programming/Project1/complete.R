complete <- function(directory, id=1:332){
        files_list <- list.files(directory, full.names=TRUE) #creates a list of files
        df_nobs <- data.frame(id = numeric(), nobs = numeric())    #initializes df
        for (i in id){ 
                file <- read.csv(files_list[i]) #loads one file at a time
                numobs <- sum(!is.na(file$sulfate+file$nitrate)) #counts complete cases
                df_nobs <- rbind(df_nobs, data.frame(id = i, nobs = numobs)) #appends to df
        } 
        df_nobs
}