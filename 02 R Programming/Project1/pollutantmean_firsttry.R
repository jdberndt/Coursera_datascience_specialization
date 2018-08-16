pollutantmean <- function(directory, pollutant, id=1:332){
psum <- numeric() #initializes vectors
pcount <- numeric()
        for (i in id) {         #converts id to string with leading zeros
                if (i<10){
                        i=(paste("00", i, sep=""))
                } else if(i<100){
                        i=(paste("0", i, sep=""))
                } else {i = as.character(i)
                } 
                file_name<- paste(directory, "/", i, ".csv", sep="")
                df<-read.csv(file_name) #reads file into dataframe
                goodvalues <- !is.na(df[ ,pollutant]) #defines non-NA values
                psum <- c(psum, sum(df[goodvalues, pollutant])) #appends vectors with the counts and sums
                pcount <- c(pcount, sum(goodvalues))
        }
sum(psum)/sum(pcount)
}