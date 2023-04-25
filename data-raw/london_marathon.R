library(rvest)
library(dplyr)
library(lubridate)
library(readr)

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
  mutate(
    Raised = gsub("\\[|*.\\]", "", Raised),
    Raised = as.numeric(Raised)
  ) %>%
  mutate(across(c(Applicants, Accepted, Starters, Finishers), parse_number)) %>%
  mutate(`Official charity` = case_when(
    `Official charity` == "—" ~ NA_character_,
    `Official charity` == "" ~ NA_character_,
    TRUE ~ `Official charity`
  ))

# save as csv
write_csv(london_marathon, file = "london_marathon.csv")
usethis::use_data(london_marathon, overwrite = TRUE)