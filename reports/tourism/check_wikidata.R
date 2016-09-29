library(dplyr)
library(jsonlite)
library(stringr)
source("scripts/r/wikidata_functions.R")
source("scripts/r/data_man.R")

api_url <- "https://query.wikidata.org/bigdata/namespace/wdq/sparql?query="

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

# See how many points related to the selected articles we have

Barcelona_points <- Barcelona_articles %>%
  left_join(items_Barcelona, by = "item") %>%
  distinct() %>%
  select(-article, -lang) 

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

# See how many points related to the selected articles we have

Vienna_points <- Vienna_articles %>%
  left_join(items_Vienna, by = "item") %>%
  distinct() %>%
  select(-article, -lang) 

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

# See how many points related to the selected articles we have

Bruges_points <- Bruges_articles %>%
  left_join(items_Bruges, by = "item") %>%
  distinct() %>%
  select(-article, -lang) 

write.csv(Barcelona_points, "./check_wikidata/Barcelona_points.csv")
write.csv(Vienna_points, "./check_wikidata/Vienna_points.csv")
write.csv(Bruges_points, "./check_wikidata/Bruges_points.csv")

### Filtering of points: may be done in ArcGIS or in RStudio:

setwd("C:/Users/Acer/Desktop/Wiki pilot/URAU-2011-2014-SH")

library(sp)
library(rgdal)

Barcelona_points <- read.csv("C:/Users/Acer/Desktop/Wiki pilot/Barcelona_points.csv") %>%
  dplyr::select(-X)
Vienna_points <- read.csv("C:/Users/Acer/Desktop/Wiki pilot/Vienna_points.csv") %>%
  dplyr::select(-X)
Bruges_points <- read.csv("C:/Users/Acer/Desktop/Wiki pilot/Bruges_points.csv") %>%
  dplyr::select(-X)

library(raster)

c.area <- shapefile("./Urban_audit_2011_2014_SH/URAU_RG_100K_2011_2014.shp")
c.area <- spTransform(c.area, "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")

# Set the city code

# Barcelona C = ES002C1

city_code <- "ES002C1"

city <- c.area[c.area$URAU_CODE == city_code,]

points <- SpatialPoints(Barcelona_points[,3:4])

# imposes the projection of the points to be equal to that of the city
proj4string(points) = proj4string(c.area)

# checks which points fall within the city boundary
a <- over(x = points, y = city)
output <- !is.na(a[,1])

# Filter dataset based on output
Barcelona_points_C <- Barcelona_points[output, ]%>%
  distinct(item, .keep_all = T)                      

# Barcelona K = ES002K1

city_code <- "ES002K1"

city <- c.area[c.area$URAU_CODE == city_code,]

points <- SpatialPoints(Barcelona_points[,3:4])

# imposes the projection of the points to be equal to that of the city
proj4string(points) = proj4string(c.area)

# checks which points fall within the city boundary
a <- over(x = points, y = city)
output <- !is.na(a[,1])

# Filter dataset based on output
Barcelona_points_K <- Barcelona_points[output, ]%>%
  distinct(item, .keep_all = T)

# Vienna C = AT001C1 

city_code <- "AT001C1"

city <- c.area[c.area$URAU_CODE == city_code,]

points <- SpatialPoints(Vienna_points[,3:4])

# imposes the projection of the points to be equal to that of the city
proj4string(points) = proj4string(c.area)

# checks which points fall within the city boundary
a <- over(x = points, y = city)
output <- !is.na(a[,1])

# Filter dataset based on output
Vienna_points_C <- Vienna_points[output, ]%>%
  distinct(item, .keep_all = T)

# Bruges C = BE006C1

city_code <- "BE006C1"

city <- c.area[c.area$URAU_CODE == city_code,]

points <- SpatialPoints(Bruges_points[,3:4])

# imposes the projection of the points to be equal to that of the city
proj4string(points) = proj4string(c.area)

