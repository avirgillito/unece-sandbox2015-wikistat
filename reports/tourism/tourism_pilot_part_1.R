### TOURISM PILOT (PART 1)

### This script starts from the query to Wikidata, downloads the list of items, gets the Wikipedia articles
### that are in the items and prepare the dataframe with all the articles to be downloaded. 

rm(list=ls())
library(dplyr)
library(jsonlite)
library(stringr)
source("scripts/r/wikidata_functions.R")
source("scripts/r/data_man.R")

api_url <- "https://query.wikidata.org/bigdata/namespace/wdq/sparql?query="

# We decided to use the no. 2 query (see the guide for more information)

## Barcelona
city_code <- 'Q1492'
radius <- '30'
query_location_2(city_code, radius)

# Read the downloaded file

items_Barcelona <- read_items_list(city_code)

# Keep the df with the articles, languages and items

df <- get_wikipedia_articles(items_Barcelona)

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
query_location_2(city_code, radius)

items_Vienna <- read_items_list(city_code)

# Keep the df with the articles, languages and items

df <- get_wikipedia_articles(items_Vienna)

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
query_location_2(city_code, radius)

# Read the downloaded file

items_Bruges <- read_items_list(city_code)

# Keep the df with the articles, languages and items

df <- get_wikipedia_articles(items_Bruges)

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

Barcelona_in_C <- read.csv("./data_using_wikidata/points/Barcelona_in_C.csv")
Barcelona_in_K <- read.csv("./data_using_wikidata/points/Barcelona_in_K.csv")

Bruges_in_C <- read.csv("./data_using_wikidata/points/Bruges_in_C.csv")
Bruges_in_F <- read.csv("./data_using_wikidata/points/Bruges_in_F.csv")

Vienna_in_C <- read.csv("./data_using_wikidata/points/Vienna_in_C.csv")

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

Articles_to_download <- rbind(Barcelona_articles_in_K, Bruges_articles_in_F, Vienna_articles_in_C)%>%
  filter(!is.na(article))
          
write.csv(Articles_to_download, 'Articles_to_download.csv')
