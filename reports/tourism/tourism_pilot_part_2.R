### TOURISM PILOT (PART 2)

### This script starts from the downloading of the Wikipedia pageviews, reads them and prepares the data 
### for the visualization. It then show how to create maps and time series plots.
### NOTE: the package leaflet does not work on the sandbox, you have to use it locally!

rm(list=ls())
library(dplyr)
library(jsonlite)
source("scripts/r/wikidata_functions.R")
source("scripts/r/redirects_target_and_origin_for_cities.R")

CITIES_ARTICLES_WIKISTATS_FILE <- "hdfs:/user/signose/cities_articles_wikistats_month.csv"
CITIES_DATASET <- "reports/cities/cities.csv"

Articles_to_download <- read.csv('Articles_to_download.csv') %>%
  mutate(wm = getWikiMarkup(article, lang),
  target = "",
  origins_checked = FALSE)

# Save as a csv
write.csv(Articles_to_download, 'Articles_to_download_wm.csv')

# Add redirects targets and origins

# This version of code does work but it takes a lot of time if you have a high number of articles, 
# so use the following, same procedure but splitted and then merged

Articles_to_download_wm <- read.csv('Articles_to_download_wm.csv', stringsAsFactors = F) %>%
  mutate(id = item, target = "") %>%
  select(-item, -X, -X.1) %>%
  add_redirect_targets() %>%
  add_redirect_origins() %>%
  select(-wm) %>%
  mutate(item = id) %>%
  select(-id)

# Splitted version (to use if the previous one takes too long)
Articles_to_download_wm <- read.csv('Articles_to_download_wm.csv', stringsAsFactors = F) 

a <- Articles_to_download_wm[1:1000, ] %>%
  mutate(id = item, target = "") %>%
  select(-item, -X, -X.1) %>%
  add_redirect_targets() %>%
  add_redirect_origins() %>%
  select(-wm) %>%
  mutate(item = id) %>%
  select(-id)

write.csv(a, './splitted_files/a.csv')

b <- Articles_to_download_wm[1001:2000, ] %>%
  mutate(id = item, target = "") %>%
  select(-item, -X, -X.1) %>%
  add_redirect_targets() %>%
  add_redirect_origins() %>%
  select(-wm) %>%
  mutate(item = id) %>%
  select(-id)

write.csv(b, './splitted_files/b.csv')

c <- Articles_to_download_wm[2001:3000, ] %>%
  mutate(id = item, target = "") %>%
  select(-item, -X, -X.1) %>%
  add_redirect_targets() %>%
  add_redirect_origins() %>%
  select(-wm) %>%
  mutate(item = id) %>%
  select(-id)

write.csv(c, './splitted_files/c.csv')

d <- Articles_to_download_wm[3001:4000, ] %>%
  mutate(id = item, target = "") %>%
  select(-item, -X, -X.1) %>%
  add_redirect_targets() %>%
  add_redirect_origins() %>%
  select(-wm) %>%
  mutate(item = id) %>%
  select(-id)

write.csv(d, './splitted_files/d.csv')

e <- Articles_to_download_wm[4001:5000, ] %>%
  mutate(id = item, target = "") %>%
  select(-item, -X, -X.1) %>%
  add_redirect_targets() %>%
  add_redirect_origins() %>%
  select(-wm) %>%
  mutate(item = id) %>%
  select(-id)

write.csv(e, './splitted_files/e.csv')

g <- Articles_to_download_wm[5001:6000, ] %>%
  mutate(id = item, target = "") %>%
  select(-item, -X, -X.1) %>%
  add_redirect_targets() %>%
  add_redirect_origins() %>%
  select(-wm) %>%
  mutate(item = id) %>%
  select(-id)

write.csv(g, './splitted_files/g.csv')

h <- Articles_to_download_wm[6001:7000, ] %>%
  mutate(id = item, target = "") %>%
  select(-item, -X, -X.1) %>%
  add_redirect_targets() %>%
  add_redirect_origins() %>%
  select(-wm) %>%
  mutate(item = id) %>%
  select(-id)

write.csv(h, './splitted_files/h.csv')

i <- Articles_to_download_wm[7001:8000, ] %>%
  mutate(id = item, target = "") %>%
  select(-item, -X, -X.1) %>%
  add_redirect_targets() %>%
  add_redirect_origins() %>%
  select(-wm) %>%
  mutate(item = id) %>%
  select(-id)

write.csv(i, './splitted_files/i.csv')

j <- Articles_to_download_wm[8001:9000, ] %>%
  mutate(id = item, target = "") %>%
  select(-item, -X, -X.1) %>%
  add_redirect_targets() %>%
  add_redirect_origins() %>%
  select(-wm) %>%
  mutate(item = id) %>%
  select(-id)

write.csv(j, './splitted_files/j.csv')

k <- Articles_to_download_wm[9001:10000, ] %>%
  mutate(id = item, target = "") %>%
  select(-item, -X, -X.1) %>%
  add_redirect_targets() %>%
  add_redirect_origins() %>%
  select(-wm) %>%
  mutate(item = id) %>%
  select(-id)

write.csv(k, './splitted_files/k.csv')

l <- Articles_to_download_wm[10001:11000, ] %>%
  mutate(id = item, target = "") %>%
  select(-item, -X, -X.1) %>%
  add_redirect_targets() %>%
  add_redirect_origins() %>%
  select(-wm) %>%
  mutate(item = id) %>%
  select(-id)

write.csv(l, './splitted_files/l.csv')

m <- Articles_to_download_wm[11001:12000, ] %>%
  mutate(id = item, target = "") %>%
  select(-item, -X, -X.1) %>%
  add_redirect_targets() %>%
  add_redirect_origins() %>%
  select(-wm) %>%
  mutate(item = id) %>%
  select(-id)

write.csv(m, './splitted_files/m.csv')

n <- Articles_to_download_wm[12001:12395, ] %>%
  mutate(id = item, target = "") %>%
  select(-item, -X, -X.1) %>%
  add_redirect_targets() %>%
  add_redirect_origins() %>%
  select(-wm) %>%
  mutate(item = id) %>%
  select(-id)

write.csv(n, './splitted_files/n.csv')

# Merge the df

a <- read.csv('./splitted_files/a.csv', stringsAsFactors = F) %>%
  select(-X)
b <- read.csv('./splitted_files/b.csv', stringsAsFactors = F) %>%
  select(-X)
c <- read.csv('./splitted_files/c.csv', stringsAsFactors = F) %>%
  select(-X)
d <- read.csv('./splitted_files/d.csv', stringsAsFactors = F) %>%
  select(-X)
e <- read.csv('./splitted_files/e.csv', stringsAsFactors = F) %>%
  select(-X)
g <- read.csv('./splitted_files/g.csv', stringsAsFactors = F) %>%
  select(-X)
h <- read.csv('./splitted_files/h.csv', stringsAsFactors = F) %>%
  select(-X)
hh <- read.csv('./splitted_files/hh.csv', stringsAsFactors = F) %>%
  select(-X)
i <- read.csv('./splitted_files/i.csv', stringsAsFactors = F) %>%
  select(-X)
j <- read.csv('./splitted_files/j.csv', stringsAsFactors = F) %>%
  select(-X)
k <- read.csv('./splitted_files/k.csv', stringsAsFactors = F) %>%
  select(-X)
l <- read.csv('./splitted_files/l.csv', stringsAsFactors = F) %>%
  select(-X)
m <- read.csv('./splitted_files/m.csv', stringsAsFactors = F) %>%
  select(-X)