# checks which points fall within the city boundary
a <- over(x = points, y = city)
output <- !is.na(a[,1])

# Filter dataset based on output
Bruges_points_C <- Bruges_points[output, ]%>%
  distinct(item, .keep_all = T)

# Bruges F = BE006L2

city_code <- "BE006L2"

city <- c.area[c.area$URAU_CODE == city_code,]

points <- SpatialPoints(Bruges_points[,3:4])

# imposes the projection of the points to be equal to that of the city
proj4string(points) = proj4string(c.area)

# checks which points fall within the city boundary
a <- over(x = points, y = city)
output <- !is.na(a[,1])

# Filter dataset based on output
Bruges_points_F <- Bruges_points[output, ]%>%
  distinct(item, .keep_all = T)

write.csv(Barcelona_points_C, "Barcelona_points_C.csv")
write.csv(Barcelona_points_K, "Barcelona_points_K.csv")
write.csv(Vienna_points_C, "Vienna_points_C.csv")
write.csv(Bruges_points_C, "Bruges_points_C.csv")
write.csv(Bruges_points_F, "Bruges_points_F.csv")

Barcelona_points_C <- read.csv("./check_wikidata/Barcelona_points_C.csv") %>%
  select(-X)
Barcelona_points_K <- read.csv("./check_wikidata/Barcelona_points_K.csv") %>%
  select(-X)
Vienna_points_C <- read.csv("./check_wikidata/Vienna_points_C.csv") %>%
  select(-X)
Bruges_points_C <- read.csv("./check_wikidata/Bruges_points_C.csv") %>%
  select(-X)
Bruges_points_F <- read.csv("./check_wikidata/Bruges_points_F.csv") %>%
  select(-X)

#### QUERY TO ALSO GET THE CATEGORIES

### Create and launch the query in RStudio

# Barcelona

city_code <- 'Q1492'
radius <- '30'

query_location_property_2(city_code, radius)

category_Barcelona <- read_property_list(city_code)

# Filter considering only points inside the city 

# Barcelona C

category_Barcelona_C <- Barcelona_points_C %>%
  select(item) %>%
  left_join(category_Barcelona, by = 'item') %>%
  distinct() %>%
  mutate(item = as.factor(item),
         category = as.factor(property))%>%
  select(-property)

# Barcelona K

category_Barcelona_K <- Barcelona_points_K %>%
  select(item) %>%
  left_join(category_Barcelona, by = 'item') %>%
  distinct()%>%
  mutate(item = as.factor(item),
         category = as.factor(property))%>%
  select(-property)

# Bruges

city_code <- 'Q12994'
radius <- '30'

query_location_property_2(city_code, radius)

category_Bruges <- read_property_list(city_code)

# Filter considering only points inside the city 

# Bruges C

category_Bruges_C <- Bruges_points_C %>%
  select(item) %>%
  left_join(category_Bruges, by = 'item') %>%
  distinct()%>%
  mutate(item = as.factor(item),
         category = as.factor(property))%>%
  select(-property)

# Bruges F

category_Bruges_F <- Bruges_points_F %>%
  select(item) %>%
  left_join(category_Bruges, by = 'item') %>%
  distinct()%>%
  mutate(item = as.factor(item),
         category = as.factor(property))%>%
  select(-property)

# Vienna

city_code <- 'Q1741'
radius <- '30'

query_location_property_2(city_code, radius)

category_Vienna <- read_property_list(city_code)

# Filter considering only points inside the city 

# Vienna C

category_Vienna_C <- Vienna_points_C %>%
  select(item) %>%
  left_join(category_Vienna, by = 'item') %>%
  distinct()%>%
  mutate(item = as.factor(item),
         category = as.factor(property))%>%
  select(-property)

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

### Starting analyzing properties/classes

### First, get the classes

# Barcelona

