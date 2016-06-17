### Functions to query for location items:

## query_location_1: queries for location items using the administrative entity

## query_location_2: queries for location items using a radius around the city

## query_location_3: queries for location items using a box around the city

## read_items_list: reads the query file

### Functions to get Wikipedia articles related to Wikidata items

## get_wikidata:   returns a list with all the data that are available in the wikidata_url
##                (function similar to the one that gets the wikimarkup)

## get_wikipedia_articles:  gets the wikidata items (through the previous function) and 
##                          create a dataframe with articles, language and items.  

##NOTE: both functions work from the dataframe 'items' that contains item, lat and long.

### Functions to get Wikidata items' properties from the Wikidata items 

## query_location_property_1: it gets the properties of items selected considering query type no.1

## query_location_property_2: it gets the properties of items selected considering query type no.2

## query_location_property_3: it gets the properties of items selected considering query type no.3

## read_property_list: it reads the list of items' properties just downloaded

### Functions to get Wikidata items' classes from the Wikidata items 

## read_property_identifier: it gets the list of properties with their own identifier

## query_property_class: it performs the query to get the class from the property

## read_property_class: it creates a df with list of properties and the class they belong to

## link_property_class: it links the df of Wikidata items with the correspondent properties and classes

library(dplyr)
library(jsonlite)
library(stringr)
library(splitstackshape)
library(tidyr)

api_url <- "https://query.wikidata.org/bigdata/namespace/wdq/sparql?query="
wikidata_url <- 'https://www.wikidata.org/wiki/Special:EntityData/'
dir.create('./wikidata_lists', showWarnings = FALSE)
dir.create('./wikidata_properties', showWarnings = FALSE)
dir.create('./wikidata_items', showWarnings = FALSE)
dir.create('./wikidata_classes', showWarnings = FALSE)

# This functions query for Wikidata items using the administrative entity. You have to look first for the wikidata location identifier on wikidata.org ('Q_____')
# It returns the list of Wikidata items that are geolocated into that administrative entity

query_location_1 <- function(city_code){
  query <- paste0('SELECT%20DISTINCT%20%3Fitem%20%3Fname%20%3Fcoord%20%0AWHERE%20%7B%0A%20%20%20%20%3Fitem%20wdt%3AP131*%20wd%3A', city_code, '%20.%0A%20%20%20%20%3Fitem%20wdt%3AP625%20%3Fcoord%20.%0A%20%20%20SERVICE%20wikibase%3Alabel%20%7B%0A%20%20%20%20%20bd%3AserviceParam%20wikibase%3Alanguage%20%22bg%22%2C%20%22cs%22%2C%20%22da%22%2C%20%22de%22%2C%20%22el%22%2C%20%0A%22en%22%2C%20%22es%22%2C%20%22et%22%2C%20%22fi%22%2C%20%22fr%22%2C%20%22ga%22%2C%20%22hr%22%2C%20%22hu%22%2C%20%22is%22%2C%20%22it%22%2C%20%22lt%22%2C%20%22lv%22%2C%20%0A%22mk%22%2C%20%22mt%22%2C%20%22nl%22%2C%20%22no%22%2C%20%22pl%22%2C%20%22pt%22%2C%20%22ro%22%2C%20%22ru%22%2C%20%22sk%22%2C%20%22sl%22%2C%20%22sq%22%2C%20%22sr%22%2C%20%0A%22sv%22%2C%20%22tr%22.%0A%20%20%20%20%20%3Fitem%20rdfs%3Alabel%20%3Fname%0A%20%20%20%20%7D%0A%7D%0AORDER%20BY%20ASC%20(%3Fname)')
  download.file(paste0(api_url, query, "&format=json"), paste0('./wikidata_lists/', city_code, '.txt'))
}

# This functions query for Wikidata items using a radius around the city. You have to look first for the wikidata location identifier on wikidata.org ('Q_____') and to set a radius in km.
# It returns the list of Wikidata items that are geolocated into that radius around the location with Wikidata identifier

