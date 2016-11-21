# TOURISM PILOT (PART 6)

# Work with tourism data

### Compare shapefiles from Urban Audit to the ones from Statistical offices

library(sp)
library(rgdal)

Barcelona_tourism = readOGR(dsn = "./tourism data/Barcelona/Barcelona shapefiles", layer = "L%C3%ADmit%20de%20terme%20municipal")
Urban_audit = readOGR(dsn = "./URAU-2011-2014-SH/Urban_audit_2011_2014_SH", layer = "URAU_RG_100K_2011_2014")

city_code <- "ES002C1"
Barcelona_urban_audit <- Urban_audit[Urban_audit$URAU_CODE == city_code,]

a <- over(x = Barcelona_urban_audit, y = Barcelona_tourism)
output <- !is.na(a[,1])

plot(Barcelona_urban_audit)
plot(Barcelona_tourism)
plot(Barcelona_tourism[output,], col = "red", add = TRUE)

# CAN'T CHANGE PROJECTION OF BARCELONA TOURISM!
proj4string(Barcelona_tourism) = proj4string(Barcelona_urban_audit) 
Barcelona_tourism <- spTransform(Barcelona_tourism, "+proj=longlat +ellps=GRS80 +no_defs")

Vienna_tourism = readOGR(dsn = "./tourism data/Vienna/GEONAMENOGD", layer = "GEONAMENOGDPoint")
city_code <- "AT001C1"
Vienna_urban_audit <- Urban_audit[Urban_audit$URAU_CODE == city_code,]

Vienna_tourism <- spTransform(Vienna_tourism, "+proj=longlat +ellps=GRS80 +no_defs")
proj4string(Vienna_tourism) = proj4string(Vienna_urban_audit) 

b <- over(x = Vienna_urban_audit, y = Vienna_tourism)
output <- !is.na(b[,1])

plot(Vienna_urban_audit)
plot(Vienna_tourism, add = TRUE)
plot(Vienna_tourism[output,], col = "red", add = TRUE)

city_code <- "BE006L2"
Bruges_urban_audit <- Urban_audit[Urban_audit$URAU_CODE == city_code,]

plot(Bruges_urban_audit)

Bruges_tourism = readOGR(dsn = "./tourism data/Bruges/scbel01012011_gen13_tcm327-275679", layer = "scbel01012011_gen13")
plot(Bruges_tourism)

city_code <- "BRUGGE"
Bruges_tourism2 <- Bruges_tourism[Bruges_tourism$Gemeente == city_code, ]

plot(Bruges_tourism2)



# Check official points from Vienna

library(stringr)

Vienna_official_points <- read.csv('./tourism_data/Vienna/GEONAMENOGD.csv') %>%
  select(OBJECTID, SHAPE, FEATURENAME, NAMECAT, NAMECAT_NAME) %>%
  mutate(long2 = gsub('POINT ', '', SHAPE),
         lat2 = gsub('POINT ', '', SHAPE)) %>%
  select(-SHAPE) %>%
  mutate(long = as.numeric(substr(long2, regexpr("\\(", long2)+1, regexpr(" ", long2)-1)), 
         lat = as.numeric(substr(lat2, regexpr(" ", lat2), regexpr("\\)", lat2)-1))) %>%
  select(-long2, -lat2)

### CHANGE PROJECTION TO SEE IF THEY MATCH TO THE POINTS WE HAVE



library(fuzzyjoin)

Vienna_join <- Vienna_C %>%
  left_join(Vienna_articles_in_C, by = 'item') %>%
  geo_left_join(Vienna_official_points) %>%
  distinct(item, .keep_all = TRUE) %>%
  select(item, article, OBJECTID, FEATURENAME, NAMECAT_NAME)

write.csv(Vienna_join, "Vienna_join.csv")

# try the other way round

Vienna_titles <- Vienna_C %>%
  left_join(Vienna_articles_in_C, by = 'item')

Vienna_join_OPPOSITE <- Vienna_official_points %>%
  geo_left_join(Vienna_titles) %>%
  distinct(OBJECTID, .keep_all = TRUE) %>%
  select(OBJECTID, FEATURENAME, NAMECAT_NAME, item, article)

write.csv(Vienna_join_OPPOSITE, "Vienna_join_OPPOSITE.csv")

write.csv(Vienna_official_points, "Vienna_official.csv")

# upload Albrecht's join file

Vienna_geo_join <- read.csv("ViennaNear.txt", sep = ",")

# Rejoin with article's name in German first

Vienna_articles_in_C_DE <- Vienna_articles_in_C %>%
  filter(lang == "de") %>%
  full_join(Vienna_articles_in_C, by = 'item') 

names(Vienna_articles_in_C_DE) <- c("item", "articlex", "langx", "articley", "langy")

Vienna_articles_DE <- data.frame(item = character(), article = character(), lang = character())
for (i in 1:nrow(Vienna_articles_in_C_DE)) {
  item <- data.frame(item = Vienna_articles_in_C_DE$item[i])
  if (!is.na(Vienna_articles_in_C_DE$langx[i])) {
    article <- Vienna_articles_in_C_DE$articlex[i]
    lang <- Vienna_articles_in_C_DE$langx[i]
  } else {
    article <- Vienna_articles_in_C_DE$articley[i]
    lang <- Vienna_articles_in_C_DE$langy[i]
  }
  temp <- item %>%
    mutate(article = article, lang = lang)
  Vienna_articles_DE <- rbind(Vienna_articles_DE, temp)
}


Vienna_articles_DE <- Vienna_articles_DE%>%
  distinct(item, .keep_all = T)

# Join with items dataset

Vienna_string_join <- Vienna_C %>%
  left_join(Vienna_articles_DE, by = 'item') 

write.csv(Vienna_string_join, "Vienna_wiki_points.csv", fileEncoding = "UTF-8")

# Join with geo distance dataset

Vienna_total_join <- Vienna_geo_join %>%
  select(-article, -lang, -value, -lat, -long, -long_1, -lat_1) %>%
  left_join(Vienna_string_join, by = "item") %>%
  mutate(lang = as.factor(lang))


# Compute string distance with German

library(stringdist)

Vienna_total_join$stringdist <- stringdist(Vienna_total_join$FEATURENAME, Vienna_total_join$article)

Vienna_total_join$cat_stringdist <- stringdist(Vienna_total_join$NAMECAT_NAME, Vienna_total_join$article)

write.csv(Vienna_total_join, "Vienna_total_join.csv")

# Select a training dataset with all categories

training_data <- Vienna_total_join %>%
  distinct(NAMECAT_NAME, .keep_all = T) %>%
  select(IN_FID)%>%
  left_join(Vienna_total_join)

write.csv(training_data, "training_data.csv")

### AFTER THIS, I'VE CHECKED MANUALLY THE MATCHING OF A SAMPLE OF POINTS AND THEN I WILL RELOAD THE FILE

# Load new training data

training_data_post <- read.delim("C:/Users/signose/Desktop/training_data_Y_N.txt", header = T,  sep = ";", stringsAsFactors = F, encoding = "UTF-8")

# create samples (do NOT do this again!)

sample.ind <- sample(3, nrow(training_data_post), replace = T, prob = c(0.6, 0.2, 0.2))

training_dev <- training_data_post[sample.ind==1,]
training_val <- training_data_post[sample.ind==2,] 
TEST <- training_data_post[sample.ind==3,]

# Keep object id for each dataset (do not do this again)

OID_training_dev <- data.frame(OBJECTID = training_dev$OBJECTID, match = as.factor(gsub("\t", "", training_dev$match))) 
OID_training_val <- data.frame(OBJECTID = training_val$OBJECTID, match = as.factor(gsub("\t", "", training_val$match))) 
OID_TEST <- data.frame(OBJECTID = TEST$OBJECTID, match = as.factor(gsub("\t", "", TEST$match)))  

###
# Add new features

# check if string exist in other variable

for (i in 1:nrow(Vienna_total_join)) {
  Vienna_total_join$check_name[i] <- grepl(toupper(gsub(" ", "", Vienna_total_join$FEATURENAME[i], fixed = T)), toupper(gsub(" ", "", Vienna_total_join$article[i], fixed = T)))
}

for (i in 1:nrow(Vienna_total_join)) {
  Vienna_total_join$check_article[i] <- grepl(toupper(gsub(" ", "", Vienna_total_join$article[i], fixed = T)), toupper(gsub(" ", "", Vienna_total_join$FEATURENAME[i], fixed = T)))
}

for (i in 1:nrow(Vienna_total_join)) {
  Vienna_total_join$check_category[i] <- grepl(toupper(gsub(" ", "", Vienna_total_join$NAMECAT_NAME[i], fixed = T)), toupper(gsub(" ", "", Vienna_total_join$article[i], fixed = T)))
}

# add synonym variable to category variable and compute check variable 

for (i in 1:nrow(Vienna_total_join)) {
  if (Vienna_total_join$NAMECAT_NAME[i] == "Spital, Pflegeheim") {
    Vienna_total_join$NAMECAT_NAME_SYNONYM[i] <- paste(Vienna_total_join$NAMECAT_NAME[i], " Krankenhaus, Krankenanstalt", sep = ",")
  } else if (Vienna_total_join$NAMECAT_NAME[i] == "Bahnhof") {
    Vienna_total_join$NAMECAT_NAME_SYNONYM[i] <- paste(Vienna_total_join$NAMECAT_NAME[i], " Haltestelle", sep = ",")
  } else {
    Vienna_total_join$NAMECAT_NAME_SYNONYM[i] <- Vienna_total_join$NAMECAT_NAME[i]
  }
}

for (i in 1:nrow(Vienna_total_join)) {
  Vienna_total_join$check_cat_synonym[i] <- grepl(toupper(gsub(" ", "", Vienna_total_join$NAMECAT_NAME_SYNONYM[i], fixed = T)), toupper(gsub(" ", "", Vienna_total_join$article[i], fixed = T)))
}

# compute stringdist from synonym (with and with no brackets)

Vienna_total_join$cat_synonym_stringdist <- stringdist(Vienna_total_join$NAMECAT_NAME_SYNONYM, Vienna_total_join$article)

Vienna_total_join$cat_synonym_stringdist_no_brackets <- stringdist(Vienna_total_join$NAMECAT_NAME_SYNONYM, gsub("\\s*\\([^\\)]+\\)","",as.character(Vienna_total_join$article)))


# no brackets

Vienna_total_join$stringdist_no_brackets <- stringdist(Vienna_total_join$FEATURENAME, gsub("\\s*\\([^\\)]+\\)","",as.character(Vienna_total_join$article)))
Vienna_total_join$cat_stringdist_no_brackets <- stringdist(Vienna_total_join$NAMECAT_NAME, gsub("\\s*\\([^\\)]+\\)","",as.character(Vienna_total_join$article)))

# cross check of more than one word and compute index

for (i in 1:nrow(Vienna_total_join)) {
  a <- unlist(strsplit(Vienna_total_join$FEATURENAME[i], " "))
  a <- unlist(strsplit(a, "-"))
  b <- unlist(strsplit(Vienna_total_join$article[i], " "))
  b <- unlist(strsplit(b, "-"))
  c <- toupper(b) %in% toupper(a)
  Vienna_total_join$multiple_match[i] <- sum(c)
}

# cross check of more than one word and compute index for categories

for (i in 1:nrow(Vienna_total_join)) {
  a <- unlist(strsplit(Vienna_total_join$NAMECAT_NAME[i], ", "))
  b <- unlist(strsplit(Vienna_total_join$article[i], " "))
  b <- unlist(strsplit(b, "-"))
  c <- toupper(b) %in% toupper(a)
  Vienna_total_join$multiple_match_cat[i] <- sum(c)
}

