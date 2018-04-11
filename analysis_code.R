# Load required packages into current R session
library(readr)
library(dplyr)
library(ggplot2)
library(R.utils)

# Check if file exists in working directory
if(!file.exists("storm_data.csv")){
        
        # Download zipped file if needed
        if(!file.exists("zipped_storm_data.csv.bz2")){
                URL <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"
                download.file(URL,
                              destfile = "zipped_storm_data.csv.bz2")
                rm(URL)
        }
        
        # Unzip data file
        bunzip2(filename = "zipped_storm_data.csv.bz2", 
                destname = "storm_data.csv", 
                remove = F, 
                skip = T)
        }

# Read unzipped data file into current R session
storm_data <- read_csv("storm_data.csv")