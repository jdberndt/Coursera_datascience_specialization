## uncomment to download, unzip, and load data
# if(!file.exists("exdata-data-NEI_data.zip")){
#         download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", 
#                       "exdata-data-NEI_data.zip", method = "curl")}
# if(!file.exists("summarySCC_PM25.rds") | !file.exists("Source_Classification_Code.rds")){
#         unzip("exdata-data-NEI_data.zip")}
# NEI <- readRDS("summarySCC_PM25.rds")
# SCC <- readRDS("Source_Classification_Code.rds")

## How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

#load libraries
library(dplyr)

# calc total emissions per year for motor vehicles in Baltimore City, 
# assumes boats, planes, trains, and Non-Road Equipment are not considered "motor vehicles"
NEI2 <- subset(NEI, fips == 24510)
SCCmv <- SCC[grep("Vehicle", SCC$EI.Sector), "SCC"]
NEImv <- NEI2%>%filter(SCC %in% SCCmv)
mvsum <- tapply(NEImv$Emissions, NEImv$year, sum) 

#make plot
png(file = "plot5.png")
barplot(mvsum, ylab = "Total motor vehicle-based emissions in Baltimore City, MD (tons)")
dev.off()