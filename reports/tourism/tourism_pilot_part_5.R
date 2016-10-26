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

# Barcelona K

Barcelona_items_ts_K <- Barcelona_reads_in_K %>%
  group_by(item, time) %>%
  summarise(value = sum(value))%>%
  tidyr::spread(item, value)%>%
  mutate(time = as.Date(ts(1:48, frequency = 12, start = c(2012, 01))))

# Bruges C

Bruges_items_ts_C <- Bruges_reads_in_C %>%
  group_by(item, time) %>%
  summarise(value = sum(value))%>%
  tidyr::spread(item, value)%>%
  mutate(time = as.Date(ts(1:48, frequency = 12, start = c(2012, 01))))

# Bruges F

Bruges_items_ts_F <- Bruges_reads_in_F %>%
  group_by(item, time) %>%
  summarise(value = sum(value))%>%
  tidyr::spread(item, value)%>%
  mutate(time = as.Date(ts(1:48, frequency = 12, start = c(2012, 01))))

# Vienna

Vienna_items_ts_C <- Vienna_reads_in_C %>%
  group_by(item, time) %>%
  summarise(value = sum(value))%>%
  tidyr::spread(item, value)%>%
  mutate(time = as.Date(ts(1:48, frequency = 12, start = c(2012, 01))))


############ CLUSTER IS NOT GOOD FOR OUR PURPOSE 
# Perform cluster analysis

# Barcelona C 

# Prepare data
  
Barcelona_items_ts_C_gather <- Barcelona_items_ts_C %>%
  gather(item, value, Q1026658:Q990510) %>%
  mutate(month = rep(as.Date(ts(1:48, frequency = 12, start = c(2012, 01))), each = 1093)) %>%
  group_by(item) %>%
  mutate(value_std = as.numeric(scale(value)))

cl <- Barcelona_items_ts_C_gather %>%
  group_by() %>%
  select(-value, -month) %>%
  spread(time, value_std)

# Run k-means

set.seed(425)
kmeans_Barcelona_C <- lapply(1:42, function(x) kmeans(cl[ ,2:49], centers = x))

# Get WSS
wss <- sapply(1:42, function(x) sum(kmeans_Barcelona_C[[x]]$withinss))

plot(1:42, wss, type = "b", xlab = "Number of clusters", ylab = "Within groups sum of squares")

knitr::kable(data.frame(2:42, cumsum(diff(wss)/sum(diff(wss)))*100), 
             col.names = c("Number of clusters", "Cumulative reduction in WSS"),
             digits = 1)

# Get 14 cluster analysis

fitcl14 <- kmeans_Barcelona_C[[3]]

# Get cluster means

kmeans <- data.frame(cluster = 1:3, fitcl14$centers) %>%
  gather(time, value, X2012.01.01:X2015.12.01) %>%
  mutate(month = rep(as.Date(ts(1:48, frequency = 12, start = c(2012, 01))), each = 3))

# Prepare data to be plotted

plot_data <- data.frame(item = cl$item, cluster = fitcl14$cluster) %>%
  right_join(Barcelona_items_ts_C_gather, by = "item")

# Plot data

library(ggplot2)

ggplot(data = plot_data, aes (x = month, y = value_std)) +
  geom_line(alpha = 0.1) +
  geom_line(data = kmeans, mapping = aes(x = month, y = value), colour = "red") +
  facet_grid(~cluster) +
  theme(axis.text.x = element_text(angle=90))+
  ylab("Standardised number of page views") +
  xlab("Months from January 2012 to December 2015") +
  ggtitle("Wikipedia page views profile by cluster in Barcelona (C)") +
  theme(plot.title = element_text(face="bold", size = 15))

# Barcelona K

# Prepare data

Barcelona_items_ts_K_gather <- Barcelona_items_ts_K %>%
  gather(item, value, Q1026658:Q990510) %>%
  mutate(month = rep(as.Date(ts(1:48, frequency = 12, start = c(2012, 01))), each = 1450)) %>%
  group_by(item) %>%
  mutate(value_std = as.numeric(scale(value)))

cl <- Barcelona_items_ts_K_gather %>%
  group_by() %>%
  select(-value, -month) %>%
  spread(time, value_std)

# Run k-means

set.seed(425)
kmeans_Barcelona_K <- lapply(1:50, function(x) kmeans(cl[ ,2:49], centers = x))

