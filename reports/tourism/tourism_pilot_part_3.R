library(dplyr)
library(jsonlite)
library(stringr)
library(leaflet)
library(htmlwidgets)
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

### Starting analyzing properties/classes

### First, get the classes

# Barcelona

Barcelona_prop_id <- read_property_identifier('Q1492')
Barcelona_classes <- read_property_class(Barcelona_prop_id)
Barcelona_properties_classes <- link_property_class(Barcelona_prop_id, Barcelona_classes, category_Barcelona)

# Barcelona C

Barcelona_C_prop_class <- read.csv('./data_using_wikidata/pageviews/Barcelona_pw_coord_C.csv') %>%
  select(item) %>%
  left_join(Barcelona_properties_classes, by = 'item') %>%
  distinct() %>%
  mutate(item = as.factor(item),
         property = as.factor(property),
         class = as.factor(class))

write.csv(Barcelona_C_prop_class, './data_using_wikidata/properties_classes/properties_classes_Q1492_C.csv')

# Barcelona K

Barcelona_K_prop_class <- read.csv('./data_using_wikidata/pageviews/Barcelona_pw_coord_K.csv') %>%
  select(item) %>%
  left_join(Barcelona_properties_classes, by = 'item') %>%
  distinct() %>%
  mutate(item = as.factor(item),
         property = as.factor(property),
         class = as.factor(class))

write.csv(Barcelona_K_prop_class, './data_using_wikidata/properties_classes/properties_classes_Q1492_K.csv')

# Bruges

Bruges_prop_id <- read_property_identifier('Q12994')
query_property_class(Bruges_prop_id)
Bruges_classes <- read_property_class(Bruges_prop_id)
Bruges_properties_classes <- link_property_class(Bruges_prop_id, Bruges_classes, category_Bruges)

# Bruges C

Bruges_C_prop_class <- read.csv('./data_using_wikidata/pageviews/Bruges_pw_coord_C.csv') %>%
  select(item) %>%
  left_join(Bruges_properties_classes, by = 'item') %>%
  distinct() %>%
  mutate(item = as.factor(item),
         property = as.factor(property),
         class = as.factor(class))

write.csv(Bruges_C_prop_class, './data_using_wikidata/properties_classes/properties_classes_Q12994_C.csv')

# Bruges F

Bruges_F_prop_class <- read.csv('./data_using_wikidata/pageviews/Bruges_pw_coord_F.csv') %>%
  select(item) %>%
  left_join(Bruges_properties_classes, by = 'item') %>%
  distinct() %>%
  mutate(item = as.factor(item),
         property = as.factor(property),
         class = as.factor(class))

write.csv(Bruges_F_prop_class, './data_using_wikidata/properties_classes/properties_classes_Q12994_F.csv')

# Vienna

Vienna_prop_id <- read_property_identifier('Q1741')
query_property_class(Vienna_prop_id)
Vienna_classes <- read_property_class(Vienna_prop_id)
Vienna_properties_classes <- link_property_class(Vienna_prop_id, Vienna_classes, category_Vienna)

# Vienna C

Vienna_C_prop_class <- read.csv('./data_using_wikidata/pageviews/Vienna_pw_coord_C.csv') %>%
  select(item) %>%
  left_join(Vienna_properties_classes, by = 'item') %>%
  distinct() %>%
  mutate(item = as.factor(item),
         property = as.factor(property),
         class = as.factor(class))

write.csv(Vienna_C_prop_class, './data_using_wikidata/properties_classes/properties_classes_Q1741_C.csv')

### Then, join with pageviews and group by classes 
### Note that here we will take the first property and the first class that appear in the dataframe

# Barcelona C

Barcelona_C_group_classes <- Barcelona_C %>%
  left_join(Barcelona_C_prop_class, by = 'item') %>%
  distinct(item) %>%
  filter(!is.na(class))%>%
  group_by(class)%>%
  summarise(value = sum(value)) %>%
  arrange(desc(value))
  
