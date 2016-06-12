### GUIDE TO QUERY WIKIDATA 

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
    bd:serviceParam wikibase:cornerNorthEast ?Firstloc .
    bd:serviceParam wikibase:cornerSouthWest ?Secondloc .
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
source("scripts/r/wikidata_functions.R")

# 1. Use the administrative entity 

city_code <- 'Q1492'

query_location_1(city_code)

# 2. Use a radius around the city

city_code <- 'Q1492'
radius <- '10'

query_location_2(city_code, radius)

# 3. Use a box around the city

# You have to specify two cities that represent two opposite corners around your target city; than you have to specify 
# at which corner they are, in the format: SouthWest, SouthEast, NorthWest, NorthEast
city_code <- 'Q12994'
first_city_code <- 'Q12988'
second_city_code <- 'Q184287'
first_city_corner <- 'NorthEast'
second_city_corner <- 'SouthWest'

query_location_3(city_code, first_corner_city_code, first_city_corner, second_corner_city_code, second_city_corner)

### Once you have downloaded the file, you can just:

read_items_list(city_code)