# Get WSS
wss <- sapply(1:50, function(x) sum(kmeans_Barcelona_K[[x]]$withinss))

plot(1:50, wss, type = "b", xlab = "Number of clusters", ylab = "Within groups sum of squares")

knitr::kable(data.frame(2:50, cumsum(diff(wss)/sum(diff(wss)))*100), 
             col.names = c("Number of clusters", "Cumulative reduction in WSS"),
             digits = 1)

# Get 14 cluster analysis

fitcl18 <- kmeans_Barcelona_K[[18]]

# Get cluster means

kmeans <- data.frame(cluster = 1:18, fitcl18$centers) %>%
  gather(time, value, X2012.01.01:X2015.12.01) %>%
  mutate(month = rep(as.Date(ts(1:48, frequency = 12, start = c(2012, 01))), each = 18))

# Prepare data to be plotted

plot_data <- data.frame(item = cl$item, cluster = fitcl18$cluster) %>%
  right_join(Barcelona_items_ts_C_gather, by = "item")

# Plot data

library(ggplot2)

ggplot(data = plot_data, aes (x = month, y = value_std)) +
  geom_point(alpha = 0.1) +
  geom_line(data = kmeans, mapping = aes(x = month, y = value), colour = "red") +
  facet_grid(~cluster) +
  theme(axis.text.x = element_text(angle=90))+
  ylab("Standardised number of page views") +
  xlab("Months from January 2012 to December 2015") +
  ggtitle("Wikipedia page views profile by cluster in Barcelona (K)") +
  theme(plot.title = element_text(face="bold", size = 15))

# Bruges C

# Prepare data

Bruges_items_ts_C_gather <- Bruges_items_ts_C %>%
  gather(item, value, Q1070150:Q917183) %>%
  mutate(month = rep(as.Date(ts(1:48, frequency = 12, start = c(2012, 01))), each = 561)) %>%
  group_by(item) %>%
  mutate(value_std = as.numeric(scale(value)))

cl <- Bruges_items_ts_C_gather %>%
  group_by() %>%
  select(-value, -month) %>%
  spread(time, value_std)

# Run k-means

set.seed(202)
kmeans_Bruges_C <- lapply(1:34, function(x) kmeans(cl[ ,2:49], centers = x))

# Get WSS
wss <- sapply(1:34, function(x) sum(kmeans_Bruges_C[[x]]$withinss))

plot(1:34, wss, type = "b", xlab = "Number of clusters", ylab = "Within groups sum of squares")

knitr::kable(data.frame(2:34, cumsum(diff(wss)/sum(diff(wss)))*100), 
             col.names = c("Number of clusters", "Cumulative reduction in WSS"),
             digits = 1)

# Get 14 cluster analysis

fitcl9 <- kmeans_Bruges_C[[3]]

# Get cluster means

kmeans <- data.frame(cluster = 1:3, fitcl9$centers) %>%
  gather(time, value, X2012.01.01:X2015.12.01) %>%
  mutate(month = rep(as.Date(ts(1:48, frequency = 12, start = c(2012, 01))), each = 3))

# Prepare data to be plotted

plot_data <- data.frame(item = cl$item, cluster = fitcl9$cluster) %>%
  right_join(Bruges_items_ts_C_gather, by = "item")

# Plot data

library(ggplot2)

ggplot(data = plot_data, aes (x = month, y = value_std)) +
  geom_line(alpha = 0.1) +
  geom_line(data = kmeans, mapping = aes(x = month, y = value), colour = "red") +
  facet_grid(~cluster) +
  theme(axis.text.x = element_text(angle=90))+
  ylab("Standardised number of page views") +
  xlab("Months from January 2012 to December 2015") +
  ggtitle("Wikipedia page views profile by cluster in Bruges (C)") +
  theme(plot.title = element_text(face="bold", size = 15))

# Bruges F

# Prepare data

Bruges_items_ts_F_gather <- Bruges_items_ts_F %>%
  gather(item, value, Q1023248:Q917183) %>%
  mutate(month = rep(as.Date(ts(1:48, frequency = 12, start = c(2012, 01))), each = 649)) %>%
  group_by(item) %>%
  mutate(value_std = as.numeric(scale(value)))

cl <- Bruges_items_ts_F_gather %>%
  group_by() %>%
  select(-value, -month) %>%
  spread(time, value_std)

# Run k-means

