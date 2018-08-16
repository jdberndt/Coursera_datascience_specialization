if(!file.exists("household_power_consumption.txt")){
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", 
                        destfile = "household_power_consumption.txt", method = "curl")}

#reads in data for Feb 1st - 2nd 2007, adds header row
hpc <- read.table("household_power_consumption.txt", header = T, sep = ";", 
                  na.strings = "?", stringsAsFactors = F, skip = 66636, nrows = 2880)
hpc.header <- read.table("household_power_consumption.txt", sep = ";", header =F, 
                        stringsAsFactors = F, nrows = 1)
colnames(hpc) <- hpc.header

#merges Date and Time as POSIXct in new column
library(lubridate)
DateTime <- dmy_hms(paste(hpc$Date, hpc$Time))
hpc <-cbind(DateTime, hpc)

#creates line plot and saves to png
png (file = "plot2.png")
with(hpc, plot(DateTime, Global_active_power, ylab = "Global Active Power (kilowatts)", xlab="", type = "l"))
dev.off()







