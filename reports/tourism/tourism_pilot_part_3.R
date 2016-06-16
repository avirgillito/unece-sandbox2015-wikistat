library(dplyr)
library(jsonlite)
library(stringr)
source("scripts/r/wikidata_functions.R")

api_url <- "https://query.wikidata.org/bigdata/namespace/wdq/sparql?query="

#### QUERY TO ALSO GET THE CATEGORIES

### Create and launch the query in RStudio

# Barcelona

query <- 'SELECT%20%3Fitem%20%3Fname%20%3Fcoord%20%3FpropertyLabel%20%0AWHERE%20%7B%0A%20%20wd%3AQ1492%20wdt%3AP625%20%3FmainLoc%20.%0A%20%20SERVICE%20wikibase%3Aaround%20%7B%20%0A%20%20%20%20%3Fitem%20wdt%3AP625%20%3Fcoord%20.%20%0A%20%20%20%20bd%3AserviceParam%20wikibase%3Acenter%20%3FmainLoc%20.%20%0A%20%20%20%20bd%3AserviceParam%20wikibase%3Aradius%20%2230%22%20.%20%0A%20%20%7D%0A%20%20SERVICE%20wikibase%3Alabel%20%7B%0A%20%20%20%20bd%3AserviceParam%20wikibase%3Alanguage%20%22bg%22%2C%20%22cs%22%2C%20%22da%22%2C%20%22de%22%2C%20%22el%22%2C%20%0A%20%20%20%20%22en%22%2C%20%22es%22%2C%20%22et%22%2C%20%22fi%22%2C%20%22fr%22%2C%20%22ga%22%2C%20%22hr%22%2C%20%22hu%22%2C%20%22is%22%2C%20%22it%22%2C%20%22lt%22%2C%20%22lv%22%2C%20%0A%20%20%20%20%22mk%22%2C%20%22mt%22%2C%20%22nl%22%2C%20%22no%22%2C%20%22pl%22%2C%20%22pt%22%2C%20%22ro%22%2C%20%22ru%22%2C%20%22sk%22%2C%20%22sl%22%2C%20%22sq%22%2C%20%22sr%22%2C%20%0A%20%20%20%20%22sv%22%2C%20%22tr%22.%0A%20%20%20%20%3Fitem%20rdfs%3Alabel%20%3Fname%0A%20%20%7D%0A%20%20%3Fitem%20wdt%3AP31%20%3Fproperty%20.%0A%20%20SERVICE%20wikibase%3Alabel%20%7B%20bd%3AserviceParam%20wikibase%3Alanguage%20%22en%22%20%7D%0A%7D%0AORDER%20BY%20ASC%20(%3Fname)'

download.file(paste0(api_url, query, "&format=json"), paste0('/ichec/home/users/signose/wikistats/wikidata_lists/categoryQ1492.txt'))

json <- jsonlite::fromJSON(paste0('/ichec/home/users/signose/wikistats/wikidata_lists/categoryQ1492.txt'), simplifyDataFrame = TRUE)

# Arrange the file in a dataframe with only three variables: item, latitute, longitude

json_item <-json$results$bindings$item
json_property <- json$results$bindings$propertyLabel

category_Barcelona <- json_item %>%
  mutate(item = gsub('http://www.wikidata.org/entity/', '', value)) %>%
  select (-type, -value) %>%
  mutate(property = gsub('http://www.wikidata.org/entity/', '', json_property$value)) %>%
  distinct()

# Filter considering only points inside the city 

# Barcelona C

category_Barcelona_C <- read.csv('./data_using_wikidata/pageviews/Barcelona_pw_coord_C.csv') %>%
  select(item) %>%
  left_join(category_Barcelona, by = 'item') %>%
  distinct() %>%
  mutate(item = as.factor(item),
         category = as.factor(property))%>%
  select(-property)

write.csv(category_Barcelona_C, './data_using_wikidata/categories/category_Q1492_C.csv')