kmeans_Bruges_F <- lapply(1:36, function(x) kmeans(cl[ ,2:49], centers = x))

# Get WSS
wss <- sapply(1:36, function(x) sum(kmeans_Bruges_F[[x]]$withinss))

plot(1:36, wss, type = "b", xlab = "Number of clusters", ylab = "Within groups sum of squares")

knitr::kable(data.frame(2:36, cumsum(diff(wss)/sum(diff(wss)))*100), 
             col.names = c("Number of clusters", "Cumulative reduction in WSS"),
             digits = 1)

# Get 14 cluster analysis

fitcl12 <- kmeans_Bruges_F[[12]]

# Get cluster means

kmeans <- data.frame(cluster = 1:12, fitcl12$centers) %>%
  gather(time, value, X2012.01.01:X2015.12.01) %>%
  mutate(month = rep(as.Date(ts(1:48, frequency = 12, start = c(2012, 01))), each = 12))

# Prepare data to be plotted

plot_data <- data.frame(item = cl$item, cluster = fitcl12$cluster) %>%
  right_join(Bruges_items_ts_F_gather, by = "item")

# Plot data

library(ggplot2)

ggplot(data = plot_data, aes (x = month, y = value_std)) +
  geom_point(alpha = 0.1) +
  geom_line(data = kmeans, mapping = aes(x = month, y = value), colour = "red") +
  facet_grid(~cluster) +
  theme(axis.text.x = element_text(angle=90))+
  ylab("Standardised number of page views") +
  xlab("Months from January 2012 to December 2015") +
  ggtitle("Wikipedia page views profile by cluster in Bruges (F)") +
  theme(plot.title = element_text(face="bold", size = 15))

# Vienna C

# Prepare data

Vienna_items_ts_C_gather <- Vienna_items_ts_C %>%
  gather(item, value, Q1001258:Q999439) %>%
  mutate(month = rep(as.Date(ts(1:48, frequency = 12, start = c(2012, 01))), each = 2663)) %>%
  group_by(item) %>%
  mutate(value_std = as.numeric(scale(value)))

cl <- Vienna_items_ts_C_gather %>%
  group_by() %>%
  select(-value, -month) %>%
  spread(time, value_std)

# Run k-means

set.seed(123)
kmeans_Vienna_C <- lapply(1:70, function(x) kmeans(cl[ ,2:49], centers = x, iter.max=30))

# Get WSS
wss <- sapply(1:70, function(x) sum(kmeans_Vienna_C[[x]]$withinss))

plot(1:70, wss, type = "b", xlab = "Number of clusters", ylab = "Within groups sum of squares")

knitr::kable(data.frame(2:70, cumsum(diff(wss)/sum(diff(wss)))*100), 
             col.names = c("Number of clusters", "Cumulative reduction in WSS"),
             digits = 1)

# Get 28 cluster analysis

fitcl28 <- kmeans_Vienna_C[[3]]

# Get cluster means

kmeans <- data.frame(cluster = 1:3, fitcl28$centers) %>%
  gather(time, value, X2012.01.01:X2015.12.01) %>%
  mutate(month = rep(as.Date(ts(1:48, frequency = 12, start = c(2012, 01))), each = 3))

# Prepare data to be plotted

plot_data <- data.frame(item = cl$item, cluster = fitcl28$cluster) %>%
  right_join(Vienna_items_ts_C_gather, by = "item")

# Plot data

library(ggplot2)

ggplot(data = plot_data, aes (x = month, y = value_std)) +
  geom_line(alpha = 0.1) +
  geom_line(data = kmeans, mapping = aes(x = month, y = value), colour = "red") +
  facet_grid(~cluster) +
  theme(axis.text.x = element_text(angle=90)) +
  ylab("Standardised number of page views") +
  xlab("Months from January 2012 to December 2015") +
  ggtitle("Wikipedia page views profile by cluster in Vienna (C)") +
  theme(plot.title = element_text(face="bold", size = 15))

# After first cluster analysis, we reduce number of clusters

# Barcelona C 

cl <- Barcelona_items_ts_C_gather %>%
  group_by() %>%
  select(-value, -month) %>%
  spread(time, value_std)

fitcl14 <- kmeans_Barcelona_C[[6]]

# Get cluster means

