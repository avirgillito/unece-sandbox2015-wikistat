
### GUIDE TO QUERY QIKIDATA ###

## From https://query.wikidata.org/ you can query for wikidata items. 
## Clicking on 'Examples' you'll see hou the query works. 

## These are the instructions to obtain items strating from their geocoordinates.

## There exists three ways to obtain items:

## 1. Using the administrative entity of a city; in this case you have to specify the 
##    code of the item (you'll find the code of the city searching it on the top right 
##    side on https://www.wikidata.org/wiki/Wikidata:Main_Page) and wikidata will return
##    all items that have the city you choose as 'location' (not the coordinates).
##    Using this method will return you fewer articles than using the following two methods. 

## 2. Using the radius around the location; in this case you have to specify the item of the 
##    location and a radius in km. Wikidata will return all items that fall into the circle with 
##    center the coordinates of the chosen location.

## 3. Using a box around the city. In this case you don't have to specify the item that you are
##    analyzing but you have to choose two items that are placed at two opposite corners with 
##    respect to your target location. Then you'll have to specify at which corner they are 
##    placed, in the format: SouthWest, SouthEast, NorthWest, NorthEast. 

## In each of the three cases, the output that you'll get is a list of items with name and coordinates. 
## It is possible to change the display of the output, swithcing from map to table. 
## It is also possible to download the output in different formats: 
##  - JSON
##  - fullJSON
##  - TSV
##  - simpleTSV
##  - CSV

## To put in RStudio a query that you created, after running it, simply click on 'link' and then
## right-click on REST Endopint and select 'Copy link location'. After that, just paste the function in
## RStudio, remove the first part 'https://query.wikidata.org/bigdata/namespace/wdq/sparql?query=' and input
## the remaining as 'query <-'. This will allow you to use the procedure that are explained later on in this guide. 

## First you'll find the queries that you can use directly on https://query.wikidata.org/
## and afterwards the R functions to query from RStudio. 

#### Queries to work on https://query.wikidata.org/

1. USE THE ADMINISTRATIVE ENTITY

# All points of interest in Barcelona with coordinates 
# defaultView:Map
# Select the ItemId, label and coordinate location that we want as output
SELECT DISTINCT ?item ?name ?coord 
WHERE {
  # Select the administrative entity (P131*) of Barcelona (Q1492) as your target city 
  ?item wdt:P131* wd:Q1492 .
  # Looking for items with coordinate locations(P625)
  ?item wdt:P625 ?coord .
  # Use the label service to get the label of the item in our 31 chosen languages
  SERVICE wikibase:label {
    bd:serviceParam wikibase:language "bg", "cs", "da", "de", "el", 
    "en", "es", "et", "fi", "fr", "ga", "hr", "hu", "is", "it", "lt", "lv", 
    "mk", "mt", "nl", "no", "pl", "pt", "ro", "ru", "sk", "sl", "sq", "sr", 
    "sv", "tr".
    ?item rdfs:label ?name
  }
}
# Get the ordered output
ORDER BY ASC (?name)


2. USE THE RADIUS AROUND THE CITY

# Select the ItemId, label and coordinate location that we want as output
SELECT ?item ?name ?coord 
WHERE {
  # Select the coordinate location(P625) of Barcelona(Q1492) as the central coordinate (?mainLoc)
  wd:Q1492 wdt:P625 ?mainLoc . 
  # Use the around service
  SERVICE wikibase:around { 
    # Looking for items with coordinate locations(P625)
    ?item wdt:P625 ?coord . 
    # That are in a circle with a centre of ?mainLoc(The coordinate location of Barcelona)
    bd:serviceParam wikibase:center ?mainLoc . 
    # Where the circle has a radius of 10km
    bd:serviceParam wikibase:radius "10" . 
  }
  # Use the label service to get the label of the item in our 31 chosen languages
  SERVICE wikibase:label {
    bd:serviceParam wikibase:language "bg", "cs", "da", "de", "el", 
    "en", "es", "et", "fi", "fr", "ga", "hr", "hu", "is", "it", "lt", "lv", 
    "mk", "mt", "nl", "no", "pl", "pt", "ro", "ru", "sk", "sl", "sq", "sr", 
    "sv", "tr".
    ?item rdfs:label ?name
  }
}
# Get the ordered output
ORDER BY ASC (?name)

3. USE A BOX AROUND THE CITY