for (i in 1:nrow(Vienna_total_join)) {
  a <- unlist(strsplit(Vienna_total_join$NAMECAT_NAME_SYNONYM[i], ", "))
  b <- unlist(strsplit(Vienna_total_join$article[i], " "))
  b <- unlist(strsplit(b, "-"))
  c <- toupper(b) %in% toupper(a)
  Vienna_total_join$multiple_match_cat_synonym[i] <- sum(c)
}

# use stem

library(SnowballC)
library(stringdist)
library(tm)

for (i in 1:nrow(Vienna_total_join)) {
  if (Vienna_total_join$lang[i]=="de") {
    a <- unlist(strsplit(Vienna_total_join$article[i], " "))
    c <- stemDocument(a, language = "german")
    f <- paste(c, collapse = " ")
    b <- unlist(strsplit(Vienna_total_join$FEATURENAME[i], " "))
    d <- stemDocument(b, language = "german")
    g <- paste(d, collapse = " ")
    Vienna_total_join$stem_stringdist[i] <- stringdist(f, g)
  } else {
    Vienna_total_join$stem_stringdist[i] <- Vienna_total_join$stringdist[i]
  }
}

for (i in 1:nrow(Vienna_total_join)) {
  if (Vienna_total_join$lang[i]=="de") {
    a <- unlist(strsplit(Vienna_total_join$article[i], " "))
    c <- stemDocument(a, language = "german")
    f <- paste(c, collapse = " ")
    b <- unlist(strsplit(Vienna_total_join$NAMECAT_NAME[i], ", "))
    d <- stemDocument(b, language = "german")
    g <- paste(d, collapse = " ")
    Vienna_total_join$stem_cat_stringdist[i] <- stringdist(f, g)
  } else {
    Vienna_total_join$stem_cat_stringdist[i] <- Vienna_total_join$cat_stringdist[i]
  }
}

for (i in 1:nrow(Vienna_total_join)) {
  if (Vienna_total_join$lang[i]=="de") {
    a <- unlist(strsplit(Vienna_total_join$article[i], " "))
    c <- stemDocument(a, language = "german")
    f <- paste(c, collapse = " ")
    b <- unlist(strsplit(Vienna_total_join$NAMECAT_NAME_SYNONYM[i], ", "))
    d <- stemDocument(b, language = "german")
    g <- paste(d, collapse = " ")
    Vienna_total_join$stem_cat_synonym_stringdist[i] <- stringdist(f, g)
  } else {
    Vienna_total_join$stem_cat_synonym_stringdist[i] <- Vienna_total_join$cat_synonym_stringdist[i]
  }
}

# stem + multiple match

for (i in 1:nrow(Vienna_total_join)) {
  if (Vienna_total_join$lang[i]=="de") {
    a <- unlist(strsplit(Vienna_total_join$article[i], " "))
    a <- unlist(strsplit(a, "-"))
    c <- stemDocument(a, language = "german")
    b <- unlist(strsplit(Vienna_total_join$FEATURENAME[i], " "))
    b <- unlist(strsplit(b, "-"))
    d <- stemDocument(b, language = "german")
    e <- toupper(c) %in% toupper(d)
    Vienna_total_join$stem_multiple_match[i] <- sum(e)
  } else {
    Vienna_total_join$stem_multiple_match[i] <- Vienna_total_join$multiple_match[i]
  }
}

for (i in 1:nrow(Vienna_total_join)) {
  if (Vienna_total_join$lang[i]=="de") {
    a <- unlist(strsplit(Vienna_total_join$article[i], " "))
    a <- unlist(strsplit(a, "-"))
    c <- stemDocument(a, language = "german")
    b <- unlist(strsplit(Vienna_total_join$NAMECAT_NAME[i], ", "))
    d <- stemDocument(b, language = "german")
    e <- toupper(c) %in% toupper(d)
    Vienna_total_join$stem_multiple_match_cat[i] <- sum(e)
  } else {
    Vienna_total_join$stem_multiple_match_cat[i] <- Vienna_total_join$multiple_match_cat[i]
  }
}

for (i in 1:nrow(Vienna_total_join)) {
  if (Vienna_total_join$lang[i]=="de") { 
    a <- unlist(strsplit(Vienna_total_join$article[i], " "))
    a <- unlist(strsplit(a, "-"))
    c <- stemDocument(a, language = "german")
    b <- unlist(strsplit(Vienna_total_join$NAMECAT_NAME_SYNONYM[i], ", "))
    d <- stemDocument(b, language = "german")
    e <- toupper(c) %in% toupper(d)
    Vienna_total_join$stem_multiple_match_cat_synonym[i] <- sum(e)
  } else {
    Vienna_total_join$stem_multiple_match_cat_synonym[i] <- Vienna_total_join$multiple_match_cat_synonym[i]
  }
}

# add summary features

for (i in 1:nrow(Vienna_total_join)) {
  Vienna_total_join$summary_stringdist[i] <- min(Vienna_total_join$stringdist[i], 
                                                 Vienna_total_join$cat_stringdist[i], 
                                                 Vienna_total_join$cat_synonym_stringdist[i])
}

for (i in 1:nrow(Vienna_total_join)) {
  Vienna_total_join$summary_stringdist_no_brackets[i] <- min(Vienna_total_join$stringdist_no_brackets[i], 
                                                             Vienna_total_join$cat_stringdist_no_brackets[i], 
                                                             Vienna_total_join$cat_synonym_stringdist_no_brackets[i])
}

for (i in 1:nrow(Vienna_total_join)) {
  Vienna_total_join$summary_stem_stringdist[i] <- min(Vienna_total_join$stem_stringdist[i], 
                                                      Vienna_total_join$stem_cat_stringdist[i], 
                                                      Vienna_total_join$stem_cat_synonym_stringdist[i])
}

for (i in 1:nrow(Vienna_total_join)) {
  Vienna_total_join$summary_check[i] <- sum(Vienna_total_join$check_name[i] == T, Vienna_total_join$check_article[i] == T, 
                                            Vienna_total_join$check_category[i] == T, Vienna_total_join$check_cat_synonym[i] == T)
}

for (i in 1:nrow(Vienna_total_join)) {
  Vienna_total_join$summary_multiple_match[i] <- sum(Vienna_total_join$multiple_match[i], 
                                                     Vienna_total_join$multiple_match_cat[i], 
                                                     Vienna_total_join$multiple_match_cat_synonym[i])
}

for (i in 1:nrow(Vienna_total_join)) {
  Vienna_total_join$summary_stem_multiple_match[i] <- sum(Vienna_total_join$stem_multiple_match[i], 
                                                          Vienna_total_join$stem_multiple_match_cat[i], 
                                                          Vienna_total_join$stem_multiple_match_cat_synonym[i])
}


Vienna_total_join$check_name <- as.factor(Vienna_total_join$check_name)
Vienna_total_join$check_category <- as.factor(Vienna_total_join$check_category)
Vienna_total_join$check_article <- as.factor(Vienna_total_join$check_article)
Vienna_total_join$check_cat_synonym <- as.factor(Vienna_total_join$check_cat_synonym)

###############  

# Divide the datasets

library(dplyr)

obj <- rbind(OID_TEST, OID_training_val, OID_training_dev)
tra <- rbind(OID_training_val, OID_training_dev)

Vienna_to_predict <- Vienna_total_join %>%
  anti_join(obj, by = "OBJECTID", .keep_all = T)

training_total <- tra %>%
  left_join(Vienna_total_join, by = c("OBJECTID"), .keep_all = T)

TEST_post <- OID_TEST %>%
  left_join(Vienna_total_join, by = "OBJECTID", .keep_all = T)

# Build random forest

sample.ind <- sample(2, nrow(training_total), replace = T, prob = c(0.7, 0.3))

training_dev_final <- training_total[sample.ind==1,]
training_val_final <- training_total[sample.ind==2,] 

library(randomForest)

training_rf <- randomForest(match ~ NEAR_DIST + 
                              summary_stringdist + summary_stringdist_no_brackets + summary_stem_stringdist +
                              summary_check + summary_multiple_match + summary_stem_multiple_match, 
                            training_dev_final, ntree = 500, importance = T)

plot(training_rf)

var.imp <- data.frame(importance(training_rf, type = 2))
var.imp$Variables <- row.names(var.imp)
var.imp[order(var.imp$MeanDecreaseGini, decreasing = T ),]

training_dev_final$predicted.response <- predict(training_rf, training_dev_final)

library(e1071)
library(caret)

confusionMatrix(data = training_dev_final$predicted.response, 
                reference = training_dev_final$match, 
                positive = "YES")

training_val_final$predicted.response <- predict(training_rf, training_val_final)

confusionMatrix(data = training_val_final$predicted.response,
                reference = training_val_final$match,
                positive = "YES")

# Test data (to be done just one time!!!)

TEST$predicted.response <- predict(training_rf, TEST)

confusionMatrix(data = TEST$predicted.response,
                reference = TEST$match,
                positive = "YES")

# Predict on the whole dataset

Vienna_to_predict$predicted.response <- predict(training_rf, Vienna_to_predict)

write.csv(Vienna_to_predict, "Vienna_to_predict.csv", fileEncoding = "UTF-8")
write.csv(training_total, "training_total.csv", fileEncoding = "UTF-8")
write.csv(TEST_post, "TEST_post.csv", fileEncoding = "UTF-8")

### Now I continue working on the Sandbox

Vienna_to_predict <- read.csv("./data_using_wikidata/random_forest/results/Vienna_to_predict.csv", encoding = "UTF-8") %>%
  select(-X)

training_total <- read.csv("./data_using_wikidata/random_forest/results/training_total.csv", encoding = "UTF-8") %>%
  select(-X)

TEST_post <- read.csv("./data_using_wikidata/random_forest/results/TEST_post.csv", encoding = "UTF-8") %>%
  select(-X)

# Verify how many matches we have

Vienna_YES <- Vienna_to_predict %>%
  filter(predicted.response == "YES") %>%
  distinct(item, .keep_all = T)

Vienna_YES_levels <- levels(Vienna_YES$NAMECAT_NAME)

write.csv(Vienna_YES, "Vienna_YES.csv", fileEncoding = "UTF-8")

# 796 points (over 2663, nearly 30% of Vienna Wikidata items)
# In this group we have 35 categories (the total was 44)

Vienna_YES <- read.csv("./data_using_wikidata/random_forest/results/Vienna_YES.csv", encoding = "UTF-8") %>%
  select(-X) 

# we build a map with official points, wiki points and matches (leaflet does not work on Sandbox)

Vienna_official_points <- read.csv("C:/Users/signose/Desktop/Vienna_official.csv", encoding = "UTF-8") %>%
  select(-X)

Vienna_wiki_points <- read.csv("C:/Users/signose/Desktop/Vienna_wiki_points.csv", encoding = "UTF-8") %>%
  select(-X)

Vienna_match_points <- Vienna_YES %>%
  select(OBJECTID_12, FEATURENAME, NAMECAT, NAMECAT_NAME, long, lat, article, lang)

library(leaflet)
library(htmlwidgets)

pal <- colorFactor("Reds", NULL, n = 44)

# Map for Official points

# with categories
m <- leaflet(Vienna_official_points) %>%
  addProviderTiles("CartoDB.Positron")%>%
  addCircles(~long, ~lat, color = ~pal(NAMECAT_NAME), weight = 8, fillOpacity = 0.8, fillColor = ~pal(NAMECAT_NAME), radius = 100, stroke = F) %>%
  addMarkers(~long, ~lat, popup = ~FEATURENAME, options =markerOptions(opacity = 0)) %>%
  addLegend(position = c("bottomright"), colorFactor("Reds", NULL, n=44), values = ~NAMECAT_NAME, title = "Vienna official points")
m

saveWidget(widget = m, file="Vienna_official_with_cat.html", selfcontained = FALSE)

