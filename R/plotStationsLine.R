plotStationsLine <- function(stations, param_name){
  # NOTE: special param name "disch-combo"
  source(here::here("R/getData.R"))
  source(here::here("R/getDischData.R"))
  # Create an empty data frame to hold all data
  all_data <- data.frame()
  
  # Loop through stations and get data for each
  for (station_shortname in stations) {
    # Get the data for the current station using the parameter name
    # print(glue::glue("station:{station_shortname}"))
    
    # if param_name "disch-combo" use getDischData to use both tidal filtered disch & disch
    if(param_name == "disch-combo"){
        df <- getDischData(station_shortname)
    } else {
        df <- getData(station_shortname, param_name)  
    }
    
    # Calculate a moving average
    library(zoo)
    df$moving_avg <- rollmean(df$value, k = 90, fill = NA, align = "right")
    
    # Add a column to identify the station
    df$station <- station_shortname
    
    # Append the current station's data to the combined data frame
    all_data <- rbind(all_data, df)
  }
  
  # Create a unified time series plot
  library(ggplot2)
  p <- ggplot(all_data, aes(x = datetime, y = value, color = station)) +
    # geom_point(shape = 4, alpha = 0.1) +  # Transparent points
    geom_line(aes(y = moving_avg)) +      # Moving average lines
    labs(
      title = "Combined Time Series Plot",
      x = "Datetime",
      y = "Value",
      color = "Station"
    ) +
    theme_minimal()
  
  # Print the plot
  return(p)
}