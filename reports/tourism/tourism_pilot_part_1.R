### TOURISM PILOT (PART 1)

### This script starts from the query to Wikidata, downloads the list of items, gets the Wikipedia articles
### that are in the items and prepare the dataframe with all the articles to be downloaded. 

rm(list=ls())
library(dplyr)
library(jsonlite)
library(stringr)
source("scripts/r/wikidata_functions.R")

api_url <- "https://query.wikidata.org/bigdata/namespace/wdq/sparql?query="

# We decided to use the no. 2 query (see the guide for more information)

## Barcelona
city_code <- 'Q1492'
radius <- '30'
query <- paste0('SELECT%20%3Fitem%20%3Fname%20%3Fcoord%20%0AWHERE%20%7B%0A%20wd%3A', city_code, '%20wdt%3AP625%20%3FmainLoc%20.%20%0A%20SERVICE%20wikibase%3Aaround%20%7B%20%0A%20%3Fitem%20wdt%3AP625%20%3Fcoord%20.%20%0A%20bd%3AserviceParam%20wikibase%3Acenter%20%3FmainLoc%20.%20%0A%20bd%3AserviceParam%20wikibase%3Aradius%20%22', radius, '%22%20.%20%0A%20%7D%0A%20SERVICE%20wikibase%3Alabel%20%7B%0A%20%20%20%20%20%20bd%3AserviceParam%20wikibase%3Alanguage%20%22bg%22%2C%20%22cs%22%2C%20%22da%22%2C%20%22de%22%2C%20%22el%22%2C%20%0A%22en%22%2C%20%22es%22%2C%20%22et%22%2C%20%22fi%22%2C%20%22fr%22%2C%20%22ga%22%2C%20%22hr%22%2C%20%22hu%22%2C%20%22is%22%2C%20%22it%22%2C%20%22lt%22%2C%20%22lv%22%2C%20%0A%22mk%22%2C%20%22mt%22%2C%20%22nl%22%2C%20%22no%22%2C%20%22pl%22%2C%20%22pt%22%2C%20%22ro%22%2C%20%22ru%22%2C%20%22sk%22%2C%20%22sl%22%2C%20%22sq%22%2C%20%22sr%22%2C%20%0A%22sv%22%2C%20%22tr%22.%0A%20%20%20%20%20%3Fitem%20rdfs%3Alabel%20%3Fname%0A%20%7D%0A%7D%0AORDER%20BY%20ASC%20(%3Fname)%0A')

# Download the file with list of wikidata items

download.file(paste0(api_url, query, "&format=json"), paste0('/ichec/home/users/signose/wikistats/wikidata_lists/', city_code, '.txt'))

# Read the downloaded file

json <- jsonlite::fromJSON(paste0('/ichec/home/users/signose/wikistats/wikidata_lists/', city_code, '.txt'), simplifyDataFrame = TRUE)

# Arrange the file in a dataframe with only three variables: item, latitute, longitude

json_item <-json$results$bindings$item
json_name <-json$results$bindings$name
json_coord <-json$results$bindings$coord

items_Barcelona <- json_item %>%
  mutate(item = gsub('http://www.wikidata.org/entity/', '', value)) %>%
  select (-type, -value) %>%
  mutate(point = json_coord$value, 
         lat = substr(point, 7, regexpr(" ", point)-1),
         long = substr(point, regexpr(" ", point), regexpr(")", point)-1)) %>%
  select(-point) %>%
  distinct()

# Keep the df with the articles, languages and items

df <- wikidata_sitelinks_df(items_Barcelona)

# Filter considering only the 31 languages

Barcelona_articles <- df %>%
  filter(lang == 'bg' | lang == 'cs' | lang == 'da' | lang == 'de' | lang == 'el' | lang == 'en' | lang == 'es' |
            lang == 'et' | lang == 'fi' | lang == 'fr' | lang == 'ga' | lang == 'hr' | lang == 'hu' | lang == 'is' | 
            lang == 'it' | lang == 'lt' | lang == 'lv' | lang == 'mk' | lang == 'mt' | lang == 'nl' | lang == 'no'| 
            lang == 'pl' | lang == 'pt' | lang == 'ro' | lang == 'ru' | lang == 'sk' | lang == 'sl' | lang == 'sq'| 
            lang == 'sr' | lang == 'sv' | lang == 'tr') %>%
  distinct()


# Count how many unique articles do we have (when we'll have pageviews we'll just summarise considering them, not inserting the new variable 'count')