Articles_to_download_redirects <- rbind(a,b,c,d,e,g,h,hh,i,j,k,l,m)

# Save as a csv
write.csv(Articles_to_download_redirects, 'Articles_to_download_redirects_SPLITTED.csv')

# Create a text file for each group of words in each language
Articles_to_download_redirects <- read.csv('Articles_to_download_redirects_SPLITTED.csv', stringsAsFactors = T) %>%
  select(-X)
articles <- as.character(Articles_to_download_redirects$article)
lang <- Articles_to_download_redirects$lang
make_extract_config(articles, lang)

# After running this script, you will receive instructions on how to extract page views 

# Read the pageviews 

articles_wikistats <- read_wikistats()

## Save data to disk
write_csv(articles_wikistats, CITIES_ARTICLES_WIKISTATS_FILE, row.names=FALSE, fileEncoding="utf-8")

# Prepare articles dataset
cities_articles <- Articles_to_download_redirects %>%
  select(-target, -origins_checked) %>%
  mutate(article = normalize(as.character(article)))

# Get wikistats (Wikipedia page views statistics)
cities_wikistats <- 
  
  # Read wikistats data file
  read_csv(CITIES_ARTICLES_WIKISTATS_FILE, fileEncoding="utf-8") %>%	
  mutate(article = normalize(as.character(article))) %>%
  
  # Join articles with wikistats
  left_join(cities_articles, by = c("lang", "article")) %>%
  
  # Aggregate wikistats by item
  group_by(lang, item, time) %>%
  summarise(value = sum(value)) %>%
  filter(time != 'article2')

# Save dataset to disk
write.csv(cities_wikistats, CITIES_DATASET, row.names=FALSE, fileEncoding="utf-8")

# Divide the dataset based on city
Barcelona_reads_in_C <- Barcelona_in_C %>%
  select(item, long, lat) %>%
  left_join(cities_wikistats, by = 'item') %>%
  group_by(lang, item, time, long, lat) %>%
  summarise(value = sum(value)) %>%
  group_by() %>%
  filter(time != 'article2') %>%
  mutate(item = as.factor(item),
         lang = as.factor(lang))

write.csv(Barcelona_reads_in_C, './reports/cities/Barcelona_C.csv')

Barcelona_reads_in_K <- Barcelona_in_K %>%
  select(item, lat, long) %>%
  left_join(cities_wikistats, by = 'item') %>%
  group_by(lang, item, time, long, lat) %>%
  summarise(value = sum(value)) %>%
  group_by() %>%
  filter(time != 'article2') %>%
  mutate(item = as.factor(item),
         lang = as.factor(lang))

write.csv(Barcelona_reads_in_K, './reports/cities/Barcelona_K.csv')

Bruges_reads_in_C <- Bruges_in_C %>%
  select(item, lat, long) %>%
  left_join(cities_wikistats, by = 'item') %>%
  group_by(lang, item, time, long, lat) %>%
  summarise(value = sum(value)) %>%
  group_by() %>%
  filter(time != 'article2') %>%
  mutate(item = as.factor(item),
         lang = as.factor(lang))

write.csv(Bruges_reads_in_C, './reports/cities/Bruges_C.csv')

Bruges_reads_in_F <- Bruges_in_F %>%
  select(item, lat, long) %>%
  left_join(cities_wikistats, by = 'item') %>%
  group_by(lang, item, time, long, lat) %>%
  summarise(value = sum(value)) %>%
  group_by() %>%
  filter(time != 'article2') %>%
  mutate(item = as.factor(item),
         lang = as.factor(lang))

write.csv(Bruges_reads_in_F, './reports/cities/Bruges_F.csv')

Vienna_reads_in_C <- Vienna_in_C %>%
  select(item, lat, long) %>%
  left_join(cities_wikistats, by = 'item') %>%
  group_by(lang, item, time, long, lat) %>%
  summarise(value = sum(value)) %>%
  group_by() %>%
  filter(time != 'article2') %>%
  mutate(item = as.factor(item),
         lang = as.factor(lang))

write.csv(Vienna_reads_in_C, './reports/cities/Vienna_C.csv')

# Prepare data for the map

# Barcelona C
Barcelona_pageviews_C <- Barcelona_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(as.numeric(value)))

write.csv(Barcelona_pageviews_C, './reports/cities/Barcelona_pageviews_C.csv')

Barcelona_C <- Barcelona_pageviews_C %>%
  left_join(Barcelona_in_C, by = 'item') %>%
  select(item, long, lat, value) %>%
  distinct(item)

write.csv(Barcelona_C, './reports/cities/Barcelona_pw_coord_C.csv')

# Barcelona K
Barcelona_pageviews_K <- Barcelona_reads_in_K %>%
  group_by(item) %>%
  summarise(value = sum(as.numeric(value)))

write.csv(Barcelona_pageviews_K, './reports/cities/Barcelona_pageviews_K.csv')

Barcelona_K <- Barcelona_pageviews_K %>%
  left_join(Barcelona_in_K, by = 'item') %>%
  select(item, long, lat, value) %>%
  distinct(item)

write.csv(Barcelona_K, './reports/cities/Barcelona_pw_coord_K.csv')

# Bruges C
Bruges_pageviews_C <- Bruges_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(as.numeric(value)))

write.csv(Bruges_pageviews_C, './reports/cities/Bruges_pageviews_C.csv')

Bruges_C <- Bruges_pageviews_C %>%
  left_join(Bruges_in_C, by = 'item') %>%
  select(item, long, lat, value) %>%
  distinct(item)

write.csv(Bruges_C, './reports/cities/Bruges_pw_coord_C.csv')

# Bruges F
Bruges_pageviews_F <- Bruges_reads_in_F %>%
  group_by(item) %>%
  summarise(value = sum(as.numeric(value)))

write.csv(Bruges_pageviews_F, './reports/cities/Bruges_pageviews_F.csv')

Bruges_F <- Bruges_pageviews_F %>%
  left_join(Bruges_in_F, by = 'item') %>%
  select(item, long, lat, value) %>%
  distinct(item)

write.csv(Bruges_F, './reports/cities/Bruges_pw_coord_F.csv')

# Vienna C
Vienna_pageviews_C <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(as.numeric(value)))

write.csv(Vienna_pageviews_C, './reports/cities/Vienna_pageviews_C.csv')

Vienna_C <- Vienna_pageviews_C %>%
  left_join(Vienna_in_C, by = 'item') %>%
  select(item, long, lat, value) %>%
  distinct(item)

write.csv(Vienna_C, './reports/cities/Vienna_pw_coord_C.csv')

# Create map using leaflet

#### NOTE FOR INSERTING HTML AND CHARTS INTO A SHINY APP:
#### In order to host an html map, upload the html file and the related foldes (i.e. 'Barcelona_files')
#### into a new folder in Google drive. Set the folder as public by right clicking on it -> share -> advanced
#### and set 'available to everybody on the web'. Copy the link and keep only the id (the code with letters and
#### numbers). Then put it after 'www.googledrive.com/host/'. This address, followed by '/____.html' will be the 
#### url to use in the shiny app.

library(dplyr)
library(leaflet)
library(htmlwidgets)

# Barcelona C

Barcelona_C <-read.csv("C:/Users/signose/Desktop/Cities/Pageviews/Barcelona_pw_coord_C.csv") %>%
  select(-X)

Barcelona_articles_in_C <-read.csv("./data_using_wikidata/pageviews/Barcelona_articles_C.csv") %>%
  select(-X) %>%
  distinct(item) %>%
  arrange(item, lang == 'en')

