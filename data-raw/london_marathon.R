library(rvest)
library(dplyr)
library(lubridate)
library(readr)

# London Marathon Data ----------------------------------------------------

# grab table of data with notes
london_raw <- read_html("https://en.wikipedia.org/wiki/London_Marathon")
london_data <- london_raw %>%
  html_elements(".wikitable.sortable") %>%
  html_table()

# convert columns to correct type
london_marathon <- london_data[[1]] %>%
  select(-c(Edition, `Official charity`)) %>%
  mutate(Date = dmy(Date)) %>%
  mutate(Year = year(Date), .after = 1) %>%
  rename(Raised = `Charity raised(£ millions)`) %>%
  mutate(
    Raised = gsub("\\[|*.\\]", "", Raised),
    Raised = as.numeric(Raised)
  ) %>%
  mutate(across(c(Applicants, Accepted, Starters, Finishers), parse_number))

# process charity data
charity_lookup <- london_raw |> 
  html_elements(".wikitable.sortable") |> 
  html_elements("tr") |> 
  as.character() |> 
  data.frame(raw_html = _) |> 
  tibble::as_tibble() |>
  dplyr::slice(-c(1)) |>
  mutate(
    Year = str_extract_between(raw_html, "title=", ">"),
    Year = readr::parse_number(Year)
  ) |> 
  mutate(
    charities = str_extract_all_between(raw_html, "\n<a href=|<br><a href=", "</a>")
  )  |> 
  tidyr::unnest(charities) |> 
  mutate(charities = stringr::str_split(charities, ">", simplify = TRUE)[,2]) |> 
  dplyr::select(-raw_html) |> 
  group_by(Year) |> 
  summarise(`Official charity` = paste(charities, collapse = ';'), .groups = 'drop')

# join
london_marathon <- london_marathon |> 
  left_join(charity_lookup, by = "Year")

# save as csv
write_csv(london_marathon, file = "data-raw/london_marathon.csv")
usethis::use_data(london_marathon, overwrite = TRUE)
