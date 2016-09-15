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

### AFTER THIS, I'VE CHECKED MANUALLY THE MATCHIN OF A SAMPLE OF POINTS AND THEN I WILL RELOAD THE FILE

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
OID_Vienna_to_predict <- data.frame(OBJECTID = Vienna_to_predict$OBJECTID) 

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

write.csv(Vienna_YES_levels, "Vienna_YES_levels.csv", fileEncoding = "UTF-8")

# 787 points (over 2663, nearly 30% of Vienna Wikidata items)
# In this group we have 42 categories (the total was 44)

Vienna_YES_levels <- read.csv("C:/Users/signose/Desktop/Vienna_YES_levels.csv", encoding = "UTF-8") %>%
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