Barcelona_C_final <- Barcelona_C %>%
  left_join(Barcelona_articles_in_C, by = 'item') 
  
pal <- colorQuantile("Reds", NULL, n = 8)

m <- leaflet(Barcelona_C_final) %>%
  addProviderTiles("CartoDB.Positron")%>%
  addCircleMarkers(~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~pal(value), fillOpacity = 0.6) %>%
  addMarkers(~long, ~lat, popup = ~article, options =markerOptions(opacity = 0)) %>%
  addLegend(position = c("bottomright"), colorNumeric("Reds", NULL, n=7), values = ~value)
m

saveWidget(widget = m, file="Barcelona_C.html", selfcontained = FALSE)

# Barcelona K

Barcelona_K <-read.csv("C:/Users/signose/Desktop/Cities/Pageviews/Barcelona_pw_coord_K.csv") %>%
  select(-X)

Barcelona_articles_in_K <-read.csv("C:/Users/signose/Desktop/Cities/Pageviews/Barcelona_articles_K.csv") %>%
  select(-X) %>%
  distinct(item) %>%
  arrange(item, lang == 'en')

Barcelona_K_final <- Barcelona_K %>%
  left_join(Barcelona_articles_in_K, by = 'item') 
  
pal <- colorQuantile("Reds", NULL, n = 8)

m <- leaflet(Barcelona_K_final) %>%
  addProviderTiles("CartoDB.Positron")%>%
  addCircleMarkers(~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~pal(value), fillOpacity = 0.6) %>%
  addMarkers(~long, ~lat, popup = ~article, options =markerOptions(opacity = 0)) %>%
  addLegend(position = c("bottomright"), colorNumeric("Reds", NULL, n=7), values = ~value)
m

saveWidget(widget = m, file="Barcelona_K.html", selfcontained = FALSE)

# Bruges C

Bruges_C <-read.csv("C:/Users/signose/Desktop/Cities/Pageviews/Bruges_pw_coord_C.csv") %>%
  select(-X)

Bruges_articles_in_C <-read.csv("C:/Users/signose/Desktop/Cities/Pageviews/Bruges_articles_C.csv") %>%
  select(-X) %>%
  distinct(item) %>%
  arrange(item, lang == 'en')

Bruges_C_final <- Bruges_C %>%
  left_join(Bruges_articles_in_C, by = 'item') 

pal <- colorQuantile("Reds", NULL, n = 8)

m <- leaflet(Bruges_C_final) %>%
  addProviderTiles("CartoDB.Positron")%>%
  addCircleMarkers(~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~pal(value), fillOpacity = 0.6) %>%
  addMarkers(~long, ~lat, popup = ~article, options =markerOptions(opacity = 0)) %>%
  addLegend(position = c("bottomright"), colorNumeric("Reds", NULL, n=7), values = ~value)
m

saveWidget(widget = m, file="Bruges_C.html", selfcontained = FALSE)

# Bruges F

Bruges_F <-read.csv("C:/Users/signose/Desktop/Cities/Pageviews/Bruges_pw_coord_F.csv") %>%
  select(-X)

Bruges_articles_in_F <-read.csv("C:/Users/signose/Desktop/Cities/Pageviews/Bruges_articles_F.csv") %>%
  select(-X) %>%
  distinct(item) %>%
  arrange(item, lang == 'en')

Bruges_F_final <- Bruges_F %>%
  left_join(Bruges_articles_in_F, by = 'item') 

pal <- colorQuantile("Reds", NULL, n = 8)

m <- leaflet(Bruges_F_final) %>%
  addProviderTiles("CartoDB.Positron")%>%
  addCircleMarkers(~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~pal(value), fillOpacity = 0.6) %>%
  addMarkers(~long, ~lat, popup = ~article, options =markerOptions(opacity = 0)) %>%
  addLegend(position = c("bottomright"), colorNumeric("Reds", NULL, n=7), values = ~value)
m

saveWidget(widget = m, file="Bruges_F.html", selfcontained = FALSE)

# Vienna C

Vienna_C <-read.csv("C:/Users/signose/Desktop/Cities/Pageviews/Vienna_pw_coord_C.csv") %>%
  select(-X)

Vienna_articles_in_C <-read.csv("C:/Users/signose/Desktop/Cities/Pageviews/Vienna_articles_C.csv") %>%
  select(-X) %>%
  distinct(item) %>%
  arrange(item, lang == 'en')

Vienna_C_final <- Vienna_C %>%
  left_join(Vienna_articles_in_C, by = 'item') 

pal <- colorQuantile("Reds", NULL, n = 8)

m <- leaflet(Vienna_C_final) %>%
  addProviderTiles("CartoDB.Positron")%>%
  addCircleMarkers(~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~pal(value), fillOpacity = 0.6) %>%
  addMarkers(~long, ~lat, popup = ~article, options =markerOptions(opacity = 0)) %>%
  addLegend(position = c("bottomright"), colorNumeric("Reds", NULL, n=7), values = ~value)
m

saveWidget(widget = m, file="Vienna_C.html", selfcontained = FALSE)

### Plot time series using dygraphs

library(xts)

# Barcelona C

Barcelona_reads_in_C <- read.csv('./reports/cities/Barcelona_C.csv') %>%
  select(-X)

### Ts of top 10 languages

# Check for main languages
Barcelona_lang_ts_C <- Barcelona_reads_in_C %>%
  group_by(lang) %>%
  summarise(value = sum(value)) %>%
  arrange(desc(value))

# Top 10 languages: en, es, fr, ru, de, it, pl, pt, nl, tr

# Create ts for each of the top 10 languages
Barcelona_en_ts_C <- Barcelona_reads_in_C %>%
  filter(lang == "en") %>%
  group_by(time)%>%
  summarise(value = sum(value)) 
names(Barcelona_en_ts_C)[2] <- "en"

Barcelona_es_ts_C <- Barcelona_reads_in_C %>%
  filter(lang == "es") %>%
  group_by(time)%>%
  summarise(value = sum(value)) 
names(Barcelona_es_ts_C)[2] <- "es"

Barcelona_de_ts_C <- Barcelona_reads_in_C %>%
  filter(lang == "de") %>%
  group_by(time)%>%
  summarise(value = sum(value)) 
names(Barcelona_de_ts_C)[2] <- "de"

Barcelona_ru_ts_C <- Barcelona_reads_in_C %>%
  filter(lang == "ru") %>%
  group_by(time)%>%
  summarise(value = sum(value)) 
names(Barcelona_ru_ts_C)[2] <- "ru"

Barcelona_pt_ts_C <- Barcelona_reads_in_C %>%
  filter(lang == "pt") %>%
  group_by(time)%>%
  summarise(value = sum(value)) 
names(Barcelona_pt_ts_C)[2] <- "pt"

Barcelona_it_ts_C <- Barcelona_reads_in_C %>%
  filter(lang == "it") %>%
  group_by(time)%>%
  summarise(value = sum(value)) 
names(Barcelona_it_ts_C)[2] <- "it"

Barcelona_pl_ts_C <- Barcelona_reads_in_C %>%
  filter(lang == "pl") %>%
  group_by(time)%>%
  summarise(value = sum(value)) 
names(Barcelona_pl_ts_C)[2] <- "pl"

Barcelona_tr_ts_C <- Barcelona_reads_in_C %>%
  filter(lang == "tr") %>%
  group_by(time)%>%
  summarise(value = sum(value)) 
names(Barcelona_tr_ts_C)[2] <- "tr"

Barcelona_fr_ts_C <- Barcelona_reads_in_C %>%
  filter(lang == "fr") %>%
  group_by(time)%>%
  summarise(value = sum(value)) 
