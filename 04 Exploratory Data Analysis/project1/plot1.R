if(!file.exists("household_power_consumption.txt")){
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", 
                        destfile = "household_power_consumption.txt", method = "curl")}

#reads in data for Feb 1st - 2nd 2007, adds header row
hpc <- read.table("household_power_consumption.txt", header = T, sep = ";", 
                  na.strings = "?", stringsAsFactors = F, skip = 66636, nrows = 2880)
hpc.header <- read.table("household_power_consumption.txt", sep = ";", header =F, 
                         stringsAsFactors = F, nrows = 1)
colnames(hpc) <- hpc.header

#creates histogram and saves to PNG file
png (file = "plot1.png")
hist(hpc$Global_active_power, col = "red", 
     main = "Global active power", xlab = "Global Active Power (kilowatts)")
dev.off()








