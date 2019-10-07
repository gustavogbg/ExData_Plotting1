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
##  Plot 1 - a histogram in red color
## ----------------------------------------------------------------------------------

png("Plot1.png", width = 480, height = 480)
hist(houseHoldPowerCons$Global_active_power, col = "red", main = "Global Active Power", 
     xlab = "Global Active Power (kilowatts)")
dev.off()