names(Barcelona_fr_ts_C)[2] <- "fr"

Barcelona_nl_ts_C <- Barcelona_reads_in_C %>%
  filter(lang == "nl") %>%
  group_by(time)%>%
  summarise(value = sum(value)) 
names(Barcelona_nl_ts_C)[2] <- "nl"

Barcelona_top_10_lang_ts_C <- data.frame(Barcelona_en_ts_C, Barcelona_es_ts_C$es, Barcelona_de_ts_C$de, Barcelona_ru_ts_C$ru, Barcelona_pt_ts_C$pt, Barcelona_it_ts_C$it, Barcelona_pl_ts_C$pl, Barcelona_tr_ts_C$tr, Barcelona_fr_ts_C$fr, Barcelona_nl_ts_C$nl)
names(Barcelona_top_10_lang_ts_C) <- c("time", "en", "es", "de", "ru", "pt", "it", "pl", "tr", "fr", "nl")
Barcelona_top_10_lang_ts_C$time <- as.Date(ts(1:48, frequency = 12, start = c(2012, 01)))
Barcelona_top_10_lang_ts_C <- xts(Barcelona_top_10_lang_ts_C[,-1], order.by = as.POSIXct(Barcelona_top_10_lang_ts_C$time))

# Save data to disk
write.csv(Barcelona_top_10_lang_ts_C, './data_using_wikidata/pageviews/Barcelona_top_10_lang_ts_C.csv', row.names=FALSE, fileEncoding="utf-8")

### Single ts

Barcelona_ts_reads_in_C <- Barcelona_reads_in_C %>%
  select(-long, -lat) %>%
  group_by(time) %>%
  summarise(value = sum(value))

# Adjust the way the time variable is displayed
Barcelona_ts_reads_in_C <- melt(Barcelona_ts_reads_in_C, id = "time") %>%
  mutate(year = substr(time, 2, 5)) %>%
  mutate(month = substr(time, 7, 8)) %>%
  select(-variable)
Barcelona_ts_reads_in_C$time <- as.Date(ts(1:48, frequency = 12, start = c(2012, 01)))
Barcelona_ts_reads_in_C <- xts(Barcelona_ts_reads_in_C[,-1], order.by = as.POSIXct(Barcelona_ts_reads_in_C$time))

# Save data to disk
write.csv(Barcelona_ts_reads_in_C, './data_using_wikidata/pageviews/Barcelona_ts_C.csv', row.names=FALSE, fileEncoding="utf-8")

# Consider only top 6 languages
Barcelona_top_6_lang_ts_C <- Barcelona_top_10_lang_ts_C[ ,1:6]

# Create ts plot

library(dygraphs)
library(htmlwidgets)
options(scipen=999)

g <- dygraph(Barcelona_top_6_lang_ts_C, main = "Barcelona (C) pageviews by top 6 languages") %>%
  dyOptions(colors = RColorBrewer::brewer.pal(6, "Dark2")) %>%
  dyHighlight(highlightSeriesOpts = list(strokeWidth = 3)) %>%
  dyRangeSelector(dateWindow = c("2013-01-01", "2014-12-31")) %>%
  dyLegend(width = 400)
g

saveWidget(widget = g, file="Barcelona_C_top_6_lang_ts.html", selfcontained = FALSE)

# scaled series

Barcelona_top_6_lang_ts_C_scaled <- scale(Barcelona_top_6_lang_ts_C)

g <- dygraph(Barcelona_top_6_lang_ts_C_scaled, main = "Barcelona (C) scaled pageviews by top 6 languages") %>%
  dyOptions(colors = RColorBrewer::brewer.pal(6, "Dark2")) %>%
  dyHighlight(highlightSeriesOpts = list(strokeWidth = 3)) %>%
  dyRangeSelector(dateWindow = c("2013-01-01", "2014-12-31")) %>%
  dyLegend(width = 400)
g

saveWidget(widget = g, file="Barcelona_C_top_6_lang_ts_scaled.html", selfcontained = FALSE)

# Barcelona K

Barcelona_reads_in_K <- read.csv('./reports/cities/Barcelona_K.csv') %>%
  select(-X)

### Ts of top 6 languages

# Check for main languages
Barcelona_lang_ts_K <- Barcelona_reads_in_K %>%
  group_by(lang) %>%
  summarise(value = sum(value)) %>%
  arrange(desc(value))

# Top 6 languages: en, es, fr, de, ru, it

# Create ts for each of the top 10 languages
Barcelona_en_ts_K <- Barcelona_reads_in_K %>%
  filter(lang == "en") %>%
  group_by(time)%>%
  summarise(value = sum(value)) 
names(Barcelona_en_ts_K)[2] <- "en"

Barcelona_es_ts_K <- Barcelona_reads_in_K %>%
  filter(lang == "es") %>%
  group_by(time)%>%
  summarise(value = sum(value)) 
names(Barcelona_es_ts_K)[2] <- "es"

Barcelona_de_ts_K <- Barcelona_reads_in_K %>%
  filter(lang == "de") %>%
  group_by(time)%>%
  summarise(value = sum(value)) 
names(Barcelona_de_ts_K)[2] <- "de"

Barcelona_ru_ts_K <- Barcelona_reads_in_K %>%
  filter(lang == "ru") %>%
  group_by(time)%>%
  summarise(value = sum(value)) 
names(Barcelona_ru_ts_K)[2] <- "ru"

Barcelona_fr_ts_K <- Barcelona_reads_in_K %>%
  filter(lang == "fr") %>%
  group_by(time)%>%
  summarise(value = sum(value)) 
names(Barcelona_fr_ts_K)[2] <- "fr"

Barcelona_it_ts_K <- Barcelona_reads_in_K %>%
  filter(lang == "it") %>%
  group_by(time)%>%
  summarise(value = sum(value)) 
names(Barcelona_it_ts_K)[2] <- "it"

library(xts)

Barcelona_top_6_lang_ts_K <- data.frame(Barcelona_en_ts_K, Barcelona_es_ts_K$es, Barcelona_de_ts_K$de, Barcelona_ru_ts_K$ru, Barcelona_fr_ts_K$fr, Barcelona_it_ts_K$it)
names(Barcelona_top_6_lang_ts_K) <- c("time", "en", "es", "de", "ru", "fr", "it")
Barcelona_top_6_lang_ts_K$time <- as.Date(ts(1:48, frequency = 12, start = c(2012, 01)))
Barcelona_top_6_lang_ts_K <- xts(Barcelona_top_6_lang_ts_K[,-1], order.by = as.POSIXct(Barcelona_top_6_lang_ts_K$time))

# Save data to disk
write.csv(Barcelona_top_6_lang_ts_K, './data_using_wikidata/pageviews/Barcelona_top_6_lang_ts_K.csv', row.names=FALSE, fileEncoding="utf-8")

# Create ts plot

g <- dygraph(Barcelona_top_6_lang_ts_K, main = "Barcelona (K) pageviews by top 6 languages") %>%
  dyOptions(colors = RColorBrewer::brewer.pal(6, "Dark2")) %>%
  dyHighlight(highlightSeriesOpts = list(strokeWidth = 3)) %>%
  dyRangeSelector(dateWindow = c("2013-01-01", "2014-12-31")) %>%
  dyLegend(width = 400)
g

saveWidget(widget = g, file="Barcelona_K_top_6_lang_ts.html", selfcontained = FALSE)

# scaled series

Barcelona_top_6_lang_ts_K_scaled <- scale(Barcelona_top_6_lang_ts_K)

