### TOURISM PILOT (PART 4)

library(dplyr)
library(jsonlite)
library(stringr)
library(leaflet)
library(htmlwidgets)

source("scripts/r/wikidata_functions.R")

### Get time series for this new variable 'cat'

Barcelona_C_ts <- Barcelona_reads_in_C %>%
  left_join(Barcelona_C_cat, by = 'item') %>%
  select(-lat, -long)%>%
  filter(!is.na(cat))%>%
  group_by(time, cat)%>%
  summarise(value = sum(value)) 

Barcelona_K_ts <- Barcelona_reads_in_K %>%
  left_join(Barcelona_K_cat, by = 'item') %>%
  select(-lat, -long)%>%
  filter(!is.na(cat))%>%
  group_by(time, cat)%>%
  summarise(value = sum(value))

Bruges_C_ts <- Bruges_reads_in_C %>%
  left_join(Bruges_C_cat, by = 'item') %>%
  select(-lat, -long)%>%
  filter(!is.na(cat))%>%
  group_by(time, cat)%>%
  summarise(value = sum(value))

Bruges_F_ts <- Bruges_reads_in_F %>%
  left_join(Bruges_F_cat, by = 'item') %>%
  select(-lat, -long)%>%
  filter(!is.na(cat))%>%
  group_by(time, cat)%>%
  summarise(value = sum(value))

Vienna_C_ts <- Vienna_reads_in_C %>%
  left_join(Vienna_C_cat, by = 'item') %>%
  select(-lat, -long)%>%
  filter(!is.na(cat))%>%
  group_by(time, cat)%>%
  summarise(value = sum(value))

## Plot time series

# Adjust the way the time variable is displayed

library(reshape2)
library(xts)

# Barcelona C

Barcelona_C_cat_ts <- dcast(Barcelona_C_ts, time ~ cat) %>%
  mutate(time = as.Date(ts(1:48, frequency = 12, start = c(2012, 01))))
Barcelona_C_cat_ts <- xts(Barcelona_C_cat_ts[,-1], order.by = as.POSIXct(Barcelona_C_cat_ts$time))

# Standardized
Barcelona_C_cat_ts_scaled <- scale(Barcelona_C_cat_ts)

# First differences
Barcelona_C_cat_ts_diff <- diff(Barcelona_C_cat_ts, differences=1)

# Barcelona K

Barcelona_K_cat_ts <- dcast(Barcelona_K_ts, time ~ cat) %>%
  mutate(time = as.Date(ts(1:48, frequency = 12, start = c(2012, 01))))
Barcelona_K_cat_ts <- xts(Barcelona_K_cat_ts[,-1], order.by = as.POSIXct(Barcelona_K_cat_ts$time))

# Standardized
Barcelona_K_cat_ts_scaled <- scale(Barcelona_K_cat_ts)

# First differences
Barcelona_K_cat_ts_diff <- diff(Barcelona_K_cat_ts, differences=1)

# Bruges C

Bruges_C_cat_ts <- dcast(Bruges_C_ts, time ~ cat) %>%
  mutate(time = as.Date(ts(1:48, frequency = 12, start = c(2012, 01))))
Bruges_C_cat_ts <- xts(Bruges_C_cat_ts[,-1], order.by = as.POSIXct(Bruges_C_cat_ts$time))

# Standardized
Bruges_C_cat_ts_scaled <- scale(Bruges_C_cat_ts)

# First differences
Bruges_C_cat_ts_diff <- diff(Bruges_C_cat_ts, differences=1)

# Bruges F

Bruges_F_cat_ts <- dcast(Bruges_F_ts, time ~ cat) %>%
  mutate(time = as.Date(ts(1:48, frequency = 12, start = c(2012, 01))))
Bruges_F_cat_ts <- xts(Bruges_F_cat_ts[,-1], order.by = as.POSIXct(Bruges_F_cat_ts$time))

# Standardized
Bruges_F_cat_ts_scaled <- scale(Bruges_F_cat_ts)

# First differences
Bruges_F_cat_ts_diff <- diff(Bruges_F_cat_ts, differences=1)

# Vienna C

Vienna_C_cat_ts <- dcast(Vienna_C_ts, time ~ cat) %>%
  mutate(time = as.Date(ts(1:48, frequency = 12, start = c(2012, 01))))