# Barcelona K

category_Barcelona_K <- read.csv('./data_using_wikidata/pageviews/Barcelona_pw_coord_K.csv') %>%
  select(item) %>%
  left_join(category_Barcelona, by = 'item') %>%
  distinct()%>%
  mutate(item = as.factor(item),
         category = as.factor(property))%>%
  select(-property)

write.csv(category_Barcelona_K, './data_using_wikidata/categories/category_Q1492_K.csv')

# Bruges

query <- 'SELECT%20%3Fitem%20%3Fname%20%3Fcoord%20%3FpropertyLabel%20%0AWHERE%20%7B%0A%20%20wd%3AQ12994%20wdt%3AP625%20%3FmainLoc%20.%0A%20%20SERVICE%20wikibase%3Aaround%20%7B%20%0A%20%20%20%20%3Fitem%20wdt%3AP625%20%3Fcoord%20.%20%0A%20%20%20%20bd%3AserviceParam%20wikibase%3Acenter%20%3FmainLoc%20.%20%0A%20%20%20%20bd%3AserviceParam%20wikibase%3Aradius%20%2230%22%20.%20%0A%20%20%7D%0A%20%20SERVICE%20wikibase%3Alabel%20%7B%0A%20%20%20%20bd%3AserviceParam%20wikibase%3Alanguage%20%22bg%22%2C%20%22cs%22%2C%20%22da%22%2C%20%22de%22%2C%20%22el%22%2C%20%0A%20%20%20%20%22en%22%2C%20%22es%22%2C%20%22et%22%2C%20%22fi%22%2C%20%22fr%22%2C%20%22ga%22%2C%20%22hr%22%2C%20%22hu%22%2C%20%22is%22%2C%20%22it%22%2C%20%22lt%22%2C%20%22lv%22%2C%20%0A%20%20%20%20%22mk%22%2C%20%22mt%22%2C%20%22nl%22%2C%20%22no%22%2C%20%22pl%22%2C%20%22pt%22%2C%20%22ro%22%2C%20%22ru%22%2C%20%22sk%22%2C%20%22sl%22%2C%20%22sq%22%2C%20%22sr%22%2C%20%0A%20%20%20%20%22sv%22%2C%20%22tr%22.%0A%20%20%20%20%3Fitem%20rdfs%3Alabel%20%3Fname%0A%20%20%7D%0A%20%20%3Fitem%20%20wdt%3AP31%20%3Fproperty%20.%0A%20%20SERVICE%20wikibase%3Alabel%20%7B%20bd%3AserviceParam%20wikibase%3Alanguage%20%22en%22%20%7D%0A%7D%0AORDER%20BY%20ASC%20(%3Fname)'

download.file(paste0(api_url, query, "&format=json"), paste0('/ichec/home/users/signose/wikistats/wikidata_lists/categoryQ12994.txt'))

json <- jsonlite::fromJSON(paste0('/ichec/home/users/signose/wikistats/wikidata_lists/categoryQ12994.txt'), simplifyDataFrame = TRUE)

# Arrange the file in a dataframe with only three variables: item, latitute, longitude

json_item <-json$results$bindings$item
json_property <- json$results$bindings$propertyLabel

category_Bruges <- json_item %>%
  mutate(item = gsub('http://www.wikidata.org/entity/', '', value)) %>%
  select (-type, -value) %>%
  mutate(property = gsub('http://www.wikidata.org/entity/', '', json_property$value)) %>%
  distinct()

# Filter considering only points inside the city 

# Bruges C

category_Bruges_C <- read.csv('./data_using_wikidata/pageviews/Bruges_pw_coord_C.csv') %>%
  select(item) %>%
  left_join(category_Bruges, by = 'item') %>%
  distinct()%>%
  mutate(item = as.factor(item),
         category = as.factor(property))%>%
  select(-property)

write.csv(category_Bruges_C, './data_using_wikidata/categories/category_Q12994_C.csv')