#Any between Knokke-Heist and Zedelgem (for Bruges)
#defaultView:Map
# Select the ItemId, label and coordinate location that we want as output
SELECT ?item ?name ?coord 
WHERE {
  # Select the coordinate locations(P625) of Knokke-Heist(Q12988) and Zedelgem(Q184287) as the opposite corners of the box
  wd:Q12988 wdt:P625 ?Firstloc .
  wd:Q184287 wdt:P625 ?Secondloc .
  # Use the box service
  SERVICE wikibase:box {
    # Looking for items with coordinate locations(P625)
    ?item wdt:P625 ?coord .
    # That have Knokke-Heist(Q12988) as South-West corner and Zedelgem(Q184287) as North-East corner
    bd:serviceParam wikibase:cornerSouthWest ?Firstloc .
    bd:serviceParam wikibase:cornerNorthEast ?Secondloc .
  }
  # Use the label service to get the label of the item in our 31 chosen languages
  SERVICE wikibase:label {
    bd:serviceParam wikibase:language "bg", "cs", "da", "de", "el", 
    "en", "es", "et", "fi", "fr", "ga", "hr", "hu", "is", "it", "lt", "lv", 
    "mk", "mt", "nl", "no", "pl", "pt", "ro", "ru", "sk", "sl", "sq", "sr", 
    "sv", "tr".
    ?item rdfs:label ?name
  }
}
# Get the ordered output
ORDER BY ASC (?name)


#### Queries to work on RStudio

# 1. Use the administrative entity 

city_code <- 'Q1492'
query <- paste0('SELECT%20DISTINCT%20%3Fitem%20%3Fname%20%3Fcoord%20%0AWHERE%20%7B%0A%20%20%20%20%3Fitem%20wdt%3AP131*%20wd%3AQ1492%20.%0A%20%20%20%20%3Fitem%20wdt%3AP625%20%3Fcoord%20.%0A%20%20%20SERVICE%20wikibase%3Alabel%20%7B%0A%20%20%20%20%20bd%3AserviceParam%20wikibase%3Alanguage%20%22bg%22%2C%20%22cs%22%2C%20%22da%22%2C%20%22de%22%2C%20%22el%22%2C%20%0A%22en%22%2C%20%22es%22%2C%20%22et%22%2C%20%22fi%22%2C%20%22fr%22%2C%20%22ga%22%2C%20%22hr%22%2C%20%22hu%22%2C%20%22is%22%2C%20%22it%22%2C%20%22lt%22%2C%20%22lv%22%2C%20%0A%22mk%22%2C%20%22mt%22%2C%20%22nl%22%2C%20%22no%22%2C%20%22pl%22%2C%20%22pt%22%2C%20%22ro%22%2C%20%22ru%22%2C%20%22sk%22%2C%20%22sl%22%2C%20%22sq%22%2C%20%22sr%22%2C%20%0A%22sv%22%2C%20%22tr%22.%0A%20%20%20%20%20%3Fitem%20rdfs%3Alabel%20%3Fname%0A%20%20%20%20%7D%0A%7D%0AORDER%20BY%20ASC%20(%3Fname)')

# 2. Use a radius around the city

city_code <- 'Q1492'
radius <- '10'
query <- paste0('SELECT%20%3Fitem%20%3Fname%20%3Fcoord%20%0AWHERE%20%7B%0A%20wd%3A', city_code, '%20wdt%3AP625%20%3FmainLoc%20.%20%0A%20SERVICE%20wikibase%3Aaround%20%7B%20%0A%20%3Fitem%20wdt%3AP625%20%3Fcoord%20.%20%0A%20bd%3AserviceParam%20wikibase%3Acenter%20%3FmainLoc%20.%20%0A%20bd%3AserviceParam%20wikibase%3Aradius%20%22', radius, '%22%20.%20%0A%20%7D%0A%20SERVICE%20wikibase%3Alabel%20%7B%0A%20%20%20%20%20%20bd%3AserviceParam%20wikibase%3Alanguage%20%22bg%22%2C%20%22cs%22%2C%20%22da%22%2C%20%22de%22%2C%20%22el%22%2C%20%0A%22en%22%2C%20%22es%22%2C%20%22et%22%2C%20%22fi%22%2C%20%22fr%22%2C%20%22ga%22%2C%20%22hr%22%2C%20%22hu%22%2C%20%22is%22%2C%20%22it%22%2C%20%22lt%22%2C%20%22lv%22%2C%20%0A%22mk%22%2C%20%22mt%22%2C%20%22nl%22%2C%20%22no%22%2C%20%22pl%22%2C%20%22pt%22%2C%20%22ro%22%2C%20%22ru%22%2C%20%22sk%22%2C%20%22sl%22%2C%20%22sq%22%2C%20%22sr%22%2C%20%0A%22sv%22%2C%20%22tr%22.%0A%20%20%20%20%20%3Fitem%20rdfs%3Alabel%20%3Fname%0A%20%7D%0A%7D%0AORDER%20BY%20ASC%20(%3Fname)%0A')

