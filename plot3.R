#######################################

# Set required libraries.

#######################################

library(dplyr)


#######################################

# Download and unzip data.

#######################################

fileName <- "exdata_data_household_power_consumption.zip"

# Checking if archieve already exists.
if (!file.exists(fileName)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(fileURL, fileName, method="curl")
}  

# Checking if folder exists
if (!file.exists("exdata_data_household_power_consumption")) { 
  unzip(fileName) 
}

dataPath <- "./"


#######################################

# Read data.

#######################################

# Source data file:
# household_power_consumption.txt

houseHoldPowerConsumption <- read.delim(file.path(dataPath, "household_power_consumption.txt"), header = TRUE, sep = ";", na.strings="?", 
                                        nrows=2075259, check.names=FALSE, stringsAsFactors=FALSE, comment.char="", quote='\"')


#######################################

# Filter the data of interest.
# Just 2 day, from 1/2/2007 to 2/2/2007.

#######################################

dataOfInterest <- filter(houseHoldPowerConsumption, Date %in% c("1/2/2007", "2/2/2007"))

dataOfInterest$Date <- as.Date(dataOfInterest$Date, format = "%d/%m/%Y")

datetime <- paste(as.Date(dataOfInterest$Date), dataOfInterest$Time)

dataOfInterest$Datetime <- as.POSIXct(datetime)


#######################################

# Remove unnecessary data 
# in order to save RAM memory.

#######################################

# Remove data table.
rm(houseHoldPowerConsumption, datetime)


#######################################

# Create the graph and save it to a
# png file.

#######################################

with(dataOfInterest, {
  plot(Sub_metering_1~Datetime, type="l", ylab="Energy sub metering", xlab="")
  lines(Sub_metering_2~Datetime,col='red')
  lines(Sub_metering_3~Datetime,col='blue')
})

legend("topright"
       , col=c("black","red","blue")
       , c("Sub_metering_1                ","Sub_metering_2                ", "Sub_metering_3                ")
       ,lty=c(1,1), lwd=c(1,1))

dev.copy(png, file="plot3.png", height = 480, width = 480)

dev.off()