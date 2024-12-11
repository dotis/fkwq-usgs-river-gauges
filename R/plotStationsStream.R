plotStationsStream <- function(stations, param_name){
  
  # Install and load required packages
  if (!requireNamespace("ggstream", quietly = TRUE)) {
    install.packages("ggstream")
  }
  if (!requireNamespace("tidyr", quietly = TRUE)) {
    install.packages("tidyr")
  }
  library(ggstream)
  library(dplyr)
  library(tidyr)
  library(ggplot2)
  
  # Combine all data into one dataframe
  all_data <- data.frame()
  
  for (station_shortname in stations) {
    # Get the data for the current station using the parameter name
    df <- getData(station_shortname, param_name)
    
    # Standardize datetime column to Date format
    df$datetime <- as.Date(df$datetime)
    
    # Add a station identifier
    df$station <- station_shortname
    
    # Append to the main dataframe
    all_data <- rbind(all_data, df)
  }
  
  # # === drop any days that are missing a value at any station
  # df_wide <- pivot_wider(all_data, names_from = station, values_from = value)
  # df_clean <- na.omit(df_wide)
  # df_long <- df_clean %>%
  #   select(-`_cd`) %>% # Drop the `_cd` column
  #   pivot_longer(
  #     cols = c(`S-351`, `S-354`, `S-308`, LV8, HillsCan), # Columns to pivot
  #     names_to = "station", # New column for station names
  #     values_to = "value"   # New column for values
  #   )
  
  # === Summarize and ensure completeness
  all_data_summary <- all_data %>%
    group_by(datetime, station) %>%
    summarize(value = mean(value, na.rm = TRUE), .groups = "drop") %>%
    complete(datetime = seq.Date(min(datetime), max(datetime), by = "day"),
             station,
             fill = list(value = 0)) %>%
    arrange(datetime, station)
  # 
  # Verify the data
  # print(head(all_data_summary))  # Ensure all datetime and station combinations exist
  # 
  # all_data_summary$days_since_epoch <- as.numeric(all_data_summary$datetime - as.Date("1970-01-01"))
  
  # bug workaround see https://github.com/davidsjoberg/ggstream/issues/16
  n_grid <- length(all_data_summary$datetime)+0.2*length(all_data_summary$datetime)
  
  # Create the streamgraph
  p <- ggplot(all_data_summary, aes(x = datetime, y = value, fill = station)) +
    geom_stream(type = "ridge", n_grid = n_grid) +
    labs(
      title = "Streamgraph of Values Over Time",
      x = "Datetime",
      y = "Value",
      fill = "Station"
    ) +
    theme_minimal()
  
  # Print the plot
  return(p)
}