kmeans <- data.frame(cluster = 1:6, fitcl14$centers) %>%
  gather(time, value, X2012.01.01:X2015.12.01) %>%
  mutate(month = rep(as.Date(ts(1:48, frequency = 12, start = c(2012, 01))), each = 6))

# Prepare data to be plotted

plot_data <- data.frame(item = cl$item, cluster = fitcl14$cluster) %>%
  right_join(Barcelona_items_ts_C_gather, by = "item")

# Plot data

library(ggplot2)

ggplot(data = plot_data, aes (x = month, y = value_std)) +
  geom_line(alpha = 0.1) +
  geom_line(data = kmeans, mapping = aes(x = month, y = value), colour = "red") +
  facet_grid(~cluster) +
  theme(axis.text.x = element_text(angle=90))+
  ylab("Standardised number of page views") +
  xlab("Months from January 2012 to December 2015") +
  ggtitle("Wikipedia page views profile by cluster in Barcelona (C)") +
  theme(plot.title = element_text(face="bold", size = 15))

# Barcelona K

cl <- Barcelona_items_ts_K_gather %>%
  group_by() %>%
  select(-value, -month) %>%
  spread(time, value_std)

# Get 14 cluster analysis

fitcl18 <- kmeans_Barcelona_K[[7]]

# Get cluster means

kmeans <- data.frame(cluster = 1:7, fitcl18$centers) %>%
  gather(time, value, X2012.01.01:X2015.12.01) %>%
  mutate(month = rep(as.Date(ts(1:48, frequency = 12, start = c(2012, 01))), each = 7))

# Prepare data to be plotted

plot_data <- data.frame(item = cl$item, cluster = fitcl18$cluster) %>%
  right_join(Barcelona_items_ts_C_gather, by = "item")

# Plot data

library(ggplot2)

ggplot(data = plot_data, aes (x = month, y = value_std)) +
  geom_line(alpha = 0.1) +
  geom_line(data = kmeans, mapping = aes(x = month, y = value), colour = "red") +
  facet_grid(~cluster) +
  theme(axis.text.x = element_text(angle=90))+
  ylab("Standardised number of page views") +
  xlab("Months from January 2012 to December 2015") +
  ggtitle("Wikipedia page views profile by cluster in Barcelona (K)") +
  theme(plot.title = element_text(face="bold", size = 15))

# Bruges C

cl <- Bruges_items_ts_C_gather %>%
  group_by() %>%
  select(-value, -month) %>%
  spread(time, value_std)

# Get 14 cluster analysis

fitcl9 <- kmeans_Bruges_C[[5]]

# Get cluster means

kmeans <- data.frame(cluster = 1:5, fitcl9$centers) %>%
  gather(time, value, X2012.01.01:X2015.12.01) %>%
  mutate(month = rep(as.Date(ts(1:48, frequency = 12, start = c(2012, 01))), each = 5))

# Prepare data to be plotted

plot_data <- data.frame(item = cl$item, cluster = fitcl9$cluster) %>%
  right_join(Bruges_items_ts_C_gather, by = "item")

# Plot data

library(ggplot2)

ggplot(data = plot_data, aes (x = month, y = value_std)) +
  geom_line(alpha = 0.1) +
  geom_line(data = kmeans, mapping = aes(x = month, y = value), colour = "red") +
  facet_grid(~cluster) +
  theme(axis.text.x = element_text(angle=90))+
  ylab("Standardised number of page views") +
  xlab("Months from January 2012 to December 2015") +
  ggtitle("Wikipedia page views profile by cluster in Bruges (C)") +
  theme(plot.title = element_text(face="bold", size = 15))

# Bruges F

cl <- Bruges_items_ts_F_gather %>%
  group_by() %>%
  select(-value, -month) %>%
  spread(time, value_std)

# Get 14 cluster analysis

fitcl12 <- kmeans_Bruges_F[[7]]

# Get cluster means

kmeans <- data.frame(cluster = 1:7, fitcl12$centers) %>%
  gather(time, value, X2012.01.01:X2015.12.01) %>%
  mutate(month = rep(as.Date(ts(1:48, frequency = 12, start = c(2012, 01))), each = 7))

# Prepare data to be plotted

plot_data <- data.frame(item = cl$item, cluster = fitcl12$cluster) %>%
  right_join(Bruges_items_ts_F_gather, by = "item")

# Plot data

library(ggplot2)