# without categories
m <- leaflet(Vienna_official_points) %>%
  addProviderTiles("CartoDB.Positron")%>%
  addCircles(~long, ~lat, color = "darkred", weight = 8, fillOpacity = 0.8, fillColor = "darkred", radius = 100, stroke = F) %>%
  addMarkers(~long, ~lat, popup = ~FEATURENAME, options =markerOptions(opacity = 0)) %>%
  addLegend(position = c("bottomright"), colors = "darkred", labels = "Point of interest", title = "Vienna official points")
m

saveWidget(widget = m, file="Vienna_official.html", selfcontained = FALSE)

# Map for Wikidata points

m <- leaflet(Vienna_wiki_points) %>%
  addProviderTiles("CartoDB.Positron")%>%
  addCircles(~long, ~lat, color = "darkred", weight = 8, fillOpacity = 0.8, fillColor = "darkred", radius = 100, stroke = F) %>%
  addMarkers(~long, ~lat, popup = ~article, options = markerOptions(opacity = 0)) %>%
  addLegend(position = c("bottomright"), colors = "darkred", labels = "Point of interest", title = "Vienna Wikidata points")
m

saveWidget(widget = m, file="Vienna_wiki.html", selfcontained = FALSE)

# Map for match points

# with categories
m <- leaflet(Vienna_match_points) %>%
  addProviderTiles("CartoDB.Positron")%>%
  addCircles(~long, ~lat, color = ~pal(NAMECAT_NAME), weight = 8, fillOpacity = 0.8, fillColor = ~pal(NAMECAT_NAME), radius = 100, stroke = F) %>%
  addMarkers(~long, ~lat, popup = ~article, options =markerOptions(opacity = 0)) %>%
  addLegend(position = c("bottomright"), colorFactor("Reds", NULL, n=44), values = ~NAMECAT_NAME, title = "Vienna matched points")
m

saveWidget(widget = m, file="Vienna_match_with_cat.html", selfcontained = FALSE)


# without categories
m <- leaflet(Vienna_match_points) %>%
  addProviderTiles("CartoDB.Positron")%>%
  addCircles(~long, ~lat, color = "darkred", weight = 8, fillOpacity = 0.8, fillColor = "darkred", radius = 100, stroke = F) %>%
  addMarkers(~long, ~lat, popup = ~article, options = markerOptions(opacity = 0)) %>%
  addLegend(position = c("bottomright"), colors = "darkred", labels = "Point of interest", title = "Vienna matched points")
m

saveWidget(widget = m, file="Vienna_match.html", selfcontained = FALSE)

### TOPIC MODELING

library(jsonlite)
source("scripts/r/wikidata_functions.R")
source("scripts/r/redirects_target_and_origin_for_cities.R")

Vienna_articles_in_C <- Vienna_articles_in_C %>%
  mutate(wm = getWikiMarkup(article, lang))

write.csv(Vienna_articles_in_C, "Vienna_articles_in_C.csv", fileEncoding = "UTF-8")

Vienna_articles_in_C <- read.csv("./Vienna_articles_in_C.csv", encoding = "UTF-8") %>%
  select(-X) %>%
  mutate(wm = as.character(wm))

Vienna_articles_in_C_DE <- Vienna_articles_in_C %>%
  filter(lang == "de") %>%
  full_join(Vienna_articles_in_C, by = 'item') 

names(Vienna_articles_in_C_DE) <- c("item", "articlex", "langx", "wmx", "articley", "langy", "wmy")

Vienna_articles_DE <- data.frame(item = character(), article = character(), lang = character(), wm = character())
for (i in 1:nrow(Vienna_articles_in_C_DE)) {
  item <- data.frame(item = Vienna_articles_in_C_DE$item[i])
  if (!is.na(Vienna_articles_in_C_DE$langx[i])) {
    article <- Vienna_articles_in_C_DE$articlex[i]
    lang <- Vienna_articles_in_C_DE$langx[i]
    wm <- Vienna_articles_in_C_DE$wmx[i]
  } else {
    article <- Vienna_articles_in_C_DE$articley[i]
    lang <- Vienna_articles_in_C_DE$langy[i]
    wm <- Vienna_articles_in_C_DE$wmy[i]
  }
  temp <- item %>%
    mutate(article = article, lang = lang, wm = wm)
  Vienna_articles_DE <- rbind(Vienna_articles_DE, temp)
}

# divide articles by language

Vienna_DE <- Vienna_articles_DE %>%
  filter(lang == "de") %>%
  distinct(article, .keep_all = TRUE)

# exclude articles without wikimarkup

Vienna_DE <- Vienna_DE %>%
  filter(wm != "ERROR: wikimarkup missing")

# Remove history part of article

# Preprocessing of data

library(tm)

#create corpus from vector

Vienna_DE$wm <- Corpus(VectorSource(Vienna_DE$wm))

#Transform to lower case

Vienna_DE$wm <- tm_map(Vienna_DE$wm, content_transformer(tolower))

#remove potentially problematic symbols
toSpace <- content_transformer(function(x, pattern) { return (gsub(pattern, " ", x))})

Vienna_DE$wm <- tm_map(Vienna_DE$wm, toSpace, "-")
Vienna_DE$wm <- tm_map(Vienna_DE$wm, toSpace, "’")
Vienna_DE$wm <- tm_map(Vienna_DE$wm, toSpace, "‘")
Vienna_DE$wm <- tm_map(Vienna_DE$wm, toSpace, "•") 
Vienna_DE$wm <- tm_map(Vienna_DE$wm, toSpace, "“")
Vienna_DE$wm <- tm_map(Vienna_DE$wm, toSpace, "”")
Vienna_DE$wm <- tm_map(Vienna_DE$wm, toSpace, "…")
Vienna_DE$wm <- tm_map(Vienna_DE$wm, toSpace, "„")
Vienna_DE$wm <- tm_map(Vienna_DE$wm, toSpace, "€")
Vienna_DE$wm <- tm_map(Vienna_DE$wm, toSpace, "—")

#remove punctuation

Vienna_DE$wm <- tm_map(Vienna_DE$wm, removePunctuation)

#Strip digits

Vienna_DE$wm <- tm_map(Vienna_DE$wm, removeNumbers)

#remove stopwords (only for selected languages)

Vienna_DE$wm <- tm_map(Vienna_DE$wm, removeWords, stopwords("de"))

#remove whitespace

Vienna_DE$wm <- tm_map(Vienna_DE$wm, stripWhitespace)

#Good practice to check every now and then
writeLines(as.character(Vienna_DE$article[[20]]))

#Stem document

Vienna_DE$wm <- tm_map(Vienna_DE$wm, stemDocument, lang = "de")

# Remove words related to the city and the country 

myStopwords <- c("wien", "austria", "osterreich", "vienna")

Vienna_DE$wm <- tm_map(Vienna_DE$wm, removeWords, myStopwords)

write.csv(Vienna_DE, "Vienna_DE.csv")

#Create document-term matrix

dtm_DE <- DocumentTermMatrix(Vienna_DE$wm)

#convert rownames to filenames

rownames(dtm_DE) <- Vienna_DE$article

#collapse matrix by summing over columns

freq_DE <- slam::col_sums(dtm_DE, na.rm = T)

#length should be total number of terms

length(freq_DE)

#create sort order (descending)

ord_DE <- order(freq_DE,decreasing=TRUE)

#List all terms in decreasing order of freq 
freq_DE[ord_DE]

#load topic models library
library(topicmodels)

#Number of topics
k <- 45

#Run LDA using Gibbs sampling

ldaOut <-LDA(dtm_DE, k, method="Gibbs")

#write out results
#docs to topics

ldaOut.topics <- as.matrix(topics(ldaOut))

save(ldaOut, file="ldaOut45.RData")
save(ldaOut.topics, file="topics45.Rdata")

#top 6 terms in each topic
ldaOut.terms <- as.matrix(terms(ldaOut,10))

save(ldaOut.terms, file="terms45.Rdata")

# upload list of found categories

categories <- read.csv("./categoriesNEW.csv") %>%
  mutate(id = as.numeric(id), keywords = as.character(keywords), category = as.character(category))

# create list of articles with id of the category

ldaOut.topics.post <- ldaOut.topics 
rownames(ldaOut.topics.post) = NULL

ldaOut_topics<- data.frame(article = rownames(ldaOut.topics), id = ldaOut.topics.post)

# Add category to data frame of articles 

Vienna_DE_post <- data.frame(item = as.character(Vienna_DE$item), article = as.character(Vienna_DE$article), lang = as.character(Vienna_DE$lang)) %>%
  left_join(ldaOut_topics, by = "article") %>%
  mutate(id = as.numeric(id), item = as.character(item), article = as.character(article), lang = as.character(lang))

library(stringi)

Vienna_DE_post$article <- stri_trans_general(Vienna_DE_post$article, "Latin-ASCII")

# Unify the doubled categories

Vienna_DE_post$id[Vienna_DE_post$id == 22] <- 30
Vienna_DE_post$id[Vienna_DE_post$id == 11] <- 9 
Vienna_DE_post$id[Vienna_DE_post$id == 14] <- 9 
Vienna_DE_post$id[Vienna_DE_post$id == 37] <- 9 
Vienna_DE_post$id[Vienna_DE_post$id == 43] <- 9 
Vienna_DE_post$id[Vienna_DE_post$id == 19] <- 3 
Vienna_DE_post$id[Vienna_DE_post$id == 26] <- 3 
Vienna_DE_post$id[Vienna_DE_post$id == 38] <- 13 
Vienna_DE_post$id[Vienna_DE_post$id == 8] <- 7 
Vienna_DE_post$id[Vienna_DE_post$id == 15] <- 7 

# prepare keywords

keywords <- paste(categories$keywords[1], categories$keywords[2], 
                  categories$keywords[3], categories$keywords[4],
                  categories$keywords[5], categories$keywords[6],
                  categories$keywords[7], categories$keywords[8],
                  categories$keywords[9], categories$keywords[10],
                  categories$keywords[11], categories$keywords[12],
                  categories$keywords[13], categories$keywords[14],
                  categories$keywords[15], categories$keywords[16],
                  categories$keywords[17], categories$keywords[18],
                  categories$keywords[19], categories$keywords[20],
                  categories$keywords[21], categories$keywords[22], 
                  categories$keywords[23], sep = ", ")

keywords <- unlist(strsplit(keywords, " "))
keywords <- unlist(strsplit(keywords, ","))

# Fix the mixed categories (6, 16, 20, 23, 24, 25, 29, 31, 32, 36, 40, 42)

Mixed_Vienna_DE <- Vienna_DE_post %>%
  filter(id == 6 | id == 16 | id == 20 | id == 23 | id == 24 | id == 25 | id == 29 |
           id == 31 | id == 32 | id == 36 | id == 40 | id == 42)

# check if match between keywords and title of article exists

