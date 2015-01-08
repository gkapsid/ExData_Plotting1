# check for file existence
# first if statement for manual download and unzip
# second if stat for automatic (using the downloader) download and unzip
if (!file.exists("exdata_data_household_power_consumption/household_power_consumption.txt")) {
    if (!file.exists("household_power_consumption.txt")) {
        
        library(downloader)
        url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        download(url, "ExDtAnProj1.zip", mode="wb")
        unzip("ExDtAnProj1.zip")
        unlink(url)
    }
}

library(data.table)

#Read specific lines

# Define no of samples/hour, days of observation and start date
# it is easier to modify the script
SPH<- 60 # one minute sampling rate, 60 per hour
DOO<- 2 # days of observation
noOfRows<-24*SPH*DOO #no of rows to be read from file
startingDay<-"1/2/2007" #as it is in txt file before turned to date

#Create the necessary dataframe

# read the data for certain days (certain lines)
proj1<-fread("household_power_consumption.txt", skip=startingDay, nrows=noOfRows, sep=";", na.strings="?")
#read colnames from txt file
headers<-fread("household_power_consumption.txt", nrows=0)
#set colnames in proj1 dataframe
setnames(proj1, names(proj1), names(headers))

#convert date data to date type
proj1$Date <- as.Date(proj1$Date, "%d/%m/%Y") #I'm not sure why but is necessary step
# Otherwise there is an error

DateTime<-strptime(paste(proj1$Date, proj1$Time), format = "%Y-%m-%d %H:%M:%S")

DT.DF<-data.frame(DateTime)
proj1<-cbind(proj1, DT.DF)

rm(DT.DF, headers, DateTime) # free some memory
#Data frame is now complete and ready to be used

Sys.setlocale("LC_TIME", "C") # my system is greek so I found this solution for the days to appear in english

#Plot and png export
png(filename="plot3.png") # open png graphics device

plot(proj1$DateTime, proj1$Sub_metering_1, xlab="" ,ylab="Energy sub metering", type="n")
points(proj1$DateTime, proj1$Sub_metering_1, type = "l")
points(proj1$DateTime, proj1$Sub_metering_2, type = "l", col = "red")
points(proj1$DateTime, proj1$Sub_metering_3, type = "l", col="blue")
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),lty=1, col = c("black", "red", "blue"))

dev.off()


