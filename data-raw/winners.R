library(rvest)
library(dplyr)
library(lubridate)
library(chron)
library(readr)

# London Marathon Winners -------------------------------------------------

# grab tables of data containing winning times
london <- read_html("https://en.wikipedia.org/wiki/List_of_winners_of_the_London_Marathon")
london <- london %>%
  html_elements(".wikitable.sortable") %>%
  html_table()

# remove last table as not related to times and combine
london <- london[1:4]
categories <- c("Men", "Women", "Wheelchair Men", "Wheelchair Women")
names(london) <- categories
london <- dplyr::bind_rows(london, .id = "Category") %>%
  select(-Notes)

# rename columns and sort time
winners <- london %>%
  rename(Time = `Time(h:m:s)`) %>%
  mutate(
    Year = gsub("\\[\\d+\\]", "", Year),
    Year = as.numeric(Year)
  ) %>%
  mutate(Time = chron(times = Time))

# save as csv
write_csv(winners, file = "winners.csv")
usethis::use_data(winners, overwrite = TRUE)