query_location_2 <- function(city_code, radius){
  query <- paste0('SELECT%20%3Fitem%20%3Fname%20%3Fcoord%20%0AWHERE%20%7B%0A%20wd%3A', city_code, '%20wdt%3AP625%20%3FmainLoc%20.%20%0A%20SERVICE%20wikibase%3Aaround%20%7B%20%0A%20%3Fitem%20wdt%3AP625%20%3Fcoord%20.%20%0A%20bd%3AserviceParam%20wikibase%3Acenter%20%3FmainLoc%20.%20%0A%20bd%3AserviceParam%20wikibase%3Aradius%20%22', radius, '%22%20.%20%0A%20%7D%0A%20SERVICE%20wikibase%3Alabel%20%7B%0A%20%20%20%20%20%20bd%3AserviceParam%20wikibase%3Alanguage%20%22bg%22%2C%20%22cs%22%2C%20%22da%22%2C%20%22de%22%2C%20%22el%22%2C%20%0A%22en%22%2C%20%22es%22%2C%20%22et%22%2C%20%22fi%22%2C%20%22fr%22%2C%20%22ga%22%2C%20%22hr%22%2C%20%22hu%22%2C%20%22is%22%2C%20%22it%22%2C%20%22lt%22%2C%20%22lv%22%2C%20%0A%22mk%22%2C%20%22mt%22%2C%20%22nl%22%2C%20%22no%22%2C%20%22pl%22%2C%20%22pt%22%2C%20%22ro%22%2C%20%22ru%22%2C%20%22sk%22%2C%20%22sl%22%2C%20%22sq%22%2C%20%22sr%22%2C%20%0A%22sv%22%2C%20%22tr%22.%0A%20%20%20%20%20%3Fitem%20rdfs%3Alabel%20%3Fname%0A%20%7D%0A%7D%0AORDER%20BY%20ASC%20(%3Fname)%0A')
  download.file(paste0(api_url, query, "&format=json"), paste0('./wikidata_lists/', city_code, '.txt'))
}

# This functions query for Wikidata items using a box around the location. You have to look first for the wikidata location identifier on wikidata.org ('Q_____') and to set two other locations that will become the corners of the box. Look for the identifier of these two locations and set at which corner they are in the format 'NorthEast', 'NorthWest', 'SouthEast', 'SouthWest'.
# It returns the list of Wikidata items that are geolocated into that box around the location with Wikidata identifier

query_location_3 <- function(city_code, first_corner_city_code, first_city_corner, second_corner_city_code, second_city_corner){
  query <- paste0('SELECT%20%3Fitem%20%3Fname%20%3Fcoord%20%0AWHERE%20%7B%0A%20%20wd%3A', first_corner_city_code, '%20wdt%3AP625%20%3FFirstloc%20.%0A%20%20wd%3A', second_corner_city_code, '%20wdt%3AP625%20%3FSecondloc%20.%0A%20%20SERVICE%20wikibase%3Abox%20%7B%0A%20%20%20%20%20%20%3Fitem%20wdt%3AP625%20%3Fcoord%20.%0A%20%20%20%20%20%20bd%3AserviceParam%20wikibase%3Acorner',first_city_corner,  '%20%3FFirstloc%20.%0A%20%20%20%20%20%20bd%3AserviceParam%20wikibase%3Acorner', second_city_corner, '%20%3FSecondloc%20.%0A%20%20%20%20%7D%0ASERVICE%20wikibase%3Alabel%20%7B%0A%20%20%20%20%20%20bd%3AserviceParam%20wikibase%3Alanguage%20%22bg%22%2C%20%22cs%22%2C%20%22da%22%2C%20%22de%22%2C%20%22el%22%2C%20%0A%22en%22%2C%20%22es%22%2C%20%22et%22%2C%20%22fi%22%2C%20%22fr%22%2C%20%22ga%22%2C%20%22hr%22%2C%20%22hu%22%2C%20%22is%22%2C%20%22it%22%2C%20%22lt%22%2C%20%22lv%22%2C%20%0A%22mk%22%2C%20%22mt%22%2C%20%22nl%22%2C%20%22no%22%2C%20%22pl%22%2C%20%22pt%22%2C%20%22ro%22%2C%20%22ru%22%2C%20%22sk%22%2C%20%22sl%22%2C%20%22sq%22%2C%20%22sr%22%2C%20%0A%22sv%22%2C%20%22tr%22.%0A%20%20%20%3Fitem%20rdfs%3Alabel%20%3Fname%0A%20%7D%0A%7D%0AORDER%20BY%20ASC%20(%3Fname)%0A%0A')
  download.file(paste0(api_url, query, "&format=json"), paste0('./wikidata_lists/', city_code, '.txt'))
}

# This functions reads the list of items downloaded
# It returns a dataframe with the identifier of the item, its name (if it exists, otherwise it will be equal to the identifier), latitude and longitude of the item

