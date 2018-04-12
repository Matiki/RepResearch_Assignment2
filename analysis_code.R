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

# Select only the event type, fatalities/injuries, and damage
storm_data <- storm_data %>%
        select(EVTYPE, FATALITIES, INJURIES, 
               PROPDMG, PROPDMGEXP, CROPDMG, CROPDMGEXP) %>%
        group_by(EVTYPE)

# Change EVTYPE to factor variable
storm_data$EVTYPE <- as.factor(storm_data$EVTYPE)

# Summarize data over mean/median/max/total fatalities/injuries
storm_data2 <- storm_data %>%
        summarize(mean_fatalities = mean(FATALITIES),
                  median_fatalities = median(FATALITIES),
                  max_fatalities = max(FATALITIES),
                  total_fatalities = sum(FATALITIES),
                  mean_injuries = mean(INJURIES),
                  median_injuries = median(INJURIES),
                  max_injuries = max(INJURIES),
                  total_injuries = sum(INJURIES))

# Find most dangerous event type
most_fatal_median <- storm_data2 %>%
        arrange(desc(median_fatalities)) %>%
        head(25)

most_fatal_total <- storm_data2 %>%
        arrange(desc(total_fatalities)) %>%
        head(25)

most_injury_median <- storm_data2 %>%
        arrange(desc(median_injuries)) %>%
        head(25)

most_injury_total <- storm_data2 %>%
        arrange(desc(total_injuries)) %>%
        head(25)