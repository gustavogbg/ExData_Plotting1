rm(list = ls())

## ----------------------------------------------------------------------------------
## Download dataset Files
## ----------------------------------------------------------------------------------

fileURL = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

if(!file.exists ("./Original/Dataset.zip")) { 
    download.file(fileURL, destfile = "./Original/Dataset.zip", method = "curl")
    unzip("./Original/Dataset.zip", exdir = ".")
}

## ----------------------------------------------------------------------------------
##  Read the .csv file and extract only the data related to the dates in question
## ----------------------------------------------------------------------------------

houseHoldPowerCons <- read.csv2("household_power_consumption.txt", header = TRUE, 
                                sep = ";", quote = "\"'", dec = ".", fill = TRUE, 
                                stringsAsFactors = FALSE, na.strings = "?", 
                                skip = 66636, nrows = 2881, 
                                col.names = c("Date", "Time", "Global_active_power", 
                                              "Global_reactive_power", "Voltage",
                                              "Global_intensity", "Sub_metering_1",
                                              "Sub_metering_2", "Sub_metering_3")
)

## ----------------------------------------------------------------------------------
##  Using 'lubridate' package to merge Date and Time columns and transform it to date.
## ----------------------------------------------------------------------------------
library(lubridate)

dayOfTheWeek <- dmy_hms(paste(houseHoldPowerCons$Date, houseHoldPowerCons$Time))
houseHoldPowerCons <- data.frame(dayOfTheWeek, houseHoldPowerCons)

## ----------------------------------------------------------------------------------
##  Plot 3 - a time series line chart of sub metering variables. I used the
##           'xts' package to transform it to a time series via 'zoo' function. 
## ----------------------------------------------------------------------------------
library(xts)

subMetering <- data.frame(houseHoldPowerCons$Sub_metering_1, houseHoldPowerCons$Sub_metering_2, houseHoldPowerCons$Sub_metering_3)
subMetering <- zoo(subMetering, houseHoldPowerCons$dayOfTheWeek)

png("Plot3.png", width = 480, height = 480)
plot(subMetering, screens = 1, col = c(1,2,4), ylab = "Energy sub metering", xlab = "")
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c(1, 2, 4), lty = 1)
dev.off()