read_items_list <- function(city_code){
  json <- jsonlite::fromJSON(paste0('./wikidata_lists/', city_code, '.txt'), simplifyDataFrame = TRUE)
  json_item <-json$results$bindings$item
  json_name <-json$results$bindings$name
  json_coord <-json$results$bindings$coord
  items_list <- json_item %>%
    mutate(item = gsub('http://www.wikidata.org/entity/', '', value)) %>%
    select (-type, -value) %>%
    mutate(name = json_name$value,
           point = json_coord$value,
           lat = substr(point, 7, regexpr(" ", point)-1),
           long = substr(point, regexpr(" ", point), regexpr(")", point)-1)) %>%
    select(-point) %>%
    distinct()
  return(items_list)
}

# This function gets the Wikidata items files, saves them in a cache and extract from them the Wikidata content
# It returns a list of Wikidata content from the items'files

get_wikidata <- function(items) {
  items_list <- items$item
  dir.create('./wikidata_items', showWarnings = FALSE)
  for (i in 1:length(items_list)) {
    file_name <- paste0('./wikidata_items/item_', items_list[i], '.txt')
    # Find out which files need to be downloaded
    to_download <- !file_exists(file_name) | refresh
    print(paste0("Files to download:", sum(to_download)))
    # Download files not in the cache
    if (any(to_download)) {
      url <- paste0(wikidata_url, items_list[i], '.json')
      download.file(url[to_download], file_name[to_download])
    }
  }
  # Read json files and extract wikidata
  res <- vector("list", length = length(items_list))
  counter <- 0
  file_list <- paste0("./wikidata_items/item_", items_list, ".txt")
  for (one_file in file_list) {
    text <- readLines(one_file)
    if (jsonlite::validate(text)) {
      json <- jsonlite::fromJSON(text)
      wikidata <- json$entities[[1]]
      trans <- wikidata$`*`
      names(trans) <- wikidata$lang
      if (is.null(wikidata)) {
        wikidata <- "ERROR: wikidata is null"
        warning(paste("null wikidata in "), substr(one_file, 57, regexpr(".", one_file)-1))
      }
    }
    counter <- counter + 1
    res[[counter]] <- wikidata
  }
  # Return wiki markup of articles
  return(res)
}

# This function gets the list of Wikipedia articles with languages from the Wikidata items
# It returns a dataframe with three variables: item identifier, Wikipedia article title and Wikipedia article language

get_wikipedia_articles <- function(items) {
  # get wikidata
  wikidata <- get_wikidata(items)
  # transform wikidata list
  wikidata <- do.call(cbind, wikidata)
  # transpose wikidata list
  wikidata <- t(wikidata)
  # create dataframe and filter considering only wikipedia items
  wikidata <- as.data.frame(wikidata)%>%
    select(-pageid, -ns, -title, -lastrevid, -modified, -type, -labels, -descriptions, -aliases, -claims) %>%
    filter(grepl("wikipedia", sitelinks))
  # split column sitelinks
  wikidata <- splitstackshape::concat.split.multiple(wikidata, "sitelinks", seps=",", "long")
  # consider only rows with title and url
  wikidata <- wikidata %>%
    filter(grepl("title =", sitelinks) | grepl("url =", sitelinks)) %>%
    tidyr::separate(sitelinks, sep = "=", c('delete', 'keep'))
  # prepare datasets with articles and urls
  title <- wikidata %>%
    filter(delete == "title ") %>%
    mutate(article = stringr::str_trim(keep, side = c("left"))) %>%
    select(-delete, -keep)
  url <- wikidata %>%
    filter(delete == "url ") %>%
    mutate(lang = substr(keep, 9, regexpr("wiki", keep)-2)) %>%
    select(-delete, -keep)
  # unify datasets
  wikidata <- cbind(title,url) %>%
    mutate(id = as.character(id)) %>%
    select(-id) %>%
    mutate(item = id) %>%
    select(-id)
  wikidata <- as.data.frame(wikidata)
  #return output
  return(wikidata)
}

# This functions query for Wikidata items' property ('Instance of' statement, P31) using the administrative entity. You have to look first for the wikidata location identifier on wikidata.org ('Q_____')
# It returns the list of Wikidata items' properties that are geolocated into that administrative entity with Wikidata identifier