Barcelona_unique_articles <- Barcelona_articles %>%
  mutate(count = rep(1)) %>%
  group_by(item) %>%
  summarise(count = sum(count))

# See how many points related to the selected articles we have

Barcelona_points <- Barcelona_articles %>%
  left_join(items_Barcelona, by = "item") %>%
  distinct() %>%
  select(-article, -lang) 

# Count how many unique points do we have

Barcelona_unique_points <- Barcelona_points %>%
  mutate(count = rep(1)) %>%
  group_by(item) %>%
  summarise(count = sum(count))

# Save files
write.csv(Barcelona_points, 'Barcelona_points.csv')

## Vienna
city_code <- 'Q1741'
radius <- '30'
query <- paste0('SELECT%20%3Fitem%20%3Fname%20%3Fcoord%20%0AWHERE%20%7B%0A%20wd%3A', city_code, '%20wdt%3AP625%20%3FmainLoc%20.%20%0A%20SERVICE%20wikibase%3Aaround%20%7B%20%0A%20%3Fitem%20wdt%3AP625%20%3Fcoord%20.%20%0A%20bd%3AserviceParam%20wikibase%3Acenter%20%3FmainLoc%20.%20%0A%20bd%3AserviceParam%20wikibase%3Aradius%20%22', radius, '%22%20.%20%0A%20%7D%0A%20SERVICE%20wikibase%3Alabel%20%7B%0A%20%20%20%20%20%20bd%3AserviceParam%20wikibase%3Alanguage%20%22bg%22%2C%20%22cs%22%2C%20%22da%22%2C%20%22de%22%2C%20%22el%22%2C%20%0A%22en%22%2C%20%22es%22%2C%20%22et%22%2C%20%22fi%22%2C%20%22fr%22%2C%20%22ga%22%2C%20%22hr%22%2C%20%22hu%22%2C%20%22is%22%2C%20%22it%22%2C%20%22lt%22%2C%20%22lv%22%2C%20%0A%22mk%22%2C%20%22mt%22%2C%20%22nl%22%2C%20%22no%22%2C%20%22pl%22%2C%20%22pt%22%2C%20%22ro%22%2C%20%22ru%22%2C%20%22sk%22%2C%20%22sl%22%2C%20%22sq%22%2C%20%22sr%22%2C%20%0A%22sv%22%2C%20%22tr%22.%0A%20%20%20%20%20%3Fitem%20rdfs%3Alabel%20%3Fname%0A%20%7D%0A%7D%0AORDER%20BY%20ASC%20(%3Fname)%0A')

# Download the file with list of wikidata items

download.file(paste0(api_url, query, "&format=json"), paste0('/ichec/home/users/signose/wikistats/wikidata_lists/', city_code, '.txt'))

# Read the downloaded file

json <- jsonlite::fromJSON(paste0('/ichec/home/users/signose/wikistats/wikidata_lists/', city_code, '.txt'), simplifyDataFrame = TRUE)

# Arrange the file in a dataframe with only three variables: item, latitute, longitude

json_item <-json$results$bindings$item
json_name <-json$results$bindings$name
json_coord <-json$results$bindings$coord

items_Vienna <- json_item %>%
  mutate(item = gsub('http://www.wikidata.org/entity/', '', value)) %>%
  select (-type, -value) %>%
  mutate(point = json_coord$value, 
         lat = substr(point, 7, regexpr(" ", point)-1),
         long = substr(point, regexpr(" ", point), regexpr(")", point)-1)) %>%
  select(-point) %>%
  distinct()

# Keep the df with the articles, languages and items

df <- wikidata_sitelinks_df(items_Vienna)

# Filter considering only the 31 languages

Vienna_articles <- df %>%
  filter(lang == 'bg' | lang == 'cs' | lang == 'da' | lang == 'de' | lang == 'el' | lang == 'en' | lang == 'es' |
           lang == 'et' | lang == 'fi' | lang == 'fr' | lang == 'ga' | lang == 'hr' | lang == 'hu' | lang == 'is' | 
           lang == 'it' | lang == 'lt' | lang == 'lv' | lang == 'mk' | lang == 'mt' | lang == 'nl' | lang == 'no'| 
           lang == 'pl' | lang == 'pt' | lang == 'ro' | lang == 'ru' | lang == 'sk' | lang == 'sl' | lang == 'sq'| 
           lang == 'sr' | lang == 'sv' | lang == 'tr') %>%
  distinct()


