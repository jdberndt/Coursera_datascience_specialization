pollutantmean <- function(directory, pollutant, id=1:332){
        files_list <- list.files(directory, full.names=TRUE) #creates a list of files
        dat <- data.frame()    #initializes empty df
        for (i in id) {
                dat <- rbind(dat, read.csv(files_list[i]))} #rbinds files 
        mean(dat[, pollutant], na.rm=TRUE) #returns mean of available values
}
        
