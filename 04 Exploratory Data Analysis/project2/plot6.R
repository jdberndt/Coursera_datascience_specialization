## uncomment to download, unzip, and load data
# if(!file.exists("exdata-data-NEI_data.zip")){
#         download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", 
#                       "exdata-data-NEI_data.zip", method = "curl")}
# if(!file.exists("summarySCC_PM25.rds") | !file.exists("Source_Classification_Code.rds")){
#         unzip("exdata-data-NEI_data.zip")}
# NEI <- readRDS("summarySCC_PM25.rds")
# SCC <- readRDS("Source_Classification_Code.rds")

## Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in 
## Los Angeles County, California (fips=="06037"). Which city has seen greater changes over time in motor vehicle emissions?

#load libraries
library(dplyr)

# calc total emissions per year for motor vehicles in Baltimore City (BC) and Los Angeles (LA) 
# assumes boats, planes, trains, and Non-Road Equipment are not considered "motor vehicles"
SCCmv <- SCC[grep("Vehicle", SCC$EI.Sector), "SCC"]
NEImvBC <- NEI%>%filter(SCC %in% SCCmv & fips == "24510")
NEImvLA<-NEI%>%filter(SCC %in% SCCmv & fips == "06037")
mvsumBC <- tapply(NEImvBC$Emissions, NEImvBC$year, sum)
mvsumLA <- tapply(NEImvLA$Emissions, NEImvLA$year, sum)
change <- c(BC=(mvsumBC[[4]]-mvsumBC[[1]]), LA=(mvsumLA[[4]]-mvsumLA[[1]]))

#make plot
png(file = "plot6.png")
par(mfrow = c(1,3), mar = c(4,4,3,1))
rng <- range(mvsumBC, mvsumLA)
barplot(mvsumBC, ylab = "Total motor vehicle-based emissions in Baltimore City, MD (tons)", ylim = rng, main = "BC", names.arg = c("99", "02", "05", "08"))
barplot(mvsumLA, ylab = "Total motor vehicle-based emissions in Los Angeles, CA (tons)", ylim = rng, main = "LA", names.arg = c("99", "02", "05", "08"))
barplot(change, ylab = "Change in motor vehicle emissions 2008-1999 (tons)", main = "Change (08-99)")
dev.off()