for (i in 1:nrow(Mixed_Vienna_DE)) {
  Mixed_Vienna_DE$stadion[i] <-  grepl(keywords[1], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$gemeindebau[i] <-  grepl(keywords[2], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$organisation[i] <-  grepl(keywords[3], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$ungarn[i] <-  grepl(keywords[5], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$deutsch[i] <-  grepl(keywords[6], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$gemeindebezirk[i] <-  grepl(keywords[7], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$kirch[i] <-  grepl(keywords[8], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$kapelle[i] <-  grepl(keywords[9], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$tempel[i] <-  grepl(keywords[10], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$synagog[i] <-  grepl(keywords[11], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$cafe[i] <-  grepl(keywords[12], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$kraftwerk[i] <-  grepl(keywords[13], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$gaswerk[i] <-  grepl(keywords[14], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$fabrik[i] <-  grepl(keywords[15], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$club[i] <-  grepl(keywords[16], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$hotel[i] <-  grepl(keywords[17], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$gasometer[i] <-  grepl(keywords[18], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$bahn[i] <-  grepl(keywords[19], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$haltestell[i] <-  grepl(keywords[20], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$berg[i] <-  grepl(keywords[21], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$send[i] <-  grepl(keywords[22], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$botschaft[i] <-  grepl(keywords[23], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$strass[i] <-  grepl(keywords[24], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$gasse[i] <-  grepl(keywords[25], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$platz[i] <-  grepl(keywords[26], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$bach[i] <-  grepl(keywords[27], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$park[i] <-  grepl(keywords[28], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$garten[i] <-  grepl(keywords[29], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$museum[i] <-  grepl(keywords[30], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$tower[i] <-  grepl(keywords[31], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$palais[i] <-  grepl(keywords[32], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$schloss[i] <-  grepl(keywords[33], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$villa[i] <-  grepl(keywords[34], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$kaserne[i] <-  grepl(keywords[35], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$krankenhaus[i] <-  grepl(keywords[36], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$spital[i] <-  grepl(keywords[37], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$klinik[i] <-  grepl(keywords[38], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$bibliothek[i] <-  grepl(keywords[39], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$statue[i] <-  grepl(keywords[40], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$brunn[i] <-  grepl(keywords[41], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$schul[i] <-  grepl(keywords[42], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$universitat[i] <-  grepl(keywords[43], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$gymnasium[i] <-  grepl(keywords[44], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$institut[i] <-  grepl(keywords[45], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$akademie[i] <-  grepl(keywords[46], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$bruck[i] <-  grepl(keywords[47], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$donau[i] <-  grepl(keywords[48], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$theat[i] <-  grepl(keywords[49], tolower(Mixed_Vienna_DE$article[i]))
  Mixed_Vienna_DE$friedhof[i] <-  grepl(keywords[50], tolower(Mixed_Vienna_DE$article[i]))
}

Mixed_Vienna_DE$matches <- rowSums(Mixed_Vienna_DE[,5:53])

# second round of matches (hof)

Second_mixed_Vienna_DE <- Mixed_Vienna_DE %>%
  filter(matches == 0) %>%
  select(item, article, lang, id)

for (i in 1:nrow(Second_mixed_Vienna_DE)) {
  Second_mixed_Vienna_DE$matches_2[i] <-  grepl("hof", tolower(Second_mixed_Vienna_DE$article[i]))
}

# add new category and add 99 for residual unclassified cases

for (i in 1:nrow(Second_mixed_Vienna_DE)) {
  if (Second_mixed_Vienna_DE$matches_2[i] == TRUE) {
    Second_mixed_Vienna_DE$id[i] <- 20
  } else {
    Second_mixed_Vienna_DE$id[i] <- 99
  }
}

# Add new categories

Match_1 <- Mixed_Vienna_DE %>%
  filter(matches == 1)

for (i in 1:nrow(Match_1)) {
  if (Match_1[i,5] == TRUE) {
    Match_1$id[i] <- 1
  } else if (Match_1[i,6] == TRUE) {
    Match_1$id[i] <- 2
  } else if (Match_1[i,7] == TRUE) {
    Match_1$id[i] <- 3
  } else if (Match_1[i,8] == TRUE | Match_1[i,9] == TRUE ) {
    Match_1$id[i] <- 4
  } else if (Match_1[i,10] == TRUE) {
    Match_1$id[i] <- 5
  } else if (Match_1[i,11] == TRUE | Match_1[i,12] == TRUE |
             Match_1[i,13] == TRUE | Match_1[i,14] == TRUE) {
    Match_1$id[i] <- 7
  } else if (Match_1[i,15] == TRUE | Match_1[i,16] == TRUE |
             Match_1[i,17] == TRUE | Match_1[i,18] == TRUE |
             Match_1[i,19] == TRUE | Match_1[i,20] == TRUE |
             Match_1[i,21] == TRUE ) {
    Match_1$id[i] <- 9
  } else if (Match_1[i,22] == TRUE | Match_1[i,23] == TRUE ) {
    Match_1$id[i] <- 12
  } else if (Match_1[i,24] == TRUE) {
    Match_1$id[i] <- 13
  } else if (Match_1[i,25] == TRUE) {
    Match_1$id[i] <- 17
  } else if (Match_1[i,26] == TRUE) {
    Match_1$id[i] <- 18
  } else if (Match_1[i,27] == TRUE | Match_1[i,28] == TRUE |
             Match_1[i,29] == TRUE) {
    Match_1$id[i] <- 20
  } else if (Match_1[i,30] == TRUE | Match_1[i,31] == TRUE |
             Match_1[i,32] == TRUE) {
    Match_1$id[i] <- 21
  } else if (Match_1[i,33] == TRUE) {
    Match_1$id[i] <- 27
  } else if (Match_1[i,34] == TRUE) {
    Match_1$id[i] <- 28
  } else if (Match_1[i,35] == TRUE | Match_1[i,36] == TRUE |
             Match_1[i,37] == TRUE | Match_1[i,38] == TRUE) {
    Match_1$id[i] <- 30
  } else if (Match_1[i,39] == TRUE | Match_1[i,40] == TRUE |
             Match_1[i,41] == TRUE) {
    Match_1$id[i] <- 33
  } else if (Match_1[i,42] == TRUE) {
    Match_1$id[i] <- 34
  } else if (Match_1[i,43] == TRUE | Match_1[i,44] == TRUE ) {
    Match_1$id[i] <- 35
  } else if (Match_1[i,45] == TRUE | Match_1[i,46] == TRUE |
             Match_1[i,47] == TRUE | Match_1[i,48] == TRUE |
             Match_1[i,49] == TRUE) {
    Match_1$id[i] <- 39
  } else if (Match_1[i,50] == TRUE | Match_1[i,51] == TRUE ) {
    Match_1$id[i] <- 41
  } else if (Match_1[i,52] == TRUE) {
    Match_1$id[i] <- 44
  } else if (Match_1[i,53] == TRUE) {
    Match_1$id[i] <- 45
  }
}

Match_2 <- Mixed_Vienna_DE %>%
  filter(matches > 1)

for (i in 1:nrow(Match_2)) {
  if (Match_2$palais[i] == TRUE) {
    Match_2$id[i] <- 30
  } 
}

Match_21 <- Match_2 %>%
  filter(id == 30)

Match_3 <- Match_2 %>%
  filter(id != 30)

for (i in 1:nrow(Match_3)) {
  if (Match_3$cafe[i] == TRUE | Match_3$gasometer[i] == TRUE | 
      Match_3$gaswerk[i] == TRUE) {
    Match_3$id[i] <- 9
  } else if (Match_3$gymnasium[i] == TRUE) {
    Match_3$id[i] <- 39
  } else if (Match_3$friedhof[i] == TRUE) {
    Match_3$id[i] <- 45
  } else if (Match_3$museum[i] == TRUE) {
    Match_3$id[i] <- 27
  } else if (Match_3$bibliothek[i] == TRUE) {
    Match_3$id[i] <- 34
  } else if (Match_3$theat[i] == TRUE) {
    Match_3$id[i] <- 44
  } else if (Match_3$kaserne[i] == TRUE) {
    Match_3$id[i] <- 30
  }
}

Match_3$id[Match_3$id == 31] <- 20
Match_3$id[Match_3$id == 42] <- 7

Match_31 <- Match_3 %>%
  filter(id == 7 | id == 9 | id == 34 | id == 20 | id == 27 | id == 30 | id == 39 | id == 44 | id == 45)

Match_4 <- Match_3 %>%
  filter(id != 7 & id != 9 & id != 34 & id != 20 & id != 27 & id != 30 & id != 39 & id != 44 & id != 45)

for (i in 1:nrow(Match_4)) {
  if (Match_4$synagog[i] == TRUE) {
    Match_4$id[i] <- 7
  } else if (Match_4$kraftwerk[i] == TRUE | Match_4$hotel[i] == TRUE) {
    Match_4$id[i] <- 9
  } else if (Match_4$club[i] == TRUE) {
    Match_4$id[i] <- 1
  } else if (Match_4$statue[i] == TRUE) {
    Match_4$id[i] <- 35
  }
}

Match_41 <- Match_4 %>%
  filter(id == 1 | id == 9 | id == 35 | id == 7)

Match_5 <- Match_4 %>%
  filter(id != 1 & id != 9 & id != 35 & id != 7)

#### DON'T RUN
write.csv(Match_5, "manual_match_Vienna.csv", fileEncoding = "UTF-8")

Match_5 <- read.csv("./manual_match_Vienna.csv", fileEncoding = "UTF-8") %>%
  select(-X)

# Unify all articles with classification

Vienna_final_match <- rbind(Match_1, Match_21, Match_31, Match_41, Match_5) %>%
  select(item, article, lang, id)

Vienna_final_match_2 <- Second_mixed_Vienna_DE %>%
  select(item, article, lang, id)

Vienna_final_match_3 <- Vienna_DE_post %>%
  filter(id != 6 & id != 16 & id != 20 & id != 23 & id != 24 & id != 25 & id != 29 &
           id != 31 & id != 32 & id != 36 & id != 40 & id != 42)

Vienna_matched <- rbind(Vienna_final_match, Vienna_final_match_2, Vienna_final_match_3)

Vienna_matched$id <- as.factor(Vienna_matched$id)

summary(Vienna_matched$id)

Vienna_articles_matched <- Vienna_matched %>%
  select(article, id)

Vienna_DE_nonunique <- Vienna_articles_DE %>%
  filter(lang == "de") 

Vienna_unique <- Vienna_articles_in_C %>%
  distinct(article, lang, .keep_all = T) %>%
  select(-wm) %>%
  left_join(Vienna_matched, by = "item")

summary(Vienna_unique$id)

Vienna_DE_nonunique$article <- stri_trans_general(Vienna_DE_nonunique$article, "Latin-ASCII")

Vienna_unique$article <- stri_trans_general(Vienna_unique$article, "Latin-ASCII")

Vienna_final <- Vienna_DE_nonunique %>%
  left_join(Vienna_articles_matched, by = "article") %>%
  select(-wm) %>%
  filter(!is.na(id))

Vienna_final$id[Vienna_final$item == 'Q46242'] <- 30
Vienna_final$id[Vienna_final$item == 'Q871525'] <- 4
Vienna_final$id[Vienna_final$item == 'Q686544'] <- 28
Vienna_final$id[Vienna_final$item == 'Q1180082'] <- 4
Vienna_final$id[Vienna_final$item == 'Q701633'] <- 4
Vienna_final$id[Vienna_final$item == 'Q303507'] <- 4

# Add residual category to dataframe

categories[24,] <- c(99, "Other/Unclassified", "")

# Join with pageviews file

Vienna_pageviews_article <- Vienna_final %>%
  distinct(item, .keep_all = T) %>%
  left_join(Vienna_pageviews_C, by = "item") %>%
  group_by(id) %>%
  summarise(value_id = sum(value, na.rm = T)) %>%
  left_join(categories, by = "id") %>%
  select(-keywords) %>%
  filter(id != 99)

Vienna_pageviews_article$percentage <- scales::percent(Vienna_pageviews_article$value_id/sum(Vienna_pageviews_article$value_id))

# create barchart 

library(ggplot2)

plot <- ggplot(data = Vienna_pageviews_article, aes(x = reorder(factor(category), value_id), y = value_id, fill = category)) +
  geom_bar(stat = "identity") +
  ggtitle("Number of pageviews by category - Vienna") +
  guides(fill=FALSE) +
  coord_flip() +
  xlab("") + 
  ylab("Number of pageviews")
  
plot

# Create scatterplot

scatter <- data.frame(no_articles = summary(Vienna_unique$id))
scatter <- scatter[-c(24,25),]
categ <- categories$id 
categ <- categ[-24]
value_id <- Vienna_pageviews_article$value_id

scatter_data <- data.frame(cbind(id = categ, value_id = value_id, no_articles = scatter), stringsAsFactors = F) %>%
  mutate(value_id = as.integer(value_id), 
         no_articles = as.integer(no_articles))

s <- ggplot(scatter_data, aes(x=no_articles, y=value_id)) +
  geom_point(shape=1) +    
  geom_smooth(method = "lm", se = F) +
  xlab("Number of articles") +
  ylab("Number of pageviews") +
  ggtitle("Correlation between number of articles and pageviews")
s

# Consider pageviews per category by language

Vienna_pageviews_article_language <- Vienna_unique %>%
  distinct(article.x, lang.x, .keep_all = T) %>%
  left_join(Vienna_pageviews_C, by = "item") %>%
  group_by(id, lang.x) %>%
  summarise(value_id = sum(value, na.rm = T)) %>%
  filter(id != 99 & !is.na(id))%>%
  left_join(categories, by = "id") %>%
  select(-keywords) 
 
Vienna_pageviews_article_language$percentage <- scales::percent(Vienna_pageviews_article_language$value_id/sum(Vienna_pageviews_article_language$value_id))

library(reshape2)

w <- dcast(Vienna_pageviews_article_language, id + category ~ lang.x, value.var = "value_id")

nas <- is.na(w_percentage)
w_percentage[nas] <- 0

library(tigerstats)

lang_percentage <- colPerc(w_percentage) 
lang_percentage <- lang_percentage[-24,]
lang_percentage <- data.frame(cbind(id = w$id, category = w$category, lang_percentage)) %>%
  mutate(id = as.numeric(id))

# Build time series for categories

Vienna_final_2 <- Vienna_final %>%
  distinct(item, .keep_all = T)
  
Vienna_final_ts <- Vienna_reads_in_C %>%
  left_join(Vienna_final_2, by = 'item') %>%
  select(-lat, -long)%>%
  filter(!is.na(id))%>%
  group_by(time, id)%>%
  summarise(value = sum(value))

## Plot time series

# Adjust the way the time variable is displayed

library(reshape2)
library(xts)

Vienna_final_ts <- dcast(Vienna_final_ts, time ~ id) %>%
  mutate(time = as.Date(ts(1:48, frequency = 12, start = c(2012, 01))))
Vienna_final_ts <- xts(Vienna_final_ts[,-1], order.by = as.POSIXct(Vienna_final_ts$time))

# Standardized
Vienna_final_ts_scaled <- scale(Vienna_final_ts)

library(dygraphs)
library(htmlwidgets)
options(scipen=999)

g <- dygraph(Vienna_final_ts_scaled, main = "Vienna (C) pageviews by categories") %>%
  dyOptions(colors = colorRampPalette(c("violet","purple", "orange","yellow", "red", "green", "blue", "light blue", "pink", "grey","black", "brown"))(24)) %>%
  dyHighlight(highlightSeriesOpts = list(strokeWidth = 3)) %>%
  dyRangeSelector(dateWindow = c("2013-01-01", "2014-12-31")) %>%
  dyLegend(width = 400)
g

saveWidget(widget = g, file="Vienna_categories.html", selfcontained = FALSE)

### BARCELONA

## TOPIC MODELING

library(jsonlite)
source("scripts/r/wikidata_functions.R")
source("scripts/r/redirects_target_and_origin_for_cities.R")

Barcelona_articles_in_C <- Barcelona_articles_in_C %>%
  mutate(wm = getWikiMarkup(article, lang))

write.csv(Barcelona_articles_in_C, "Barcelona_articles_in_C.csv", fileEncoding = "UTF-8")

Barcelona_articles_in_C <- read.csv("C:/Users/signose/Desktop/Barcelona_articles_in_C.csv", encoding = "UTF-8") %>%
  select(-X) %>%
  mutate(wm = as.character(wm))

B <- Barcelona_articles_in_C %>%
  mutate(lang = as.factor(lang))

summary(B)

Barcelona_articles_in_C_ES <- Barcelona_articles_in_C %>%
  filter(lang == "es") %>%
  full_join(Barcelona_articles_in_C, by = 'item')

names(Barcelona_articles_in_C_ES) <- c("item", "articlex", "langx", "wmx", "articley", "langy", "wmy")

Barcelona_articles_ES <- data.frame(item = character(), article = character(), lang = character(), wm = character())
for (i in 1:nrow(Barcelona_articles_in_C_ES)) {
  item <- data.frame(item = Barcelona_articles_in_C_ES$item[i])
  if (!is.na(Barcelona_articles_in_C_ES$langx[i])) {
    article <- Barcelona_articles_in_C_ES$articlex[i]
    lang <- Barcelona_articles_in_C_ES$langx[i]
    wm <- Barcelona_articles_in_C_ES$wmx[i]
  } else {
    article <- Barcelona_articles_in_C_ES$articley[i]
    lang <- Barcelona_articles_in_C_ES$langy[i]
    wm <- Barcelona_articles_in_C_ES$wmy[i]
  }
  temp <- item %>%
    mutate(article = article, lang = lang, wm = wm)
  Barcelona_articles_ES <- rbind(Barcelona_articles_ES, temp)
}

# divide articles by language

Barcelona_ES <- Barcelona_articles_ES %>%
  filter(lang == "es") %>%
  distinct(article, .keep_all = TRUE)

# exclude articles without wikimarkup

Barcelona_ES <- Barcelona_ES %>%
  filter(wm != "ERROR: wikimarkup missing")

# Preprocessing of data

library(tm)

#create corpus from vector

Barcelona_ES$wm <- Corpus(VectorSource(Barcelona_ES$wm))

#Transform to lower case

Barcelona_ES$wm <- tm_map(Barcelona_ES$wm, content_transformer(tolower))

#remove potentially problematic symbols
toSpace <- content_transformer(function(x, pattern) { return (gsub(pattern, " ", x))})

Barcelona_ES$wm <- tm_map(Barcelona_ES$wm, toSpace, "-")
Barcelona_ES$wm <- tm_map(Barcelona_ES$wm, toSpace, "’")
Barcelona_ES$wm <- tm_map(Barcelona_ES$wm, toSpace, "‘")
Barcelona_ES$wm <- tm_map(Barcelona_ES$wm, toSpace, "•") 
Barcelona_ES$wm <- tm_map(Barcelona_ES$wm, toSpace, "“")
Barcelona_ES$wm <- tm_map(Barcelona_ES$wm, toSpace, "”")
Barcelona_ES$wm <- tm_map(Barcelona_ES$wm, toSpace, "…")
Barcelona_ES$wm <- tm_map(Barcelona_ES$wm, toSpace, "„")
Barcelona_ES$wm <- tm_map(Barcelona_ES$wm, toSpace, "€")
Barcelona_ES$wm <- tm_map(Barcelona_ES$wm, toSpace, "—")

#remove punctuation

Barcelona_ES$wm <- tm_map(Barcelona_ES$wm, removePunctuation)

#Strip digits

Barcelona_ES$wm <- tm_map(Barcelona_ES$wm, removeNumbers)

#remove stopwords (only for selected languages)

Barcelona_ES$wm <- tm_map(Barcelona_ES$wm, removeWords, stopwords("es"))

#remove whitespace

Barcelona_ES$wm <- tm_map(Barcelona_ES$wm, stripWhitespace)

#Good practice to check every now and then
writeLines(as.character(Barcelona_ES$article[[20]]))

#Stem document

Barcelona_ES$wm <- tm_map(Barcelona_ES$wm, stemDocument, lang = "es")

# Remove words related to the city and the country 

myStopwords <- c("españ", "barcelon", "ciud", "cataluñ")

Barcelona_ES$wm <- tm_map(Barcelona_ES$wm, removeWords, myStopwords)

#write.csv(Barcelona_ES, "Barcelona_ES.csv")

#Create document-term matrix

dtm_ES <- DocumentTermMatrix(Barcelona_ES$wm)

#convert rownames to filenames

rownames(dtm_ES) <- Barcelona_ES$article

#collapse matrix by summing over columns

freq_ES <- slam::col_sums(dtm_ES, na.rm = T)

#length should be total number of terms

length(freq_ES)

#create sort orESr (ESscending)

ord_ES <- order(freq_ES,decreasing=TRUE)

#List all terms in EScreasing orESr of freq 
freq_ES[ord_ES]

#load topic moESls library

library(topicmodels)

#Number of topics
k <- 45
k <- 35
k <- 20

#Run LDA using Gibbs sampling

ldaOut <-LDA(dtm_ES, k, method="Gibbs")
ldaOut.35 <-LDA(dtm_ES, k, method="Gibbs")
ldaOut.20 <-LDA(dtm_ES, k, method="Gibbs")

#write out results
#docs to topics

ldaOut.topics.Barcelona <- as.matrix(topics(ldaOut))
ldaOut.topics.Barcelona.35 <- as.matrix(topics(ldaOut.35))
ldaOut.topics.Barcelona.20 <- as.matrix(topics(ldaOut.20))

save(ldaOut.20, file="ldaOut20Barcelona.RData")
save(ldaOut.topics.Barcelona.20, file="topics20Barcelona.Rdata")

#top 6 terms in each topic
ldaOut.terms.Barcelona <- as.matrix(terms(ldaOut,10))
ldaOut.terms.Barcelona.35 <- as.matrix(terms(ldaOut.35,10))
ldaOut.terms.Barcelona.20 <- as.matrix(terms(ldaOut.20,10))

save(ldaOut.terms.Barcelona.20, file="terms20Barcelona.Rdata")

# upload list of found categories

categories_Barcelona <- read.csv("./categoriesBARCELONA.csv") %>%
  mutate(id = as.numeric(id), keywords = as.character(keywords), category = as.character(category))

# create list of articles with id of the category

ldaOut.topics.Barcelona.post <- ldaOut.topics.Barcelona.20 
rownames(ldaOut.topics.Barcelona.post) = NULL

ldaOut_topics_Barcelona <- data.frame(article = rownames(ldaOut.topics.Barcelona.20), id = ldaOut.topics.Barcelona.post)

# Add category to data frame of articles 

Barcelona_ES_post <- data.frame(item = as.character(Barcelona_ES$item), article = as.character(Barcelona_ES$article), lang = as.character(Barcelona_ES$lang)) %>%
  left_join(ldaOut_topics_Barcelona, by = "article") %>%
  mutate(id = as.numeric(id), item = as.character(item), article = as.character(article), lang = as.character(lang))

library(stringi)

Barcelona_ES_post$article <- stri_trans_general(Barcelona_ES_post$article, "Latin-ASCII")

# Unify the doubled categories

Barcelona_ES_post$id[Barcelona_ES_post$id == 14] <- 7
Barcelona_ES_post$id[Barcelona_ES_post$id == 5] <- 1 
Barcelona_ES_post$id[Barcelona_ES_post$id == 19] <- 1 
Barcelona_ES_post$id[Barcelona_ES_post$id == 8] <- 2 
Barcelona_ES_post$id[Barcelona_ES_post$id == 20] <- 2 

# prepare keywords

keywords_Barcelona <- paste(categories_Barcelona$keywords[1], categories_Barcelona$keywords[2], 
                  categories_Barcelona$keywords[3], categories_Barcelona$keywords[4],
                  categories_Barcelona$keywords[5], categories_Barcelona$keywords[6],
                  categories_Barcelona$keywords[7], categories_Barcelona$keywords[8],
                  categories_Barcelona$keywords[9], categories_Barcelona$keywords[10],
                  categories_Barcelona$keywords[11], categories_Barcelona$keywords[12],
                  categories_Barcelona$keywords[13], categories_Barcelona$keywords[14], sep = ", ")

keywords_Barcelona <- unlist(strsplit(keywords_Barcelona, " "))
keywords_Barcelona <- unlist(strsplit(keywords_Barcelona, ","))

# Fix the mixed categories (4)

Mixed_Barcelona_ES <- Barcelona_ES_post %>%
  filter(id == 4) 

# check if match between keywords and title of article exists

for (i in 1:nrow(Mixed_Barcelona_ES)) {
  Mixed_Barcelona_ES$estacion[i] <-  grepl(keywords_Barcelona[1], tolower(Mixed_Barcelona_ES$article[i]))
  Mixed_Barcelona_ES$line[i] <-  grepl(keywords_Barcelona[2], tolower(Mixed_Barcelona_ES$article[i]))
  Mixed_Barcelona_ES$metr[i] <-  grepl(keywords_Barcelona[3], tolower(Mixed_Barcelona_ES$article[i]))
  Mixed_Barcelona_ES$club[i] <-  grepl(keywords_Barcelona[4], tolower(Mixed_Barcelona_ES$article[i]))
  Mixed_Barcelona_ES$futbol[i] <-  grepl(keywords_Barcelona[5], tolower(Mixed_Barcelona_ES$article[i]))
  Mixed_Barcelona_ES$equip[i] <-  grepl(keywords_Barcelona[6], tolower(Mixed_Barcelona_ES$article[i]))
  Mixed_Barcelona_ES$camp[i] <-  grepl(keywords_Barcelona[7], tolower(Mixed_Barcelona_ES$article[i]))
  Mixed_Barcelona_ES$deport[i] <-  grepl(keywords_Barcelona[8], tolower(Mixed_Barcelona_ES$article[i]))
  Mixed_Barcelona_ES$univers[i] <-  grepl(keywords_Barcelona[9], tolower(Mixed_Barcelona_ES$article[i]))
  Mixed_Barcelona_ES$escuel[i] <-  grepl(keywords_Barcelona[10], tolower(Mixed_Barcelona_ES$article[i]))
  Mixed_Barcelona_ES$estudi[i] <-  grepl(keywords_Barcelona[11], tolower(Mixed_Barcelona_ES$article[i]))
  Mixed_Barcelona_ES$institut[i] <-  grepl(keywords_Barcelona[12], tolower(Mixed_Barcelona_ES$article[i]))
  Mixed_Barcelona_ES$superior[i] <-  grepl(keywords_Barcelona[13], tolower(Mixed_Barcelona_ES$article[i]))
  Mixed_Barcelona_ES$campus[i] <-  grepl(keywords_Barcelona[14], tolower(Mixed_Barcelona_ES$article[i]))
  Mixed_Barcelona_ES$escola[i] <-  grepl(keywords_Barcelona[15], tolower(Mixed_Barcelona_ES$article[i]))
  Mixed_Barcelona_ES$teatr[i] <-  grepl(keywords_Barcelona[16], tolower(Mixed_Barcelona_ES$article[i]))
  Mixed_Barcelona_ES$music[i] <-  grepl(keywords_Barcelona[17], tolower(Mixed_Barcelona_ES$article[i]))
  Mixed_Barcelona_ES$edifici[i] <-  grepl(keywords_Barcelona[18], tolower(Mixed_Barcelona_ES$article[i]))
  Mixed_Barcelona_ES$cas[i] <-  grepl(keywords_Barcelona[19], tolower(Mixed_Barcelona_ES$article[i]))
  Mixed_Barcelona_ES$torr[i] <-  grepl(keywords_Barcelona[20], tolower(Mixed_Barcelona_ES$article[i]))
  Mixed_Barcelona_ES$fabric[i] <-  grepl(keywords_Barcelona[21], tolower(Mixed_Barcelona_ES$article[i]))
  Mixed_Barcelona_ES$industrial[i] <-  grepl(keywords_Barcelona[22], tolower(Mixed_Barcelona_ES$article[i]))
  Mixed_Barcelona_ES$palacio[i] <-  grepl(keywords_Barcelona[23], tolower(Mixed_Barcelona_ES$article[i]))
  Mixed_Barcelona_ES$villa[i] <-  grepl(keywords_Barcelona[24], tolower(Mixed_Barcelona_ES$article[i]))
  Mixed_Barcelona_ES$can[i] <-  grepl(keywords_Barcelona[25], tolower(Mixed_Barcelona_ES$article[i]))
  Mixed_Barcelona_ES$palacete[i] <-  grepl(keywords_Barcelona[26], tolower(Mixed_Barcelona_ES$article[i]))
  Mixed_Barcelona_ES$barri[i] <-  grepl(keywords_Barcelona[27], tolower(Mixed_Barcelona_ES$article[i]))
  Mixed_Barcelona_ES$distrit[i] <-  grepl(keywords_Barcelona[28], tolower(Mixed_Barcelona_ES$article[i]))
  Mixed_Barcelona_ES$call[i] <-  grepl(keywords_Barcelona[29], tolower(Mixed_Barcelona_ES$article[i]))
  Mixed_Barcelona_ES$plaz[i] <-  grepl(keywords_Barcelona[30], tolower(Mixed_Barcelona_ES$article[i]))
  Mixed_Barcelona_ES$avenida[i] <-  grepl(keywords_Barcelona[31], tolower(Mixed_Barcelona_ES$article[i]))
  Mixed_Barcelona_ES$paseo[i] <-  grepl(keywords_Barcelona[32], tolower(Mixed_Barcelona_ES$article[i]))
  Mixed_Barcelona_ES$muse[i] <-  grepl(keywords_Barcelona[33], tolower(Mixed_Barcelona_ES$article[i]))
  Mixed_Barcelona_ES$famili[i] <-  grepl(keywords_Barcelona[34], tolower(Mixed_Barcelona_ES$article[i]))
  Mixed_Barcelona_ES$sagr[i] <-  grepl(keywords_Barcelona[35], tolower(Mixed_Barcelona_ES$article[i]))
  Mixed_Barcelona_ES$guerr[i] <-  grepl(keywords_Barcelona[36], tolower(Mixed_Barcelona_ES$article[i]))
  Mixed_Barcelona_ES$general[i] <-  grepl(keywords_Barcelona[37], tolower(Mixed_Barcelona_ES$article[i]))
  Mixed_Barcelona_ES$departamento[i] <-  grepl(keywords_Barcelona[38], tolower(Mixed_Barcelona_ES$article[i]))
  Mixed_Barcelona_ES$monument[i] <-  grepl(keywords_Barcelona[39], tolower(Mixed_Barcelona_ES$article[i]))
  Mixed_Barcelona_ES$fuent[i] <-  grepl(keywords_Barcelona[40], tolower(Mixed_Barcelona_ES$article[i]))
  Mixed_Barcelona_ES$arte[i] <-  grepl(keywords_Barcelona[41], tolower(Mixed_Barcelona_ES$article[i]))
  Mixed_Barcelona_ES$parqu[i] <-  grepl(keywords_Barcelona[42], tolower(Mixed_Barcelona_ES$article[i]))
  Mixed_Barcelona_ES$jardin[i] <-  grepl(keywords_Barcelona[43], tolower(Mixed_Barcelona_ES$article[i]))
  Mixed_Barcelona_ES$sant[i] <-  grepl(keywords_Barcelona[44], tolower(Mixed_Barcelona_ES$article[i]))
  Mixed_Barcelona_ES$iglesi[i] <-  grepl(keywords_Barcelona[45], tolower(Mixed_Barcelona_ES$article[i]))
}

Mixed_Barcelona_ES$matches <- rowSums(Mixed_Barcelona_ES[,5:45])

# add new category and add 99 for residual unclassified cases

for (i in 1:nrow(Mixed_Barcelona_ES)) {
  if (Mixed_Barcelona_ES$matches[i] == 0) {
    Mixed_Barcelona_ES$id[i] <- 99
  } 
}

# Add new categories

Match_1_Barcelona <- Mixed_Barcelona_ES %>%
  filter(matches == 1)

for (i in 1:nrow(Match_1_Barcelona)) {
  if (Match_1_Barcelona[i,5] == TRUE) {
    Match_1_Barcelona$id[i] <- 1
  } else if (Match_1_Barcelona[i,19] == TRUE) {
    Match_1_Barcelona$id[i] <- 3
  } else if (Match_1_Barcelona[i,20] == TRUE | Match_1_Barcelona[i,21] == TRUE) {
    Match_1_Barcelona$id[i] <- 6
  } else if (Match_1_Barcelona[i,22] == TRUE | Match_1_Barcelona[i,23] == TRUE | 
             Match_1_Barcelona[i,25] == TRUE | Match_1_Barcelona[i,27] == TRUE |
             Match_1_Barcelona[i,30] == TRUE) {
    Match_1_Barcelona$id[i] <- 7
  } else if (Match_1_Barcelona[i,35] == TRUE | Match_1_Barcelona[i,36] == TRUE) {
    Match_1_Barcelona$id[i] <- 9
  } else if (Match_1_Barcelona[i,47] == TRUE) {
    Match_1_Barcelona$id[i] <- 17
  } 
}

Match_1_Barcelona$id[Match_1_Barcelona$id == 4] <- 99 

Match_2_Barcelona <- Mixed_Barcelona_ES %>%
  filter(matches == 0)

Match_3_Barcelona <- Mixed_Barcelona_ES %>%
  filter(matches == 2)

for (i in 1:nrow(Match_3_Barcelona)) {
  if (Match_3_Barcelona[i,27] == TRUE) {
    Match_3_Barcelona$id[i] <- 7
  }
}

Match_3_Barcelona$id[Match_3_Barcelona$id == 4] <- 99

Barcelona_final_match <- rbind(Match_1_Barcelona, Match_2_Barcelona, Match_3_Barcelona) %>%
  select(item, article, lang, id)

Barcelona_final_match_2 <- Barcelona_ES_post %>%
  filter(id != 4)

Barcelona_matched <- rbind(Barcelona_final_match, Barcelona_final_match_2)

Barcelona_matched$id <- as.factor(Barcelona_matched$id)

summary(Barcelona_matched$id)

Barcelona_articles_matched <- Barcelona_matched %>%
  select(article, id)

Barcelona_ES_nonunique <- Barcelona_articles_ES %>%
  filter(lang == "es") 

Barcelona_unique <- Barcelona_articles_in_C %>%
  distinct(article, lang, .keep_all = T) %>%
  select(-wm) %>%
  left_join(Barcelona_matched, by = "item") %>%
  select(-article.y, -lang.y)

names(Barcelona_unique) <- c("item", "article", "lang", "id")

summary(Barcelona_unique$id)

Barcelona_ES_nonunique$article <- stri_trans_general(Barcelona_ES_nonunique$article, "Latin-ASCII")

Barcelona_unique$article <- stri_trans_general(Barcelona_unique$article, "Latin-ASCII")

Barcelona_final <- Barcelona_ES_nonunique %>%
  left_join(Barcelona_articles_matched, by = "article") %>%
  select(-wm) %>%
  filter(!is.na(id))

Barcelona_final$id[Barcelona_final$item == 'Q755125'] <- 2 
Barcelona_final$id[Barcelona_final$item == 'Q19799406'] <- 2 
Barcelona_final$id[Barcelona_final$item == 'Q16325382'] <- 2 
Barcelona_final$id[Barcelona_final$item == 'Q3838459'] <- 2 
Barcelona_final$id[Barcelona_final$item == 'Q299163'] <- 2 

# Add residual category to dataframe

categories_Barcelona[15,] <- c(99, "Other/Unclassified", "")

# Join with pageviews file

Barcelona_pageviews_article <- Barcelona_final %>%
  distinct(item, .keep_all = T) %>%
  left_join(Barcelona_pageviews_C, by = "item") %>%
  group_by(id) %>%
  summarise(value_id = sum(value, na.rm = T)) %>%
  left_join(categories_Barcelona, by = "id") %>%
  select(-keywords) %>%
  filter(id != 99)

Barcelona_pageviews_article$percentage <- scales::percent(Barcelona_pageviews_article$value_id/sum(Barcelona_pageviews_article$value_id))

# create barchart 

library(ggplot2)

plot <- ggplot(data = Barcelona_pageviews_article, aes(x = reorder(factor(category), value_id), y = value_id, fill = category)) +
  geom_bar(stat = "identity") +
  ggtitle("Number of pageviews by category - Barcelona") +
  guides(fill=FALSE) +
  coord_flip() +
  xlab("") + 
  ylab("Number of pageviews")

plot

# Create scatterplot

scatter <- data.frame(no_articles = summary(Barcelona_unique$id))
scatter <- scatter[-c(15,16),]
categ <- categories_Barcelona$id 
categ <- categ[-15]
value_id <- Barcelona_pageviews_article$value_id

scatter_data <- data.frame(cbind(id = categ, value_id = value_id, no_articles = scatter), stringsAsFactors = F) %>%
  mutate(value_id = as.integer(value_id), 
         no_articles = as.integer(no_articles))

s <- ggplot(scatter_data, aes(x=no_articles, y=value_id)) +
  geom_point(shape=1) +    
  geom_smooth(method = "lm", se = F) +
  xlab("Number of articles") +
  ylab("Number of pageviews") +
  ggtitle("Correlation between number of articles and pageviews")
s

# Consider pageviews per category by language

Barcelona_pageviews_article_language <- Barcelona_unique %>%
  distinct(article, lang, .keep_all = T) %>%
  left_join(Barcelona_pageviews_C, by = "item") %>%
  group_by(id, lang) %>%
  summarise(value_id = sum(value, na.rm = T)) %>%
  filter(id != 99 & !is.na(id))%>%
  left_join(categories_Barcelona, by = "id") %>%
  select(-keywords) 

Barcelona_pageviews_article_language$percentage <- scales::percent(Barcelona_pageviews_article_language$value_id/sum(Barcelona_pageviews_article_language$value_id))

library(reshape2)

w <- dcast(Barcelona_pageviews_article_language, id + category ~ lang, value.var = "value_id")
w_percentage <- w[,3:33]
nas <- is.na(w_percentage)
w_percentage[nas] <- 0

library(tigerstats)

lang_percentage <- colPerc(w_percentage) 
lang_percentage <- lang_percentage[-15,]
lang_percentage <- data.frame(cbind(id = w$id, category = w$category, lang_percentage)) %>%
  mutate(id = as.numeric(id))

# Build time series for categories

Barcelona_final_2 <- Barcelona_final %>%
  distinct(item, .keep_all = T)

Barcelona_final_ts <- Barcelona_reads_in_C %>%
  left_join(Barcelona_final_2, by = 'item') %>%
  select(-lat, -long)%>%
  filter(!is.na(id))%>%
  group_by(time, id)%>%
  summarise(value = sum(value))

## Plot time series

# Adjust the way the time variable is displayed

library(reshape2)
library(xts)

Barcelona_final_ts <- dcast(Barcelona_final_ts, time ~ id) %>%
  mutate(time = as.Date(ts(1:48, frequency = 12, start = c(2012, 01))))
Barcelona_final_ts <- xts(Barcelona_final_ts[,-1], order.by = as.POSIXct(Barcelona_final_ts$time))

# Standardized
Barcelona_final_ts_scaled <- scale(Barcelona_final_ts)

library(dygraphs)
library(htmlwidgets)
options(scipen=999)

g <- dygraph(Barcelona_final_ts_scaled, main = "Barcelona (C) pageviews by categories") %>%
  dyOptions(colors = colorRampPalette(c("purple", "orange", "red", "green", "blue", "pink", "grey", "brown"))(15)) %>%
  dyHighlight(highlightSeriesOpts = list(strokeWidth = 3)) %>%
  dyRangeSelector(dateWindow = c("2013-01-01", "2014-12-31")) %>%
  dyLegend(width = 400)
g

saveWidget(widget = g, file="Barcelona_categories.html", selfcontained = FALSE)

### BRUGES

## TOPIC MODELING

library(jsonlite)
source("scripts/r/wikidata_functions.R")
source("scripts/r/redirects_target_and_origin_for_cities.R")

Bruges_articles_in_C <- Bruges_articles_in_C %>%
  mutate(wm = getWikiMarkup(article, lang))

write.csv(Bruges_articles_in_C, "Bruges_articles_in_C.csv", fileEncoding = "UTF-8")

Bruges_articles_in_C <- read.csv("C:/Users/signose/Desktop/Bruges_articles_in_C.csv", encoding = "UTF-8") %>%
  select(-X) %>%
  mutate(wm = as.character(wm))

B <- Bruges_articles_in_C %>%
  mutate(lang = as.factor(lang))

summary(B)

Bruges_articles_in_C_NL <- Bruges_articles_in_C %>%
  filter(lang == "nl") %>%
  full_join(Bruges_articles_in_C, by = 'item')

names(Bruges_articles_in_C_NL) <- c("item", "articlex", "langx", "wmx", "articley", "langy", "wmy")

Bruges_articles_NL <- data.frame(item = character(), article = character(), lang = character(), wm = character())
for (i in 1:nrow(Bruges_articles_in_C_NL)) {
  item <- data.frame(item = Bruges_articles_in_C_NL$item[i])
  if (!is.na(Bruges_articles_in_C_NL$langx[i])) {
    article <- Bruges_articles_in_C_NL$articlex[i]
    lang <- Bruges_articles_in_C_NL$langx[i]
    wm <- Bruges_articles_in_C_NL$wmx[i]
  } else {
    article <- Bruges_articles_in_C_NL$articley[i]
    lang <- Bruges_articles_in_C_NL$langy[i]
    wm <- Bruges_articles_in_C_NL$wmy[i]
  }
  temp <- item %>%
    mutate(article = article, lang = lang, wm = wm)
  Bruges_articles_NL <- rbind(Bruges_articles_NL, temp)
}

# divide articles by language

Bruges_NL <- Bruges_articles_NL %>%
  filter(lang == "nl") %>%
  distinct(article, .keep_all = TRUE)

# exclude articles without wikimarkup

Bruges_NL <- Bruges_NL %>%
  filter(wm != "ERROR: wikimarkup missing")

# Preprocessing of data

library(tm)

#create corpus from vector

Bruges_NL$wm <- Corpus(VectorSource(Bruges_NL$wm))

#Transform to lower case

Bruges_NL$wm <- tm_map(Bruges_NL$wm, content_transformer(tolower))

#remove potentially problematic symbols
toSpace <- content_transformer(function(x, pattern) { return (gsub(pattern, " ", x))})

Bruges_NL$wm <- tm_map(Bruges_NL$wm, toSpace, "-")
Bruges_NL$wm <- tm_map(Bruges_NL$wm, toSpace, "’")
Bruges_NL$wm <- tm_map(Bruges_NL$wm, toSpace, "‘")
Bruges_NL$wm <- tm_map(Bruges_NL$wm, toSpace, "•") 
Bruges_NL$wm <- tm_map(Bruges_NL$wm, toSpace, "“")
Bruges_NL$wm <- tm_map(Bruges_NL$wm, toSpace, "”")
Bruges_NL$wm <- tm_map(Bruges_NL$wm, toSpace, "…")
Bruges_NL$wm <- tm_map(Bruges_NL$wm, toSpace, "„")
Bruges_NL$wm <- tm_map(Bruges_NL$wm, toSpace, "€")
Bruges_NL$wm <- tm_map(Bruges_NL$wm, toSpace, "—")

#remove punctuation

Bruges_NL$wm <- tm_map(Bruges_NL$wm, removePunctuation)

#Strip digits

Bruges_NL$wm <- tm_map(Bruges_NL$wm, removeNumbers)

#remove stopwords (only for selected languages)

Bruges_NL$wm <- tm_map(Bruges_NL$wm, removeWords, stopwords("nl"))

#remove whitespace

Bruges_NL$wm <- tm_map(Bruges_NL$wm, stripWhitespace)

#Good practice to check every now and then
writeLines(as.character(Bruges_NL$article[[20]]))

#Stem document

Bruges_NL$wm <- tm_map(Bruges_NL$wm, stemDocument, lang = "nl")

# Remove words related to the city and the country 

myStopwords <- c("brugg", "belgie", "bruges", "sint", "stad")

Bruges_NL$wm <- tm_map(Bruges_NL$wm, removeWords, myStopwords)

#write.csv(Bruges_NL, "Bruges_NL.csv")

#Create document-term matrix

dtm_NL <- DocumentTermMatrix(Bruges_NL$wm)

#convert rownames to filenames

rownames(dtm_NL) <- Bruges_NL$article

#collapse matrix by summing over columns

freq_NL <- slam::col_sums(dtm_NL, na.rm = T)

#length should be total number of terms

length(freq_NL)

#create sort orNLr (NLscending)

ord_NL <- order(freq_NL,decreasing=TRUE)

#List all terms in NLcreasing orNLr of freq 

freq_NL[ord_NL]

#load topic moNLls library

library(topicmodels)

#Number of topics
k <- 20
k <- 15
k <- 12

#Run LDA using Gibbs sampling

ldaOut.20 <-LDA(dtm_NL, k, method="Gibbs")
ldaOut.10 <-LDA(dtm_NL, k, method="Gibbs")
ldaOut.12 <-LDA(dtm_NL, k, method="Gibbs")


#write out results
#docs to topics

ldaOut.topics.Bruges.20 <- as.matrix(topics(ldaOut.20))
ldaOut.topics.Bruges.10 <- as.matrix(topics(ldaOut.10))
ldaOut.topics.Bruges.12 <- as.matrix(topics(ldaOut.12))

save(ldaOut.12, file="ldaOut12Bruges.RData")
save(ldaOut.topics.Bruges.12, file="topics12Bruges.Rdata")

#top 6 terms in each topic

ldaOut.terms.Bruges.20 <- as.matrix(terms(ldaOut.20,10))
ldaOut.terms.Bruges.10 <- as.matrix(terms(ldaOut.10,10))
ldaOut.terms.Bruges.12 <- as.matrix(terms(ldaOut.12,10))

save(ldaOut.terms.Bruges.12, file="terms12Bruges.Rdata")

# upload list of found categories

categories_Bruges <- read.csv("./categoriesBRUGES.csv") %>%
  mutate(id = as.numeric(id), keywords = as.character(keywords), category = as.character(category))

# create list of articles with id of the category

ldaOut.topics.Bruges.post <- ldaOut.topics.Bruges.12
rownames(ldaOut.topics.Bruges.post) = NULL

ldaOut_topics_Bruges <- data.frame(article = rownames(ldaOut.topics.Bruges.12), id = ldaOut.topics.Bruges.post)

# Add category to data frame of articles 

Bruges_NL_post <- data.frame(item = as.character(Bruges_NL$item), article = as.character(Bruges_NL$article), lang = as.character(Bruges_NL$lang)) %>%
  left_join(ldaOut_topics_Bruges, by = "article") %>%
  mutate(id = as.numeric(id), item = as.character(item), article = as.character(article), lang = as.character(lang))

library(stringi)

Bruges_NL_post$article <- stri_trans_general(Bruges_NL_post$article, "Latin-ASCII")

# Unify the doubled categories

Bruges_NL_post$id[Bruges_NL_post$id == 12] <- 2
Bruges_NL_post$id[Bruges_NL_post$id == 7] <- 2

# prepare keywords

keywords_Bruges <- paste(categories_Bruges$keywords[1], categories_Bruges$keywords[2], 
                            categories_Bruges$keywords[3], categories_Bruges$keywords[4],
                            categories_Bruges$keywords[5], categories_Bruges$keywords[6],
                            categories_Bruges$keywords[7], categories_Bruges$keywords[8],
                            categories_Bruges$keywords[9], categories_Bruges$keywords[10],
                            categories_Bruges$keywords[11], sep = ", ")

keywords_Bruges <- unlist(strsplit(keywords_Bruges, " "))
keywords_Bruges <- unlist(strsplit(keywords_Bruges, ","))

# Fix the mixed categories (4)

Mixed_Bruges_NL <- Bruges_NL_post %>%
  filter(id == 3 | id == 5 | id == 6 | id == 8 | id == 10) 

# check if match between keywords and title of article exists

for (i in 1:nrow(Mixed_Bruges_NL)) {
  Mixed_Bruges_NL$station[i] <-  grepl(keywords_Bruges[1], tolower(Mixed_Bruges_NL$article[i]))
  Mixed_Bruges_NL$statt[i] <-  grepl(keywords_Bruges[2], tolower(Mixed_Bruges_NL$article[i]))
  Mixed_Bruges_NL$plein[i] <-  grepl(keywords_Bruges[3], tolower(Mixed_Bruges_NL$article[i]))
  Mixed_Bruges_NL$rei[i] <-  grepl(keywords_Bruges[4], tolower(Mixed_Bruges_NL$article[i]))
  Mixed_Bruges_NL$tunnel[i] <-  grepl(keywords_Bruges[5], tolower(Mixed_Bruges_NL$article[i]))
  Mixed_Bruges_NL$poort[i] <-  grepl(keywords_Bruges[6], tolower(Mixed_Bruges_NL$article[i]))
  Mixed_Bruges_NL$weg[i] <-  grepl(keywords_Bruges[7], tolower(Mixed_Bruges_NL$article[i]))
  Mixed_Bruges_NL$bibliotheek[i] <-  grepl(keywords_Bruges[8], tolower(Mixed_Bruges_NL$article[i]))
  Mixed_Bruges_NL$kastel[i] <-  grepl(keywords_Bruges[9], tolower(Mixed_Bruges_NL$article[i]))
  Mixed_Bruges_NL$fort[i] <-  grepl(keywords_Bruges[10], tolower(Mixed_Bruges_NL$article[i]))
  Mixed_Bruges_NL$schol[i] <-  grepl(keywords_Bruges[11], tolower(Mixed_Bruges_NL$article[i]))
  Mixed_Bruges_NL$instituut[i] <-  grepl(keywords_Bruges[12], tolower(Mixed_Bruges_NL$article[i]))
  Mixed_Bruges_NL$school[i] <-  grepl(keywords_Bruges[13], tolower(Mixed_Bruges_NL$article[i]))
  Mixed_Bruges_NL$college[i] <-  grepl(keywords_Bruges[14], tolower(Mixed_Bruges_NL$article[i]))
  Mixed_Bruges_NL$brouwerij[i] <-  grepl(keywords_Bruges[15], tolower(Mixed_Bruges_NL$article[i]))
  Mixed_Bruges_NL$brug[i] <-  grepl(keywords_Bruges[16], tolower(Mixed_Bruges_NL$article[i]))
  Mixed_Bruges_NL$kanal[i] <-  grepl(keywords_Bruges[17], tolower(Mixed_Bruges_NL$article[i]))
  Mixed_Bruges_NL$kanaal[i] <-  grepl(keywords_Bruges[18], tolower(Mixed_Bruges_NL$article[i]))
  Mixed_Bruges_NL$stadion[i] <-  grepl(keywords_Bruges[19], tolower(Mixed_Bruges_NL$article[i]))
  Mixed_Bruges_NL$kerk[i] <-  grepl(keywords_Bruges[21], tolower(Mixed_Bruges_NL$article[i]))
  Mixed_Bruges_NL$kapel[i] <-  grepl(keywords_Bruges[22], tolower(Mixed_Bruges_NL$article[i]))
  Mixed_Bruges_NL$kathedraal[i] <-  grepl(keywords_Bruges[23], tolower(Mixed_Bruges_NL$article[i]))
  Mixed_Bruges_NL$museum[i] <-  grepl(keywords_Bruges[24], tolower(Mixed_Bruges_NL$article[i]))
}

Mixed_Bruges_NL$matches <- rowSums(Mixed_Bruges_NL[,5:27])

# add new category and add 99 for residual unclassified cases

for (i in 1:nrow(Mixed_Bruges_NL)) {
  if (Mixed_Bruges_NL$matches[i] == 0) {
    Mixed_Bruges_NL$id[i] <- 99
  } 
}

# Add new categories

Match_1_Bruges <- Mixed_Bruges_NL %>%
  filter(matches == 1)

for (i in 1:nrow(Match_1_Bruges)) {
  if (Match_1_Bruges[i,5] == TRUE) {
    Match_1_Bruges$id[i] <- 1
  } else if (Match_1_Bruges[i,7] == TRUE | Match_1_Bruges[i,8] == TRUE | Match_1_Bruges[i,9] == TRUE) {
    Match_1_Bruges$id[i] <- 2
  } else if (Match_1_Bruges[i,12] == TRUE) {
    Match_1_Bruges$id[i] <- 3
  } else if (Match_1_Bruges[i,16] == TRUE | Match_1_Bruges[i,18]) {
    Match_1_Bruges$id[i] <- 5
  } else if (Match_1_Bruges[i,19] == TRUE) {
    Match_1_Bruges$id[i] <- 13
  } else if (Match_1_Bruges[i,22] == TRUE) {
    Match_1_Bruges$id[i] <- 8
  } else if (Match_1_Bruges[i,24] == TRUE) {
    Match_1_Bruges$id[i] <- 11
  } else if (Match_1_Bruges[i,27] == TRUE) {
    Match_1_Bruges$id[i] <- 14
  }
}

Match_1_Bruges$id[Match_1_Bruges$id == 6] <- 99 

Match_2_Bruges <- Mixed_Bruges_NL %>%
  filter(matches == 0)

Match_3_Bruges <- Mixed_Bruges_NL %>%
  filter(matches == 2)

for (i in 1:nrow(Match_3_Bruges)) {
  if (Match_3_Bruges[i,19] == TRUE) {
    Match_3_Bruges$id[i] <- 13
  }
}

Match_4_Bruges <- Mixed_Bruges_NL %>%
  filter(matches == 3)

Match_4_Bruges$id[Match_4_Bruges$id == 5] <- 14 

Bruges_final_match <- rbind(Match_1_Bruges, Match_2_Bruges, Match_3_Bruges, Match_4_Bruges) %>%
  select(item, article, lang, id)

Bruges_final_match_2 <- Bruges_NL_post %>%
  filter(id != 3 & id != 5 & id != 6 & id != 8 & id != 10)

Bruges_matched <- rbind(Bruges_final_match, Bruges_final_match_2)

Bruges_matched$id <- as.factor(Bruges_matched$id)

summary(Bruges_matched$id)

Bruges_articles_matched <- Bruges_matched %>%
  select(article, id)

Bruges_NL_nonunique <- Bruges_articles_NL %>%
  filter(lang == "nl") 

Bruges_unique <- Bruges_articles_in_C %>%
  distinct(article, lang, .keep_all = T) %>%
  select(-wm) %>%
  left_join(Bruges_matched, by = "item") %>%
  select(-article.y, -lang.y)

names(Bruges_unique) <- c("item", "article", "lang", "id")

summary(Bruges_unique$id)

Bruges_NL_nonunique$article <- stri_trans_general(Bruges_NL_nonunique$article, "Latin-ASCII")

Bruges_unique$article <- stri_trans_general(Bruges_unique$article, "Latin-ASCII")

Bruges_final <- Bruges_NL_nonunique %>%
  left_join(Bruges_articles_matched, by = "article") %>%
  select(-wm) %>%
  filter(!is.na(id))

Bruges_final$id[Bruges_final$item == 'Q590398'] <- 11
Bruges_final$id[Bruges_final$item == 'Q184383'] <- 10
Bruges_final$id[Bruges_final$item == 'Q700864'] <- 10
Bruges_final$id[Bruges_final$item == 'Q1477819'] <- 13

# Add residual category to dataframe

categories_Bruges[13,] <- c(99, "Other/Unclassified", "")

# Join with pageviews file

Bruges_pageviews_article <- Bruges_final %>%
  distinct(item, .keep_all = T) %>%
  left_join(Bruges_pageviews_C, by = "item") %>%
  group_by(id) %>%
  summarise(value_id = sum(value, na.rm = T)) %>%
  left_join(categories_Bruges, by = "id") %>%
  select(-keywords) %>%
  filter(id != 99)

Bruges_pageviews_article$percentage <- scales::percent(Bruges_pageviews_article$value_id/sum(Bruges_pageviews_article$value_id))

# create barchart 

library(ggplot2)

plot <- ggplot(data = Bruges_pageviews_article, aes(x = reorder(factor(category), value_id), y = value_id, fill = category)) +
  geom_bar(stat = "identity") +
  ggtitle("Number of pageviews by category - Bruges") +
  guides(fill=FALSE) +
  coord_flip() +
  xlab("") + 
  ylab("Number of pageviews")

plot

# Create scatterplot

scatter <- data.frame(no_articles = summary(Bruges_unique$id))
scatter <- scatter[-c(11,12),]
categ <- categories_Bruges$id 
categ <- categ[-c(12,13)]
value_id <- Bruges_pageviews_article$value_id

scatter_data <- data.frame(cbind(id = categ, value_id = value_id, no_articles = scatter), stringsAsFactors = F) %>%
  mutate(value_id = as.integer(value_id), 
         no_articles = as.integer(no_articles))

s <- ggplot(scatter_data, aes(x=no_articles, y=value_id)) +
  geom_point(shape=1) +    
  geom_smooth(method = "lm", se = F) +
  xlab("Number of articles") +
  ylab("Number of pageviews") +
  ggtitle("Correlation between number of articles and pageviews")
s

# Consider pageviews per category by language

Bruges_pageviews_article_language <- Bruges_unique %>%
  distinct(article, lang, .keep_all = T) %>%
  left_join(Bruges_pageviews_C, by = "item") %>%
  group_by(id, lang) %>%
  summarise(value_id = sum(value, na.rm = T)) %>%
  filter(id != 99 & !is.na(id))%>%
  left_join(categories_Bruges, by = "id") %>%
  select(-keywords) 

Bruges_pageviews_article_language$percentage <- scales::percent(Bruges_pageviews_article_language$value_id/sum(Bruges_pageviews_article_language$value_id))

library(reshape2)

w <- dcast(Bruges_pageviews_article_language, id + category ~ lang, value.var = "value_id")
w_percentage <- w[,3:27]
nas <- is.na(w_percentage)
w_percentage[nas] <- 0

library(tigerstats)

lang_percentage <- colPerc(w_percentage) 
lang_percentage <- lang_percentage[-12,]
lang_percentage <- data.frame(cbind(id = w$id, category = w$category, lang_percentage)) %>%
  mutate(id = as.numeric(id))

# Build time series for categories

Bruges_final_2 <- Bruges_final %>%
  distinct(item, .keep_all = T)

Bruges_final_ts <- Bruges_reads_in_C %>%
  left_join(Bruges_final_2, by = 'item') %>%
  select(-lat, -long)%>%
  filter(!is.na(id))%>%
  group_by(time, id)%>%
  summarise(value = sum(value))

## Plot time series

# Adjust the way the time variable is displayed

library(reshape2)
library(xts)

Bruges_final_ts <- dcast(Bruges_final_ts, time ~ id) %>%
  mutate(time = as.Date(ts(1:48, frequency = 12, start = c(2012, 01))))
Bruges_final_ts <- xts(Bruges_final_ts[,-1], order.by = as.POSIXct(Bruges_final_ts$time))

# Standardized
Bruges_final_ts_scaled <- scale(Bruges_final_ts)

library(dygraphs)
library(htmlwidgets)
options(scipen=999)

g <- dygraph(Bruges_final_ts_scaled, main = "Bruges (C) pageviews by categories") %>%
  dyOptions(colors = colorRampPalette(c("purple", "orange", "red", "green", "blue", "pink", "grey", "brown"))(12)) %>%
  dyHighlight(highlightSeriesOpts = list(strokeWidth = 3)) %>%
  dyRangeSelector(dateWindow = c("2013-01-01", "2014-12-31")) %>%
  dyLegend(width = 400)
g

saveWidget(widget = g, file="Bruges_categories.html", selfcontained = FALSE)
