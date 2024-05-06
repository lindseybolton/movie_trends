# Final Project
# Lindsey Bolton and Mollie Cox
# Our final project focuses on collecting data from Metacritic and IMDb to understand the relationship bewteen critic scores
# and box office sales for movies over the past 10 years.

rm(list = ls())

# Load library
library("xml2")

# Initalize empty vectors
movie_title <- character(0)
critic_score <- character(0)
release_date <- character(0)


# Set user agent
user_agent <- "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36"

# Scraping for Metacritic
for (i in 1:399){
  print(i)
  
  url<-paste("https://www.metacritic.com/browse/movie/?releaseYearMin=2006&releaseYearMax=2016&page=", i, sep="")
  
  url
  page <- read_html(url, user_agent)
  
  Sys.sleep(5)
  
  title <- xml_text(xml_find_all(page, "//h3[@class='c-finderProductCard_titleHeading']"))
  movie_title <- c(movie_title, title)
  
  score <- xml_text(xml_find_all(page, "//div[@class='c-siteReviewScore_background c-finderProductCard_metascoreValue u-flexbox-alignCenter g-height-100 g-outer-spacing-right-xsmall c-siteReviewScore_background-critic_xsmall']/div/span"))
  critic_score <- c(critic_score, score)
  
  date <- xml_text(xml_find_all(page, "//div[@class='c-finderProductCard_meta']"))
  release_date <- c(release_date, date)
  
  random_value <- sample(2:20, 1)
  Sys.sleep(random_value)
  
}

# Delete the last two entries in both movie_title and release_date
movie_title <- movie_title[1:(length(movie_title) - 2)]
release_date <- release_date[1:(length(release_date) - 2)]

# Combine into dataset
metacritic <- data.frame(score = critic_score, title = movie_title, date = release_date)

# Data cleaning

# Remove numbers in front of titles
metacritic$title <- gsub("^\\d{1,3}(,\\d{3})*\\.\\s", "", metacritic$title)

# Remove movie rating in date
metacritic$date <- gsub(".*?(\\b\\w{3} \\d{1,2}, \\d{4}\\b).*", "\\1", metacritic$date)

# We will only use the year, so we can remove that as well
metacritic$date <- gsub(".*,\\s(\\d{4})", "\\1", metacritic$date)

# Trim any white space
metacritic$score <- trimws(metacritic$score)
metacritic$title <- trimws(metacritic$title)
metacritic$date <- trimws(metacritic$date)

# Save data frame as csv
write.csv(metacritic, file = "metacritic.csv", row.names = FALSE)

