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

#creates multi faceted plot and saves to png
png (file = "plot4.png")
#parameters
par(mfcol=c(2,2))
#first graph
with(hpc, plot(DateTime, Global_active_power, ylab = "Global Active Power", xlab="", type = "l"))
#second graph
with(hpc, plot(DateTime, Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering"))
with(hpc, lines(DateTime, Sub_metering_3, type = "l", col = "blue"))
with(hpc, lines(DateTime, Sub_metering_2, type = "l", col = "red"))
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       col = c("black", "red", "blue"), lwd =2, bty = "n")
#third graph
with(hpc, plot(DateTime, Voltage, ylab = "Voltage", xlab="datetime", type = "l"))
#fourth graph
with(hpc, plot(DateTime, Global_reactive_power, ylab = "Global_reactive_power", xlab="datetime", type = "l"))

dev.off()







