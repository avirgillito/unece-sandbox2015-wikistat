### GUIDE TO QUERY WIKIDATA FOR CATEGORIES

## This is a step further of the script 'guide_to_query_wikidata.R'.
## Following these instructions you'll be able to get the categories related to the items
## that you got from the previous script.

## NOTE: with these queries you'll get fewer items than the previous script. This because some items
## does not have categories. So just keep this file separated from the other one. You'll be able
## to left join the two when you need for your analysis.

## The queries are the same as before, we just added a part of code to get the labels.
## Also here you'll see the queries for the website and those to use in RStudio.

#### Queries to work on https://query.wikidata.org/

### 1. Using administrative entity

SELECT DISTINCT ?item ?property ?propertyLabel
WHERE {
  ?item wdt:P131* wd:Q1492 .
  #Looking for items with coordinate locations(P625)
  ?item wdt:P625 ?coord .
  ?item wdt:P31 ?property .
  SERVICE wikibase:label {
    bd:serviceParam wikibase:language "en".
    ?item rdfs:label ?name
  }
  SERVICE wikibase:label { bd:serviceParam wikibase:language "en" }
}
#Get the ordered output
ORDER BY ASC (?name)

### 2. Using a radius around the city

SELECT ?item ?property ?propertyLabel
WHERE {
  wd:Q1492 wdt:P625 ?mainLoc .
  SERVICE wikibase:around {
    ?item wdt:P625 ?coord .
    bd:serviceParam wikibase:center ?mainLoc .
    bd:serviceParam wikibase:radius "30" .
  }
  SERVICE wikibase:label {
    bd:serviceParam wikibase:language "bg", "cs", "da", "de", "el",
    "en", "es", "et", "fi", "fr", "ga", "hr", "hu", "is", "it", "lt", "lv",
    "mk", "mt", "nl", "no", "pl", "pt", "ro", "ru", "sk", "sl", "sq", "sr",
    "sv", "tr".
    ?item rdfs:label ?name
  }
  ?item wdt:P31 ?property .
  SERVICE wikibase:label { bd:serviceParam wikibase:language "en" }
}
ORDER BY ASC (?name)

### 3. Using a box around the city

SELECT ?item ?property ?propertyLabel
WHERE {
  wd:Q12988 wdt:P625 ?Firstloc .
  wd:Q184287 wdt:P625 ?Secondloc .
  SERVICE wikibase:box {
    ?item wdt:P625 ?coord .
    bd:serviceParam wikibase:cornerNorthEast ?Firstloc .
    bd:serviceParam wikibase:cornerSouthWest ?Secondloc .
  }
  SERVICE wikibase:label {
    bd:serviceParam wikibase:language "en".
    ?item rdfs:label ?name
  }
  ?item wdt:P31 ?property .
  ?property wdt:P279 ?class
  SERVICE wikibase:label { bd:serviceParam wikibase:language "en" }
}
ORDER BY ASC (?name)

#### Queries to work on RStudio
source("scripts/r/wikidata_functions.R")

# 1. Use the administrative entity

city_code <- 'Q1492'
query_location_category_1(city_code)

# 2. Use a radius around the city

city_code <- 'Q1492'
radius <- '30'

query_location_category_2(city_code, radius)

# 3. Use a box around the city

# You have to specify two cities that represent two opposite corners around your target city; than you have to specify
# at which corner they are, in the format: SouthWest, SouthEast, NorthWest, NorthEast

city_code <- 'Q12994'
first_city_code <- 'Q12988'
second_city_code <- 'Q184287'
first_city_corner <- 'NorthEast'
second_city_corner <- 'SouthWest'

query_location_category_3(city_code, first_corner_city_code, first_city_corner, second_corner_city_code, second_city_corner)

### Once you have downloaded the file, you can just:

# Read the downloaded file

read_category_list(city_code)