query_location_property_1 <- function(city_code){
  query <- paste0('SELECT%20DISTINCT%20%3Fitem%20%3Fproperty%20%3FpropertyLabel%20%0AWHERE%20%7B%0A%20%20%3Fitem%20wdt%3AP131*%20wd%3A', city_code, '%20.%0A%20%20%23Looking%20for%20items%20with%20coordinate%20locations(P625)%0A%20%20%3Fitem%20wdt%3AP625%20%3Fcoord%20.%20%0A%20%20%3Fitem%20wdt%3AP31%20%3Fproperty%20.%0A%20%20SERVICE%20wikibase%3Alabel%20%7B%0A%20%20%20%20bd%3AserviceParam%20wikibase%3Alanguage%20%22en%22.%0A%20%20%20%20%3Fitem%20rdfs%3Alabel%20%3Fname%0A%20%20%7D%0A%20%20SERVICE%20wikibase%3Alabel%20%7B%20bd%3AserviceParam%20wikibase%3Alanguage%20%22en%22%20%7D%0A%7D%0A%23Get%20the%20ordered%20output%0AORDER%20BY%20ASC%20(%3Fname)')
  download.file(paste0(api_url, query, "&format=json"), paste0('./wikidata_properties/', city_code, '.txt'))
}

# This functions query for Wikidata items's property using a radius around the city. You have to look first for the wikidata location identifier on wikidata.org ('Q_____') and to set a radius in km.
# It returns the list of Wikidata items' properties that are geolocated into that radius around the location with Wikidata identifier

query_location_property_2 <- function(city_code, radius){
  query <- paste0('SELECT%20%3Fitem%20%3Fproperty%20%3FpropertyLabel%20%0AWHERE%20%7B%0A%20%20wd%3A', city_code, '%20wdt%3AP625%20%3FmainLoc%20.%0A%20%20SERVICE%20wikibase%3Aaround%20%7B%20%0A%20%20%20%20%3Fitem%20wdt%3AP625%20%3Fcoord%20.%20%0A%20%20%20%20bd%3AserviceParam%20wikibase%3Acenter%20%3FmainLoc%20.%20%0A%20%20%20%20bd%3AserviceParam%20wikibase%3Aradius%20%22', radius, '%22%20.%20%0A%20%20%7D%0A%20%20SERVICE%20wikibase%3Alabel%20%7B%0A%20%20%20%20bd%3AserviceParam%20wikibase%3Alanguage%20%22bg%22%2C%20%22cs%22%2C%20%22da%22%2C%20%22de%22%2C%20%22el%22%2C%20%0A%20%20%20%20%22en%22%2C%20%22es%22%2C%20%22et%22%2C%20%22fi%22%2C%20%22fr%22%2C%20%22ga%22%2C%20%22hr%22%2C%20%22hu%22%2C%20%22is%22%2C%20%22it%22%2C%20%22lt%22%2C%20%22lv%22%2C%20%0A%20%20%20%20%22mk%22%2C%20%22mt%22%2C%20%22nl%22%2C%20%22no%22%2C%20%22pl%22%2C%20%22pt%22%2C%20%22ro%22%2C%20%22ru%22%2C%20%22sk%22%2C%20%22sl%22%2C%20%22sq%22%2C%20%22sr%22%2C%20%0A%20%20%20%20%22sv%22%2C%20%22tr%22.%0A%20%20%20%20%3Fitem%20rdfs%3Alabel%20%3Fname%0A%20%20%7D%0A%20%20%3Fitem%20wdt%3AP31%20%3Fproperty%20.%0A%20%20SERVICE%20wikibase%3Alabel%20%7B%20bd%3AserviceParam%20wikibase%3Alanguage%20%22en%22%20%7D%0A%7D%0AORDER%20BY%20ASC%20(%3Fname)')
  download.file(paste0(api_url, query, "&format=json"), paste0('./wikidata_properties/', city_code, '.txt'))
}

# This functions query for Wikidata items' properties using a box around the location. You have to look first for the wikidata location identifier on wikidata.org ('Q_____') and to set two other locations that will become the corners of the box. Look for the identifier of these two locations and set at which corner they are in the format 'NorthEast', 'NorthWest', 'SouthEast', 'SouthWest'.
# It returns the list of Wikidata items' properties that are geolocated into that box around the location with Wikidata identifier

query_location_property_3 <- function(city_code, first_corner_city_code, first_city_corner, second_corner_city_code, second_city_corner){
  query <- paste0('SELECT%20%3Fitem%20%3Fproperty%20%3FpropertyLabel%20%0AWHERE%20%7B%0A%20%20wd%3A', first_city_code, '%20wdt%3AP625%20%3FFirstloc%20.%0A%20%20wd%3A', second_city_code, '%20wdt%3AP625%20%3FSecondloc%20.%0A%20%20SERVICE%20wikibase%3Abox%20%7B%0A%20%20%20%20%3Fitem%20wdt%3AP625%20%3Fcoord%20.%0A%20%20%20%20bd%3AserviceParam%20wikibase%3Acorner',first_city_corner, '%20%3FFirstloc%20.%0A%20%20%20%20bd%3AserviceParam%20wikibase%3Acorner', second_city_corner, '%20%3FSecondloc%20.%0A%20%20%7D%0A%20%20SERVICE%20wikibase%3Alabel%20%7B%0A%20%20%20%20bd%3AserviceParam%20wikibase%3Alanguage%20%22en%22.%0A%20%20%20%20%3Fitem%20rdfs%3Alabel%20%3Fname%0A%20%20%7D%0A%20%20%3Fitem%20wdt%3AP31%20%3Fproperty%20.%0A%20%20%3Fproperty%20wdt%3AP279%20%3Fclass%0A%20%20SERVICE%20wikibase%3Alabel%20%7B%20bd%3AserviceParam%20wikibase%3Alanguage%20%22en%22%20%7D%0A%7D%0AORDER%20BY%20ASC%20(%3Fname)')
  download.file(paste0(api_url, query, "&format=json"), paste0('./wikidata_properties/', city_code, '.txt'))
}