g <- dygraph(Barcelona_top_6_lang_ts_K_scaled, main = "Barcelona (K) scaled pageviews by top 6 languages") %>%
  dyOptions(colors = RColorBrewer::brewer.pal(6, "Dark2")) %>%
  dyHighlight(highlightSeriesOpts = list(strokeWidth = 3)) %>%
  dyRangeSelector(dateWindow = c("2013-01-01", "2014-12-31")) %>%
  dyLegend(width = 400)
g

saveWidget(widget = g, file="Barcelona_K_top_6_lang_ts_scaled.html", selfcontained = FALSE)


# Bruges C

Bruges_reads_in_C <- read.csv('./reports/cities/Bruges_C.csv') %>%
  select(-X)

### Ts of top 6 languages

# Check for main languages
Bruges_lang_ts_C <- Bruges_reads_in_C %>%
  group_by(lang) %>%
  summarise(value = sum(value)) %>%
  arrange(desc(value))

# Top 6 languages: en, es, fr, nl, de, it

# Create ts for each of the top 6 languages
Bruges_en_ts_C <- Bruges_reads_in_C %>%
  filter(lang == "en") %>%
  group_by(time)%>%
  summarise(value = sum(value)) 
names(Bruges_en_ts_C)[2] <- "en"

Bruges_de_ts_C <- Bruges_reads_in_C %>%
  filter(lang == "de") %>%
  group_by(time)%>%
  summarise(value = sum(value)) 
names(Bruges_de_ts_C)[2] <- "de"

Bruges_fr_ts_C <- Bruges_reads_in_C %>%
  filter(lang == "fr") %>%
  group_by(time)%>%
  summarise(value = sum(value)) 
names(Bruges_fr_ts_C)[2] <- "fr"

Bruges_nl_ts_C <- Bruges_reads_in_C %>%
  filter(lang == "nl") %>%
  group_by(time)%>%
  summarise(value = sum(value)) 
names(Bruges_nl_ts_C)[2] <- "nl"

Bruges_it_ts_C <- Bruges_reads_in_C %>%
  filter(lang == "it") %>%
  group_by(time)%>%
  summarise(value = sum(value)) 
names(Bruges_it_ts_C)[2] <- "it"

Bruges_es_ts_C <- Bruges_reads_in_C %>%
  filter(lang == "es") %>%
  group_by(time)%>%
  summarise(value = sum(value)) 
names(Bruges_es_ts_C)[2] <- "es"

library(xts)

Bruges_top_6_lang_ts_C <- data.frame(Bruges_en_ts_C, Bruges_es_ts_C$es, Bruges_fr_ts_C$fr, Bruges_nl_ts_C$nl, Bruges_de_ts_C$de, Bruges_it_ts_C$it)
names(Bruges_top_6_lang_ts_C) <- c("time", "en", "es", "fr", "nl", "de", "it")
Bruges_top_6_lang_ts_C$time <- as.Date(ts(1:48, frequency = 12, start = c(2012, 01)))
Bruges_top_6_lang_ts_C <- xts(Bruges_top_6_lang_ts_C[,-1], order.by = as.POSIXct(Bruges_top_6_lang_ts_C$time))

# Save data to disk
write.csv(Bruges_top_6_lang_ts_C, './reports/cities/Bruges_top_6_lang_ts_C.csv', row.names=FALSE, fileEncoding="utf-8")

# Create ts plot

g <- dygraph(Bruges_top_6_lang_ts_C, main = "Bruges (C) pageviews by top 6 languages") %>%
  dyOptions(colors = RColorBrewer::brewer.pal(6, "Dark2")) %>%
  dyHighlight(highlightSeriesOpts = list(strokeWidth = 3)) %>%
  dyRangeSelector(dateWindow = c("2013-01-01", "2014-12-31")) %>%
  dyLegend(width = 400)
g

saveWidget(widget = g, file="Bruges_C_top_6_lang_ts.html", selfcontained = FALSE)


# Bruges F

Bruges_reads_in_F <- read.csv('./reports/cities/Bruges_F.csv') %>%
  select(-X)

### Ts of top 6 languages

# Check for main languages
Bruges_lang_ts_F <- Bruges_reads_in_F %>%
  group_by(lang) %>%
  summarise(value = sum(value)) %>%
  arrange(desc(value))

# Top 6 languages: en, es, nl, fr, de, it

# Create ts for each of the top 6 languages
Bruges_en_ts_F <- Bruges_reads_in_F %>%
  filter(lang == "en") %>%
  group_by(time)%>%
  summarise(value = sum(value)) 
names(Bruges_en_ts_F)[2] <- "en"

Bruges_de_ts_F <- Bruges_reads_in_F %>%
  filter(lang == "de") %>%
  group_by(time)%>%
  summarise(value = sum(value)) 
names(Bruges_de_ts_F)[2] <- "de"

Bruges_fr_ts_F <- Bruges_reads_in_F %>%
  filter(lang == "fr") %>%
  group_by(time)%>%
  summarise(value = sum(value)) 
names(Bruges_fr_ts_F)[2] <- "fr"

Bruges_nl_ts_F <- Bruges_reads_in_F %>%
  filter(lang == "nl") %>%
  group_by(time)%>%
  summarise(value = sum(value)) 
names(Bruges_nl_ts_F)[2] <- "nl"

Bruges_it_ts_F <- Bruges_reads_in_F %>%
  filter(lang == "it") %>%
  group_by(time)%>%
  summarise(value = sum(value)) 
names(Bruges_it_ts_F)[2] <- "it"

Bruges_es_ts_F <- Bruges_reads_in_F %>%
  filter(lang == "es") %>%
  group_by(time)%>%
  summarise(value = sum(value)) 
names(Bruges_es_ts_F)[2] <- "es"

library(xts)

Bruges_top_6_lang_ts_F <- data.frame(Bruges_en_ts_F, Bruges_es_ts_F$es, Bruges_nl_ts_F$nl, Bruges_fr_ts_F$fr, Bruges_de_ts_F$de, Bruges_it_ts_F$it)
names(Bruges_top_6_lang_ts_F) <- c("time", "en", "es", "nl", "fr", "de", "it")
Bruges_top_6_lang_ts_F$time <- as.Date(ts(1:48, frequency = 12, start = c(2012, 01)))
Bruges_top_6_lang_ts_F <- xts(Bruges_top_6_lang_ts_F[,-1], order.by = as.POSIXct(Bruges_top_6_lang_ts_F$time))

# Save data to disk
write.csv(Bruges_top_6_lang_ts_F, './reports/cities/Bruges_top_6_lang_ts_F.csv', row.names=FALSE, fileEncoding="utf-8")

# Create ts plot

g <- dygraph(Bruges_top_6_lang_ts_F, main = "Bruges (F) pageviews by top 6 languages") %>%
  dyOptions(colors = RColorBrewer::brewer.pal(6, "Dark2")) %>%
  dyHighlight(highlightSeriesOpts = list(strokeWidth = 3)) %>%
  dyRangeSelector(dateWindow = c("2013-01-01", "2014-12-31")) %>%
  dyLegend(width = 400)
g

saveWidget(widget = g, file="Bruges_F_top_6_lang_ts.html", selfcontained = FALSE)

# scaled series

Bruges_top_6_lang_ts_F_scaled <- scale(Bruges_top_6_lang_ts_F)

g <- dygraph(Bruges_top_6_lang_ts_F_scaled, main = "Bruges (F) scaled pageviews by top 6 languages") %>%
  dyOptions(colors = RColorBrewer::brewer.pal(6, "Dark2")) %>%
  dyHighlight(highlightSeriesOpts = list(strokeWidth = 3)) %>%
  dyRangeSelector(dateWindow = c("2013-01-01", "2014-12-31")) %>%
  dyLegend(width = 400)
