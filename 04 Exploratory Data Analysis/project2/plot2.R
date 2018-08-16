## uncomment to download, unzip, and load data
# if(!file.exists("exdata-data-NEI_data.zip")){
#         download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", 
#                       "exdata-data-NEI_data.zip", method = "curl")}
# if(!file.exists("summarySCC_PM25.rds") | !file.exists("Source_Classification_Code.rds")){
#         unzip("exdata-data-NEI_data.zip")}
# NEI <- readRDS("summarySCC_PM25.rds")
# SCC <- readRDS("Source_Classification_Code.rds")

## Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips=="24510") from 1999 to 2008? 

#calc total emissions for each year in Baltimore City
NEI2 <- subset(NEI, fips == 24510)
sum_em_by_yr <- tapply(NEI2$Emissions, NEI2$year, sum)

#make plot
png(file = "plot2.png")
barplot(sum_em_by_yr, ylab = "Total emissions Baltimore City, MD (tons)")
dev.off()