# Count how many unique items do we have (when we'll have pageviews we'll just summarise considering them, not inserting the new variable 'count')

Vienna_unique_articles <- Vienna_articles %>%
  mutate(count = rep(1)) %>%
  group_by(item) %>%
  summarise(count = sum(count))

# See how many points related to the selected articles we have

Vienna_points <- Vienna_articles %>%
  left_join(items_Vienna, by = "item") %>%
  distinct() %>%
  select(-article, -lang) 

# Count how many unique points do we have

Vienna_unique_points <- Vienna_points %>%
  mutate(count = rep(1)) %>%
  group_by(item) %>%
  summarise(count = sum(count))

# Save files
write.csv(Vienna_points, 'Vienna_points.csv')

## Bruges
city_code <- 'Q12994'
radius <- '30'
query <- paste0('SELECT%20%3Fitem%20%3Fname%20%3Fcoord%20%0AWHERE%20%7B%0A%20wd%3A', city_code, '%20wdt%3AP625%20%3FmainLoc%20.%20%0A%20SERVICE%20wikibase%3Aaround%20%7B%20%0A%20%3Fitem%20wdt%3AP625%20%3Fcoord%20.%20%0A%20bd%3AserviceParam%20wikibase%3Acenter%20%3FmainLoc%20.%20%0A%20bd%3AserviceParam%20wikibase%3Aradius%20%22', radius, '%22%20.%20%0A%20%7D%0A%20SERVICE%20wikibase%3Alabel%20%7B%0A%20%20%20%20%20%20bd%3AserviceParam%20wikibase%3Alanguage%20%22bg%22%2C%20%22cs%22%2C%20%22da%22%2C%20%22de%22%2C%20%22el%22%2C%20%0A%22en%22%2C%20%22es%22%2C%20%22et%22%2C%20%22fi%22%2C%20%22fr%22%2C%20%22ga%22%2C%20%22hr%22%2C%20%22hu%22%2C%20%22is%22%2C%20%22it%22%2C%20%22lt%22%2C%20%22lv%22%2C%20%0A%22mk%22%2C%20%22mt%22%2C%20%22nl%22%2C%20%22no%22%2C%20%22pl%22%2C%20%22pt%22%2C%20%22ro%22%2C%20%22ru%22%2C%20%22sk%22%2C%20%22sl%22%2C%20%22sq%22%2C%20%22sr%22%2C%20%0A%22sv%22%2C%20%22tr%22.%0A%20%20%20%20%20%3Fitem%20rdfs%3Alabel%20%3Fname%0A%20%7D%0A%7D%0AORDER%20BY%20ASC%20(%3Fname)%0A')

# Download the file with list of wikidata items

download.file(paste0(api_url, query, "&format=json"), paste0('/ichec/home/users/signose/wikistats/wikidata_lists/', city_code, '.txt'))

# Read the downloaded file

json <- jsonlite::fromJSON(paste0('/ichec/home/users/signose/wikistats/wikidata_lists/', city_code, '.txt'), simplifyDataFrame = TRUE)

# Arrange the file in a dataframe with only three variables: item, longitude, latitute

json_item <-json$results$bindings$item
json_name <-json$results$bindings$name
json_coord <-json$results$bindings$coord

items_Bruges <- json_item %>%
  mutate(item = gsub('http://www.wikidata.org/entity/', '', value)) %>%
  select (-type, -value) %>%
  mutate(point = json_coord$value, 
         long = substr(point, 7, regexpr(" ", point)-1),
         lat = substr(point, regexpr(" ", point), regexpr(")", point)-1)) %>%
  select(-point) %>%
  distinct()

# Keep the df with the articles, languages and items

df <- wikidata_sitelinks_df(items_Bruges)

# Filter considering only the 31 languages

Bruges_articles <- df %>%
  filter(lang == 'bg' | lang == 'cs' | lang == 'da' | lang == 'de' | lang == 'el' | lang == 'en' | lang == 'es' |
           lang == 'et' | lang == 'fi' | lang == 'fr' | lang == 'ga' | lang == 'hr' | lang == 'hu' | lang == 'is' | 
           lang == 'it' | lang == 'lt' | lang == 'lv' | lang == 'mk' | lang == 'mt' | lang == 'nl' | lang == 'no'| 
           lang == 'pl' | lang == 'pt' | lang == 'ro' | lang == 'ru' | lang == 'sk' | lang == 'sl' | lang == 'sq'| 
           lang == 'sr' | lang == 'sv' | lang == 'tr') %>%
  distinct()


