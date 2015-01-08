if (!file.exists("exdata_data_household_power_consumption/household_power_consumption.txt")) {
    if (!file.exists("household_power_consumption.txt")) {
        
        library(downloader)
        url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        download(url, "ExDtAnProj1.zip", mode="wb")
        unzip("ExDtAnProj1.zip")
        unlink(url)
    }
}

#read specific lines
#library(dplyr)
library(data.table)
# Define no of samples/hour, days of observation and start date
# it is easier to modify the script
SPH<- 60 # one minute sampling rate 60 per hour
DOO<- 2 # days of observation
noOfRows<-24*SPH*DOO #no of rows to be read from file
startingDay<-"1/2/2007" #as it is in txt file before turned to date

# read the data for certain days (certain lines)
proj1<-fread("household_power_consumption.txt", skip=startingDay, nrows=noOfRows, sep=";", na.strings="?")
#read colnames from txt file
headers<-fread("household_power_consumption.txt", nrows=0)
#set colnames in proj1 dataframe
setnames(proj1, names(proj1), names(headers))

#convert date data to date type
proj1$Date <- as.Date(proj1$Date, "%d/%m/%Y")


#Histogram plot and png export
png(filename="plot1.png") # open png graphics device

hist(proj1$Global_active_power, col="red", main="Global Active Power", xlab="Global Active Power (kilowatts)", ylim=range(1200, 6))
dev.off()
