library(readr)
library(dplyr)
library(ggplot2)

if(!file.exists("storm_data.csv")){
        download.file("https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2",
                      destfile = "zipped_data.csv")
}