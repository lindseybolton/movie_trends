# Final Project
# Lindsey Bolton and Mollie Cox
# Our final project focuses on collecting data from Metacritic and IMDb to understand the relationship between critic scores
# and box office sales for movies over the past 10 years.

rm(list = ls())


library(ggplot2)

# Horizontally merge our metacritic data and our box office data
box_office <- read.csv("box_office.csv")
metacritic <- read.csv("metacritic.csv")

# We have to reorder the columns to be the same order, start with title then go to date then the rest of the columns
library(dplyr)

metacritic <- metacritic %>%
  select(title, date, score)

# Sort by date (earliest to most recent) in both datasets
box_office <- box_office %>%
  arrange(date)

metacritic <- metacritic %>%
  arrange(date)

# Need to trim the white space on box_office

box_office$title <- trimws(box_office$title)

# Merge the data and keep distinct values

merged_data <- merge(metacritic, box_office, by = c("title", "date"), all = FALSE)

merged_data <- distinct(merged_data)

# Save as an excel file
write.csv(merged_data, file = "merged_data.csv", row.names = FALSE)

