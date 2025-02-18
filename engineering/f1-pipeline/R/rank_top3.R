library(dplyr)

# csv_file <- "C:/Downloads/peacock/simulated_race.csv"
csv_file <- "https://raw.githubusercontent.com/dataconsumer101/code-assignment/refs/heads/main/engineering/f1-pipeline/R/simulated_race.csv"

df_raw <- read.csv(csv_file)

# summary of all laps by driver, ranked by average lap time
rank_df <- df_raw %>%
  group_by(driver) %>%
  summarize(avg_lap_time = mean(time),
            fastest_lap_time = min(time)) %>%
  mutate(rank = rank(avg_lap_time)) %>%
  arrange(avg_lap_time)

# top 3 only, driver and times
top3 <- rank_df %>%
  filter(rank <= 3) %>%
  arrange(rank, avg_lap_time) %>%
  select(-rank)

# csv output
filename <- 'top3_drivers.csv'
write.csv(top3, filename, row.names = F)
paste0(getwd(), '/', filename)