Vienna_C_cat_ts <- xts(Vienna_C_cat_ts[,-1], order.by = as.POSIXct(Vienna_C_cat_ts$time))

# Standardized
Vienna_C_cat_ts_scaled <- scale(Vienna_C_cat_ts)

# First differences
Vienna_C_cat_ts_diff <- diff(Vienna_C_cat_ts, differences=1)


### NEW TENTATIVE SEPT 1 WITH PVCLUST

library(pvclust)

# Barcelona C

fit <- pvclust(Barcelona_C_cat_ts_scaled, method.hclust="average",
               method.dist="euclidean")
# dendogram with p values
plot(fit) 
# add rectangles around groups highly supported by the data
pvrect(fit, alpha=.95)
# show list of clusters and their composition
pvpick(fit, alpha=.95)

# Barcelona K

fit <- pvclust(Barcelona_K_cat_ts_scaled, method.hclust="average",
               method.dist="euclidean")
# dendogram with p values
plot(fit) 
# add rectangles around groups highly supported by the data
pvrect(fit, alpha=.95)
# show list of clusters and their composition
pvpick(fit, alpha=.95)

# Bruges C

fit <- pvclust(Bruges_C_cat_ts_scaled, method.hclust="average",
               method.dist="euclidean")
# dendogram with p values
plot(fit) 
# add rectangles around groups highly supported by the data
pvrect(fit, alpha=.95)
# show list of clusters and their composition
pvpick(fit, alpha=.95)

# Bruges F

fit <- pvclust(Bruges_F_cat_ts_scaled, method.hclust="average",
               method.dist="euclidean")
# dendogram with p values
plot(fit) 
# add rectangles around groups highly supported by the data
pvrect(fit, alpha=.95)
# show list of clusters and their composition
pvpick(fit, alpha=.95)

# Vienna C

fit <- pvclust(Vienna_C_cat_ts_scaled, method.hclust="average",
               method.dist="euclidean")
# dendogram with p values
plot(fit) 
# add rectangles around groups highly supported by the data
pvrect(fit, alpha=.95)
# show list of clusters and their composition
pvpick(fit, alpha=.95)

### NEW METHOD N. 2

library(cluster)

res.agnes <- agnes(Barcelona_C_cat_ts_scaled_T, method = "average")
res.agnes$ac
pltree(res.agnes, main = "Dendrogram of Barcelona C") 
summary(res.agnes)

### Time series clustering
### Dynamic time warping

library(dtw)
library(mclust)

# Barcelona C

Barcelona_C_cat_ts_scaled_T <- t(Barcelona_C_cat_ts_scaled)
distMatrix <- dist(Barcelona_C_cat_ts_scaled_T, method= "DTW")
hc <- hclust(distMatrix, method= "average")
plot(hc, main = "Barcelona C")

### verify
# Highlight a certain number of clusters
rect.hclust(hc, k=3, border="red")
groups <- cutree(hc, k=3)
fit <- Mclust(Barcelona_C_cat_ts_scaled_T)
plot(fit) # plot results 
summary(fit) # display the best model

# Barcelona K

Barcelona_K_cat_ts_scaled_T <- t(Barcelona_K_cat_ts_scaled)

distMatrix <- dist(Barcelona_K_cat_ts_scaled_T, method= "DTW")
hc <- hclust(distMatrix, method= "average")
plot(hc, main = "Barcelona K")

# Bruges C

Bruges_C_cat_ts_scaled_T <- t(Bruges_C_cat_ts_scaled)

distMatrix <- dist(Bruges_C_cat_ts_scaled_T, method= "DTW")
hc <- hclust(distMatrix, method= "average")
plot(hc, main = "Bruges C")

# Bruges F

Bruges_F_cat_ts_scaled_T <- t(Bruges_F_cat_ts_scaled)

distMatrix <- dist(Bruges_F_cat_ts_scaled_T, method= "DTW")
hc <- hclust(distMatrix, method= "average")
plot(hc, main = "Bruges F")

# Vienna C

Vienna_C_cat_ts_scaled_T <- t(Vienna_C_cat_ts_scaled)

distMatrix <- dist(Vienna_C_cat_ts_scaled_T, method= "DTW")
hc <- hclust(distMatrix, method= "average")
plot(hc, main = "Vienna C")

# Plot time series
########### CONTROLLA E FAI

