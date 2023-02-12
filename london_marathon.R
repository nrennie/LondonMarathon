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
  mutate(Year = gsub("\\[|*.\\]", "", Year), 
         Year = as.numeric(Year)) %>% 
  mutate(Time = chron(times = Time))

# save as csv
write_csv(winners, file = "winners.csv")

# London Marathon Data ----------------------------------------------------

# grab table of data with notes
london_data <- read_html("https://en.wikipedia.org/wiki/London_Marathon")
london_data <- london_data %>% 
  html_elements(".wikitable.sortable") %>% 
  html_table()

# convert columns to correct type
london_marathon <- london_data[[1]] %>% 
  select(-Edition) %>% 
  mutate(Date = dmy(Date)) %>% 
  mutate(Year = year(Date), .after = 1) %>% 
  rename(Raised = `Charity raised(£ millions)`) %>% 
  mutate(Raised = gsub("\\[|*.\\]", "", Raised), 
         Raised = as.numeric(Raised)) %>% 
  mutate(across(c(Applicants, Accepted, Starters, Finishers), parse_number)) %>% 
  mutate(`Official charity` = case_when(`Official charity` == "—" ~ NA_character_,
                                        `Official charity` == "" ~ NA_character_,
                                        TRUE ~ `Official charity`))

# save as csv
write_csv(london_marathon, file = "london_marathon.csv")