Barcelona_C_group_classes[1:10,]

# Barcelona K

Barcelona_K_group_classes <- Barcelona_K %>%
  left_join(Barcelona_K_prop_class, by = 'item') %>%
  distinct(item) %>%
  filter(!is.na(class))%>%
  group_by(class)%>%
  summarise(value = sum(value)) %>%
  arrange(desc(value))

Barcelona_K_group_classes[1:10,]
  
# Bruges C

Bruges_C_group_classes <- Bruges_C %>%
  left_join(Bruges_C_prop_class, by = 'item') %>%
  distinct(item) %>%
  filter(!is.na(class))%>%
  group_by(class)%>%
  summarise(value = sum(value)) %>%
  arrange(desc(value))

Bruges_C_group_classes[1:10,]

# Bruges F

Bruges_F_group_classes <- Bruges_F %>%
  left_join(Bruges_F_prop_class, by = 'item') %>%
  distinct(item) %>%
  filter(!is.na(class))%>%
  group_by(class)%>%
  summarise(value = sum(value)) %>%
  arrange(desc(value))

Bruges_F_group_classes[1:10,]

# Vienna C

Vienna_C_group_classes <- Vienna_C %>%
  left_join(Vienna_C_prop_class, by = 'item') %>%
  distinct(item) %>%
  filter(!is.na(class))%>%
  group_by(class)%>%
  summarise(value = sum(value)) %>%
  arrange(desc(value))

Vienna_C_group_classes[1:10,]

### Test to link equal properties and classes

# Barcelona C

prop <- data.frame(item = Barcelona_C_prop_class$item, cat = Barcelona_C_prop_class$property)
class <- data.frame(item = Barcelona_C_prop_class$item, cat = Barcelona_C_prop_class$class)

test1 <- class%>%
  semi_join(prop, by = 'cat') %>%
  distinct(item) %>%
  filter(!is.na(cat))

test <- class%>%
  left_join(test1, by = 'item')

Barcelona_C_cat <- data.frame(item = character(), cat = character())
for (i in 1:nrow(test)) {
  item <- data.frame(item = test$item[i])
  if (is.na(test$cat.y[i])) {
    cat <- test$cat.x[i]
    } else {
    cat <- test$cat.y[i]
    }
  temp <- item %>%
    mutate(cat = cat) 
  Barcelona_C_cat <- rbind(Barcelona_C_cat, temp)
}

Barcelona_C_cat <- Barcelona_C_cat%>%
  distinct(item)

# Compute top ten categories

Barcelona_C_link <- Barcelona_C %>%
  left_join(Barcelona_C_cat, by = 'item') %>%
  distinct(item) %>%
  filter(!is.na(cat))%>%
  group_by(cat)%>%
  summarise(value = sum(value)) %>%
  arrange(desc(value))

# Barcelona K

prop <- data.frame(item = Barcelona_K_prop_class$item, cat = Barcelona_K_prop_class$property)
class <- data.frame(item = Barcelona_K_prop_class$item, cat = Barcelona_K_prop_class$class)

test1 <- class%>%
  semi_join(prop, by = 'cat') %>%
  distinct(item) %>%
  filter(!is.na(cat))

test <- class%>%
  left_join(test1, by = 'item')

Barcelona_K_cat <- data.frame(item = character(), cat = character())
for (i in 1:nrow(test)) {
  item <- data.frame(item = test$item[i])
  if (is.na(test$cat.y[i])) {
    cat <- test$cat.x[i]
  } else {
    cat <- test$cat.y[i]
  }
  temp <- item %>%
    mutate(cat = cat) 
  Barcelona_K_cat <- rbind(Barcelona_K_cat, temp)
}

Barcelona_K_cat <- Barcelona_K_cat%>%
  distinct(item)

# Compute top ten categories

