# create a csv of simulated laps based on the parameters below

library(dplyr)
library(tidyr)

driver_count <- 20
lap_count <- 12

# in seconds
estimated_time <- 95
all_drivers_sd <- 3
single_driver_sd <- 1

name_list <- paste0('Driver_', seq(1, driver_count, 1))

set.seed(8)

# first random lap time will be used as the simulated average for each driver
driver_baseline_times <- rnorm(n = driver_count, 
                               mean = estimated_time, 
                               sd = all_drivers_sd)

baseline_df <- data.frame(driver = name_list,
                          base_time = driver_baseline_times)

# additional lap times will be normally distributed based off each driver's baseline
lap_var <- rnorm(n = driver_count * (lap_count - 1),
                 mean = 0,
                 sd = single_driver_sd)

var_df <- data.frame(driver = paste0('Driver_', rep(1:driver_count, times = (lap_count - 1))),
                     lap_number = rep(2:lap_count, each = driver_count),
                     lap_variance = lap_var) %>%
  inner_join(baseline_df, by = c('driver' = 'driver')) %>%
  mutate(time = base_time + lap_variance)

lapx_df <- var_df %>%
  select(driver, lap_number, time)

df <- baseline_df %>%
  mutate(lap_number = 1) %>%
  select(driver, lap_number, time = base_time) %>%
  bind_rows(lapx_df)


filename <- 'simulated_race.csv'
write.csv(df, filename, row.names = F)
paste0(getwd(), '/', filename)


