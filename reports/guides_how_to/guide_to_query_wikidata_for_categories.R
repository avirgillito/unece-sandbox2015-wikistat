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

SELECT DISTINCT ?item ?name ?coord ?propertyLabel 
WHERE {
  ?item wdt:P131* wd:Q1492 .
  #Looking for items with coordinate locations(P625)
  ?item wdt:P625 ?coord . 
  ?item wdt:P31 ?property .
  SERVICE wikibase:label {
    bd:serviceParam wikibase:language "bg", "cs", "da", "de", "el", 
    "en", "es", "et", "fi", "fr", "ga", "hr", "hu", "is", "it", "lt", "lv", 
    "mk", "mt", "nl", "no", "pl", "pt", "ro", "ru", "sk", "sl", "sq", "sr", 
    "sv", "tr".
    ?item rdfs:label ?name
  }
  SERVICE wikibase:label { bd:serviceParam wikibase:language "en" }
}
#Get the ordered output
ORDER BY ASC (?name)

### 2. Using a radius around the city

SELECT ?item ?name ?coord ?propertyLabel 
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

SELECT ?item ?name ?coord ?propertyLabel
WHERE {
  wd:Q12988 wdt:P625 ?Firstloc .
  wd:Q184287 wdt:P625 ?Secondloc .
  SERVICE wikibase:box {
    ?item wdt:P625 ?coord .
    bd:serviceParam wikibase:cornerNorthEast ?Firstloc .
    bd:serviceParam wikibase:cornerSouthWest ?Secondloc .
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

#### Queries to work on RStudio

# 1. Use the administrative entity 

city_code <- 'Q1492'

query <- paste0('SELECT%20DISTINCT%20%3Fitem%20%3Fname%20%3Fcoord%20%3FpropertyLabel%20%0AWHERE%20%7B%0A%20%20%3Fitem%20wdt%3AP131*%20wd%3A', city_code, '%20.%0A%20%20%3Fitem%20wdt%3AP625%20%3Fcoord%20.%20%0A%20%20%3Fitem%20wdt%3AP31%20%3Fproperty%20.%0A%20%20SERVICE%20wikibase%3Alabel%20%7B%0A%20%20%20%20bd%3AserviceParam%20wikibase%3Alanguage%20%22bg%22%2C%20%22cs%22%2C%20%22da%22%2C%20%22de%22%2C%20%22el%22%2C%20%0A%20%20%20%20%22en%22%2C%20%22es%22%2C%20%22et%22%2C%20%22fi%22%2C%20%22fr%22%2C%20%22ga%22%2C%20%22hr%22%2C%20%22hu%22%2C%20%22is%22%2C%20%22it%22%2C%20%22lt%22%2C%20%22lv%22%2C%20%0A%20%20%20%20%22mk%22%2C%20%22mt%22%2C%20%22nl%22%2C%20%22no%22%2C%20%22pl%22%2C%20%22pt%22%2C%20%22ro%22%2C%20%22ru%22%2C%20%22sk%22%2C%20%22sl%22%2C%20%22sq%22%2C%20%22sr%22%2C%20%0A%20%20%20%20%22sv%22%2C%20%22tr%22.%0A%20%20%20%20%3Fitem%20rdfs%3Alabel%20%3Fname%0A%20%20%7D%0A%20%20SERVICE%20wikibase%3Alabel%20%7B%20bd%3AserviceParam%20wikibase%3Alanguage%20%22en%22%20%7D%0A%7D%0AORDER%20BY%20ASC%20(%3Fname)')

# 2. Use a radius around the city

city_code <- 'Q1492'
radius <- '30'

query <- paste0('SELECT%20%3Fitem%20%3Fname%20%3Fcoord%20%3FpropertyLabel%20%0AWHERE%20%7B%0A%20%20wd%3A', city_code, '%20wdt%3AP625%20%3FmainLoc%20.%0A%20%20SERVICE%20wikibase%3Aaround%20%7B%20%0A%20%20%20%20%3Fitem%20wdt%3AP625%20%3Fcoord%20.%20%0A%20%20%20%20bd%3AserviceParam%20wikibase%3Acenter%20%3FmainLoc%20.%20%0A%20%20%20%20bd%3AserviceParam%20wikibase%3Aradius%20%22', radius, '%22%20.%20%0A%20%20%7D%0A%20%20SERVICE%20wikibase%3Alabel%20%7B%0A%20%20%20%20bd%3AserviceParam%20wikibase%3Alanguage%20%22bg%22%2C%20%22cs%22%2C%20%22da%22%2C%20%22de%22%2C%20%22el%22%2C%20%0A%20%20%20%20%22en%22%2C%20%22es%22%2C%20%22et%22%2C%20%22fi%22%2C%20%22fr%22%2C%20%22ga%22%2C%20%22hr%22%2C%20%22hu%22%2C%20%22is%22%2C%20%22it%22%2C%20%22lt%22%2C%20%22lv%22%2C%20%0A%20%20%20%20%22mk%22%2C%20%22mt%22%2C%20%22nl%22%2C%20%22no%22%2C%20%22pl%22%2C%20%22pt%22%2C%20%22ro%22%2C%20%22ru%22%2C%20%22sk%22%2C%20%22sl%22%2C%20%22sq%22%2C%20%22sr%22%2C%20%0A%20%20%20%20%22sv%22%2C%20%22tr%22.%0A%20%20%20%20%3Fitem%20rdfs%3Alabel%20%3Fname%0A%20%20%7D%0A%20%20%3Fitem%20wdt%3AP31%20%3Fproperty%20.%0A%20%20SERVICE%20wikibase%3Alabel%20%7B%20bd%3AserviceParam%20wikibase%3Alanguage%20%22en%22%20%7D%0A%7D%0AORDER%20BY%20ASC%20(%3Fname)'
                
# 3. Use a box around the city

# You have to specify two cities that represent two opposite corners around your target city; than you have to specify 
# at which corner they are, in the format: SouthWest, SouthEast, NorthWest, NorthEast
city_code <- 'Q12994'
first_city_code <- 'Q12988'
second_city_code <- 'Q184287'
first_city_corner <- 'NorthEast'
second_city_corner <- 'SouthWest'

query <- paste0('SELECT%20%3Fitem%20%3Fname%20%3Fcoord%20%3FpropertyLabel%0AWHERE%20%7B%0A%20%20wd%3A', first_city_code, '%20wdt%3AP625%20%3FFirstloc%20.%0A%20%20wd%3A', second_city_code, '%20wdt%3AP625%20%3FSecondloc%20.%0A%20%20SERVICE%20wikibase%3Abox%20%7B%0A%20%20%20%20%3Fitem%20wdt%3AP625%20%3Fcoord%20.%0A%20%20%20%20bd%3AserviceParam%20wikibase%3Acorner',first_city_corner,  '%20%3FFirstloc%20.%0A%20%20%20%20bd%3AserviceParam%20wikibase%3Acorner', second_city_corner, '%20%3FSecondloc%20.%0A%20%20%7D%0A%20%20SERVICE%20wikibase%3Alabel%20%7B%0A%20%20%20%20bd%3AserviceParam%20wikibase%3Alanguage%20%22bg%22%2C%20%22cs%22%2C%20%22da%22%2C%20%22de%22%2C%20%22el%22%2C%20%0A%20%20%20%20%22en%22%2C%20%22es%22%2C%20%22et%22%2C%20%22fi%22%2C%20%22fr%22%2C%20%22ga%22%2C%20%22hr%22%2C%20%22hu%22%2C%20%22is%22%2C%20%22it%22%2C%20%22lt%22%2C%20%22lv%22%2C%20%0A%20%20%20%20%22mk%22%2C%20%22mt%22%2C%20%22nl%22%2C%20%22no%22%2C%20%22pl%22%2C%20%22pt%22%2C%20%22ro%22%2C%20%22ru%22%2C%20%22sk%22%2C%20%22sl%22%2C%20%22sq%22%2C%20%22sr%22%2C%20%0A%20%20%20%20%22sv%22%2C%20%22tr%22.%0A%20%20%20%20%3Fitem%20rdfs%3Alabel%20%3Fname%0A%20%20%7D%0A%20%20%3Fitem%20wdt%3AP31%20%3Fproperty%20.%0A%20%20SERVICE%20wikibase%3Alabel%20%7B%20bd%3AserviceParam%20wikibase%3Alanguage%20%22en%22%20%7D%0A%7D%0AORDER%20BY%20ASC%20(%3Fname)')

## After having chosen the kind of query, you just need to specify the api:
api_url <- "https://query.wikidata.org/bigdata/namespace/wdq/sparql?query="

# and download the file (I created a folder to collect all the queries that I made, named as the item which represents my target):
download.file(paste0(api_url, query, "&format=json"), paste0('/ichec/home/users/signose/wikistats/wikidata_lists/', city_code, '.txt'))

### Once you have downloaded the file, you can just:

# Read the downloaded file

json <- jsonlite::fromJSON(paste0('/ichec/home/users/signose/wikistats/wikidata_lists/category', city_code, '.txt'), simplifyDataFrame = TRUE)

# Arrange the file in a dataframe with only three variables: item, latitute, longitude

json_item <-json$results$bindings$item
json_property <- json$results$bindings$propertyLabel

category <- json_item %>%
  mutate(item = gsub('http://www.wikidata.org/entity/', '', value)) %>%
  select (-type, -value) %>%
  mutate(property = gsub('http://www.wikidata.org/entity/', '', json_property$value)) %>%
  distinct()
