corr <- function(directory, threshold = 0){
        file_list <- list.files(directory, full.names=TRUE) #creates a list of files
        x<- numeric()
        for (i in 1:332){ 
                file <- read.csv(file_list[i]) #loads one file at a time
                numobs <- sum(!is.na(file[,2]+file[,3])) #counts complete cases
                if (numobs > threshold){
                        x[i] <- cor(file[,2], file[,3], use = "complete.obs") 
                }        
        } 
        y<-!is.na(x)
        x<-x[y]
}