ggplot(data = plot_data, aes (x = month, y = value_std)) +
  geom_line(alpha = 0.1) +
  geom_line(data = kmeans, mapping = aes(x = month, y = value), colour = "red") +
  facet_grid(~cluster) +
  theme(axis.text.x = element_text(angle=90))+
  ylab("Standardised number of page views") +
  xlab("Months from January 2012 to December 2015") +
  ggtitle("Wikipedia page views profile by cluster in Bruges (F)") +
  theme(plot.title = element_text(face="bold", size = 15))

# Vienna C

cl <- Vienna_items_ts_C_gather %>%
  group_by() %>%
  select(-value, -month) %>%
  spread(time, value_std)

# Get 28 cluster analysis

fitcl28 <- kmeans_Vienna_C[[9]]

# Get cluster means

kmeans <- data.frame(cluster = 1:9, fitcl28$centers) %>%
  gather(time, value, X2012.01.01:X2015.12.01) %>%
  mutate(month = rep(as.Date(ts(1:48, frequency = 12, start = c(2012, 01))), each = 9))

# Prepare data to be plotted

plot_data <- data.frame(item = cl$item, cluster = fitcl28$cluster) %>%
  right_join(Vienna_items_ts_C_gather, by = "item")

# Plot data

library(ggplot2)

ggplot(data = plot_data, aes (x = month, y = value_std)) +
  geom_line(alpha = 0.1) +
  geom_line(data = kmeans, mapping = aes(x = month, y = value), colour = "red") +
  facet_grid(~cluster) +
  theme(axis.text.x = element_text(angle=90)) +
  ylab("Standardised number of page views") +
  xlab("Months from January 2012 to December 2015") +
  ggtitle("Wikipedia page views profile by cluster in Vienna (C)") +
  theme(plot.title = element_text(face="bold", size = 15))

#### PRINCIPAL COMPONENT ANALYSIS

library(xts)
library(reshape2)
library(dplyr)

# Barcelona C

Barcelona_items_ts_C_PCA <- Barcelona_reads_in_C %>%
  group_by(item, time) %>%
  summarise(value = sum(value))%>%
  mutate(time = as.Date(ts(1:48, frequency = 12, start = c(2012, 01))))

Barcelona_C_PCA_items <- dcast(Barcelona_items_ts_C_PCA, time ~ item) %>%
  mutate(time = as.Date(ts(1:48, frequency = 12, start = c(2012, 01))))

Barcelona_C_PCA_items_ts <- xts(Barcelona_C_PCA_items[,-1], order.by = as.POSIXct(Barcelona_C_PCA_items$time))
Barcelona_C_PCA_diff <- diff(Barcelona_C_PCA_items_ts, differences=1)
Barcelona_C_PCA_diff_scaled <- scale(Barcelona_C_PCA_diff)
Barcelona_C_PCA_diff_scaled = Barcelona_C_PCA_diff_scaled[-1,]

# PCA with diff and scale ts

Barcelona_C_PCA <- prcomp(Barcelona_C_PCA_diff_scaled)
summary(Barcelona_C_PCA)
Barcelona_C_PCA$sdev

# DECIDE HOW MANY COMPONENTS

# No. 1: first change in slope in screeplot
screeplot(Barcelona_C_PCA, type="barplot")
screeplot(Barcelona_C_PCA, type="lines")

# No. 2: variance of components
(Barcelona_C_PCA$sdev)^2
# Using Kaiser's criterion (variance>1), we retain 46 components

# No. 3: decide a percentage of total variance

# Loadings of components
Barcelona_C_PCA$rotation[,1]

# Bruges C

Bruges_items_ts_C_PCA <- Bruges_reads_in_C %>%
  group_by(item, time) %>%
  summarise(value = sum(value))%>%
  mutate(time = as.Date(ts(1:48, frequency = 12, start = c(2012, 01))))

Bruges_C_PCA_items <- dcast(Bruges_items_ts_C_PCA, time ~ item) %>%
  mutate(time = as.Date(ts(1:48, frequency = 12, start = c(2012, 01))))
Bruges_C_PCA_items_ts <- xts(Bruges_C_PCA_items[,-1], order.by = as.POSIXct(Bruges_C_PCA_items$time))

Bruges_C_PCA_diff <- diff(Bruges_C_PCA_items_ts, differences=1)
Bruges_C_PCA_diff_scaled <- scale(Bruges_C_PCA_diff)
Bruges_C_PCA_diff_scaled = Bruges_C_PCA_diff_scaled[-1,]