library(dygraphs)
library(htmlwidgets)
options(scipen=999)

g <- dygraph(Bruges_C_cat_ts_scaled, main = "Bruges (C) pageviews by categories") %>%
  dyOptions(colors = RColorBrewer::brewer.pal(8, "Dark2"))
g

### Maps with layer per category

# Barcelona C   CONTROLLARE E CAMBIARE CATEGORIE

Barcelona_C_category <- read.csv("C:/Users/signose/Desktop/Cities/Categories/Barcelona_C_category.csv") %>%
  select(-X)

Barcelona_C_all_category <- read.csv("C:/Users/signose/Desktop/Cities/Categories/Barcelona_C_all_category.csv") %>%
  select(-X)

m <- leaflet(Barcelona_C_all_category) %>%
  addProviderTiles("CartoDB.Positron")%>%
  addCircleMarkers(~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~colorFactor(topo.colors(133), Barcelona_C_all_category$cat)(cat), fillOpacity = 0.6) %>%
  addMarkers(~long, ~lat, popup = ~cat, options =markerOptions(opacity = 0)) %>%
  addLegend(position = c("bottomright"), colorFactor(topo.colors(133), Barcelona_C_all_category$category), values = ~category)
m

### Get time series by language

Barcelona_C_lang_ts <- Barcelona_reads_in_C %>%
  select(-lat, -long)%>%
  group_by(time, lang)%>%
  summarise(value = sum(value)) 

Barcelona_K_lang_ts <- Barcelona_reads_in_K %>%
  select(-lat, -long)%>%
  group_by(time, lang)%>%
  summarise(value = sum(value)) 

Bruges_C_lang_ts <- Bruges_reads_in_C %>%
  select(-lat, -long)%>%
  group_by(time, lang)%>%
  summarise(value = sum(value)) 

Bruges_F_lang_ts <- Bruges_reads_in_F %>%
  select(-lat, -long)%>%
  group_by(time, lang)%>%
  summarise(value = sum(value)) 

Vienna_C_lang_ts <- Vienna_reads_in_C %>%
  select(-lat, -long)%>%
  group_by(time, lang)%>%
  summarise(value = sum(value)) 

# Adjust the way the time variable is displayed

library(reshape2)
library(xts)

# Barcelona C

Barcelona_C_lang_ts <- dcast(Barcelona_C_lang_ts, time ~ lang) %>%
  mutate(time = as.Date(ts(1:48, frequency = 12, start = c(2012, 01))))
Barcelona_C_lang_ts <- xts(Barcelona_C_lang_ts[,-1], order.by = as.POSIXct(Barcelona_C_lang_ts$time))

# Standardized
Barcelona_C_lang_ts_scaled <- scale(Barcelona_C_lang_ts)

# First differences
Barcelona_C_lang_ts_diff <- diff(Barcelona_C_lang_ts, differences=1)

# Barcelona K

Barcelona_K_lang_ts <- dcast(Barcelona_K_lang_ts, time ~ lang) %>%
  mutate(time = as.Date(ts(1:48, frequency = 12, start = c(2012, 01))))
Barcelona_K_lang_ts <- xts(Barcelona_K_lang_ts[,-1], order.by = as.POSIXct(Barcelona_K_lang_ts$time))

# Standardized
Barcelona_K_lang_ts_scaled <- scale(Barcelona_K_lang_ts)

# First differences
Barcelona_K_lang_ts_diff <- diff(Barcelona_K_lang_ts, differences=1)

# Bruges C

Bruges_C_lang_ts <- dcast(Bruges_C_lang_ts, time ~ lang) %>%
  mutate(time = as.Date(ts(1:48, frequency = 12, start = c(2012, 01))))
Bruges_C_lang_ts <- xts(Bruges_C_lang_ts[,-1], order.by = as.POSIXct(Bruges_C_lang_ts$time))

# Standardized
Bruges_C_lang_ts_scaled <- scale(Bruges_C_lang_ts)

# First differences
Bruges_C_lang_ts_diff <- diff(Bruges_C_lang_ts, differences=1)

# Bruges F

Bruges_F_lang_ts <- dcast(Bruges_F_lang_ts, time ~ lang) %>%
  mutate(time = as.Date(ts(1:48, frequency = 12, start = c(2012, 01))))