g

saveWidget(widget = g, file="Bruges_F_top_6_lang_ts_scaled.html", selfcontained = FALSE)# Vienna C

# Vienna C 

Vienna_reads_in_C <- read.csv('./reports/cities/Vienna_C.csv') %>%
  select(-X)

### Ts of top 6 languages

# Check for main languages
Vienna_lang_ts_C <- Vienna_reads_in_C %>%
  group_by(lang) %>%
  summarise(value = sum(value)) %>%
  arrange(desc(value))

# Top 6 languages: en, de, es, ru, pl, fr

# Create ts for each of the top 6 languages
Vienna_en_ts_C <- Vienna_reads_in_C %>%
  filter(lang == "en") %>%
  group_by(time)%>%
  summarise(value = sum(value)) 
names(Vienna_en_ts_C)[2] <- "en"

Vienna_de_ts_C <- Vienna_reads_in_C %>%
  filter(lang == "de") %>%
  group_by(time)%>%
  summarise(value = sum(value)) 
names(Vienna_de_ts_C)[2] <- "de"

Vienna_ru_ts_C <- Vienna_reads_in_C %>%
  filter(lang == "ru") %>%
  group_by(time)%>%
  summarise(value = sum(value)) 
names(Vienna_ru_ts_C)[2] <- "ru"

Vienna_es_ts_C <- Vienna_reads_in_C %>%
  filter(lang == "es") %>%
  group_by(time)%>%
  summarise(value = sum(value)) 
names(Vienna_es_ts_C)[2] <- "es"

Vienna_pl_ts_C <- Vienna_reads_in_C %>%
  filter(lang == "pl") %>%
  group_by(time)%>%
  summarise(value = sum(value)) 
names(Vienna_pl_ts_C)[2] <- "pl"

Vienna_fr_ts_C <- Vienna_reads_in_C %>%
  filter(lang == "fr") %>%
  group_by(time)%>%
  summarise(value = sum(value)) 
names(Vienna_fr_ts_C)[2] <- "fr"

library(xts)

Vienna_top_6_lang_ts_C <- data.frame(Vienna_en_ts_C, Vienna_de_ts_C$de, Vienna_es_ts_C$es, Vienna_ru_ts_C$ru,  Vienna_pl_ts_C$pl, Vienna_fr_ts_C$fr)
names(Vienna_top_6_lang_ts_C) <- c("time", "en", "de", "es", "ru", "pl", "fr")
Vienna_top_6_lang_ts_C$time <- as.Date(ts(1:48, frequency = 12, start = c(2012, 01)))
Vienna_top_6_lang_ts_C <- xts(Vienna_top_6_lang_ts_C[,-1], order.by = as.POSIXct(Vienna_top_6_lang_ts_C$time))

# Save data to disk
write.csv(Vienna_top_6_lang_ts_C, './reports/cities/Vienna_top_6_lang_ts_C.csv', row.names=FALSE, fileEncoding="utf-8")

# Create ts plot

g <- dygraph(Vienna_top_6_lang_ts_C, main = "Vienna (C) pageviews by top 6 languages") %>%
  dyOptions(colors = RColorBrewer::brewer.pal(6, "Dark2")) %>%
  dyHighlight(highlightSeriesOpts = list(strokeWidth = 3)) %>%
  dyRangeSelector(dateWindow = c("2013-01-01", "2014-12-31")) %>%
  dyLegend(width = 400)
g

saveWidget(widget = g, file="Vienna_C_top_6_lang_ts.html", selfcontained = FALSE)

# scaled series

Vienna_top_6_lang_ts_C_scaled <- scale(Vienna_top_6_lang_ts_C)

g <- dygraph(Vienna_top_6_lang_ts_C_scaled, main = "Vienna (C) scaled pageviews by top 6 languages") %>%
  dyOptions(colors = RColorBrewer::brewer.pal(6, "Dark2")) %>%
  dyHighlight(highlightSeriesOpts = list(strokeWidth = 3)) %>%
  dyRangeSelector(dateWindow = c("2013-01-01", "2014-12-31")) %>%
  dyLegend(width = 400)
g

saveWidget(widget = g, file="Vienna_C_top_6_lang_ts_scaled.html", selfcontained = FALSE)



### Maps with layer per language

# Barcelona C

Barcelona_reads_in_C <- read.csv("C:/Users/signose/Desktop/Cities/Pageviews/Barcelona_C.csv") %>%
  select(-X)

# top 6 languages: en es de ru pt it

# Create one df for each of top 6 languages

# en
Barcelona_C_en <- Barcelona_reads_in_C %>%
  filter(lang == 'en') %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_C, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) 


# es
Barcelona_C_es <- Barcelona_reads_in_C %>%
  filter(lang == 'es') %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_C, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) 

# de
Barcelona_C_de <- Barcelona_reads_in_C %>%
  filter(lang == 'de') %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_C, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) 

# ru
Barcelona_C_ru <- Barcelona_reads_in_C %>%
  filter(lang == 'ru') %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_C, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) 

# pt
Barcelona_C_pt <- Barcelona_reads_in_C %>%
  filter(lang == 'pt') %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_C, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) 

# it
Barcelona_C_it <- Barcelona_reads_in_C %>%
  filter(lang == 'it') %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_C, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) 

Barcelona_top6_C <- rbind(Barcelona_C_en, Barcelona_C_es, Barcelona_C_de, Barcelona_C_ru, Barcelona_C_pt, Barcelona_C_it) %>%
  group_by(item)%>%
  summarise(value = sum(value))%>%
  left_join(Barcelona_C_final, by = "item")%>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) 

# Create map with layers

Red <- colorQuantile("Reds", NULL, n = 8)
Green <- colorQuantile("Greens", NULL, n = 8)
Blue <- colorQuantile("Blues", NULL, n = 8)
Purple <- colorQuantile("Purples", NULL, n = 8)
Grey <- colorQuantile("Greys", NULL, n = 8)
Orange <- colorQuantile("Oranges", NULL, n = 8)

m <- leaflet(Barcelona_C_final) %>%
  addProviderTiles("CartoDB.Positron")%>%
  addCircleMarkers(data = Barcelona_C_en, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Red(value), fillOpacity = 0.6, group = "English") %>%
  addCircleMarkers(data = Barcelona_C_es, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Green(value), fillOpacity = 0.6, group = "Spanish") %>%
  addCircleMarkers(data = Barcelona_C_de, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Blue(value), fillOpacity = 0.6, group = "German") %>%
  addCircleMarkers(data = Barcelona_C_ru, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Purple(value), fillOpacity = 0.6, group = "Russian") %>%
  addCircleMarkers(data = Barcelona_C_pt, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Grey(value), fillOpacity = 0.6, group = "Portuguese") %>%
  addCircleMarkers(data = Barcelona_C_it, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Orange(value), fillOpacity = 0.6, group = "Italian") %>%
  addMarkers(data = Barcelona_top6_C, ~long, ~lat, popup = ~article, options =markerOptions(opacity = 0)) %>%
  addLegend(position = c("bottomright"), colorNumeric("Reds", NULL, n=8),  values = ~value) %>%
  addLayersControl(overlayGroups = c("English", "Spanish", "German", "Russian", "Portuguese", "Italian"), options = layersControlOptions(collapsed = FALSE))
m

saveWidget(widget = m, file="Barcelona_C_top6.html", selfcontained = FALSE)