# This function reads the list of properties that has been downloaded
# It returns a dataframe with the Wikidata identifier of the item and its property (there could be multiple properties for each item)

read_property_list <- function(city_code){
  json <- jsonlite::fromJSON(paste0('./wikidata_properties/', city_code, '.txt'), simplifyDataFrame = TRUE)
  json_item <-json$results$bindings$item
  json_property <- json$results$bindings$propertyLabel
  property <- json_item %>%
    mutate(item = gsub('http://www.wikidata.org/entity/', '', value)) %>%
    select (-type, -value) %>%
    mutate(property = gsub('http://www.wikidata.org/entity/', '', json_property$value)) %>%
    distinct()
  return(property)
}

# This function reads the list of properties that has been downloaded with each identifier (of the property). You should use this function ONLY when you need to search for classes.
# It returns dataframe with the Wikidata identifier of the property and its label

read_property_identifier <- function(city_code){
  json <- jsonlite::fromJSON(paste0('./wikidata_properties/', city_code, '.txt'), simplifyDataFrame = TRUE)
  json_property <-json$results$bindings$property
  json_property_Label <- json$results$bindings$propertyLabel
  property <- json_property %>%
    mutate(item = gsub('http://www.wikidata.org/entity/', '', value)) %>%
    select (-type, -value) %>%
    mutate(property = json_property_Label$value) %>%
    distinct()
  return(property)
}

# This function gets the list of class from Wikidata property items' identifier that has been obtained through the query_location_property functions and read through the read_property_identifier function
# This functions simply performs ther query and downloads the JSON files, so you will have to launch the read_property_class to have a result

query_property_class <- function(items) {
  items_list <- items$item
  for (i in 1:length(items_list)) {
    query <- paste0('SELECT%20%3FclassLabel%20%0AWHERE%20%7B%0A%20%20wd%3A', items_list[i], '%20wdt%3AP279%20%3Fclass%0A%20%20SERVICE%20wikibase%3Alabel%20%7B%20bd%3AserviceParam%20wikibase%3Alanguage%20%22en%22%20%7D%0A%7D%0A%0A')
    download.file(paste0(api_url, query, "&format=json"), paste0('./wikidata_classes/', items_list[i], '.txt'))
  }
}

# This function reads the list of classes from Wikidata property items' identifier that has been obtained through the query_property_class function.
# It returns a dataframe with two variables: Wikidata property items' identifier and the class to which this property belongs to

read_property_class <- function(items) {
  items_list <- items$item
  class_df <- data.frame(item = character(), class = character())
  for (i in 1:length(items_list)) {
    json <- jsonlite::fromJSON(paste0('./wikidata_classes/', items_list[i], '.txt'), simplifyDataFrame = TRUE)
    if (!length(json$results$bindings) == 0) {
      class <-json$results$bindings$classLabel
      item <- data.frame(item = rep.int(items_list[i], nrow(class)))
      df <- item %>%
        mutate(class = class$value) %>%
        distinct()
      class_df <- rbind(class_df, df)
    } else {
      class <- NA
      item <- data.frame(item = items_list[i])
      df <- item %>%
        mutate(class = class) %>%
        distinct()
      class_df <- rbind(class_df, df)
    }
  }
  return(class_df)
}

# This function links the list of Wikidata properties id (from read_property_identifier) to the list of classes (from read_property_class) and then to the list of properties (from read_property_list)
# It returns a dataframe with three variables: Wikidata items identifier (not property identifier), property and class

link_property_class <- function(properties_id, classes, properties) {
  linked <- properties_id %>%
    full_join(classes, by = 'item')%>%
    select(-item)%>%
    right_join(properties, by = 'property')%>%
    select(item, property, class)
  return(linked)
}

