## uncomment to download, unzip, and load data
# if(!file.exists("exdata-data-NEI_data.zip")){
#         download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", 
#                       "exdata-data-NEI_data.zip", method = "curl")}
# if(!file.exists("summarySCC_PM25.rds") | !file.exists("Source_Classification_Code.rds")){
#         unzip("exdata-data-NEI_data.zip")}
# NEI <- readRDS("summarySCC_PM25.rds")
# SCC <- readRDS("Source_Classification_Code.rds")

## Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
#       which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
#       Which have seen increases in emissions from 1999–2008? 

#load libraries
library(ggplot2)
library(dplyr)

#calc total emissions for each type and year in Baltimore City
NEI2 <- subset(NEI, fips == 24510)
NEI3 <- NEI2%>%
        group_by(type, year)%>%
        summarize(total = sum(Emissions, na.rm = TRUE))

#make plot
png(file = "plot3.png")
with (NEI3, qplot(x = year, y = total, geom = "line", col = type, ylab = "Total Emissions Baltimore City, MD (tons)"))
dev.off()