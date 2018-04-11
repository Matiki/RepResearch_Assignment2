library(readr)
library(dplyr)
library(ggplot2)

if(!file.exists("zipped_storm_data.csv.bz2")){
        URL <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"
        download.file(URL,
                      destfile = "zipped_storm_data.csv.bz2")
}

if(!file.exists("storm_data.csv")){
        library(R.utils)
        bunzip2(filename = "zipped_storm_data.csv.bz2", 
                destname = "storm_data.csv", 
                remove = F, 
                skip = T)
        }

storm_data <- read_csv("storm_data.csv")