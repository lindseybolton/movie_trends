# Final Project
# Lindsey Bolton and Mollie Cox
# Our final project focuses on collecting data from Metacritic and IMDb to understand the relationship between critic scores
# and box office sales for movies over the past 10 years.

rm(list = ls())


library(ggplot2)

merged_data <- read.csv("merged_data.csv")

## Question 1: Is there a strong relationship between box office sales and critic reviews? 
# Can we use the performance of a movie based on critic reviews to predict box office sales?

ggplot(merged_data, aes(x = score, y = gross)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(title = "Relationship Between Box Office and Critic Score", x = "Score", y = "Gross")

## Question 2: Which genre generates the most box office sales?
# Do critics and the public tend to feel the same way about certain genres?
merged_data$genre <- trimws(merged_data$genre)

genre_profit <- aggregate(gross ~ genre, data = merged_data, sum)

ggplot(genre_profit, aes(x = reorder(genre, -gross), y = gross, fill = genre)) +
  geom_bar(stat = "identity") +
  labs(title = "Box Office Profit by Genre",
       x = "Genre",
       y = "Total Box Office Gross") +
  theme(axis.text.x = element_blank())

genre_score <- aggregate(score ~ genre, data = merged_data, sum)

ggplot(genre_score, aes(x = reorder(genre, -score), y = score, fill = genre)) +
  geom_bar(stat = "identity") +
  labs(title = "Critic Score by Genre",
       x = "Genre",
       y = "Total Critic Score") +
  theme(axis.text.x = element_blank())

## Question 3: What years have seen the most box office sales? 
# Have movies increased or decreased in popularity, and is there an explanation for these trends?

merged_data <- merged_data %>%
  arrange(date)

yearly_profit <- aggregate(gross ~ date, data = merged_data, mean)

ggplot(yearly_profit, aes(x = date, y = gross, group = 1)) +
  geom_line() +
  labs(title = "Box Office Sales Over Time",
       x = "Year",
       y = "Average Box Office Sales")
