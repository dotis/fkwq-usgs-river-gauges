getData <- function(station_id, param_name){
  source("R/getMetadata.R")
  metadata <- getMetadata()
  
  # Get row from metadata with USGS_ID matching station_id
  metadata_row <- metadata[metadata$USGS_ID == station_id, ]
  
  # Get param_code from column of metadata row
  param_code <- metadata_row[[param_name]]
  
  # check for cached file
  fname <- glue::glue("data/cache/{station_id}___{param_name}.RDS")
  if (file.exists(fname)){
    print('using cached data')
    df <- readRDS(fname)
  } else {
    print('requesting data from web')
    df <- doDataRequest(param_code, station_id)
    saveRDS(df, fname)
  }
  return(df)
}

doDataRequest <- function(param_code, station_id){
  request <- glue::glue(
    "https://waterdata.usgs.gov/nwis/dv?cb_{param_code}=on&format=rdb&site_no={station_id}&referred_module=sw&period=&begin_date=01-01-1950&end_date=12-31-2024"
  )
  
  print("fetching from ")
  print(request)
  
  # Perform the request and read the data
  library(httr)
  
  response <- GET(request)
  
  # Check if the request was successful
  if (status_code(response) == 200) {
    # Convert the response content to a text format
    response_content <- content(response, as = "text")
    
    # Read the data into a dataframe (assuming tab-separated data)
    data <- read.table(text = response_content, header = TRUE, sep = "\t", comment.char = "#")
    
    # Display the first few rows of the data
    # print(head(data))
  } else {
    # Print an error message if the request failed
    stop("Failed to fetch data. Status code: ", status_code(response))
  }
  
  # drop 1st row of data that has some kind of metadata. example of 1st row:
  # 1          5s      15s        20d                 14n                    10s
  data <- data[-1, ]
  
  # Ensure 'datetime' is properly converted
  data$datetime <- as.Date(data$datetime, format = "%Y-%m-%d")
  
  data <- data[!is.na(data$datetime), ]  # Remove rows with NA in datetime
  
  # NOTE: assumes data is always fourth row
  # Check and convert data row to numeric
  data[[4]] <- as.numeric(data[[4]])
  data <- data[!is.na(data[[4]]), ]  # Remove rows with NA
  
  # rename columns
  names(data)[4] <- "value"
  names(data)[5] <- "_cd"

  # drop cols 1 & 2
  data <- data[, -c(1, 2)]
  return(data)
}