# Barcelona K

Barcelona_reads_K <- read.csv("C:/Users/signose/Desktop/Cities/Pageviews/Barcelona_K.csv") %>%
  select(-X)

# top 6 languages: en es fr de ru it

# Create one df for each of top 6 languages

# en
Barcelona_K_en <- Barcelona_reads_K %>%
  filter(lang == 'en') %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_K, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) 


# es
Barcelona_K_es <- Barcelona_reads_K %>%
  filter(lang == 'es') %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_K, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) 

# fr
Barcelona_K_fr <- Barcelona_reads_K %>%
  filter(lang == 'fr') %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_K, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) 

# de
Barcelona_K_de <- Barcelona_reads_K %>%
  filter(lang == 'de') %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_K, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) 

# ru
Barcelona_K_ru <- Barcelona_reads_K %>%
  filter(lang == 'ru') %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_K, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) 

# it
Barcelona_K_it <- Barcelona_reads_K %>%
  filter(lang == 'it') %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_K, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) 

Barcelona_top6_K <- rbind(Barcelona_K_en, Barcelona_K_es, Barcelona_K_fr, Barcelona_K_de, Barcelona_K_ru, Barcelona_K_it) %>%
  group_by(item)%>%
  summarise(value = sum(value))%>%
  left_join(Barcelona_K_final, by = "item")%>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) 

# Create map with layers

Red <- colorQuantile("Reds", NULL, n = 8)
Green <- colorQuantile("Greens", NULL, n = 8)
Blue <- colorQuantile("Blues", NULL, n = 8)
Purple <- colorQuantile("Purples", NULL, n = 8)
Grey <- colorQuantile("Greys", NULL, n = 8)
Orange <- colorQuantile("Oranges", NULL, n = 8)

m <- leaflet(Barcelona_K_final) %>%
  addProviderTiles("CartoDB.Positron")%>%
  addCircleMarkers(data = Barcelona_K_en, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Red(value), fillOpacity = 0.6, group = "English") %>%
  addCircleMarkers(data = Barcelona_K_es, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Green(value), fillOpacity = 0.6, group = "Spanish") %>%
  addCircleMarkers(data = Barcelona_K_fr, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Grey(value), fillOpacity = 0.6, group = "French") %>%
  addCircleMarkers(data = Barcelona_K_de, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Blue(value), fillOpacity = 0.6, group = "German") %>%
  addCircleMarkers(data = Barcelona_K_ru, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Purple(value), fillOpacity = 0.6, group = "Russian") %>%
  addCircleMarkers(data = Barcelona_K_it, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Orange(value), fillOpacity = 0.6, group = "Italian") %>%
  addMarkers(data = Barcelona_top6_K, ~long, ~lat, popup = ~article, options =markerOptions(opacity = 0)) %>%
  addLegend(position = c("bottomright"), colorNumeric("Reds", NULL, n=8),  values = ~value) %>%
  addLayersControl(overlayGroups = c("English", "Spanish", "French",  "German", "Russian", "Italian"), options = layersControlOptions(collapsed = FALSE))
m

saveWidget(widget = m, file="Barcelona_K_top6.html", selfcontained = FALSE)

# Bruges C

Bruges_reads_C <- read.csv("C:/Users/signose/Desktop/Cities/Pageviews/Bruges_C.csv") %>%
  select(-X)

# top 6 languages: en es fr nl de it

# Create one df for each of top 6 languages

# en
Bruges_C_en <- Bruges_reads_C %>%
  filter(lang == 'en') %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Bruges_C, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) 

# es
Bruges_C_es <- Bruges_reads_C %>%
  filter(lang == 'es') %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Bruges_C, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) 

# fr
Bruges_C_fr <- Bruges_reads_C %>%
  filter(lang == 'fr') %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Bruges_C, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) 

# nl
Bruges_C_nl <- Bruges_reads_C %>%
  filter(lang == 'nl') %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Bruges_C, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) 

# de
Bruges_C_de <- Bruges_reads_C %>%
  filter(lang == 'de') %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Bruges_C, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) 

# it
Bruges_C_it <- Bruges_reads_C %>%
  filter(lang == 'it') %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Bruges_C, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) 

Bruges_top6_C <- rbind(Bruges_C_en, Bruges_C_fr, Bruges_C_fr, Bruges_C_nl, Bruges_C_de, Bruges_C_it) %>%
  group_by(item)%>%
  summarise(value = sum(value))%>%
  left_join(Bruges_C_final, by = "item")%>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) 

# Create map with layers

Red <- colorQuantile("Reds", NULL, n = 8)
Green <- colorQuantile("Greens", NULL, n = 8)
Blue <- colorQuantile("Blues", NULL, n = 8)
Purple <- colorQuantile("Purples", NULL, n = 8)
Grey <- colorQuantile("Greys", NULL, n = 8)
Orange <- colorQuantile("Oranges", NULL, n = 8)

m <- leaflet(Bruges_C_final) %>%
  addProviderTiles("CartoDB.Positron")%>%
  addCircleMarkers(data = Bruges_C_en, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Red(value), fillOpacity = 0.6, group = "English") %>%
  addCircleMarkers(data = Bruges_C_es, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Orange(value), fillOpacity = 0.6, group = "Spanish") %>%
  addCircleMarkers(data = Bruges_C_fr, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Blue(value), fillOpacity = 0.6, group = "French") %>%
  addCircleMarkers(data = Bruges_C_nl, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Purple(value), fillOpacity = 0.6, group = "Dutch") %>%
  addCircleMarkers(data = Bruges_C_de, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Green(value), fillOpacity = 0.6, group = "German") %>%
  addCircleMarkers(data = Bruges_C_it, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Grey(value), fillOpacity = 0.6, group = "Italian") %>%
  addMarkers(data = Bruges_top6_C, ~long, ~lat, popup = ~article, options =markerOptions(opacity = 0)) %>%
  addLegend(position = c("bottomright"), colorNumeric("Reds", NULL, n=8),  values = ~value) %>%
  addLayersControl(overlayGroups = c("English", "Spanish", "French", "Dutch", "German", "Italian"), options = layersControlOptions(collapsed = FALSE))
m

saveWidget(widget = m, file="Bruges_C_top6.html", selfcontained = FALSE)

# Bruges F

Bruges_reads_F <- read.csv("C:/Users/signose/Desktop/Cities/Pageviews/Bruges_F.csv") %>%
  select(-X)

# top 6 languages: en es nl fr de it

# Create one df for each of top 6 languages

# en
Bruges_F_en <- Bruges_reads_F %>%
  filter(lang == 'en') %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Bruges_F, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) 

# es
Bruges_F_es <- Bruges_reads_F %>%
  filter(lang == 'es') %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Bruges_F, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) 

# nl
Bruges_F_nl <- Bruges_reads_F %>%
  filter(lang == 'nl') %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Bruges_F, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) 

# fr
Bruges_F_fr <- Bruges_reads_F %>%
  filter(lang == 'fr') %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Bruges_F, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) 

# de
Bruges_F_de <- Bruges_reads_F %>%
  filter(lang == 'de') %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Bruges_F, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) 

# it
Bruges_F_it <- Bruges_reads_F %>%
  filter(lang == 'it') %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Bruges_F, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) 

Bruges_top6_F <- rbind(Bruges_F_en, Bruges_F_es, Bruges_F_nl, Bruges_F_fr, Bruges_F_de, Bruges_F_it) %>%
  group_by(item)%>%
  summarise(value = sum(value))%>%
  left_join(Bruges_F_final, by = "item")%>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) 

# Create map with layers