# Count how many unique items do we have (when we'll have pageviews we'll just summarise considering them, not inserting the new variable 'count')

Bruges_unique_articles <- Bruges_articles %>%
  mutate(count = rep(1)) %>%
  group_by(item) %>%
  summarise(count = sum(count))

# See how many points related to the selected articles we have

Bruges_points <- Bruges_articles %>%
  left_join(items_Bruges, by = "item") %>%
  distinct() %>%
  select(-article, -lang) 

# Count how many unique points do we have

Bruges_unique_points <- Bruges_points %>%
  mutate(count = rep(1)) %>%
  group_by(item) %>%
  summarise(count = sum(count))

# Save files
write.csv(Bruges_points, 'Bruges_points.csv')

### Filtering of points: may be done in ArcGIS or in RStudio:

library(sp)
library(rgdal)

c.area = readOGR(dsn = ".", layer = "./Urban_audit_2011_2014_SH/URAU_RG_100K_2011_2014")
c.area <- spTransform(c.area, "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")

# Set the city code

# Barcelona C = ES002C1
# Barcelona K = ES002K1
# Vienna C = AT001C1 
# Bruges C = BE006C1
# Bruges F = BE006L2

city_code <- "ES002C1"

city <- c.area[c.area$URAU_CODE == city_code,]

Barcelona_points <-read.csv("C:/Users/signose/Desktop/Cities/Barcelona_points.csv")

points <- SpatialPoints(Barcelona_points[,2:3])

# imposes the projection of the points to be equal to that of the city
proj4string(points) = proj4string(c.area)

# checks which points fall within the city boundary
a <- over(x = points, y = city)
output <- !is.na(a[,1])

# Filter dataset based on output
Barcelona_points <- Barcelona_points[output, ]                            
                           
### After having filtered the points in ArcGIS, I load the new datasets
# (don't need to do this if you worked in RStudio)

Barcelona_in_C <- read.csv("Barcelona_in_C.csv")
Barcelona_in_K <- read.csv("Barcelona_in_K.csv")

Bruges_in_C <- read.csv("Bruges_in_C.csv")
Bruges_in_F <- read.csv("Bruges_in_F.csv")

Vienna_in_C <- read.csv("Vienna_in_C.csv")

# Then, I have to join these new datasets with the articles df

Barcelona_articles_in_C <- Barcelona_in_C %>%
  select(item) %>%
  left_join(Barcelona_articles, by = 'item') %>%
  distinct()
Barcelona_articles_in_C$article <- str_trim(Barcelona_articles_in_C$article, side = c("left"))

Barcelona_articles_in_K <- Barcelona_in_K %>%
  select(item) %>%
  left_join(Barcelona_articles, by = 'item') %>%
  distinct()
Barcelona_articles_in_K$article <- str_trim(Barcelona_articles_in_K$article, side = c("left"))

Bruges_articles_in_C <- Bruges_in_C %>%
  select(item) %>%
  left_join(Bruges_articles, by = 'item') %>%
  distinct()
Bruges_articles_in_C$article <- str_trim(Bruges_articles_in_C$article, side = c("left"))

Bruges_articles_in_F <- Bruges_in_F %>%
  select(item) %>%
  left_join(Bruges_articles, by = 'item') %>%
  distinct()
Bruges_articles_in_F$article <- str_trim(Bruges_articles_in_F$article, side = c("left"))

Vienna_articles_in_C <- Vienna_in_C %>%
  select(item) %>%
  left_join(Vienna_articles, by = 'item') %>%
  distinct()
Vienna_articles_in_C$article <- str_trim(Vienna_articles_in_C$article, side = c("left"))

write.csv(Barcelona_articles_in_C, './reports/cities/Barcelona_articles_C.csv')
write.csv(Barcelona_articles_in_K, './reports/cities/Barcelona_articles_K.csv')
write.csv(Bruges_articles_in_C, './reports/cities/Bruges_articles_C.csv')
write.csv(Bruges_articles_in_F, './reports/cities/Bruges_articles_F.csv')
write.csv(Vienna_articles_in_C, './reports/cities/Vienna_articles_C.csv')

### Get the final list of articles 

Articles_to_download <- rbind(Barcelona_articles_in_K, Bruges_articles_in_F, Vienna_articles_in_C) 
          
write.csv(Articles_to_download, 'Articles_to_download.csv')
