getDischData <- function(station_shortname){
  source(here::here("R/getData.R"))
  # Attempt to get the primary data
  df <- tryCatch({
    getData(station_shortname, "Disch_tdflt")
  }, error = function(e) {
    # On error, attempt to get the fallback data
    message("Error with 'Disch_tdflt', trying 'Disch': ", e$message)
    getData(station_shortname, "Disch")
  })
  return(df)
}