Red <- colorQuantile("Reds", NULL, n = 8)
Green <- colorQuantile("Greens", NULL, n = 8)
Blue <- colorQuantile("Blues", NULL, n = 8)
Purple <- colorQuantile("Purples", NULL, n = 8)
Grey <- colorQuantile("Greys", NULL, n = 8)
Orange <- colorQuantile("Oranges", NULL, n = 8)

m <- leaflet(Bruges_F_final) %>%
  addProviderTiles("CartoDB.Positron")%>%
  addCircleMarkers(data = Bruges_F_en, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Red(value), fillOpacity = 0.6, group = "English") %>%
  addCircleMarkers(data = Bruges_F_es, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Orange(value), fillOpacity = 0.6, group = "Spanish") %>%
  addCircleMarkers(data = Bruges_F_nl, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Purple(value), fillOpacity = 0.6, group = "Dutch") %>%
  addCircleMarkers(data = Bruges_F_fr, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Blue(value), fillOpacity = 0.6, group = "French") %>%
  addCircleMarkers(data = Bruges_F_de, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Green(value), fillOpacity = 0.6, group = "German") %>%
  addCircleMarkers(data = Bruges_F_it, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Grey(value), fillOpacity = 0.6, group = "Italian") %>%
  addMarkers(data = Bruges_top6_F, ~long, ~lat, popup = ~article, options =markerOptions(opacity = 0)) %>%
  addLegend(position = c("bottomright"), colorNumeric("Reds", NULL, n=8),  values = ~value) %>%
  addLayersControl(overlayGroups = c("English", "Spanish",  "Dutch", "French", "German", "Italian" ), options = layersControlOptions(collapsed = FALSE))
m

saveWidget(widget = m, file="Bruges_F_top6.html", selfcontained = FALSE)

# Vienna C

Vienna_reads_C <- read.csv("C:/Users/signose/Desktop/Cities/Pageviews/Vienna_C.csv") %>%
  select(-X)

# top 6 languages: en, de, es, ru, pl, fr

# Create one df for each of top 6 languages

# en
Vienna_C_en <- Vienna_reads_C %>%
  filter(lang == 'en') %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_C, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) 

# de
Vienna_C_de <- Vienna_reads_C %>%
  filter(lang == 'de') %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_C, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) 

# es
Vienna_C_es <- Vienna_reads_C %>%
  filter(lang == 'es') %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_C, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) 

# ru
Vienna_C_ru <- Vienna_reads_C %>%
  filter(lang == 'ru') %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_C, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) 

# pl
Vienna_C_pl <- Vienna_reads_C %>%
  filter(lang == 'pl') %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_C, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) 

# fr
Vienna_C_fr <- Vienna_reads_C %>%
  filter(lang == 'fr') %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_C, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) 

Vienna_top6_C <- rbind(Vienna_C_en, Vienna_C_de, Vienna_C_es, Vienna_C_ru, Vienna_C_pl, Vienna_C_fr) %>%
  group_by(item)%>%
  summarise(value = sum(value))%>%
  left_join(Vienna_C_final, by = "item")%>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) 

# Create map with layers

Red <- colorQuantile("Reds", NULL, n = 8)
Green <- colorQuantile("Greens", NULL, n = 8)
Blue <- colorQuantile("Blues", NULL, n = 8)
Purple <- colorQuantile("Purples", NULL, n = 8)
Grey <- colorQuantile("Greys", NULL, n = 8)
Orange <- colorQuantile("Oranges", NULL, n = 8)

m <- leaflet(Vienna_C_final) %>%
  addProviderTiles("CartoDB.Positron")%>%
  addCircleMarkers(data = Vienna_C_en, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Red(value), fillOpacity = 0.6, group = "English") %>%
  addCircleMarkers(data = Vienna_C_de, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Green(value), fillOpacity = 0.6, group = "German") %>%
  addCircleMarkers(data = Vienna_C_es, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Purple(value), fillOpacity = 0.6, group = "Spanish") %>%
  addCircleMarkers(data = Vienna_C_ru, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Blue(value), fillOpacity = 0.6, group = "Russian") %>%
  addCircleMarkers(data = Vienna_C_pl, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Grey(value), fillOpacity = 0.6, group = "Polish") %>%
  addCircleMarkers(data = Vienna_C_fr, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Orange(value), fillOpacity = 0.6, group = "French") %>%
  addMarkers(data = Vienna_top6_C, ~long, ~lat, popup = ~article, options =markerOptions(opacity = 0)) %>%
  addLegend(position = c("bottomright"), colorNumeric("Reds", NULL, n=8),  values = ~value) %>%
  addLayersControl(overlayGroups = c("English", "German", "Spanish","Russian",  "Polish", "French"), options = layersControlOptions(collapsed = FALSE))
m

saveWidget(widget = m, file="Vienna_C_top6.html", selfcontained = FALSE)

### Maps with layer per year

Barcelona_reads_C <- read.csv("C:/Users/signose/Desktop/Cities/Pageviews/Barcelona_C.csv") %>%
  select(-X)
names(Barcelona_reads_C) = c("lang", "item", "time", "lng", "lat", "value")
Barcelona_reads_C <- Barcelona_reads_C[,c(3,1,2,4,5,6)]

names(Barcelona_C) = c("item", "lng", "lat", "value")

# Create one df for each year

# 2012
Barcelona_C_2012 <- Barcelona_reads_in_C %>%
  filter(substr(time, 2, 5) == "2012") %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_C, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) 

# 2013
Barcelona_C_2013 <- Barcelona_reads_in_C %>%
  filter(substr(time, 2, 5) == "2013") %>%
  group_by(item) %>%
  summarise(value = sum(value))%>%
  left_join(Barcelona_C, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) 

# 2014
Barcelona_C_2014 <- Barcelona_reads_in_C %>%
  filter(substr(time, 2, 5) == "2014") %>%
  group_by(item) %>%
  summarise(value = sum(value))%>%
  left_join(Barcelona_C, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) 

# 2015
Barcelona_C_2015 <- Barcelona_reads_in_C %>%
  filter(substr(time, 2, 5) == "2015") %>%
  group_by(item) %>%
  summarise(value = sum(value))%>%
  left_join(Barcelona_C, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) 

pal <- colorQuantile("Reds", NULL, n = 6)

m <- leaflet(Barcelona_C_final) %>%
  addProviderTiles("CartoDB.Positron")%>%
  addCircleMarkers(data = Barcelona_C_2012, ~lng, ~lat, radius = ~log(value), stroke = F, fillColor = ~pal(value), fillOpacity = 0.6, group = "2012") %>%
  addCircleMarkers(data = Barcelona_C_2013, ~lng, ~lat, radius = ~log(value), stroke = F, fillColor = ~pal(value), fillOpacity = 0.6, group = "2013") %>%
  addCircleMarkers(data = Barcelona_C_2014, ~lng, ~lat, radius = ~log(value), stroke = F, fillColor = ~pal(value), fillOpacity = 0.6, group = "2014") %>%
  addCircleMarkers(data = Barcelona_C_2015, ~lng, ~lat, radius = ~log(value), stroke = F, fillColor = ~pal(value), fillOpacity = 0.6, group = "2015") %>%
  addMarkers(data = Barcelona_C_final, ~lng, ~lat, popup = ~article, options =markerOptions(opacity = 0)) %>%
  addLegend(position = c("bottomright"), colorNumeric("Reds", NULL, n=6), values = ~value) %>%
  addLayersControl(baseGroups = c("2012", "2013", "2014", "2015"), options = layersControlOptions(collapsed = FALSE))
m