Bruges_F_lang_ts <- xts(Bruges_F_lang_ts[,-1], order.by = as.POSIXct(Bruges_F_lang_ts$time))

# Standardized
Bruges_F_lang_ts_scaled <- scale(Bruges_F_lang_ts)

# First differences
Bruges_F_lang_ts_diff <- diff(Bruges_F_lang_ts, differences=1)

# Vienna C

Vienna_C_lang_ts <- dcast(Vienna_C_lang_ts, time ~ lang) %>%
  mutate(time = as.Date(ts(1:48, frequency = 12, start = c(2012, 01))))
Vienna_C_lang_ts <- xts(Vienna_C_lang_ts[,-1], order.by = as.POSIXct(Vienna_C_lang_ts$time))

# Standardized
Vienna_C_lang_ts_scaled <- scale(Vienna_C_lang_ts)

# First differences
Vienna_C_lang_ts_diff <- diff(Vienna_C_lang_ts, differences=1)


### NEW TENTATIVE SEPT 1 WITH PVCLUST

library(pvclust)

# Barcelona C

fit <- pvclust(Barcelona_C_lang_ts_scaled, method.hclust="average",
               method.dist="euclidean")
# dendogram with p values
plot(fit) 
# add rectangles around groups highly supported by the data
pvrect(fit, alpha=.95)
# show list of clusters and their composition
pvpick(fit, alpha=.95)

# Barcelona K

fit <- pvclust(Barcelona_K_lang_ts_scaled, method.hclust="average",
               method.dist="euclidean")
# dendogram with p values
plot(fit) 
# add rectangles around groups highly supported by the data
pvrect(fit, alpha=.95)
# show list of clusters and their composition
pvpick(fit, alpha=.95)

# Bruges C

fit <- pvclust(Bruges_C_lang_ts_scaled, method.hclust="average",
               method.dist="euclidean")
# dendogram with p values
plot(fit) 
# add rectangles around groups highly supported by the data
pvrect(fit, alpha=.95)
# show list of clusters and their composition
pvpick(fit, alpha=.95)

# Bruges F

fit <- pvclust(Bruges_F_lang_ts_scaled, method.hclust="average",
               method.dist="euclidean")
# dendogram with p values
plot(fit) 
# add rectangles around groups highly supported by the data
pvrect(fit, alpha=.95)
# show list of clusters and their composition
pvpick(fit, alpha=.95)

# Vienna C

fit <- pvclust(Vienna_C_lang_ts_scaled, method.hclust="average",
               method.dist="euclidean")
# dendogram with p values
plot(fit) 
# add rectangles around groups highly supported by the data
pvrect(fit, alpha=.95)
# show list of clusters and their composition
pvpick(fit, alpha=.95)

### Time series clustering
### Dynamic time warping

library(dtw)
library(mclust)

# Barcelona C

Barcelona_C_lang_ts_scaled_T <- t(Barcelona_C_lang_ts_scaled)
distMatrix <- dist(Barcelona_C_lang_ts_scaled_T, method= "DTW")
hc <- hclust(distMatrix, method= "average")
plot(hc, main = "Barcelona C")

# Barcelona K

Barcelona_K_lang_ts_scaled_T <- t(Barcelona_K_lang_ts_scaled)
distMatrix <- dist(Barcelona_K_lang_ts_scaled_T, method= "DTW")
hc <- hclust(distMatrix, method= "average")
plot(hc, main = "Barcelona K")

# Bruges C

Bruges_C_lang_ts_scaled_T <- t(Bruges_C_lang_ts_scaled)
distMatrix <- dist(Bruges_C_lang_ts_scaled_T, method= "DTW")
hc <- hclust(distMatrix, method= "average")
plot(hc, main = "Bruges C")

# Bruges F

Bruges_F_lang_ts_scaled_T <- t(Bruges_F_lang_ts_scaled)
distMatrix <- dist(Bruges_F_lang_ts_scaled_T, method= "DTW")
hc <- hclust(distMatrix, method= "average")
plot(hc, main = "Bruges F")

# Vienna C

Vienna_C_lang_ts_scaled_T <- t(Vienna_C_lang_ts_scaled)
distMatrix <- dist(Vienna_C_lang_ts_scaled_T, method= "DTW")
hc <- hclust(distMatrix, method= "average")
plot(hc, main = "Vienna C")