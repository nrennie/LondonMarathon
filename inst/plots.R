library(tidyverse)

# read in data
london_marathon <- read_csv("data-raw/london_marathon.csv")
winners <- read_csv("data-raw/winners.csv")

# london marathon plot
london_plot <- london_marathon %>%
  filter(Year < 2020) %>%
  mutate(Year = factor(Year))

ggplot(
  data = london_plot,
  mapping = aes(y = Year)
) +
  geom_point(aes(x = Starters),
    colour = "#008080"
  ) +
  geom_point(aes(x = Finishers),
    colour = "#800080"
  ) +
  geom_segment(aes(
    x = Starters,
    xend = Finishers,
    y = Year,
    yend = Year
  )) +
  labs(
    x = "Number of runners",
    title = "Number of London Marathon Starters and Finishers"
  ) +
  theme_minimal() +
  theme(
    axis.title.y = element_blank(),
    plot.background = element_rect(fill = "white", colour = "white"),
    panel.background = element_rect(fill = "white", colour = "white")
  )

ggsave(filename = "inst/london_marathon.png", height = 7, width = 5)

# winners plot
winners_plot <- winners %>%
  group_by(Nationality) %>%
  summarise(n = n())

ggplot(
  data = winners_plot,
  mapping = aes(
    y = reorder(Nationality, n),
    x = n
  )
) +
  geom_col(fill = "#e00601") +
  geom_text(aes(label = n),
    colour = "#e00601",
    hjust = -1
  ) +
  labs(
    x = "Number of winners",
    title = "Nationality of London Marathon Winners"
  ) +
  scale_x_continuous(limits = c(0, 50)) +
  coord_cartesian(expand = FALSE) +
  theme_minimal() +
  theme(
    axis.title.y = element_blank(),
    plot.background = element_rect(fill = "white", colour = "white"),
    panel.background = element_rect(fill = "white", colour = "white")
  )

ggsave(filename = "inst/winners.png", height = 7, width = 5)
