# TOURISM PILOT (PART 5)

library(dplyr)
library(xts)

# Build time series for items

# Barcelona C

Barcelona_items_ts_C <- Barcelona_reads_in_C %>%
  group_by(item, time) %>%
  summarise(value = sum(value))%>%
  tidyr::spread(item, value)%>%
  mutate(time = as.Date(ts(1:48, frequency = 12, start = c(2012, 01))))

Barcelona_items_ts_C <- xts(Barcelona_items_ts_C[,-1], order.by = as.POSIXct(Barcelona_items_ts_C$time))

# Standardized
Barcelona_items_ts_C_scaled <- scale(Barcelona_items_ts_C)

# First differences
Barcelona_items_ts_C_diff <- diff(Barcelona_items_ts_C, differences=1)

# Barcelona K

Barcelona_items_ts_K <- Barcelona_reads_in_K %>%
  group_by(item, time) %>%
  summarise(value = sum(value))%>%
  tidyr::spread(item, value)%>%
  mutate(time = as.Date(ts(1:48, frequency = 12, start = c(2012, 01))))

Barcelona_items_ts_K <- xts(Barcelona_items_ts_K[,-1], order.by = as.POSIXct(Barcelona_items_ts_K$time))

# Standardized
Barcelona_items_ts_K_scaled <- scale(Barcelona_items_ts_K)

# First differences
Barcelona_items_ts_K_diff <- diff(Barcelona_items_ts_K, differences=1)

# Bruges C

Bruges_items_ts_C <- Bruges_reads_in_C %>%
  group_by(item, time) %>%
  summarise(value = sum(value))%>%
  tidyr::spread(item, value)%>%
  mutate(time = as.Date(ts(1:48, frequency = 12, start = c(2012, 01))))

Bruges_items_ts_C <- xts(Bruges_items_ts_C[,-1], order.by = as.POSIXct(Bruges_items_ts_C$time))

# Standardized
Barcelona_items_ts_C_scaled <- scale(Barcelona_items_ts_C)

# First differences
Barcelona_items_ts_C_diff <- diff(Barcelona_items_ts_C, differences=1)

# Burges F

Bruges_items_ts_F <- Bruges_reads_in_F %>%
  group_by(item, time) %>%
  summarise(value = sum(value))%>%
  tidyr::spread(item, value)%>%
  mutate(time = as.Date(ts(1:48, frequency = 12, start = c(2012, 01))))

Bruges_items_ts_F <- xts(Bruges_items_ts_F[,-1], order.by = as.POSIXct(Bruges_items_ts_F$time))

Vienna_items_ts_C <- Vienna_reads_in_C %>%
  group_by(item, time) %>%
  summarise(value = sum(value))%>%
  tidyr::spread(item, value)%>%
  mutate(time = as.Date(ts(1:48, frequency = 12, start = c(2012, 01))))

Vienna_items_ts_C <- xts(Vienna_items_ts_C[,-1], order.by = as.POSIXct(Vienna_items_ts_C$time))

# Clustering

library(NbClust)

# Barcelona C

Barcelona_C_cat_ts_scaled <- t(Barcelona_C_cat_ts_scaled)

# Find optimal number of clusters
NbClust(Barcelona_C_cat_ts_scaled, distance = "euclidean", min.nc = 2, max.nc = 50, method = "kmeans", index = "kl")

# Run k-means
kmeans <- lapply(1:74, function(x) kmeans(Barcelona_C_cat_ts_scaled[, 1:48], centers = x))

# Get WSS
wss <- sapply(1:74, function (x) sum (kmeans[[x]]$withinss))

# Plot WSS
plot(1:74, wss, type="b", xlab = "Number of clusters", ylab = "Within groups sum of squares")

# Build table with reduction in WSS
knitr::kable(data.frame(2:74, cumsum(diff(wss)/sum(diff(wss)))*100), col.names = c("Number of clusters", "Cumulative reduction in WSS"), digits = 1)

# Get 35 cluster analysis
Barcelona_C_cl_35 <- kmeans[[35]]

# Barcelona K

Barcelona_K_cat_ts_scaled <- t(Barcelona_K_cat_ts_scaled)

# Find optimal number of clusters
NbClust(Barcelona_K_cat_ts_scaled, distance = "euclidean", min.nc = 2, max.nc = 40, method = "kmeans", index = "hubert")

# Run k-means
kmeans <- lapply(1:40, function(x) kmeans(Barcelona_K_cat_ts_scaled[, 1:48], centers = x))

