## uncomment to download, unzip, and load data
# if(!file.exists("exdata-data-NEI_data.zip")){
#         download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", 
#                       "exdata-data-NEI_data.zip", method = "curl")}
# if(!file.exists("summarySCC_PM25.rds") | !file.exists("Source_Classification_Code.rds")){
#         unzip("exdata-data-NEI_data.zip")}
# NEI <- readRDS("summarySCC_PM25.rds")
# SCC <- readRDS("Source_Classification_Code.rds")

## Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

#load libraries
library(dplyr)

#calc total emissions for year filtering for coal
SCCcoal <- SCC[grep("Coal", SCC$EI.Sector), "SCC"]
NEIcoal <- NEI%>%filter(SCC %in% SCCcoal)
coalsum <- tapply(NEIcoal$Emissions, NEIcoal$year, sum)

#make plot
png(file = "plot4.png")
barplot(coalsum, ylab = "Total coal-based emissions (tons)")
dev.off()