# Bruges F

category_Bruges_F <- read.csv('./data_using_wikidata/pageviews/Bruges_pw_coord_F.csv') %>%
  select(item) %>%
  left_join(category_Bruges, by = 'item') %>%
  distinct()%>%
  mutate(item = as.factor(item),
         category = as.factor(property))%>%
  select(-property)

write.csv(category_Bruges_F, './data_using_wikidata/categories/category_Q12994_F.csv')

# Vienna

query <- 'SELECT%20%3Fitem%20%3Fname%20%3Fcoord%20%3FpropertyLabel%20%0AWHERE%20%7B%0A%20%20wd%3AQ1741%20wdt%3AP625%20%3FmainLoc%20.%0A%20%20SERVICE%20wikibase%3Aaround%20%7B%20%0A%20%20%20%20%3Fitem%20wdt%3AP625%20%3Fcoord%20.%20%0A%20%20%20%20bd%3AserviceParam%20wikibase%3Acenter%20%3FmainLoc%20.%20%0A%20%20%20%20bd%3AserviceParam%20wikibase%3Aradius%20%2230%22%20.%20%0A%20%20%7D%0A%20%20SERVICE%20wikibase%3Alabel%20%7B%0A%20%20%20%20bd%3AserviceParam%20wikibase%3Alanguage%20%22bg%22%2C%20%22cs%22%2C%20%22da%22%2C%20%22de%22%2C%20%22el%22%2C%20%0A%20%20%20%20%22en%22%2C%20%22es%22%2C%20%22et%22%2C%20%22fi%22%2C%20%22fr%22%2C%20%22ga%22%2C%20%22hr%22%2C%20%22hu%22%2C%20%22is%22%2C%20%22it%22%2C%20%22lt%22%2C%20%22lv%22%2C%20%0A%20%20%20%20%22mk%22%2C%20%22mt%22%2C%20%22nl%22%2C%20%22no%22%2C%20%22pl%22%2C%20%22pt%22%2C%20%22ro%22%2C%20%22ru%22%2C%20%22sk%22%2C%20%22sl%22%2C%20%22sq%22%2C%20%22sr%22%2C%20%0A%20%20%20%20%22sv%22%2C%20%22tr%22.%0A%20%20%20%20%3Fitem%20rdfs%3Alabel%20%3Fname%0A%20%20%7D%0A%20%20%3Fitem%20%20wdt%3AP31%20%3Fproperty%20.%0A%20%20SERVICE%20wikibase%3Alabel%20%7B%20bd%3AserviceParam%20wikibase%3Alanguage%20%22en%22%20%7D%0A%7D%0AORDER%20BY%20ASC%20(%3Fname)'

download.file(paste0(api_url, query, "&format=json"), paste0('/ichec/home/users/signose/wikistats/wikidata_lists/categoryQ1741.txt'))

json <- jsonlite::fromJSON(paste0('/ichec/home/users/signose/wikistats/wikidata_lists/categoryQ1741.txt'), simplifyDataFrame = TRUE)

# Arrange the file in a dataframe with only three variables: item, latitute, longitude

json_item <-json$results$bindings$item
json_property <- json$results$bindings$propertyLabel

category_Vienna <- json_item %>%
  mutate(item = gsub('http://www.wikidata.org/entity/', '', value)) %>%
  select (-type, -value) %>%
  mutate(property = gsub('http://www.wikidata.org/entity/', '', json_property$value)) %>%
  distinct()

# Filter considering only points inside the city 

# Vienna C

category_Vienna_C <- read.csv('./data_using_wikidata/pageviews/Vienna_pw_coord_C.csv') %>%
  select(item) %>%
  left_join(category_Vienna, by = 'item') %>%
  distinct()%>%
  mutate(item = as.factor(item),
         category = as.factor(property))%>%
  select(-property)

write.csv(category_Vienna_C, './data_using_wikidata/categories/category_Q1741_C.csv')

# Compute a summary of the categories

