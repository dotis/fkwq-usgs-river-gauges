getMetadata <- function(){
  metadata <- read.csv(
    "data/SouthFL_USGS_ACE_SiteList.csv",
    colClasses = "character",
    quote = "\""
  )
  
  # Remove any remaining quotes from all elements in the dataframe
  metadata <- as.data.frame(apply(metadata, 2, function(x) gsub("\"", "", x)))
  return(metadata)
}