Barcelona_prop_id <- read_property_identifier('Q1492')
query_property_class(Barcelona_prop_id)
Barcelona_classes <- read_property_class(Barcelona_prop_id)
Barcelona_properties_classes <- link_property_class(Barcelona_prop_id, Barcelona_classes, category_Barcelona)

# Barcelona C

Barcelona_C_prop_class <- Barcelona_points_C %>%
  select(item) %>%
  left_join(Barcelona_properties_classes, by = 'item') %>%
  distinct() %>%
  mutate(item = as.factor(item),
         property = as.factor(property),
         class = as.factor(class))

# Barcelona K

Barcelona_K_prop_class <- Barcelona_points_K %>%
  select(item) %>%
  left_join(Barcelona_properties_classes, by = 'item') %>%
  distinct() %>%
  mutate(item = as.factor(item),
         property = as.factor(property),
         class = as.factor(class))

# Bruges

Bruges_prop_id <- read_property_identifier('Q12994')
query_property_class(Bruges_prop_id)
Bruges_classes <- read_property_class(Bruges_prop_id)
Bruges_properties_classes <- link_property_class(Bruges_prop_id, Bruges_classes, category_Bruges)

# Bruges C

Bruges_C_prop_class <- Bruges_points_C %>%
  select(item) %>%
  left_join(Bruges_properties_classes, by = 'item') %>%
  distinct() %>%
  mutate(item = as.factor(item),
         property = as.factor(property),
         class = as.factor(class))

# Bruges F

Bruges_F_prop_class <- Bruges_points_F %>%
  select(item) %>%
  left_join(Bruges_properties_classes, by = 'item') %>%
  distinct() %>%
  mutate(item = as.factor(item),
         property = as.factor(property),
         class = as.factor(class))

# Vienna

Vienna_prop_id <- read_property_identifier('Q1741')
query_property_class(Vienna_prop_id)
Vienna_classes <- read_property_class(Vienna_prop_id)
Vienna_properties_classes <- link_property_class(Vienna_prop_id, Vienna_classes, category_Vienna)

# Vienna C

Vienna_C_prop_class <- Vienna_points_C %>%
  select(item) %>%
  left_join(Vienna_properties_classes, by = 'item') %>%
  distinct() %>%
  mutate(item = as.factor(item),
         property = as.factor(property),
         class = as.factor(class))

### Test to link equal properties and classes

# Barcelona C

prop <- data.frame(item = Barcelona_C_prop_class$item, cat = Barcelona_C_prop_class$property)
class <- data.frame(item = Barcelona_C_prop_class$item, cat = Barcelona_C_prop_class$class)

test1 <- class %>%
  semi_join(prop, by = 'cat') %>%
  distinct(item, .keep_all = TRUE) %>%
  filter(!is.na(cat))

test <- class%>%
  left_join(test1, by = 'item')

Barcelona_C_cat_SEPTEMBER <- data.frame(item = character(), cat = character())
for (i in 1:nrow(test)) {
  item <- data.frame(item = test$item[i])
  if (is.na(test$cat.y[i])) {
    cat <- test$cat.x[i]
  } else {
    cat <- test$cat.y[i]
  }
  temp <- item %>%
    mutate(cat = cat) 
  Barcelona_C_cat_SEPTEMBER <- rbind(Barcelona_C_cat_SEPTEMBER, temp)
}

Barcelona_C_cat_SEPTEMBER <- Barcelona_C_cat_SEPTEMBER%>%
  distinct(item, .keep_all = TRUE)

# Barcelona K

prop <- data.frame(item = Barcelona_K_prop_class$item, cat = Barcelona_K_prop_class$property)
class <- data.frame(item = Barcelona_K_prop_class$item, cat = Barcelona_K_prop_class$class)

test1 <- class%>%
  semi_join(prop, by = 'cat') %>%
  distinct(item, .keep_all = TRUE) %>%
  filter(!is.na(cat))

test <- class%>%
  left_join(test1, by = 'item')