str(category_Barcelona_C)
str(category_Barcelona_K)
str(category_Bruges_C)
str(category_Bruges_F)
str(category_Vienna_C)

# Compute how many items do not have category

sum(is.na(category_Barcelona_C$category))
sum(is.na(category_Barcelona_K$category))
sum(is.na(category_Bruges_C$category))
sum(is.na(category_Bruges_F$category))
sum(is.na(category_Vienna_C$category))

# Try to compute top 10 by category (removing multiple categories and items with no category)

Barcelona_C_top10_category <- Barcelona_C %>%
  left_join(category_Barcelona_C, by = 'item') %>%
  distinct(item) %>%
  filter(!is.na(category))%>%
  group_by(category)%>%
  summarise(value = sum(value)) %>%
  arrange(desc(value))

Barcelona_C_top10_category[1:10,1]

Barcelona_K_top10_category <- Barcelona_K %>%
  left_join(category_Barcelona_K, by = 'item') %>%
  distinct(item) %>%
  filter(!is.na(category))%>%
  group_by(category)%>%
  summarise(value = sum(value)) %>%
  arrange(desc(value))

Barcelona_K_top10_category[1:10,]

Bruges_C_top10_category <- Bruges_C %>%
  left_join(category_Bruges_C, by = 'item') %>%
  distinct(item) %>%
  filter(!is.na(category))%>%
  group_by(category)%>%
  summarise(value = sum(value)) %>%
  arrange(desc(value))

Bruges_C_top10_category[1:10,]

Bruges_F_top10_category <- Bruges_F %>%
  left_join(category_Bruges_F, by = 'item') %>%
  distinct(item) %>%
  filter(!is.na(category))%>%
  group_by(category)%>%
  summarise(value = sum(value)) %>%
  arrange(desc(value))

Bruges_F_top10_category[1:10,]

Vienna_C_top10_category <- Vienna_C %>%
  left_join(category_Vienna_C, by = 'item') %>%
  distinct(item) %>%
  filter(!is.na(category))%>%
  group_by(category)%>%
  summarise(value = sum(value)) %>%
  arrange(desc(value))

Vienna_C_top10_category[1:10,]

# Prepare data to plot on the map

Barcelona_C_category <- Barcelona_C %>%
  left_join(category_Barcelona_C, by = 'item') %>%
  distinct(item) %>%
  filter(!is.na(category)) %>%
  filter(category == 'association football club' | category == 'city' | category == 'church' |
           category == 'stadium' | category == 'building' | category == 'park' | category == 'skyscraper' |
           category == 'neighborhood' | category == 'district' | category == 'Summer Olympic Games')

write.csv(Barcelona_C_category, 'Barcelona_C_category.csv')

Barcelona_C_all_category <- Barcelona_C %>%
  left_join(category_Barcelona_C, by = 'item') %>%
  distinct(item) %>%
  filter(!is.na(category))

write.csv(Barcelona_C_all_category, 'Barcelona_C_all_category.csv')

library(dplyr)
library(leaflet)
library(htmlwidgets)

### Maps with layer per category

# Barcelona C

Barcelona_C_category <- read.csv("C:/Users/signose/Desktop/Cities/Categories/Barcelona_C_category.csv") %>%
  select(-X)

Barcelona_C_all_category <- read.csv("C:/Users/signose/Desktop/Cities/Categories/Barcelona_C_all_category.csv") %>%
  select(-X)

m <- leaflet(Barcelona_C_all_category) %>%
  addProviderTiles("CartoDB.Positron")%>%
  addCircleMarkers(~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~colorFactor(topo.colors(133), Barcelona_C_all_category$category)(category), fillOpacity = 0.6) %>%
  addMarkers(~long, ~lat, popup = ~category, options =markerOptions(opacity = 0)) %>%
  addLegend(position = c("bottomright"), colorFactor(topo.colors(133), Barcelona_C_all_category$category), values = ~category)
m



