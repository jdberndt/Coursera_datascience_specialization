NCOL <- 9

readFile <- function(filename="./household_power_consumption.txt", skip=66637, nrows=2880, 
                     colC = c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"), 
                     colN = c("Date", "Time", "Global_Active_Power", "Global_Reactive_Power", "Voltage", "Global_Intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3") ) {
        
        # no attempt to check the validity of skip or nrows
        # assuming colNames and ColClasses have same length and do match
        if (length(colC) < NCOL) {
                v <- rep("NULL", NCOL - length(colC))    
                colC <- c(colC, v)
                colN <- c(colN, v)
        }
        
        read.table(filename, sep=';', header=FALSE, skip=skip, dec = ".", nrows=nrows, na.strings=c("NA", "?"), 
                   colClasses = colC, col.names = colN)
}

aggDateTime <- function(df) {
        # Assuming colNames Date and Time in correct format and at pos 1, 2 
        colN = colnames(df)[-(1:2)]
        vDate <- as.character(as.Date(df$Date, format="%d/%m/%Y")) 
        df$DateTime <- strptime(paste(vDate, df$Time, sep=" "), format = "%F %H:%M:%S", tz = "UTC")
        subset(df, select=-(Date:Time))[, c("DateTime", colN)]
}

withpng <- function(df, plotfun, filename="plot4.png") {
        png(filename=filename, width=480, height=480, bg="white")
        plotfun(df)
        dev.off()
}

plotfun <- function(df) {
        # Prep.
        par(mfrow = c(2, 2), mar = c(4, 4, 4, 1), oma = c(0, 2, 0, 1))
        
        # 1st plot
        with(df, plot(DateTime, Global_Active_Power, type="l", xlab="", ylab = "Global Active Power(kilowatts)"))
        
        # 2nd plot
        with(df, plot(DateTime, Voltage, type="l", xlab="datetime", ylab = "Voltage"))
        
        # 3rd plot
        with(df, plot(DateTime, Sub_metering_1, type="l", ylab = "Energy sub metering", xlab =""))
        with(df, lines(DateTime, Sub_metering_2, type="l", col="red"))
        with(df, lines(DateTime, Sub_metering_3, type="l", col="blue"))
        legend("topright", lty=1, col=c("black", "red", "blue"), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
               box.lty=0)
        
        # 4th plot
        with(df, plot(DateTime, Global_Reactive_Power, type="l", ylab = "Global Reactive Power", xlab ="datetime"))
}

# call
df <- readFile()
df <- aggDateTime(df)
withpng(df, plotfun)
print("Done")