# 3. Use a box around the city

# You have to specify two cities that represent two opposite corners around your target city; than you have to specify 
# at which corner they are, in the format: SouthWest, SouthEast, NorthWest, NorthEast
city_code <- 'Q1492'
first_city_code <- 'Q12988'
first_city_corner <- 'Q184287'
second_city_code <- 'SouthWest'
second_city_corner <- 'NorthEast'

query <- paste0('SELECT%20%3Fitem%20%3Fname%20%3Fcoord%20%0AWHERE%20%7B%0A%20%20wd%3A', first_city_code, '%20wdt%3AP625%20%3FFirstloc%20.%0A%20%20wd%3A', second_city_code, '%20wdt%3AP625%20%3FSecondloc%20.%0A%20%20SERVICE%20wikibase%3Abox%20%7B%0A%20%20%20%20%20%20%3Fitem%20wdt%3AP625%20%3Fcoord%20.%0A%20%20%20%20%20%20bd%3AserviceParam%20wikibase%3Acorner',first_city_corner,  '%20%3FFirstloc%20.%0A%20%20%20%20%20%20bd%3AserviceParam%20wikibase%3Acorner', second_city_corner, '%20%3FSecondloc%20.%0A%20%20%20%20%7D%0ASERVICE%20wikibase%3Alabel%20%7B%0A%20%20%20%20%20%20bd%3AserviceParam%20wikibase%3Alanguage%20%22bg%22%2C%20%22cs%22%2C%20%22da%22%2C%20%22de%22%2C%20%22el%22%2C%20%0A%22en%22%2C%20%22es%22%2C%20%22et%22%2C%20%22fi%22%2C%20%22fr%22%2C%20%22ga%22%2C%20%22hr%22%2C%20%22hu%22%2C%20%22is%22%2C%20%22it%22%2C%20%22lt%22%2C%20%22lv%22%2C%20%0A%22mk%22%2C%20%22mt%22%2C%20%22nl%22%2C%20%22no%22%2C%20%22pl%22%2C%20%22pt%22%2C%20%22ro%22%2C%20%22ru%22%2C%20%22sk%22%2C%20%22sl%22%2C%20%22sq%22%2C%20%22sr%22%2C%20%0A%22sv%22%2C%20%22tr%22.%0A%20%20%20%3Fitem%20rdfs%3Alabel%20%3Fname%0A%20%7D%0A%7D%0AORDER%20BY%20ASC%20(%3Fname)%0A%0A')

## After having chosen the kind of query, you just need to specify the api:
api_url <- "https://query.wikidata.org/bigdata/namespace/wdq/sparql?query="

# and download the file (I created a folder to collect all the queries that I made, named as the item which represents my target):
download.file(paste0(api_url, query, "&format=json"), paste0('/ichec/home/users/signose/wikistats/wikidata_lists/', city_code, '.txt'))

### Once you have downloaded the file, you can just:

# Read the downloaded file

json <- jsonlite::fromJSON(paste0('/ichec/home/users/signose/wikistats/wikidata_lists/', city_code, '.txt'), simplifyDataFrame = TRUE)

# Arrange the file in a dataframe with only three variables: item, latitute, longitude

json_item <-json$results$bindings$item
json_name <-json$results$bindings$name
json_coord <-json$results$bindings$coord

items <- json_item %>%
  mutate(item = gsub('http://www.wikidata.org/entity/', '', value)) %>%
  select (-type, -value) %>%
  mutate(point = json_coord$value, 
         lat = substr(point, 7, regexpr(" ", point)-1),
         long = substr(point, regexpr(" ", point), regexpr(")", point)-1)) %>%
  select(-point)

#### NOTE: In the folder '/scripts/r' you'll find a new script called 'wikidata_functions.R' with the new functions 
#### that I created to get and handle the items that you'll find in the output.
