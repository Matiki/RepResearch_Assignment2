# Load required packages into current R session
library(readr)
library(dplyr)
library(ggplot2)
library(tidyr)
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

# Find most dangerous event types by fatalities and injuries
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

# Filter data by property damage in the billions
storm_data3 <- storm_data %>%
        filter(PROPDMGEXP == "B") %>%
        summarize(prop_dmg = sum(PROPDMG)) %>%
        arrange(desc(prop_dmg))

# Filter by crop damage in the billions
storm_data4 <- storm_data %>%
        filter(CROPDMGEXP == "B") %>%
        summarize(crop_dmg = sum(CROPDMG)) %>%
        arrange(desc(crop_dmg))

# Plot the most harmful weather events
most_harmful %>% gather(value = casualties, 
                        key = type, 
                        total_fatalities, 
                        total_injuries) %>% 
        ggplot(aes(x = reorder(EVTYPE, 
                               desc(casualties)),
                   y = log(casualties),
                   fill = type)) +
        geom_bar(stat = "identity",
                 position = "dodge") +
        theme(axis.text.x = element_text(angle = 45, 
                                         vjust = 1, 
                                         hjust=1))

# Plot the most property damaging events
storm_data3 %>% head() %>%
        ggplot(aes(x = reorder(EVTYPE,
                               desc(prop_dmg)),
                   y = log(prop_dmg))) +
        geom_bar(stat = "identity") +
        theme(axis.text.x = element_text(angle = 45, 
                                         vjust = 1, 
                                         hjust=1))

# Plot the most crop damaging events
storm_data4 %>% ggplot(aes(x = reorder(EVTYPE,
                                       desc(crop_dmg)),
                           y = crop_dmg)) +
        geom_bar(stat = "identity") +
        theme(axis.text.x = element_text(angle = 45, 
                                         vjust = 1, 
                                         hjust=1))