# Get WSS
wss <- sapply(1:40, function (x) sum (kmeans[[x]]$withinss))

# Plot WSS
plot(1:40, wss, type="b", xlab = "Number of clusters", ylab = "Within groups sum of squares")

# Build table with reduction in WSS
knitr::kable(data.frame(2:40, cumsum(diff(wss)/sum(diff(wss)))*100), col.names = c("Number of clusters", "Cumulative reduction in WSS"), digits = 1)

# Get 29 cluster analysis
Barcelona_K_cl_29 <- kmeans[[29]]

# Get cluster means ####CONTROLLA
k_means <- data.frame(cluster = 1:9, Barcelona_K_cl_9$centers)%>%
  gather(1:83)

# Bruges C

Bruges_C_cat_ts_scaled <- t(Bruges_C_cat_ts_scaled)

# Find optimal number of clusters
NbClust(Bruges_C_cat_ts_scaled, distance = "euclidean", min.nc = 2, max.nc = 28, method = "kmeans", index = "hubert")

# Run k-means
kmeans <- lapply(1:20, function(x) kmeans(Bruges_C_cat_ts_scaled[, 1:48], centers = x))

# Get WSS
wss <- sapply(1:20, function (x) sum (kmeans[[x]]$withinss))

# Plot WSS
plot(1:20, wss, type="b", xlab = "Number of clusters", ylab = "Within groups sum of squares")

# Build table with reduction in WSS
knitr::kable(data.frame(2:20, cumsum(diff(wss)/sum(diff(wss)))*100), col.names = c("Number of clusters", "Cumulative reduction in WSS"), digits = 1)

# Get 15 cluster analysis
Bruges_C_cl_15 <- kmeans[[15]]

# Bruges F

Bruges_F_cat_ts_scaled <- t(Bruges_F_cat_ts_scaled)

# Find optimal number of clusters
NbClust(Bruges_F_cat_ts_scaled, distance = "euclidean", min.nc = 2, max.nc = 32, method = "kmeans", index = "hubert")

# Run k-means
kmeans <- lapply(1:25, function(x) kmeans(Bruges_F_cat_ts_scaled[, 1:34], centers = x))

# Get WSS
wss <- sapply(1:25, function (x) sum (kmeans[[x]]$withinss))

# Plot WSS
plot(1:25, wss, type="b", xlab = "Number of clusters", ylab = "Within groups sum of squares")

# Build table with reduction in WSS
knitr::kable(data.frame(2:25, cumsum(diff(wss)/sum(diff(wss)))*100), col.names = c("Number of clusters", "Cumulative reduction in WSS"), digits = 1)

# Get 19 cluster analysis
Bruges_F_cl_19<- kmeans[[19]]

# Vienna C

Vienna_C_cat_ts_scaled <- t(Vienna_C_cat_ts_scaled)

# Find optimal number of clusters
NbClust(Vienna_C_cat_ts_scaled, distance = "euclidean", min.nc = 2, max.nc = 40, method = "kmeans", index = "hubert")

# Run k-means
kmeans <- lapply(1:40, function(x) kmeans(Vienna_C_cat_ts_scaled[, 1:48], centers = x))

# Get WSS
wss <- sapply(1:40, function (x) sum (kmeans[[x]]$withinss))

# Plot WSS
plot(1:40, wss, type="b", xlab = "Number of clusters", ylab = "Within groups sum of squares")

# Build table with reduction in WSS
knitr::kable(data.frame(2:40, cumsum(diff(wss)/sum(diff(wss)))*100), col.names = c("Number of clusters", "Cumulative reduction in WSS"), digits = 1)

# Get 27 cluster analysis
Vienna_C_cl_27 <- kmeans[[27]]

##########################################################################################

############ Build correlogram (too many series yet, cluster before)

library(corrplot)

M <- cor(Barcelona_items_ts_C)
corrplot(M, method="circle", type = "upper", order = "hclust")

M <- cor(Barcelona_K_cat_ts)
corrplot(M, method="circle", type = "upper", order = "hclust")

M <- cor(Bruges_C_cat_ts)
corrplot(M, method="circle", type = "upper", order = "hclust")

M <- cor(Bruges_F_cat_ts)
corrplot(M, method="circle", type = "upper", order = "hclust")

M <- cor(Vienna_C_cat_ts)
corrplot(M, method="circle", type = "upper", order = "hclust")

# Work with tourism data

### COmpare shapefiles from Urban Audit to the ones from Statistical offices

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
