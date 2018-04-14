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
        select(BGN_DATE, STATE, EVTYPE, FATALITIES, INJURIES, 
               PROPDMG, PROPDMGEXP, CROPDMG, CROPDMGEXP) %>%
        group_by(EVTYPE)

# Change EVTYPE to factor variable
storm_data$EVTYPE <- as.factor(storm_data$EVTYPE)

# Summarize data over max/total fatalities/injuries
storm_data2 <- storm_data %>%
        summarize(total_fatalities = sum(FATALITIES),
                  total_injuries = sum(INJURIES))

# Find most dangerous event type by fatalities and injuries
top = 25

top_fatal <- storm_data2 %>%
        arrange(desc(total_fatalities)) %>%
        head(top)

top_injury <- storm_data2 %>%
        arrange(desc(total_injuries)) %>%
        head(top)

# Combine data
most_harmful <- inner_join(top_fatal, 
                           top_injury, 
                           by = c("EVTYPE", 
                                  "total_fatalities", 
                                  "total_injuries"))

# Filter data by damage in the billions
storm_data3 <- storm_data %>%
        filter(CROPDMGEXP == "B" | PROPDMGEXP == "B") %>%
        summarize(prop_dmg = sum(PROPDMG), 
                  crop_dmg = sum(CROPDMG)) %>%
        arrange(desc(prop_dmg), desc(crop_dmg))