# PCA with diff and scale ts

Bruges_C_PCA <- prcomp(Bruges_C_PCA_diff_scaled)
summary(Bruges_C_PCA)
Bruges_C_PCA$sdev

# DECIDE HOW MANY COMPONENTS

# No. 1: first change in slope in screeplot
screeplot(Bruges_C_PCA, type="barplot")
screeplot(Bruges_C_PCA, type="lines")

# No. 2: variance of components
(Bruges_C_PCA$sdev)^2
# Using Kaiser's criterion (variance>1), we retain 41 components

# No. 3: decide a percentage of total variance

# Loadings of components
Bruges_C_PCA$rotation[,1]

# Vienna C

Vienna_items_ts_C_PCA <- Vienna_reads_in_C %>%
  group_by(item, time) %>%
  summarise(value = sum(value))%>%
  mutate(time = as.Date(ts(1:48, frequency = 12, start = c(2012, 01))))

Vienna_C_PCA_items <- dcast(Vienna_items_ts_C_PCA, time ~ item) %>%
  mutate(time = as.Date(ts(1:48, frequency = 12, start = c(2012, 01))))
Vienna_C_PCA_items_ts <- xts(Vienna_C_PCA_items[,-1], order.by = as.POSIXct(Vienna_C_PCA_items$time))

Vienna_C_PCA_diff <- diff(Vienna_C_PCA_items_ts, differences=1)
Vienna_C_PCA_diff_scaled <- scale(Vienna_C_PCA_diff)
Vienna_C_PCA_diff_scaled = Vienna_C_PCA_diff_scaled[-1,]

# PCA with diff and scale ts

Vienna_C_PCA <- prcomp(Vienna_C_PCA_diff_scaled)
summary(Vienna_C_PCA)
Vienna_C_PCA$sdev

# DECIDE HOW MANY COMPONENTS

# No. 1: first change in slope in screeplot
screeplot(Vienna_C_PCA, type="barplot")
screeplot(Vienna_C_PCA, type="lines")

# No. 2: variance of components
(Vienna_C_PCA$sdev)^2
# Using Kaiser's criterion (variance>1), we retain 46 components

# No. 3: decide a percentage of total variance

# Loadings of components
Vienna_C_PCA$rotation[,1]

### TSFA PACKAGE

library(tsfa)


# Barcelona C

tfplot(Barcelona_C_PCA_items_ts,graphs.per.page = 3)
tfplot(diff(Barcelona_C_PCA_items_ts),graphs.per.page = 3)
start(Barcelona_C_PCA_items_ts)
end(Barcelona_C_PCA_items_ts)
Tobs(Barcelona_C_PCA_items_ts)
nseries(Barcelona_C_PCA_items_ts)
DX <- diff(Barcelona_C_PCA_items_ts, lag=1)
DX = DX[-1,]
colMeans(DX)
sqrt(diag(cov(DX)))

zz <- eigen(cor(DX), symmetric = T)[["values"]]
print(zz)

# Bruges C

tfplot(Bruges_C_PCA_items_ts,graphs.per.page = 3)
tfplot(diff(Bruges_C_PCA_items_ts),graphs.per.page = 3)
start(Bruges_C_PCA_items_ts)
end(Bruges_C_PCA_items_ts)
Tobs(Bruges_C_PCA_items_ts)
nseries(Bruges_C_PCA_items_ts)
DX <- diff(Bruges_C_PCA_items_ts, lag=1)
DX = DX[-1,]
colMeans(DX)
sqrt(diag(cov(DX)))

zz <- eigen(cor(DX), symmetric = T)[["values"]]
print(zz)

# Vienna C

tfplot(Vienna_C_PCA_items_ts,graphs.per.page = 3)
tfplot(diff(Vienna_C_PCA_items_ts),graphs.per.page = 3)
start(Vienna_C_PCA_items_ts)                                       
end(Vienna_C_PCA_items_ts)                                                                                                                                                                                                                                                                   
Tobs(Vienna_C_PCA_items_ts)
nseries(Vienna_C_PCA_items_ts)
DX <- diff(Vienna_C_PCA_items_ts, lag=1)
DX = DX[-1,]
colMeans(DX)
sqrt(diag(cov(DX)))

zz <- eigen(cor(DX), symmetric = T)[["values"]]
print(zz)
