## uncomment to download, unzip, and load data
# if(!file.exists("exdata-data-NEI_data.zip")){
#         download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", 
#                       "exdata-data-NEI_data.zip", method = "curl")}
# if(!file.exists("summarySCC_PM25.rds") | !file.exists("Source_Classification_Code.rds")){
#         unzip("exdata-data-NEI_data.zip")}
# NEI <- readRDS("summarySCC_PM25.rds")
# SCC <- readRDS("Source_Classification_Code.rds")

## Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 

#calc total emissions for each year
sum_em_by_yr <- tapply(NEI$Emissions, NEI$year, sum)

#make plot
png(file = "plot1.png")
barplot(sum_em_by_yr, ylab = "Total emissions (tons)")
dev.off()
