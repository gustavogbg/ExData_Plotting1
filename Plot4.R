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
##  Creating time series data with 'xts' package via 'zoo' function.
## ----------------------------------------------------------------------------------
library(xts)

globalActivePower <- zoo(houseHoldPowerCons$Global_active_power, houseHoldPowerCons$dayOfTheWeek)

subMetering <- data.frame(houseHoldPowerCons$Sub_metering_1, houseHoldPowerCons$Sub_metering_2, houseHoldPowerCons$Sub_metering_3)
subMetering <- zoo(subMetering, houseHoldPowerCons$dayOfTheWeek)

voltage <- zoo(houseHoldPowerCons$Voltage, houseHoldPowerCons$dayOfTheWeek)

globalReactivePower <- zoo(houseHoldPowerCons$Global_reactive_power, houseHoldPowerCons$dayOfTheWeek)

## ----------------------------------------------------------------------------------
##  Plot 4 - a four plot frame, with time series line charts. Consists on Global Active
##           Power, Voltage, Energy Sub Metering (all three) and Global Reactive Power.
## ----------------------------------------------------------------------------------

png("Plot4.png", width = 480, height = 480)
par(mfrow = c(2,2))
plot(globalActivePower, ylab = "Global Active Power", xlab = "")
plot(voltage, ylab = "Voltage", xlab = "datetime")
plot(subMetering, screens = 1, col = c(1,2,4), ylab = "Energy sub metering", xlab = "")
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c(1, 2, 4), lty = 1, bty = "n")
plot(globalReactivePower, ylab = "Global_reactive_power", xlab = "datetime")
dev.off()