Barcelona_K_cat_SEPTEMBER <- data.frame(item = character(), cat = character())
for (i in 1:nrow(test)) {
  item <- data.frame(item = test$item[i])
  if (is.na(test$cat.y[i])) {
    cat <- test$cat.x[i]
  } else {
    cat <- test$cat.y[i]
  }
  temp <- item %>%
    mutate(cat = cat) 
  Barcelona_K_cat_SEPTEMBER <- rbind(Barcelona_K_cat_SEPTEMBER, temp)
}

Barcelona_K_cat_SEPTEMBER <- Barcelona_K_cat_SEPTEMBER%>%
  distinct(item, .keep_all = TRUE)

# Bruges C

prop <- data.frame(item = Bruges_C_prop_class$item, cat = Bruges_C_prop_class$property)
class <- data.frame(item = Bruges_C_prop_class$item, cat = Bruges_C_prop_class$class)

test1 <- class%>%
  semi_join(prop, by = 'cat') %>%
  distinct(item, .keep_all = TRUE) %>%
  filter(!is.na(cat))

test <- class%>%
  left_join(test1, by = 'item')

Bruges_C_cat_SEPTEMBER <- data.frame(item = character(), cat = character())
for (i in 1:nrow(test)) {
  item <- data.frame(item = test$item[i])
  if (is.na(test$cat.y[i])) {
    cat <- test$cat.x[i]
  } else {
    cat <- test$cat.y[i]
  }
  temp <- item %>%
    mutate(cat = cat) 
  Bruges_C_cat_SEPTEMBER <- rbind(Bruges_C_cat_SEPTEMBER, temp)
}

Bruges_C_cat_SEPTEMBER <- Bruges_C_cat_SEPTEMBER%>%
  distinct(item, .keep_all = TRUE)

# Bruges F

prop <- data.frame(item = Bruges_F_prop_class$item, cat = Bruges_F_prop_class$property)
class <- data.frame(item = Bruges_F_prop_class$item, cat = Bruges_F_prop_class$class)

test1 <- class%>%
  semi_join(prop, by = 'cat') %>%
  distinct(item, .keep_all = TRUE) %>%
  filter(!is.na(cat))

test <- class%>%
  left_join(test1, by = 'item')

Bruges_F_cat_SEPTEMBER <- data.frame(item = character(), cat = character())
for (i in 1:nrow(test)) {
  item <- data.frame(item = test$item[i])
  if (is.na(test$cat.y[i])) {
    cat <- test$cat.x[i]
  } else {
    cat <- test$cat.y[i]
  }
  temp <- item %>%
    mutate(cat = cat) 
  Bruges_F_cat_SEPTEMBER <- rbind(Bruges_F_cat_SEPTEMBER, temp)
}

Bruges_F_cat_SEPTEMBER <- Bruges_F_cat_SEPTEMBER%>%
  distinct(item, .keep_all = TRUE)

# Vienna C

prop <- data.frame(item = Vienna_C_prop_class$item, cat = Vienna_C_prop_class$property)
class <- data.frame(item = Vienna_C_prop_class$item, cat = Vienna_C_prop_class$class)

test1 <- class%>%
  semi_join(prop, by = 'cat') %>%
  distinct(item, .keep_all = TRUE) %>%
  filter(!is.na(cat))

test <- class%>%
  left_join(test1, by = 'item')

Vienna_C_cat_SEPTEMBER <- data.frame(item = character(), cat = character())
for (i in 1:nrow(test)) {
  item <- data.frame(item = test$item[i])
  if (is.na(test$cat.y[i])) {
    cat <- test$cat.x[i]
  } else {
    cat <- test$cat.y[i]
  }
  temp <- item %>%
    mutate(cat = cat) 
  Vienna_C_cat_SEPTEMBER <- rbind(Vienna_C_cat_SEPTEMBER, temp)
}

Vienna_C_cat_SEPTEMBER <- Vienna_C_cat_SEPTEMBER%>%
  distinct(item, .keep_all = TRUE)
