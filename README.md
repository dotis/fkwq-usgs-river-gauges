## Usage:
This is a quarto website published to github pages using `quarto render`.
For local development the terminal command `quarto preview` can be used.

## Packages needed:
1. rmarkdown
2. leaflet
3. here
4. httr
5. zoo
6. ggplot2
7. ggstream

## NOTES:
999 indicates param is not measured at that location.

## IDEAS:
* **station inspector** : all params at one station
  * lots of time series plots
  * gauges
  * infographic
  * one tab per parameter
* **station comparison** : compare params at multiple stations
  * time series w/ multiple station for one param
  * selected stations shown on map
* **map** : one param value for all stations on a map
  * values encoded in color (and/or size) of points
  * interpolation
  
* **RQ: rainfall impact** : specific focus on rainfall events
  * precip, sal, temp, disch, level, gaugeHeight
* **RQ: dicharge events** : highlight discharge events not related to precip
  * how long does it take to go downstream to FL Bay
    * sat data when it gets there
  * should see more water going to everglades instead of st lucie et al.
  * start: disch for stations in a downstream flow

#### Notes/ideas:
1. Perhaps add a tab called "historical flow" showing data from 2000-present. Apply monthly moving avg.
2. Then, have a "recent flow" that will show data from the past year with no moving avg.
3. Sum certain groups of stations that represent similar flow regimes (@dotis needs to make groups)
4. use `Disch_tdflt` if available fallback to `Disch` if not available

#### Lake Okeechobee flows:
1. Out to West: S77, S79 (good - S78 is very low, don't include)
2. Out to East: S308, S80 (good); could add StLcRvSt - has bad vals
3. Out to South: S190 only (good) 
4. Out to Southeast: S354, S351, HillsCan (good)
5. Out to Southwest: Not needed - no direct flow to SW from Lake O.


## For each row in data/[...]csv do API call:

params and station ID values in quotes

The API requires a call like this:

https://waterdata.usgs.gov/nwis/dv?cb_{param_code}=on&format=rdb&site_no={sta_ID}&referred_module=sw&period=&begin_date=01-01-1950&end_date=12-31-2024 ,''ContentType'',''raw''

Examples from the first row of the csv file:

param_code =  00060 (this is for discharge; each parameter has a different code)

sta_ID = 02292900 (must have the 0 in front)

