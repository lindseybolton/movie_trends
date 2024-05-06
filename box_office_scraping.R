# Final Project
# Lindsey Bolton and Mollie Cox
# Our final project focuses on collecting data from Metacritic and IMDb to understand the relationship bewteen critic scores
# and box office sales for movies over the past 10 years.

rm(list = ls())

# Load library
library("xml2")

# Initalize empty vectors
movie_title <- character(0)
gross <- character(0)
genre <- character(0)

# Set user agent
user_agent <- "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36"


# Scraping for Metacritic
for (i in 1:100){
  print(i)
  
  url<-paste("https://www.imdb.com/list/ls057823854/?st_dt=&mode=detail&page=", i, "&ref_=ttls_vm_dtl&sort=list_order,asc", sep="")
  
  url
  page <- read_html(url, user_agent)
  
  Sys.sleep(5)
  
  title <- xml_text(xml_find_all(page, "//h3[@class='lister-item-header']"))
  movie_title <- c(movie_title, title)
  
  grossing <- xml_text(xml_find_all(page, "//p[@class='text-muted text-small']"))
  gross <- c(gross, grossing)
  
  genres <- xml_text(xml_find_all(page, "//span[@class='genre']"))
  genre <- c(genre, genres)
  
  random_value <- sample(2:20, 1)
  Sys.sleep(random_value)
  
}

# Data Cleaning

# We want to keep only the even indexes in the gross vector. The scraping pulled both "Yearly gross" and "Total gross" from the website, and we are
# only interested in total, which is every other value
gross <- as.data.frame(gross)
modified_gross <- gross[grep("^\\s*Votes:", gross$gross), ]


# Now, we want to only keep the gross amount
gross_revenue <- gsub(".*\\$([0-9.,]+)M.*", "\\1", modified_gross)

# From movie title, we want to extract the year
movie_title1 <- as.data.frame(movie_title)

movie_title1$date <- as.numeric(sub(".*\\((\\d{4})\\).*", "\\1", movie_title1$movie_title)) # Stores the year in another column

movie_title1$movie_title <- sub("^\\s*\\d+,?\\d*\\.\\s*|\\s*\\(\\d{4}\\)", "", movie_title1$movie_title) # Gets rid of the leading number

movie_title1$movie_title <- sub("\\s*\\(\\d+\\)", "", movie_title1$movie_title) # Gets rid of the year

# Now we will clean the genre
genre <- as.data.frame(genre)

genre1 <- genre

# Since movies can have multiple genres, we will just work with the first one listed.
genre1$genre <- sub("^\\s*([^,]+).*", "\\1", genre1$genre)

# Now we need to make sure our data lengths are all the same. Since the shortest vector is the "gross_revenue" vector, we will base it off of that.
genre1 <- genre1[1:9749,]
movie_title1 <- movie_title1[1:9749,]

# Combine our vectors into a dataframe
box_office <- data.frame(title = movie_title1, gross = gross_revenue, genre = genre1)

# Delete Values that didn't have a gross, so they just kept the votes
box_office <- box_office[!grepl("^\\s*Votes:", box_office$gross), ]

# Save to a csv file
write.csv(box_office, file = "box_office.csv", row.names = FALSE)