Barcelona_K_link <- Barcelona_K %>%
  left_join(Barcelona_K_cat, by = 'item') %>%
  distinct(item) %>%
  filter(!is.na(cat))%>%
  group_by(cat)%>%
  summarise(value = sum(value)) %>%
  arrange(desc(value))


# Bruges C

prop <- data.frame(item = Bruges_C_prop_class$item, cat = Bruges_C_prop_class$property)
class <- data.frame(item = Bruges_C_prop_class$item, cat = Bruges_C_prop_class$class)

test1 <- class%>%
  semi_join(prop, by = 'cat') %>%
  distinct(item) %>%
  filter(!is.na(cat))

test <- class%>%
  left_join(test1, by = 'item')

Bruges_C_cat <- data.frame(item = character(), cat = character())
for (i in 1:nrow(test)) {
  item <- data.frame(item = test$item[i])
  if (is.na(test$cat.y[i])) {
    cat <- test$cat.x[i]
  } else {
    cat <- test$cat.y[i]
  }
  temp <- item %>%
    mutate(cat = cat) 
  Bruges_C_cat <- rbind(Bruges_C_cat, temp)
}

Bruges_C_cat <- Bruges_C_cat%>%
  distinct(item)

# Compute top ten categories

Bruges_C_link <- Bruges_C %>%
  left_join(Bruges_C_cat, by = 'item') %>%
  distinct(item) %>%
  filter(!is.na(cat))%>%
  group_by(cat)%>%
  summarise(value = sum(value)) %>%
  arrange(desc(value))


# Bruges F

prop <- data.frame(item = Bruges_F_prop_class$item, cat = Bruges_F_prop_class$property)
class <- data.frame(item = Bruges_F_prop_class$item, cat = Bruges_F_prop_class$class)

test1 <- class%>%
  semi_join(prop, by = 'cat') %>%
  distinct(item) %>%
  filter(!is.na(cat))

test <- class%>%
  left_join(test1, by = 'item')

Bruges_F_cat <- data.frame(item = character(), cat = character())
for (i in 1:nrow(test)) {
  item <- data.frame(item = test$item[i])
  if (is.na(test$cat.y[i])) {
    cat <- test$cat.x[i]
  } else {
    cat <- test$cat.y[i]
  }
  temp <- item %>%
    mutate(cat = cat) 
  Bruges_F_cat <- rbind(Bruges_F_cat, temp)
}

Bruges_F_cat <- Bruges_F_cat%>%
  distinct(item)

# Compute top ten categories

Bruges_F_link <- Bruges_F %>%
  left_join(Bruges_F_cat, by = 'item') %>%
  distinct(item) %>%
  filter(!is.na(cat))%>%
  group_by(cat)%>%
  summarise(value = sum(value)) %>%
  arrange(desc(value))

# Vienna C

prop <- data.frame(item = Vienna_C_prop_class$item, cat = Vienna_C_prop_class$property)
class <- data.frame(item = Vienna_C_prop_class$item, cat = Vienna_C_prop_class$class)

test1 <- class%>%
  semi_join(prop, by = 'cat') %>%
  distinct(item) %>%
  filter(!is.na(cat))

test <- class%>%
  left_join(test1, by = 'item')

Vienna_C_cat <- data.frame(item = character(), cat = character())
for (i in 1:nrow(test)) {
  item <- data.frame(item = test$item[i])
  if (is.na(test$cat.y[i])) {
    cat <- test$cat.x[i]
  } else {
    cat <- test$cat.y[i]
  }
  temp <- item %>%
    mutate(cat = cat) 
  Vienna_C_cat <- rbind(Vienna_C_cat, temp)
}

Vienna_C_cat <- Vienna_C_cat%>%
  distinct(item)

# Compute top ten categories

Vienna_C_link <- Vienna_C %>%
  left_join(Vienna_C_cat, by = 'item') %>%
  distinct(item) %>%
  filter(!is.na(cat))%>%
  group_by(cat)%>%
  summarise(value = sum(value)) %>%
  arrange(desc(value))
