# TOURISM PILOT (PART 7)

#Combine big data source with tourism data

library(dplyr)

library(xts)
library(reshape2)

# Transpose dataframe of tourism flows 

# Barcelona

Barcelona_arrivals <- read.csv("./tourism_data/Barcelona/Barcelona_arrivals.csv", strip.white = T, stringsAsFactors = F, header = T) %>%
  select(-X)
Barcelona_overnight_stays <- read.csv("./tourism_data/Barcelona/Barcelona_overnight_stays.csv", strip.white = T, stringsAsFactors = F, header = T) %>%
  select(-X)

Barcelona_arrivals_t <- data.frame(t(Barcelona_arrivals[,-1]), stringsAsFactors = F)
colnames(Barcelona_arrivals_t) <- Barcelona_arrivals$country_of_origin
rownames(Barcelona_arrivals_t) <- NULL
Barcelona_arrivals_t <- Barcelona_arrivals_t[1:48,]
Barcelona_arrivals_t <- Barcelona_arrivals_t %>%
  mutate(time = as.Date(ts(1:48, frequency = 12, start = c(2012, 01))))

Barcelona_overnight_stays_t <- data.frame(t(Barcelona_overnight_stays[,-1]), stringsAsFactors = F)
colnames(Barcelona_overnight_stays_t) <- Barcelona_overnight_stays$country_of_origin
rownames(Barcelona_overnight_stays_t) <- NULL
Barcelona_overnight_stays_t <- Barcelona_overnight_stays_t[1:48,]
Barcelona_overnight_stays_t <- Barcelona_overnight_stays_t %>%
  mutate(time = as.Date(ts(1:48, frequency = 12, start = c(2012, 01))))

Barcelona_final_ts <- Barcelona_reads_in_C %>%
  left_join(Barcelona_final_2, by = 'item') %>%
  select(-lat, -long)%>%
  filter(!is.na(id))%>%
  group_by(time, id)%>%
  summarise(value = sum(value))

Barcelona_final_ts <- dcast(Barcelona_final_ts, time ~ id) %>%
  mutate(time = as.Date(ts(1:48, frequency = 12, start = c(2012, 01))))

library(stringr)

Barcelona_OVER <- merge(Barcelona_final_ts, Barcelona_overnight_stays_t)
colnames(Barcelona_OVER) <- str_trim(colnames(Barcelona_OVER))
colnames(Barcelona_OVER) <- c("time", "public_transport", "sport", "high_education", "theatres", "buildings",
                             "streets_and_districts", "museums", "sagrada_familia", "history", "institutions_organizations",
                             "monuments_and_fountains", "culture_and_art", "parks", "places_of_worship", 
                             "other_unclassified", "number_of_bookings", "residents_in_spain", "residents_abroad",
                             "germany", "austria", "belgium", "denmark", "finland", "france", "greece", "ireland",
                             "italy", "luxembourg", "netherlands", "poland", "portugal", "united_kingdom", 
                             "czech_republic", "sweden", "rest_of_eu", "norway", "russia", "switzerland", 
                             "rest_of_europe", "japan", "usa", "rest_of_america", "african_countries", "rest_of_world")

Barcelona_ARR <- merge(Barcelona_final_ts, Barcelona_arrivals_t)
colnames(Barcelona_ARR) <- str_trim(colnames(Barcelona_ARR))
colnames(Barcelona_ARR) <- c("time", "public_transport", "sport", "high_education", "theatres", "buildings",
                             "streets_and_districts", "museums", "sagrada_familia", "history", "institutions_organizations",
                             "monuments_and_fountains", "culture_and_art", "parks", "places_of_worship", 
                             "other_unclassified", "number_of_passengers", "residents_in_spain", "residents_abroad",
                             "germany", "austria", "belgium", "denmark", "finland", "france", "greece", "ireland",
                             "italy", "luxembourg", "netherlands", "poland", "portugal", "united_kingdom", 
                             "czech_republic", "sweden", "rest_of_eu", "norway", "russia", "switzerland", 
                             "rest_of_europe", "japan", "usa", "rest_of_america", "african_countries", "rest_of_world")

write.csv(Barcelona_ARR, "Barcelona_ARR.csv")
write.csv(Barcelona_OVER, "Barcelona_OVER.csv")

Barcelona_ARR <- read.csv("./Barcelona_ARR.csv", stringsAsFactors = F) %>%
  select(-X)

Barcelona_OVER <- read.csv("./Barcelona_OVER.csv", stringsAsFactors = F) %>%
  select(-X)

# BRUGES ADJUST NAME OF VARIABLES

Bruges_arrivals <- read.csv("./tourism_data/Bruges/Bruges_arrivals.csv", strip.white = T, stringsAsFactors = F, header = T) %>%
  select(-X)
Bruges_overnight_stays <- read.csv("./tourism_data/Bruges/Bruges_overnight_stays.csv", strip.white = T, stringsAsFactors = F, header = T) %>%
  select(-X)

library(reshape2)

Bruges_arrivals_t <- data.frame(t(Bruges_arrivals[,-1]))
colnames(Bruges_arrivals_t) <- Bruges_arrivals$country_of_origin
rownames(Bruges_arrivals_t) <- NULL
Bruges_arrivals_t <- Bruges_arrivals_t[1:48,]
Bruges_arrivals_t <- Bruges_arrivals_t %>%
  mutate(time = as.Date(ts(1:48, frequency = 12, start = c(2012, 01))))

Bruges_overnight_stays_t <- data.frame(t(Bruges_overnight_stays[,-1]))
colnames(Bruges_overnight_stays_t) <- Bruges_overnight_stays$country_of_origin
rownames(Bruges_overnight_stays_t) <- NULL
Bruges_overnight_stays_t <- Bruges_overnight_stays_t[1:48,]
Bruges_overnight_stays_t <- Bruges_overnight_stays_t %>%
  mutate(time = as.Date(ts(1:48, frequency = 12, start = c(2012, 01))))

Bruges_final_ts <- Bruges_reads_in_C %>%
  left_join(Bruges_final_2, by = 'item') %>%
  select(-lat, -long)%>%
  filter(!is.na(id))%>%
  group_by(time, id)%>%
  summarise(value = sum(value))

Bruges_final_ts <- dcast(Bruges_final_ts, time ~ id) %>%
  mutate(time = as.Date(ts(1:48, frequency = 12, start = c(2012, 01))))

library(stringr)

Bruges_OVER <- merge(Bruges_final_ts, Bruges_overnight_stays_t)
colnames(Bruges_OVER) <- str_trim(colnames(Bruges_OVER))
colnames(Bruges_OVER) <- c("time", "public_transport", "streets_and_streams", "libraries", "buildings", "high_education",
                              "bridges_and_canals", "sport", "districts", "places_of_worship", "companies", 
                              "museums", "other_unclassified", "belgium", "netherlands", "germany",
                              "france", "united_kingdom", "luxembourg", "ireland", "denmark", "sweden", "finland", "italy",
                              "spain", "portugal", "greece", "austria", "poland", "czech_republic", 
                              "hungary", "romania", "norway", "switzerland", "russia", 
                              "usa", "canada", "japan", "china", "india", "israel", "turkey", 
                              "australia", "brazil", "other", "abroad", "number_of_bookings")

Bruges_ARR <- merge(Bruges_final_ts, Bruges_arrivals_t)
colnames(Bruges_ARR) <- str_trim(colnames(Bruges_ARR))
colnames(Bruges_ARR) <- c("time", "public_transport", "streets_and_streams", "libraries", "buildings", "high_education",
                           "bridges_and_canals", "sport", "districts", "places_of_worship", "companies", 
                           "museums", "other_unclassified", "belgium", "netherlands", "germany",
                           "france", "united_kingdom", "luxembourg", "ireland", "denmark", "sweden", "finland", "italy",
                           "spain", "portugal", "greece", "austria", "poland", "czech_republic", 
                           "hungary", "romania", "norway", "switzerland", "russia", 
                           "usa", "canada", "japan", "china", "india", "israel", "turkey", 
                           "australia", "brazil", "other", "abroad", "number_of_passengers")


write.csv(Bruges_ARR, 'Bruges_ARR.csv')
write.csv(Bruges_OVER, 'Bruges_OVER.csv')

# VIENNA

Vienna_arrivals <- read.csv("./tourism_data/Vienna/Vienna_arrivals.csv", strip.white = T, stringsAsFactors = F, header = T) %>%
  select(-X)

Vienna_arrivals_t <- data.frame(t(Vienna_arrivals))
colnames(Vienna_arrivals_t) <- Vienna_arrivals[,1]
Vienna_arrivals_t <- Vienna_arrivals_t[-1,]
Vienna_arrivals_t <- Vienna_arrivals_t[-c(13:17),]

Vienna_arrivals_t <- Vienna_arrivals_t[1:12,]
Vienna_arrivals_t <- Vienna_arrivals_t %>%
  mutate(time = as.Date(ts(1:12, frequency = 12, start = c(2015, 01))))

Vienna_overnight_stays <- read.csv("./tourism_data/Vienna/Vienna_overnight_stays.csv", strip.white = T, stringsAsFactors = F, header = T) %>%
  select(-X)

Vienna_overnight_stays_t <- data.frame(t(Vienna_overnight_stays))
colnames(Vienna_overnight_stays_t) <- Vienna_overnight_stays[,1]
Vienna_overnight_stays_t <- Vienna_overnight_stays_t[-1,]
Vienna_overnight_stays_t <- Vienna_overnight_stays_t[-c(13:17),]

Vienna_overnight_stays_t <- Vienna_overnight_stays_t[1:12,]
Vienna_overnight_stays_t <- Vienna_overnight_stays_t %>%
  mutate(time = as.Date(ts(1:12, frequency = 12, start = c(2015, 01))))

Vienna_arrivals_2012_2014 <- read.csv("./tourism_data/Vienna/Vienna_arrivals_2012_2014.csv", strip.white = T, stringsAsFactors = F, header = T)
colnames(Vienna_arrivals_2012_2014) <- Vienna_arrivals_2012_2014[1,]
colnames(Vienna_arrivals_2012_2014) <- c("country of origin", "Jan_2012", "Feb_2012", "Mar_2012", "Apr_2012", "May_2012", "Jun_2012",
                                         "Jul_2012", "Aug_2012", "Sep_2012", "Oct_2012", "Nov_2012", "Dec_2012", 
                                         "Jan_2013", "Feb_2013", "Mar_2013", "Apr_2013", "May_2013", "Jun_2013",
                                         "Jul_2013", "Aug_2013", "Sep_2013", "Oct_2013", "Nov_2013", "Dec_2013", 
                                         "Jan_2014", "Feb_2014", "Mar_2014", "Apr_2014", "May_2014", "Jun_2014",
                                         "Jul_2014", "Aug_2014", "Sep_2014", "Oct_2014", "Nov_2014", "Dec_2014")
Vienna_arrivals_2012_2014 <- Vienna_arrivals_2012_2014[-1,]
Vienna_arrivals_2012_2014 <- Vienna_arrivals_2012_2014[-c(58:85),]

Vienna_arrivals_2012_2014_t <- data.frame(t(Vienna_arrivals_2012_2014))
colnames(Vienna_arrivals_2012_2014_t) <- Vienna_arrivals_2012_2014[,1]
Vienna_arrivals_2012_2014_t <- Vienna_arrivals_2012_2014_t[-1,]

Vienna_arrivals_2012_2014_t <- Vienna_arrivals_2012_2014_t[1:36,]
Vienna_arrivals_2012_2014_t <- Vienna_arrivals_2012_2014_t %>%
  mutate(time = as.Date(ts(1:36, frequency = 12, start = c(2012, 01))))

Vienna_overnight_stays_2012_2014 <- read.csv("./tourism_data/Vienna/Vienna_overnight_stays_2012_2014.csv", strip.white = T, stringsAsFactors = F, header = T)
colnames(Vienna_overnight_stays_2012_2014) <- Vienna_overnight_stays_2012_2014[1,]
colnames(Vienna_overnight_stays_2012_2014) <- c("country of origin", "Jan_2012", "Feb_2012", "Mar_2012", "Apr_2012", "May_2012", "Jun_2012",
                                         "Jul_2012", "Aug_2012", "Sep_2012", "Oct_2012", "Nov_2012", "Dec_2012", 
                                         "Jan_2013", "Feb_2013", "Mar_2013", "Apr_2013", "May_2013", "Jun_2013",
                                         "Jul_2013", "Aug_2013", "Sep_2013", "Oct_2013", "Nov_2013", "Dec_2013", 
                                         "Jan_2014", "Feb_2014", "Mar_2014", "Apr_2014", "May_2014", "Jun_2014",
                                         "Jul_2014", "Aug_2014", "Sep_2014", "Oct_2014", "Nov_2014", "Dec_2014")
Vienna_overnight_stays_2012_2014 <- Vienna_overnight_stays_2012_2014[-1,]
Vienna_overnight_stays_2012_2014 <- Vienna_overnight_stays_2012_2014[-c(58:85),]

Vienna_overnight_stays_2012_2014_t <- data.frame(t(Vienna_overnight_stays_2012_2014))
colnames(Vienna_overnight_stays_2012_2014_t) <- Vienna_overnight_stays_2012_2014[,1]
Vienna_overnight_stays_2012_2014_t <- Vienna_overnight_stays_2012_2014_t[-1,]

Vienna_overnight_stays_2012_2014_t <- Vienna_overnight_stays_2012_2014_t[1:36,]
Vienna_overnight_stays_2012_2014_t <- Vienna_overnight_stays_2012_2014_t %>%
  mutate(time = as.Date(ts(1:36, frequency = 12, start = c(2012, 01))))

ARR_1 <- data.frame(Total = gsub(",", "", Vienna_arrivals_2012_2014_t$Total))
ARR_2 <- data.frame(Total = Vienna_arrivals_t$Total)

Vienna_ARR_tourism <-rbind(ARR_1, ARR_2)%>%
  mutate(time = as.Date(ts(1:48, frequency = 12, start = c(2012, 01))))

OVER_1 <- data.frame(Total = gsub(",", "", Vienna_overnight_stays_2012_2014_t$Total))
OVER_2 <- data.frame(Total = Vienna_overnight_stays_t$Total)

Vienna_OVER_tourism <-rbind(OVER_1, OVER_2) %>%
  mutate(time = as.Date(ts(1:48, frequency = 12, start = c(2012, 01))))

Vienna_final_ts <- Vienna_reads_in_C %>%
  left_join(Vienna_final_2, by = 'item') %>%
  select(-lat, -long)%>%
  filter(!is.na(id))%>%
  group_by(time, id)%>%
  summarise(value = sum(value))

Vienna_final_ts <- dcast(Vienna_final_ts, time ~ id) %>%
  mutate(time = as.Date(ts(1:48, frequency = 12, start = c(2012, 01))))

library(stringr)

Vienna_OVER <- merge(Vienna_final_ts, Vienna_OVER_tourism)
colnames(Vienna_OVER) <- str_trim(colnames(Vienna_OVER))
colnames(Vienna_OVER) <- c("time", "sport", "council_housing", "institutions_organizations", "history", "township",
                              "places_of_worship", "companies", "bus_stops_and_stations", "mountains", "transmitters",
                              "embassies", "streets_and_squares", "rivers_and_parks", "museums", 
                              "towers", "buildings", "hospitals", "libraries",
                              "statues_and_fountains", "high_education", "bridges", "theatres", "cemeteries", 
                              "other_unclassified", "number_of_bookings")

Vienna_ARR <- merge(Vienna_final_ts, Vienna_ARR_tourism)
colnames(Vienna_ARR) <- str_trim(colnames(Vienna_ARR))
colnames(Vienna_ARR) <- c("time", "sport", "council_housing", "institutions_organizations", "history", "township",
                           "places_of_worship", "companies", "bus_stops_and_stations", "mountains", "transmitters",
                           "embassies", "streets_and_squares", "rivers_and_parks", "museums", 
                           "towers", "buildings", "hospitals", "libraries",
                           "statues_and_fountains", "high_education", "bridges", "theatres", "cemeteries", 
                           "other_unclassified", "number_of_passengers")

# save data to work locally

write.csv(Barcelona_ARR, "./Barcelona_ARR.csv")
write.csv(Vienna_ARR, "./Vienna_ARR.csv")
write.csv(Bruges_ARR, "./Bruges_ARR.csv")

write.csv(Barcelona_OVER, "./Barcelona_OVER.csv")
write.csv(Vienna_OVER, "./Vienna_OVER.csv")
write.csv(Bruges_OVER, "./Bruges_OVER.csv")

# PROPOSED MODELS:ARIMAX, ADL (Autoregressive Distributed Lag)

# function to plot residuals
plotForecastErrors <- function(forecasterrors)
{
  # make a histogram of the forecast errors:
  mybinsize <- IQR(forecasterrors)/4
  mysd   <- sd(forecasterrors)
  mymin  <- min(forecasterrors) - mysd*5
  mymax  <- max(forecasterrors) + mysd*3
  # generate normally distributed data with mean 0 and standard deviation mysd
  mynorm <- rnorm(10000, mean=0, sd=mysd)
  mymin2 <- min(mynorm)
  mymax2 <- max(mynorm)
  if (mymin2 < mymin) { mymin <- mymin2 }
  if (mymax2 > mymax) { mymax <- mymax2 }
  # make a red histogram of the forecast errors, with the normally distributed data overlaid:
  mybins <- seq(mymin, mymax, mybinsize)
  hist(forecasterrors, col="red", freq=FALSE, breaks=mybins)
  # freq=FALSE ensures the area under the histogram = 1
  # generate normally distributed data with mean 0 and standard deviation mysd
  myhist <- hist(mynorm, plot=FALSE, breaks=mybins)
  # plot the normal curve as a blue line on top of the histogram of forecast errors:
  points(myhist$mids, myhist$density, type="l", col="blue", lwd=2)
}

library(dplyr)

# read data

Barcelona_ARR <- read.csv("C:/Users/Acer/Desktop/Wiki pilot/wikistats/Barcelona_ARR_model.csv", stringsAsFactors = F) %>%
  select(-X)
Bruges_ARR <- read.csv("C:/Users/Acer/Desktop/Wiki pilot/wikistats/Bruges_ARR_model2.csv", stringsAsFactors = F) %>%
  select(-X, -belgium, -netherlands, -germany, - france, - united_kingdom, -luxembourg, -ireland, 
         -denmark, -sweden, -finland, -italy, -spain, -portugal, -greece, -austria, -poland, 
         -czech_republic, -hungary, -romania, -norway, -switzerland, -russia, -usa, 
         -canada, -japan, -china, -india, -israel, -turkey, -australia, -brazil, -other, -abroad)
Vienna_ARR <- read.csv("C:/Users/Acer/Desktop/Wiki pilot/wikistats/Vienna_ARR_model.csv", stringsAsFactors = F) %>%
  select(-X)

Barcelona_OVER <- read.csv("C:/Users/Acer/Desktop/Wiki pilot/wikistats/Barcelona_OVER_model.csv", stringsAsFactors = F) %>%
  select(-X)
Bruges_OVER <- read.csv("C:/Users/Acer/Desktop/Wiki pilot/wikistats/Bruges_OVER_model2.csv", stringsAsFactors = F) %>%
  select(-X, -belgium, -netherlands, -germany, - france, - united_kingdom, -luxembourg, -ireland, 
         -denmark, -sweden, -finland, -italy, -spain, -portugal, -greece, -austria, -poland, 
         -czech_republic, -hungary, -romania, -norway, -switzerland, -russia, -usa, 
         -canada, -japan, -china, -india, -israel, -turkey, -australia, -brazil, -other, -abroad)
Vienna_OVER <- read.csv("C:/Users/Acer/Desktop/Wiki pilot/wikistats/Vienna_OVER_model.csv", stringsAsFactors = F) %>%
  select(-X)

# Transform into ts objects

Barcelona_ARR_ts <- ts(Barcelona_ARR[,2:19], frequency = 12, start = c(2012, 1))
Barcelona_OVER_ts <- ts(Barcelona_OVER[,2:19], frequency = 12, start = c(2012, 1))

Bruges_ARR_ts <- ts(Bruges_ARR[,2:20], frequency = 12, start = c(2012, 1))
Bruges_OVER_ts <- ts(Bruges_OVER[,2:20], frequency = 12, start = c(2012, 1))

Vienna_ARR_ts <- ts(Vienna_ARR[,2:35], frequency = 12, start = c(2012, 1))
Vienna_OVER_ts <- ts(Vienna_OVER[,2:35], frequency = 12, start = c(2012, 1))

# Plot time series

plot.ts(Barcelona_ARR_ts[, 1:9])
plot.ts(Barcelona_ARR_ts[, 10:18])

plot.ts(Barcelona_OVER_ts[, 1:9])
plot.ts(Barcelona_OVER_ts[, 10:18])

plot.ts(Bruges_ARR_ts[, 1:10])
plot.ts(Bruges_ARR_ts[, 11:19])

plot.ts(Bruges_OVER_ts[, 1:10])
plot.ts(Bruges_OVER_ts[, 11:19])

plot.ts(Vienna_ARR_ts[, 1:8])
plot.ts(Vienna_ARR_ts[, 9:16])
plot.ts(Vienna_ARR_ts[, 17:24])
plot.ts(Vienna_ARR_ts[, 25:34])

plot.ts(Vienna_OVER_ts[, 1:8])
plot.ts(Vienna_OVER_ts[, 9:16])
plot.ts(Vienna_OVER_ts[, 17:24])
plot.ts(Vienna_OVER_ts[, 25:34])

# Adjust the series for seasonality

# Barcelona

BAR_public_transport_components <- decompose(Barcelona_ARR_ts[,1])
plot(BAR_public_transport_components)
BAR_public_transport_seas_adj <- Barcelona_ARR_ts[,1] - BAR_public_transport_components$seasonal
plot(BAR_public_transport_seas_adj)

BAR_sport_components <- decompose(Barcelona_ARR_ts[,11])
plot(BAR_sport_components)
BAR_sport_seas_adj <- Barcelona_ARR_ts[,11] - BAR_sport_components$seasonal
plot(BAR_sport_seas_adj)

BAR_high_education_components <- decompose(Barcelona_ARR_ts[,12])
plot(BAR_high_education_components)
BAR_high_education_seas_adj <- Barcelona_ARR_ts[,12] - BAR_high_education_components$seasonal
plot(BAR_high_education_seas_adj)

BAR_gran_teatro_del_liceo_components <- decompose(Barcelona_ARR_ts[,4])
plot(BAR_gran_teatro_del_liceo_components)
BAR_gran_teatro_del_liceo_seas_adj <- Barcelona_ARR_ts[,4] - BAR_gran_teatro_del_liceo_components$seasonal
plot(BAR_gran_teatro_del_liceo_seas_adj)

BAR_theatres_components <- decompose(Barcelona_ARR_ts[,13])
plot(BAR_theatres_components)
BAR_theatres_seas_adj <- Barcelona_ARR_ts[,13] - BAR_theatres_components$seasonal
plot(BAR_theatres_seas_adj)

BAR_buildings_components <- decompose(Barcelona_ARR_ts[,14])
plot(BAR_buildings_components)
BAR_buildings_seas_adj <- Barcelona_ARR_ts[,14] - BAR_buildings_components$seasonal
plot(BAR_buildings_seas_adj)

BAR_streets_and_districts_components <- decompose(Barcelona_ARR_ts[,16])
plot(BAR_streets_and_districts_components)
BAR_streets_and_districts_seas_adj <- Barcelona_ARR_ts[,16] - BAR_streets_and_districts_components$seasonal
plot(BAR_streets_and_districts_seas_adj)

BAR_museums_components <- decompose(Barcelona_ARR_ts[,2])
plot(BAR_museums_components)
BAR_museums_seas_adj <- Barcelona_ARR_ts[,2] - BAR_museums_components$seasonal
plot(BAR_museums_seas_adj)

BAR_sagrada_familia_components <- decompose(Barcelona_ARR_ts[,3])
plot(BAR_sagrada_familia_components)
BAR_sagrada_familia_seas_adj <- Barcelona_ARR_ts[,3] - BAR_sagrada_familia_components$seasonal
plot(BAR_sagrada_familia_seas_adj)

BAR_history_components <- decompose(Barcelona_ARR_ts[,5])
plot(BAR_history_components)
BAR_history_seas_adj <- Barcelona_ARR_ts[,5] - BAR_history_components$seasonal
plot(BAR_history_seas_adj)

BAR_institutions_organizations_components <- decompose(Barcelona_ARR_ts[,6])
plot(BAR_institutions_organizations_components)
BAR_institutions_organizations_seas_adj <- Barcelona_ARR_ts[,6] - BAR_institutions_organizations_components$seasonal
plot(BAR_institutions_organizations_seas_adj)

BAR_monuments_and_fountains_components <- decompose(Barcelona_ARR_ts[,7])
plot(BAR_monuments_and_fountains_components)
BAR_monuments_and_fountains_seas_adj <- Barcelona_ARR_ts[,7] - BAR_monuments_and_fountains_components$seasonal
plot(BAR_monuments_and_fountains_seas_adj)

BAR_culture_and_art_components <- decompose(Barcelona_ARR_ts[,8])
plot(BAR_culture_and_art_components)
BAR_culture_and_art_seas_adj <- Barcelona_ARR_ts[,8] - BAR_culture_and_art_components$seasonal
plot(BAR_culture_and_art_seas_adj)

BAR_parks_components <- decompose(Barcelona_ARR_ts[,9])
plot(BAR_parks_components)
BAR_parks_seas_adj <- Barcelona_ARR_ts[,9] - BAR_parks_components$seasonal
plot(BAR_parks_seas_adj)

BAR_futbol_club_barcelona_components <- decompose(Barcelona_ARR_ts[,15])
plot(BAR_futbol_club_barcelona_components)
BAR_futbol_club_barcelona_seas_adj <- Barcelona_ARR_ts[,15] - BAR_futbol_club_barcelona_components$seasonal
plot(BAR_futbol_club_barcelona_seas_adj)

BAR_places_of_worship_components <- decompose(Barcelona_ARR_ts[,10])
plot(BAR_places_of_worship_components)
BAR_places_of_worship_seas_adj <- Barcelona_ARR_ts[,10] - BAR_places_of_worship_components$seasonal
plot(BAR_places_of_worship_seas_adj)

#BAR_sagrada_other_components <- decompose(Barcelona_ARR_ts[,17])
#plot(BAR_sagrada_other_components)
#BAR_sagrada_other_seas_adj <- Barcelona_ARR_ts[,17] - BAR_sagrada_other_components$seasonal
#plot(BAR_sagrada_other_seas_adj)

#BAR_sagrada_es_components <- decompose(Barcelona_ARR_ts[,18])
#plot(BAR_sagrada_es_components)
#BAR_sagrada_es_seas_adj <- Barcelona_ARR_ts[,18] - BAR_sagrada_es_components$seasonal
#plot(BAR_sagrada_es_seas_adj)

BAR_number_of_passenger_components <- decompose(Barcelona_ARR_ts[,18])
plot(BAR_number_of_passenger_components)
BAR_number_of_passenger_seas_adj <- Barcelona_ARR_ts[,18] - BAR_number_of_passenger_components$seasonal
plot(BAR_number_of_passenger_seas_adj)

BAR_number_of_bookings_components <- decompose(Barcelona_OVER_ts[,18])
plot(BAR_number_of_bookings_components)
BAR_number_of_bookings_seas_adj <- Barcelona_OVER_ts[,18] - BAR_number_of_bookings_components$seasonal
plot(BAR_number_of_bookings_seas_adj)

library(corrplot)

Barc_ARR <- Barcelona_ARR %>%
  select(public_transport, sport, high_education, theatres, buildings, streets_and_districts, museums,
         sagrada_familia, history, institutions_organizations, monuments_and_fountains, culture_and_art, 
         parks, places_of_worship, other_unclassified, number_of_passengers)

Barc_OVER <- Barcelona_OVER %>%
  select(public_transport, sport, high_education, theatres, buildings, streets_and_districts, museums,
         sagrada_familia, history, institutions_organizations, monuments_and_fountains, culture_and_art, 
         parks, places_of_worship, other_unclassified, number_of_bookings)

res_Barc_ARR <- cor(Barc_ARR)
res_Barc_OVER <- cor(Barc_OVER)

corrplot(res_Barc_ARR, type = "upper", method = "number", order = "FPC")
corrplot(res_Barc_OVER, type = "upper", method = "number", order = "FPC")

cor.test(Barc_OVER$number_of_bookings, Barc_OVER$high_education)

# Testing for stationarity

library(tseries)

adf.test(BAR_number_of_passenger_seas_adj)
adf.test(diff(BAR_number_of_passenger_seas_adj))

BAR_number_of_passenger_seas_adj_diff <- diff(BAR_number_of_passenger_seas_adj)

adf.test(BAR_number_of_bookings_seas_adj)

BAR_number_of_bookings_seas_adj_diff <- diff(BAR_number_of_bookings_seas_adj)

adf.test(BAR_public_transport_seas_adj)
adf.test(diff(BAR_public_transport_seas_adj))
BAR_public_transport_seas_adj_diff <-  diff(BAR_public_transport_seas_adj)

adf.test(BAR_sport_seas_adj)
adf.test(diff(BAR_sport_seas_adj))
BAR_sport_seas_adj_diff <- diff(BAR_sport_seas_adj)

adf.test(BAR_high_education_seas_adj)
adf.test(diff(BAR_high_education_seas_adj))
BAR_high_education_seas_adj_diff <- diff(BAR_high_education_seas_adj)

adf.test(BAR_gran_teatro_del_liceo_seas_adj)
adf.test(diff(BAR_gran_teatro_del_liceo_seas_adj))
BAR_gran_teatro_del_liceo_seas_adj_diff <- diff(BAR_gran_teatro_del_liceo_seas_adj)

adf.test(BAR_theatres_seas_adj)
adf.test(diff(BAR_theatres_seas_adj))
adf.test(diff(diff(BAR_theatres_seas_adj)))
BAR_theatres_seas_adj_diff <- diff(BAR_theatres_seas_adj, differences = 2)

adf.test(BAR_buildings_seas_adj)
adf.test(diff(BAR_buildings_seas_adj))
BAR_buildings_seas_adj_diff <- diff(BAR_buildings_seas_adj)

adf.test(BAR_streets_and_districts_seas_adj)
adf.test(diff(BAR_streets_and_districts_seas_adj))
BAR_streets_and_districts_seas_adj_diff <- diff(BAR_streets_and_districts_seas_adj)

adf.test(BAR_museums_seas_adj)
adf.test(diff(BAR_museums_seas_adj))
BAR_museums_seas_adj_diff <- diff(BAR_museums_seas_adj)

adf.test(BAR_sagrada_familia_seas_adj)
adf.test(diff(BAR_sagrada_familia_seas_adj))
BAR_sagrada_familia_seas_adj_diff <- diff(BAR_sagrada_familia_seas_adj)

adf.test(BAR_history_seas_adj)
adf.test(diff(BAR_history_seas_adj))
BAR_history_seas_adj_diff <- diff(BAR_history_seas_adj)

adf.test(BAR_institutions_organizations_seas_adj)
adf.test(diff(BAR_institutions_organizations_seas_adj))
BAR_institutions_organizations_seas_adj_diff <- diff(BAR_institutions_organizations_seas_adj)

adf.test(BAR_monuments_and_fountains_seas_adj)
adf.test(diff(BAR_monuments_and_fountains_seas_adj))
BAR_monuments_and_fountains_seas_adj_diff <- diff(BAR_monuments_and_fountains_seas_adj)

adf.test(BAR_culture_and_art_seas_adj)
adf.test(diff(BAR_culture_and_art_seas_adj))
BAR_culture_and_art_seas_adj_diff <- diff(BAR_culture_and_art_seas_adj)

adf.test(BAR_parks_seas_adj)
adf.test(diff(BAR_parks_seas_adj))
BAR_parks_seas_adj_diff <- diff(BAR_parks_seas_adj)

adf.test(BAR_futbol_club_barcelona_seas_adj)
adf.test(diff(BAR_futbol_club_barcelona_seas_adj))
BAR_futbol_club_barcelona_seas_adj_diff <- diff(BAR_futbol_club_barcelona_seas_adj)

adf.test(BAR_places_of_worship_seas_adj)
adf.test(diff(BAR_places_of_worship_seas_adj))
BAR_places_of_worship_seas_adj_diff <- diff(BAR_places_of_worship_seas_adj)

#adf.test(BAR_sagrada_other_seas_adj)
#adf.test(diff(BAR_sagrada_other_seas_adj))
#BAR_sagrada_other_seas_adj_diff <- diff(BAR_sagrada_other_seas_adj)

#adf.test(BAR_sagrada_es_seas_adj)
#adf.test(diff(BAR_sagrada_es_seas_adj))
#BAR_sagrada_es_seas_adj_diff <- diff(BAR_sagrada_es_seas_adj)


# compute autocorrelations and partial autocorrelations 

# on data seasonally adjusted

acfBarARR <- acf(BAR_number_of_passenger_seas_adj_diff)
acfBarARR$lag <- acfBarARR$lag * 12
plot(acfBarARR)

pacfBarARR <- pacf(BAR_number_of_passenger_seas_adj_diff)
pacfBarARR$lag <- pacfBarARR$lag*12
plot(pacfBarARR)

acfBarOVER <- acf(BAR_number_of_bookings_seas_adj_diff)
acfBarOVER$lag <- acfBarOVER$lag*12
plot(acfBarOVER)

pacfBarOVER <- pacf(BAR_number_of_bookings_seas_adj_diff)
pacfBarOVER$lag <- pacfBarOVER$lag*12
plot(pacfBarOVER)

# try auto.arima

library(forecast)

auto.arima(BAR_number_of_passenger_seas_adj_diff)
auto.arima(BAR_number_of_bookings_seas_adj_diff)

# scale all the time series

BAR_number_of_passenger_seas_adj_diff <- BAR_number_of_passenger_seas_adj_diff[6:47]
BAR_number_of_bookings_seas_adj_diff <- BAR_number_of_bookings_seas_adj_diff[6:47]

BAR_number_of_passenger_seas_adj_diff_scaled <- scale(BAR_number_of_passenger_seas_adj_diff)
BAR_number_of_bookings_seas_adj_diff_scaled <- scale(BAR_number_of_bookings_seas_adj_diff)

auto.arima(BAR_number_of_passenger_seas_adj_diff_scaled)
auto.arima(BAR_number_of_bookings_seas_adj_diff_scaled)

BAR_public_transport_seas_adj_diff <- BAR_public_transport_seas_adj_diff[6:47]
BAR_sport_seas_adj_diff <- BAR_sport_seas_adj_diff[6:47]
BAR_high_education_seas_adj_diff <- BAR_high_education_seas_adj_diff[6:47]
BAR_gran_teatro_del_liceo_seas_adj_diff <- BAR_gran_teatro_del_liceo_seas_adj_diff[6:47]
BAR_theatres_seas_adj_diff <- BAR_theatres_seas_adj_diff[6:47]
BAR_buildings_seas_adj_diff <- BAR_buildings_seas_adj_diff[6:47]
BAR_streets_and_districts_seas_adj_diff <- BAR_streets_and_districts_seas_adj_diff[6:47]
BAR_museums_seas_adj_diff <- BAR_museums_seas_adj_diff[6:47]
BAR_sagrada_familia_seas_adj_diff <- BAR_sagrada_familia_seas_adj_diff[6:47]
BAR_history_seas_adj_diff <- BAR_history_seas_adj_diff[6:47]
BAR_institutions_organizations_seas_adj_diff <- BAR_institutions_organizations_seas_adj_diff[6:47]
BAR_monuments_and_fountains_seas_adj_diff <- BAR_monuments_and_fountains_seas_adj_diff[6:47]
BAR_culture_and_art_seas_adj_diff <- BAR_culture_and_art_seas_adj_diff[6:47]
BAR_parks_seas_adj_diff <- BAR_parks_seas_adj_diff[6:47]
BAR_futbol_club_barcelona_seas_adj_diff <- BAR_futbol_club_barcelona_seas_adj_diff[6:47]
BAR_places_of_worship_seas_adj_diff <- BAR_places_of_worship_seas_adj_diff[6:47]
#BAR_sagrada_other_seas_adj_diff <- BAR_sagrada_other_seas_adj_diff[6:47]
#BAR_sagrada_es_seas_adj_diff <- BAR_sagrada_es_seas_adj_diff[6:47]

BAR_public_transport_seas_adj_diff_scaled <- scale(BAR_public_transport_seas_adj_diff)
BAR_sport_seas_adj_diff_scaled <- scale(BAR_sport_seas_adj_diff)
BAR_high_education_seas_adj_diff_scaled <- scale(BAR_high_education_seas_adj_diff)
BAR_gran_teatro_del_liceo_seas_adj_diff_scaled <- scale(BAR_gran_teatro_del_liceo_seas_adj_diff)
BAR_theatres_seas_adj_diff_scaled <- scale(BAR_theatres_seas_adj_diff)
BAR_buildings_seas_adj_diff_scaled <- scale(BAR_buildings_seas_adj_diff)
BAR_streets_and_districts_seas_adj_diff_scaled <- scale(BAR_streets_and_districts_seas_adj_diff)
BAR_museums_seas_adj_diff_scaled <- scale(BAR_museums_seas_adj_diff)
BAR_sagrada_familia_seas_adj_diff_scaled <- scale(BAR_sagrada_familia_seas_adj_diff)
BAR_history_seas_adj_diff_scaled <- scale(BAR_history_seas_adj_diff)
BAR_institutions_organizations_seas_adj_diff_scaled <- scale(BAR_institutions_organizations_seas_adj_diff)
BAR_monuments_and_fountains_seas_adj_diff_scaled <- scale(BAR_monuments_and_fountains_seas_adj_diff)
BAR_culture_and_art_seas_adj_diff_scaled <- scale(BAR_culture_and_art_seas_adj_diff)
BAR_parks_seas_adj_diff_scaled <- scale(BAR_parks_seas_adj_diff)
BAR_futbol_club_barcelona_seas_adj_diff_scaled <- scale(BAR_futbol_club_barcelona_seas_adj_diff)
BAR_places_of_worship_seas_adj_diff_scaled <- scale(BAR_places_of_worship_seas_adj_diff)
#BAR_sagrada_other_seas_adj_diff_scaled <- scale(BAR_sagrada_other_seas_adj_diff)
#BAR_sagrada_es_seas_adj_diff_scaled <- scale(BAR_sagrada_es_seas_adj_diff)

# create xreg dataframe

BAR_xreg<- data.frame(public_transport = BAR_public_transport_seas_adj_diff_scaled, 
                      sport = BAR_sport_seas_adj_diff_scaled, 
                      high_education = BAR_high_education_seas_adj_diff_scaled,
                      gran_teatro_del_liceo = BAR_gran_teatro_del_liceo_seas_adj_diff_scaled,     
                      theatres = BAR_theatres_seas_adj_diff_scaled, 
                      buildings = BAR_buildings_seas_adj_diff_scaled, 
                      streets_and_districts = BAR_streets_and_districts_seas_adj_diff_scaled, 
                      museums = BAR_museums_seas_adj_diff_scaled, 
                      sagrada_familia = BAR_sagrada_familia_seas_adj_diff_scaled, 
                      history = BAR_history_seas_adj_diff_scaled, 
                      institutions_organizations = BAR_institutions_organizations_seas_adj_diff_scaled, 
                      monuments_and_fountains = BAR_monuments_and_fountains_seas_adj_diff_scaled, 
                      culture_and_art = BAR_culture_and_art_seas_adj_diff_scaled, 
                      parks = BAR_parks_seas_adj_diff_scaled, 
                      futbol_club_barcelona = BAR_futbol_club_barcelona_seas_adj_diff_scaled,   
                      places_of_worship = BAR_places_of_worship_seas_adj_diff_scaled)
#sagrada_other = BAR_sagrada_other_seas_adj_diff_scaled,
#sagrada_es = BAR_sagrada_es_seas_adj_diff_scaled)

# plot time series

plot.ts(BAR_number_of_passenger_seas_adj_diff_scaled, main = "Number of passengers")
plot.ts(BAR_number_of_bookings_seas_adj_diff_scaled, main = "Number of bookings")
plot.ts(BAR_xreg[,1:9])
plot.ts(BAR_xreg[,10:16])

# try again with auto.arima and regressors

auto.arima(BAR_number_of_passenger_seas_adj_diff_scaled, xreg = BAR_xreg)
auto.arima(BAR_number_of_bookings_seas_adj_diff_scaled, xreg = BAR_xreg)

# check acf and pacf

acf(BAR_number_of_passenger_seas_adj_diff_scaled)
pacf(BAR_number_of_passenger_seas_adj_diff_scaled)

BAR_fit_passengers <- Arima(BAR_number_of_passenger_seas_adj_diff_scaled, order = c(0,0,0), xreg = BAR_xreg, include.mean = F)
BAR_fit_passengers

BAR_res_fit_passengers <- acf(BAR_fit_passengers$residuals, lag.max = 20)
Box.test(BAR_fit_passengers$residuals, lag = 20, type = "Ljung-Box")

acf(BAR_fit_passengers$residuals)
plotForecastErrors(BAR_fit_passengers$residuals)

acf(BAR_number_of_bookings_seas_adj_diff_scaled)
pacf(BAR_number_of_bookings_seas_adj_diff_scaled)

BAR_fit_bookings <- Arima(BAR_number_of_bookings_seas_adj_diff_scaled, order = c(0,0,0), xreg = BAR_xreg, include.mean = F)
BAR_fit_bookings

BAR_res_fit_bookings <- acf(BAR_fit_bookings$residuals, lag.max = 20)
Box.test(BAR_fit_bookings$residuals, lag = 20, type = "Ljung-Box")

acf(BAR_fit_bookings$residuals)
plotForecastErrors(BAR_fit_bookings$residuals)

# Bruges

Bru_ARR <- Bruges_ARR %>%
  select(-time)
Bru_OVER <- Bruges_OVER %>%
  select(-time)

res_Bru_ARR <- cor(Bru_ARR)

res_Bru_OVER <- cor(Bru_OVER)

corrplot(res_Bru_ARR, type = "upper", method = "number", order = "FPC")
corrplot(res_Bru_OVER, type = "upper", method = "number", order = "FPC")

cor.test(Bru_OVER$number_of_bookings, Bru_OVER$buildings)

BRU_public_transport_components <- decompose(Bruges_ARR_ts[,1])
plot(BRU_public_transport_components)
BRU_public_transport_seas_adj <- Bruges_ARR_ts[,1] - BRU_public_transport_components$seasonal
plot(BRU_public_transport_seas_adj)

BRU_streets_and_streams_components <- decompose(Bruges_ARR_ts[,8])
plot(BRU_streets_and_streams_components)
BRU_streets_and_streams_seas_adj <- Bruges_ARR_ts[,8] - BRU_streets_and_streams_components$seasonal
plot(BRU_streets_and_streams_seas_adj)

BRU_libraries_components <- decompose(Bruges_ARR_ts[,11])
plot(BRU_libraries_components)
BRU_libraries_seas_adj <- Bruges_ARR_ts[,11] - BRU_libraries_components$seasonal
plot(BRU_libraries_seas_adj)

BRU_buildings_components <- decompose(Bruges_ARR_ts[,13])
plot(BRU_buildings_components)
BRU_buildings_seas_adj <- Bruges_ARR_ts[,13] - BRU_buildings_components$seasonal
plot(BRU_buildings_seas_adj)

BRU_high_education_components <- decompose(Bruges_ARR_ts[,14])
plot(BRU_high_education_components)
BRU_high_education_seas_adj <- Bruges_ARR_ts[,14] - BRU_high_education_components$seasonal
plot(BRU_high_education_seas_adj)

BRU_bridges_and_canals_components <- decompose(Bruges_ARR_ts[,16])
plot(BRU_bridges_and_canals_components)
BRU_bridges_and_canals_seas_adj <- Bruges_ARR_ts[,16] - BRU_bridges_and_canals_components$seasonal
plot(BRU_bridges_and_canals_seas_adj)

BRU_sport_components <- decompose(Bruges_ARR_ts[,17])
plot(BRU_sport_components)
BRU_sport_seas_adj <- Bruges_ARR_ts[,17] - BRU_sport_components$seasonal
plot(BRU_sport_seas_adj)

BRU_districts_components <- decompose(Bruges_ARR_ts[,2])
plot(BRU_districts_components)
BRU_districts_seas_adj <- Bruges_ARR_ts[,2] - BRU_districts_components$seasonal
plot(BRU_districts_seas_adj)

BRU_places_of_worship_components <- decompose(Bruges_ARR_ts[,3])
plot(BRU_places_of_worship_components)
BRU_places_of_worship_seas_adj <- Bruges_ARR_ts[,3] - BRU_places_of_worship_components$seasonal
plot(BRU_places_of_worship_seas_adj)

BRU_companies_components <- decompose(Bruges_ARR_ts[,5])
plot(BRU_companies_components)
BRU_companies_seas_adj <- Bruges_ARR_ts[,5] - BRU_companies_components$seasonal
plot(BRU_companies_seas_adj)

BRU_museums_components <- decompose(Bruges_ARR_ts[,6])
plot(BRU_museums_components)
BRU_museums_seas_adj <- Bruges_ARR_ts[,6] - BRU_museums_components$seasonal
plot(BRU_museums_seas_adj)

BRU_zeebrugge_components <- decompose(Bruges_ARR_ts[,7])
plot(BRU_zeebrugge_components)
BRU_zeebrugge_seas_adj <- Bruges_ARR_ts[,7] - BRU_zeebrugge_components$seasonal
plot(BRU_zeebrugge_seas_adj)

BRU_belfort_van_brugge_components <- decompose(Bruges_ARR_ts[,9])
plot(BRU_belfort_van_brugge_components)
BRU_belfort_van_brugge_seas_adj <- Bruges_ARR_ts[,9] - BRU_belfort_van_brugge_components$seasonal
plot(BRU_belfort_van_brugge_seas_adj)

BRU_cercle_brugge_components <- decompose(Bruges_ARR_ts[,12])
plot(BRU_cercle_brugge_components)
BRU_cercle_brugge_seas_adj <- Bruges_ARR_ts[,12] - BRU_cercle_brugge_components$seasonal
plot(BRU_cercle_brugge_seas_adj)

BRU_grote_markt_components <- decompose(Bruges_ARR_ts[,4])
plot(BRU_grote_markt_components)
BRU_grote_markt_seas_adj <- Bruges_ARR_ts[,4] - BRU_grote_markt_components$seasonal
plot(BRU_grote_markt_seas_adj)

BRU_sint_andries_components <- decompose(Bruges_ARR_ts[,10])
plot(BRU_sint_andries_components)
BRU_sint_andries_seas_adj <- Bruges_ARR_ts[,10] - BRU_sint_andries_components$seasonal
plot(BRU_sint_andries_seas_adj)

BRU_madonna_met_kind_components <- decompose(Bruges_ARR_ts[,15])
plot(BRU_madonna_met_kind_components)
BRU_madonna_met_kind_seas_adj <- Bruges_ARR_ts[,15] - BRU_madonna_met_kind_components$seasonal
plot(BRU_madonna_met_kind_seas_adj)

BRU_number_of_passenger_components <- decompose(Bruges_ARR_ts[,19])
plot(BRU_number_of_passenger_components)
BRU_number_of_passenger_seas_adj <- Bruges_ARR_ts[,19] - BRU_number_of_passenger_components$seasonal
plot(BRU_number_of_passenger_seas_adj)

BRU_number_of_bookings_components <- decompose(Bruges_OVER_ts[,19])
plot(BRU_number_of_bookings_components)
BRU_number_of_bookings_seas_adj <- Bruges_OVER_ts[,19] - BRU_number_of_bookings_components$seasonal
plot(BRU_number_of_bookings_seas_adj)

# Test stationarity

library(tseries)

adf.test(BRU_number_of_passenger_seas_adj)
adf.test(diff(BRU_number_of_passenger_seas_adj))

BRU_number_of_passenger_seas_adj_diff <- diff(BRU_number_of_passenger_seas_adj)

adf.test(BRU_number_of_bookings_seas_adj)
adf.test(diff(BRU_number_of_bookings_seas_adj))

BRU_number_of_bookings_seas_adj_diff <- diff(BRU_number_of_bookings_seas_adj)

adf.test(BRU_public_transport_seas_adj)
adf.test(diff(BRU_public_transport_seas_adj))

BRU_public_transport_seas_adj_diff <- diff(BRU_public_transport_seas_adj)

adf.test(BRU_streets_and_streams_seas_adj)
adf.test(diff(BRU_streets_and_streams_seas_adj))
adf.test(diff(diff(BRU_streets_and_streams_seas_adj)))

BRU_streets_and_streams_seas_adj_diff <- diff(BRU_streets_and_streams_seas_adj, differences = 2)

adf.test(BRU_libraries_seas_adj)
adf.test(diff(BRU_libraries_seas_adj))

BRU_libraries_seas_adj_diff <- diff(BRU_libraries_seas_adj)

adf.test(BRU_buildings_seas_adj)
adf.test(diff(BRU_buildings_seas_adj))

BRU_buildings_seas_adj_diff <- diff(BRU_buildings_seas_adj)

adf.test(BRU_high_education_seas_adj)
adf.test(diff(BRU_high_education_seas_adj))

BRU_high_education_seas_adj_diff <- diff(BRU_high_education_seas_adj)

adf.test(BRU_bridges_and_canals_seas_adj)
adf.test(diff(BRU_bridges_and_canals_seas_adj))

BRU_bridges_and_canals_seas_adj_diff <- diff(BRU_bridges_and_canals_seas_adj)

adf.test(BRU_sport_seas_adj)
adf.test(diff(BRU_sport_seas_adj))

BRU_sport_seas_adj_diff <- diff(BRU_sport_seas_adj)

adf.test(BRU_districts_seas_adj)
adf.test(diff(BRU_districts_seas_adj))

BRU_districts_seas_adj_diff <- diff(BRU_districts_seas_adj)

adf.test(BRU_places_of_worship_seas_adj)
adf.test(diff(BRU_places_of_worship_seas_adj))
adf.test(diff(diff(BRU_places_of_worship_seas_adj)))

BRU_places_of_worship_seas_adj_diff <- diff(BRU_places_of_worship_seas_adj, differences = 2)

adf.test(BRU_companies_seas_adj)
adf.test(diff(BRU_companies_seas_adj))

BRU_companies_seas_adj_diff <- diff(BRU_companies_seas_adj)

adf.test(BRU_museums_seas_adj)
adf.test(diff(BRU_museums_seas_adj))

BRU_museums_seas_adj_diff <- diff(BRU_museums_seas_adj)

adf.test(BRU_zeebrugge_seas_adj)
adf.test(diff(BRU_zeebrugge_seas_adj))

BRU_zeebrugge_seas_adj_diff <- diff(BRU_zeebrugge_seas_adj)

adf.test(BRU_belfort_van_brugge_seas_adj)
adf.test(diff(BRU_belfort_van_brugge_seas_adj))

BRU_belfort_van_brugge_seas_adj_diff <- diff(BRU_belfort_van_brugge_seas_adj)

adf.test(BRU_cercle_brugge_seas_adj)
adf.test(diff(BRU_cercle_brugge_seas_adj))
adf.test(diff(diff(BRU_cercle_brugge_seas_adj)))

BRU_cercle_brugge_seas_adj_diff <- diff(BRU_cercle_brugge_seas_adj, differences = 2)

adf.test((BRU_grote_markt_seas_adj))
adf.test(diff(BRU_grote_markt_seas_adj))

BRU_grote_markt_seas_adj_diff <- diff(BRU_grote_markt_seas_adj)

adf.test(BRU_sint_andries_seas_adj)
adf.test(diff(BRU_sint_andries_seas_adj))
adf.test(diff(diff(BRU_sint_andries_seas_adj)))

BRU_sint_andries_seas_adj_diff <- diff(BRU_sint_andries_seas_adj, differences = 2)

adf.test(BRU_madonna_met_kind_seas_adj)
adf.test(diff(BRU_madonna_met_kind_seas_adj))
adf.test(diff(diff(BRU_madonna_met_kind_seas_adj)))

BRU_madonna_met_kind_seas_adj_diff <- diff(BRU_madonna_met_kind_seas_adj, differences = 2)

# compute autocorrelations and partial autocorrelations 

# on data seasonally adjusted

acfBruARR <- acf(BRU_number_of_passenger_seas_adj_diff)
acfBruARR$lag <- acfBruARR$lag * 12
plot(acfBruARR)

pacfBruARR <- pacf(BRU_number_of_passenger_seas_adj_diff)
pacfBruARR$lag <- pacfBruARR$lag*12
plot(pacfBruARR)

acfBruOVER <- acf(BRU_number_of_bookings_seas_adj_diff)
acfBruOVER$lag <- acfBruOVER$lag*12
plot(acfBruOVER)

pacfBruOVER <- pacf(BRU_number_of_bookings_seas_adj_diff)
pacfBruOVER$lag <- pacfBruOVER$lag*12
plot(pacfBruOVER)

# try auto.arima

auto.arima(BRU_number_of_passenger_seas_adj_diff)
auto.arima(BRU_number_of_bookings_seas_adj_diff)

# scale time series 

BRU_number_of_passenger_seas_adj_diff_scaled <- scale(BRU_number_of_passenger_seas_adj_diff[-1])
BRU_number_of_bookings_seas_adj_diff_scaled <- scale(BRU_number_of_bookings_seas_adj_diff[-1])

BRU_public_transport_seas_adj_diff_scaled <- scale(BRU_public_transport_seas_adj_diff[-1])
BRU_streets_and_streams_seas_adj_diff_scaled <- scale(BRU_streets_and_streams_seas_adj_diff)
BRU_libraries_seas_adj_diff_scaled <- scale(BRU_libraries_seas_adj_diff[-1])
BRU_buildings_seas_adj_diff_scaled <- scale(BRU_buildings_seas_adj_diff[-1])
BRU_high_education_seas_adj_diff_scaled <- scale(BRU_high_education_seas_adj_diff[-1])
BRU_bridges_and_canals_seas_adj_diff_scaled <- scale(BRU_bridges_and_canals_seas_adj_diff[-1])
BRU_sport_seas_adj_diff_scaled <- scale(BRU_sport_seas_adj_diff[-1])
BRU_districts_seas_adj_diff_scaled <- scale(BRU_districts_seas_adj_diff[-1])
BRU_places_of_worship_seas_adj_diff_scaled <- scale(BRU_places_of_worship_seas_adj_diff)
BRU_companies_seas_adj_diff_scaled <- scale(BRU_companies_seas_adj_diff[-1])
BRU_museums_seas_adj_diff_scaled <- scale(BRU_museums_seas_adj_diff[-1])
BRU_zeebrugge_seas_adj_diff_scaled <- scale(BRU_zeebrugge_seas_adj_diff[-1])
BRU_belfort_van_brugge_seas_adj_diff_scaled <- scale(BRU_belfort_van_brugge_seas_adj_diff[-1])
BRU_cercle_brugge_seas_adj_diff_scaled <- scale(BRU_cercle_brugge_seas_adj_diff)
BRU_grote_markt_seas_adj_diff_scaled <- scale(BRU_grote_markt_seas_adj_diff[-1])
BRU_sint_andries_seas_adj_diff_scaled <- scale(BRU_sint_andries_seas_adj_diff)
BRU_madonna_met_kind_seas_adj_diff_scaled <- scale(BRU_madonna_met_kind_seas_adj_diff)


BRU_xreg <- data.frame(public_transport = BRU_public_transport_seas_adj_diff_scaled, 
                       streets_and_streams = BRU_streets_and_streams_seas_adj_diff_scaled, 
                       libraries = BRU_libraries_seas_adj_diff_scaled,
                       buildings = BRU_buildings_seas_adj_diff_scaled, 
                       high_education = BRU_high_education_seas_adj_diff_scaled, 
                       bridges_and_canals = BRU_bridges_and_canals_seas_adj_diff_scaled, 
                       sport = BRU_sport_seas_adj_diff_scaled,
                       districts = BRU_districts_seas_adj_diff_scaled,
                       places_of_worship = BRU_places_of_worship_seas_adj_diff_scaled, 
                       companies = BRU_companies_seas_adj_diff_scaled,
                       museums = BRU_museums_seas_adj_diff_scaled,
                       zeebrugge = BRU_zeebrugge_seas_adj_diff_scaled,
                       belfort_van_brugge = BRU_belfort_van_brugge_seas_adj_diff_scaled,
                       cercle_brugge = BRU_cercle_brugge_seas_adj_diff_scaled, 
                       grote_markt = BRU_grote_markt_seas_adj_diff_scaled, 
                       sint_andries = BRU_sint_andries_seas_adj_diff_scaled,
                       madonna_met_kind = BRU_madonna_met_kind_seas_adj_diff_scaled)

# plot time series

plot.ts(BRU_number_of_passenger_seas_adj_diff_scaled, main = "Number of passengers")
plot.ts(BRU_number_of_bookings_seas_adj_diff_scaled, main = "Number of bookings")
plot.ts(BRU_xreg[,1:9])
plot.ts(BRU_xreg[,10:17])

# try again with auto.arima and regressors

library(forecast)

auto.arima(BRU_number_of_passenger_seas_adj_diff_scaled, xreg = BRU_xreg)
auto.arima(BRU_number_of_bookings_seas_adj_diff_scaled, xreg = BRU_xreg)

# check acf and pacf

acf(BRU_number_of_passenger_seas_adj_diff_scaled)
pacf(BRU_number_of_passenger_seas_adj_diff_scaled)

BRU_fit_passengers <- Arima(BRU_number_of_passenger_seas_adj_diff_scaled, order = c(1,0,0), xreg = BRU_xreg, include.mean = F)
BRU_fit_passengers

BRU_res_fit_passengers <- acf(BRU_fit_passengers$residuals, lag.max = 20)
Box.test(BRU_fit_passengers$residuals, lag = 20, type = "Ljung-Box")

acf(BRU_fit_passengers$residuals)
plotForecastErrors(BRU_fit_passengers$residuals)

acf(BRU_number_of_bookings_seas_adj_diff_scaled)
pacf(BRU_number_of_bookings_seas_adj_diff_scaled)

BRU_fit_bookings <- Arima(BRU_number_of_bookings_seas_adj_diff_scaled, order = c(1,0,0), xreg = BRU_xreg, include.mean = F)
BRU_fit_bookings

BRU_res_fit_bookings <- acf(BRU_fit_bookings$residuals, lag.max = 20)
Box.test(BRU_fit_bookings$residuals, lag = 20, type = "Ljung-Box")

acf(BRU_fit_bookings$residuals)
plotForecastErrors(BRU_fit_bookings$residuals)

# Vienna

Vie_ARR <- Vienna_ARR %>%
  select(-time)
Vie_OVER <- Vienna_OVER %>%
  select(-time)

res_Vie_ARR <- cor(Vie_ARR)

res_Vie_OVER <- cor(Vie_OVER)

corrplot(res_Vie_ARR, type = "upper", method = "number", order = "FPC")
corrplot(res_Vie_OVER, type = "upper", method = "number", order = "FPC")

cor.test(Vie_ARR$number_of_passengers, Vie_ARR$buildings)
cor.test(Vie_OVER$number_of_bookings, Vie_OVER$buildings)

VIE_sport_components <- decompose(Vienna_ARR_ts[,1])
plot(VIE_sport_components)
VIE_sport_seas_adj <- Vienna_ARR_ts[,1] - VIE_sport_components$seasonal
plot(VIE_sport_seas_adj)

VIE_council_housing_components <- decompose(Vienna_ARR_ts[,8])
plot(VIE_council_housing_components)
VIE_council_housing_seas_adj <- Vienna_ARR_ts[,8] - VIE_council_housing_components$seasonal
plot(VIE_council_housing_seas_adj)

VIE_institutions_organizations_components <- decompose(Vienna_ARR_ts[,15])
plot(VIE_institutions_organizations_components)
VIE_institutions_organizations_seas_adj <- Vienna_ARR_ts[,15] - VIE_institutions_organizations_components$seasonal
plot(VIE_institutions_organizations_seas_adj)

VIE_history_components <- decompose(Vienna_ARR_ts[,22])
plot(VIE_history_components)
VIE_history_seas_adj <- Vienna_ARR_ts[,22] - VIE_history_components$seasonal
plot(VIE_history_seas_adj)

VIE_township_components <- decompose(Vienna_ARR_ts[,27])
plot(VIE_township_components)
VIE_township_seas_adj <- Vienna_ARR_ts[,27] - VIE_township_components$seasonal
plot(VIE_township_seas_adj)

VIE_places_of_worship_components <- decompose(Vienna_ARR_ts[,29])
plot(VIE_places_of_worship_components)
VIE_places_of_worship_seas_adj <- Vienna_ARR_ts[,29] - VIE_places_of_worship_components$seasonal
plot(VIE_places_of_worship_seas_adj)

VIE_companies_components <- decompose(Vienna_ARR_ts[,32])
plot(VIE_companies_components)
VIE_companies_seas_adj <- Vienna_ARR_ts[,32] - VIE_companies_components$seasonal
plot(VIE_companies_seas_adj)

VIE_bus_stops_and_stations_components <- decompose(Vienna_ARR_ts[,2])
plot(VIE_bus_stops_and_stations_components)
VIE_bus_stops_and_stations_seas_adj <- Vienna_ARR_ts[,2] - VIE_bus_stops_and_stations_components$seasonal
plot(VIE_bus_stops_and_stations_seas_adj)

VIE_mountains_components <- decompose(Vienna_ARR_ts[,3])
plot(VIE_mountains_components)
VIE_mountains_seas_adj <- Vienna_ARR_ts[,3] - VIE_mountains_components$seasonal
plot(VIE_mountains_seas_adj)

VIE_transmitters_components <- decompose(Vienna_ARR_ts[,6])
plot(VIE_transmitters_components)
VIE_transmitters_seas_adj <- Vienna_ARR_ts[,6] - VIE_transmitters_components$seasonal
plot(VIE_transmitters_seas_adj)

VIE_embassies_components <- decompose(Vienna_ARR_ts[,7])
plot(VIE_embassies_components)
VIE_embassies_seas_adj <- Vienna_ARR_ts[,7] - VIE_embassies_components$seasonal
plot(VIE_embassies_seas_adj)

VIE_streets_and_squares_components <- decompose(Vienna_ARR_ts[,9])
plot(VIE_streets_and_squares_components)
VIE_streets_and_squares_seas_adj <- Vienna_ARR_ts[,9] - VIE_streets_and_squares_components$seasonal
plot(VIE_streets_and_squares_seas_adj)

VIE_rivers_and_parks_components <- decompose(Vienna_ARR_ts[,10])
plot(VIE_rivers_and_parks_components)
VIE_rivers_and_parks_seas_adj <- Vienna_ARR_ts[,10] - VIE_rivers_and_parks_components$seasonal
plot(VIE_rivers_and_parks_seas_adj)

VIE_museums_components <- decompose(Vienna_ARR_ts[,12])
plot(VIE_museums_components)
VIE_museums_seas_adj <- Vienna_ARR_ts[,12] - VIE_museums_components$seasonal
plot(VIE_museums_seas_adj)

VIE_towers_components <- decompose(Vienna_ARR_ts[,13])
plot(VIE_towers_components)
VIE_towers_seas_adj <- Vienna_ARR_ts[,13] - VIE_towers_components$seasonal
plot(VIE_towers_seas_adj)

VIE_buildings_components <- decompose(Vienna_ARR_ts[,16])
plot(VIE_buildings_components)
VIE_buildings_seas_adj <- Vienna_ARR_ts[,16] - VIE_buildings_components$seasonal
plot(VIE_buildings_seas_adj)

VIE_hospitals_components <- decompose(Vienna_ARR_ts[,18])
plot(VIE_hospitals_components)
VIE_hospitals_seas_adj <- Vienna_ARR_ts[,18] - VIE_hospitals_components$seasonal
plot(VIE_hospitals_seas_adj)

VIE_libraries_components <- decompose(Vienna_ARR_ts[,19])
plot(VIE_libraries_components)
VIE_libraries_seas_adj <- Vienna_ARR_ts[,19] - VIE_libraries_components$seasonal
plot(VIE_libraries_seas_adj)

VIE_statues_and_fountains_components <- decompose(Vienna_ARR_ts[,20])
plot(VIE_statues_and_fountains_components)
VIE_statues_and_fountains_seas_adj <- Vienna_ARR_ts[,20] - VIE_statues_and_fountains_components$seasonal
plot(VIE_statues_and_fountains_seas_adj)

VIE_high_education_components <- decompose(Vienna_ARR_ts[,21])
plot(VIE_high_education_components)
VIE_high_education_seas_adj <- Vienna_ARR_ts[,21] - VIE_high_education_components$seasonal
plot(VIE_high_education_seas_adj)

VIE_bridges_components <- decompose(Vienna_ARR_ts[,23])
plot(VIE_bridges_components)
VIE_bridges_seas_adj <- Vienna_ARR_ts[,23] - VIE_bridges_components$seasonal
plot(VIE_bridges_seas_adj)

VIE_theatres_components <- decompose(Vienna_ARR_ts[,24])
plot(VIE_theatres_components)
VIE_theatres_seas_adj <- Vienna_ARR_ts[,24] - VIE_theatres_components$seasonal
plot(VIE_theatres_seas_adj)

VIE_cemeteries_components <- decompose(Vienna_ARR_ts[,25])
plot(VIE_cemeteries_components)
VIE_cemeteries_seas_adj <- Vienna_ARR_ts[,25] - VIE_cemeteries_components$seasonal
plot(VIE_cemeteries_seas_adj)

VIE_schloss_schonbrunn_components <- decompose(Vienna_ARR_ts[,4])
plot(VIE_schloss_schonbrunn_components)
VIE_schloss_schonbrunn_seas_adj <- Vienna_ARR_ts[,4] - VIE_schloss_schonbrunn_components$seasonal
plot(VIE_schloss_schonbrunn_seas_adj)

VIE_universitat_wien_components <- decompose(Vienna_ARR_ts[,5])
plot(VIE_universitat_wien_components)
VIE_universitat_wien_seas_adj <- Vienna_ARR_ts[,5] - VIE_universitat_wien_components$seasonal
plot(VIE_universitat_wien_seas_adj)

VIE_osterreich_ungarn_components <- decompose(Vienna_ARR_ts[,14])
plot(VIE_osterreich_ungarn_components)
VIE_osterreich_ungarn_seas_adj <- Vienna_ARR_ts[,14] - VIE_osterreich_ungarn_components$seasonal
plot(VIE_osterreich_ungarn_seas_adj)

VIE_wiener_ringstrasse_components <- decompose(Vienna_ARR_ts[,26])
plot(VIE_wiener_ringstrasse_components)
VIE_wiener_ringstrasse_seas_adj <- Vienna_ARR_ts[,26] - VIE_wiener_ringstrasse_components$seasonal
plot(VIE_wiener_ringstrasse_seas_adj)

VIE_der_kuss_components <- decompose(Vienna_ARR_ts[,28])
plot(VIE_der_kuss_components)
VIE_der_kuss_seas_adj <- Vienna_ARR_ts[,28] - VIE_der_kuss_components$seasonal
plot(VIE_der_kuss_seas_adj)

VIE_nationalbibliothek_components <- decompose(Vienna_ARR_ts[,17])
plot(VIE_nationalbibliothek_components)
VIE_nationalbibliothek_seas_adj <- Vienna_ARR_ts[,17] - VIE_nationalbibliothek_components$seasonal
plot(VIE_nationalbibliothek_seas_adj)

VIE_donauinsel_components <- decompose(Vienna_ARR_ts[,11])
plot(VIE_donauinsel_components)
VIE_donauinsel_seas_adj <- Vienna_ARR_ts[,11] - VIE_donauinsel_components$seasonal
plot(VIE_donauinsel_seas_adj)

VIE_botschaft_usa_components <- decompose(Vienna_ARR_ts[,31])
plot(VIE_botschaft_usa_components)
VIE_botschaft_usa_seas_adj <- Vienna_ARR_ts[,31] - VIE_botschaft_usa_components$seasonal
plot(VIE_botschaft_usa_seas_adj)

VIE_organisation_erdolexportierender_lander_components <- decompose(Vienna_ARR_ts[,30])
plot(VIE_organisation_erdolexportierender_lander_components)
VIE_organisation_erdolexportierender_lander_seas_adj <- Vienna_ARR_ts[,30] - VIE_organisation_erdolexportierender_lander_components$seasonal
plot(VIE_organisation_erdolexportierender_lander_seas_adj)

VIE_number_of_passenger_components <- decompose(Vienna_ARR_ts[,34])
plot(VIE_number_of_passenger_components)
VIE_number_of_passenger_seas_adj <- Vienna_ARR_ts[,34] - VIE_number_of_passenger_components$seasonal
plot(VIE_number_of_passenger_seas_adj)

VIE_number_of_bookings_components <- decompose(Vienna_OVER_ts[,34])
plot(VIE_number_of_bookings_components)
VIE_number_of_bookings_seas_adj <- Vienna_OVER_ts[,34] - VIE_number_of_bookings_components$seasonal
plot(VIE_number_of_bookings_seas_adj)

# Testing for stationarity

adf.test(VIE_number_of_passenger_seas_adj)

VIE_number_of_passenger_seas_adj_diff <- diff(VIE_number_of_passenger_seas_adj)

adf.test(VIE_number_of_bookings_seas_adj)

VIE_number_of_bookings_seas_adj_diff <- diff(VIE_number_of_bookings_seas_adj)

adf.test(VIE_sport_seas_adj)
adf.test(diff(VIE_sport_seas_adj))

VIE_sport_seas_adj_diff <- diff(VIE_sport_seas_adj)

adf.test(VIE_council_housing_seas_adj)
adf.test(diff(VIE_council_housing_seas_adj))

VIE_council_housing_seas_adj_diff <- diff(VIE_council_housing_seas_adj)

adf.test(VIE_institutions_organizations_seas_adj)
adf.test(diff(VIE_institutions_organizations_seas_adj))

VIE_institutions_organizations_seas_adj_diff <- diff(VIE_institutions_organizations_seas_adj)

adf.test(VIE_history_seas_adj)
adf.test(diff(VIE_history_seas_adj))
adf.test(diff(diff(VIE_history_seas_adj)))

VIE_history_seas_adj_diff <- diff(VIE_history_seas_adj, differences = 2)

adf.test(VIE_township_seas_adj)
adf.test(diff(VIE_township_seas_adj))
adf.test(diff(diff(VIE_township_seas_adj)))

VIE_township_seas_adj_diff <- diff(VIE_township_seas_adj, differences = 2)

adf.test(VIE_places_of_worship_seas_adj)
adf.test(diff(VIE_places_of_worship_seas_adj))
adf.test(diff(diff(VIE_places_of_worship_seas_adj)))

VIE_places_of_worship_seas_adj_diff <- diff(VIE_places_of_worship_seas_adj, differences = 2)

adf.test(VIE_companies_seas_adj)
adf.test(diff(VIE_companies_seas_adj))

VIE_companies_seas_adj_diff <- diff(VIE_companies_seas_adj)

adf.test(VIE_bus_stops_and_stations_seas_adj)
adf.test(diff(VIE_bus_stops_and_stations_seas_adj))

VIE_bus_stops_and_stations_seas_adj_diff <- diff(VIE_bus_stops_and_stations_seas_adj)

adf.test(VIE_mountains_seas_adj)

VIE_mountains_seas_adj_diff <- diff(VIE_mountains_seas_adj)

adf.test(VIE_transmitters_seas_adj)
adf.test(diff(VIE_transmitters_seas_adj))

VIE_transmitters_seas_adj_diff <- diff(VIE_transmitters_seas_adj)

adf.test(VIE_embassies_seas_adj)
adf.test(diff(VIE_embassies_seas_adj))

VIE_embassies_seas_adj_diff <- diff(VIE_embassies_seas_adj)

adf.test(VIE_streets_and_squares_seas_adj)
adf.test(diff(VIE_streets_and_squares_seas_adj))

VIE_streets_and_squares_seas_adj_diff <- diff(VIE_streets_and_squares_seas_adj)

adf.test(VIE_rivers_and_parks_seas_adj)
adf.test(diff(VIE_rivers_and_parks_seas_adj))

VIE_rivers_and_parks_seas_adj_diff <- diff(VIE_rivers_and_parks_seas_adj)

adf.test(VIE_museums_seas_adj)

VIE_museums_seas_adj_diff <- diff(VIE_museums_seas_adj)

adf.test(VIE_towers_seas_adj)
adf.test(diff(VIE_towers_seas_adj))

VIE_towers_seas_adj_diff <- diff(VIE_towers_seas_adj)

adf.test(VIE_buildings_seas_adj)
adf.test(diff(VIE_buildings_seas_adj))
adf.test(diff(diff(VIE_buildings_seas_adj)))

VIE_buildings_seas_adj_diff <- diff(VIE_buildings_seas_adj, differences = 2)

adf.test(VIE_hospitals_seas_adj)
adf.test(diff(VIE_hospitals_seas_adj))

VIE_hospitals_seas_adj_diff <- diff(VIE_hospitals_seas_adj)

adf.test(VIE_libraries_seas_adj)
adf.test(diff(VIE_libraries_seas_adj))

VIE_libraries_seas_adj_diff <- diff(VIE_libraries_seas_adj)

adf.test(VIE_statues_and_fountains_seas_adj)
adf.test(diff(VIE_statues_and_fountains_seas_adj))

VIE_statues_and_fountains_seas_adj_diff <- diff(VIE_statues_and_fountains_seas_adj)

adf.test(VIE_high_education_seas_adj)
adf.test(diff(VIE_high_education_seas_adj))
adf.test(diff(diff(VIE_high_education_seas_adj)))

VIE_high_education_seas_adj_diff <- diff(VIE_high_education_seas_adj, differences = 2)

adf.test(VIE_bridges_seas_adj)

VIE_bridges_seas_adj_diff <- diff(VIE_bridges_seas_adj)

adf.test(VIE_theatres_seas_adj)
adf.test(diff(VIE_theatres_seas_adj))

VIE_theatres_seas_adj_diff <- diff(VIE_theatres_seas_adj)

adf.test(VIE_cemeteries_seas_adj)
adf.test(diff(VIE_cemeteries_seas_adj))

VIE_cemeteries_seas_adj_diff <- diff(VIE_cemeteries_seas_adj)

adf.test(VIE_schloss_schonbrunn_seas_adj)
adf.test(diff(VIE_schloss_schonbrunn_seas_adj))

VIE_schloss_schonbrunn_seas_adj_diff <- diff(VIE_schloss_schonbrunn_seas_adj)

adf.test(VIE_universitat_wien_seas_adj)
adf.test(diff(VIE_universitat_wien_seas_adj))

VIE_universitat_wien_seas_adj_diff <- diff(VIE_universitat_wien_seas_adj)

adf.test(VIE_osterreich_ungarn_seas_adj)
adf.test(diff(VIE_osterreich_ungarn_seas_adj))
adf.test(diff(diff(VIE_osterreich_ungarn_seas_adj)))

VIE_osterreich_ungarn_seas_adj_diff <- diff(VIE_osterreich_ungarn_seas_adj, differences = 2)

adf.test(VIE_wiener_ringstrasse_seas_adj)
adf.test(diff(VIE_wiener_ringstrasse_seas_adj))

VIE_wiener_ringstrasse_seas_adj_diff <- diff(VIE_wiener_ringstrasse_seas_adj)

adf.test(VIE_der_kuss_seas_adj)
adf.test(diff(VIE_der_kuss_seas_adj))

VIE_der_kuss_seas_adj_diff <- diff(VIE_der_kuss_seas_adj)

adf.test(VIE_organisation_erdolexportierender_lander_seas_adj)
adf.test(diff(VIE_organisation_erdolexportierender_lander_seas_adj))

VIE_organisation_erdolexportierender_lander_seas_adj_diff <- diff(VIE_organisation_erdolexportierender_lander_seas_adj)

adf.test(VIE_donauinsel_seas_adj)
adf.test(diff(VIE_donauinsel_seas_adj))

VIE_donauinsel_seas_adj_diff <- diff(VIE_donauinsel_seas_adj)

adf.test(VIE_nationalbibliothek_seas_adj)
adf.test(diff(VIE_nationalbibliothek_seas_adj))

VIE_nationalbibliothek_seas_adj_diff <- diff(VIE_nationalbibliothek_seas_adj)

adf.test(VIE_botschaft_usa_seas_adj)
adf.test(diff(VIE_botschaft_usa_seas_adj))

VIE_botschaft_usa_seas_adj_diff <- diff(VIE_botschaft_usa_seas_adj)

# try auto.arima

auto.arima(VIE_number_of_passenger_seas_adj_diff)
auto.arima(VIE_number_of_bookings_seas_adj_diff)

# scale time series 

VIE_number_of_passenger_seas_adj_diff_scaled <- scale(VIE_number_of_passenger_seas_adj_diff[-1])
VIE_number_of_bookings_seas_adj_diff_scaled <- scale(VIE_number_of_bookings_seas_adj_diff[-1])

VIE_sport_seas_adj_diff_scaled <- scale(VIE_sport_seas_adj_diff[-1])
VIE_council_housing_seas_adj_diff_scaled <- scale(VIE_council_housing_seas_adj_diff[-1])
VIE_institutions_organizations_seas_adj_diff_scaled <- scale(VIE_institutions_organizations_seas_adj_diff[-1])
VIE_history_seas_adj_diff_scaled <- scale(VIE_history_seas_adj_diff)
VIE_township_seas_adj_diff_scaled <- scale(VIE_township_seas_adj_diff)
VIE_places_of_worship_seas_adj_diff_scaled <- scale(VIE_places_of_worship_seas_adj_diff)
VIE_companies_seas_adj_diff_scaled <- scale(VIE_companies_seas_adj_diff[-1])
VIE_bus_stops_and_stations_seas_adj_diff_scaled <- scale(VIE_bus_stops_and_stations_seas_adj_diff[-1])
VIE_mountains_seas_adj_diff_scaled <- scale(VIE_mountains_seas_adj_diff[-1])
VIE_transmitters_seas_adj_diff_scaled <- scale(VIE_transmitters_seas_adj_diff[-1])
VIE_embassies_seas_adj_diff_scaled <- scale(VIE_embassies_seas_adj_diff[-1])
VIE_streets_and_squares_seas_adj_diff_scaled <- scale(VIE_streets_and_squares_seas_adj_diff[-1])
VIE_rivers_and_parks_seas_adj_diff_scaled <- scale(VIE_rivers_and_parks_seas_adj_diff[-1])
VIE_museums_seas_adj_diff_scaled <- scale(VIE_museums_seas_adj_diff[-1])
VIE_towers_seas_adj_diff_scaled <- scale(VIE_towers_seas_adj_diff[-1])
VIE_buildings_seas_adj_diff_scaled <- scale(VIE_buildings_seas_adj_diff)
VIE_hospitals_seas_adj_diff_scaled <- scale(VIE_hospitals_seas_adj_diff[-1])
VIE_libraries_seas_adj_diff_scaled <- scale(VIE_libraries_seas_adj_diff[-1])
VIE_statues_and_fountains_seas_adj_diff_scaled <- scale(VIE_statues_and_fountains_seas_adj_diff[-1]) 
VIE_high_education_seas_adj_diff_scaled <- scale(VIE_high_education_seas_adj_diff)
VIE_bridges_seas_adj_diff_scaled <- scale(VIE_bridges_seas_adj_diff[-1]) 
VIE_theatres_seas_adj_diff_scaled <- scale(VIE_theatres_seas_adj_diff[-1])
VIE_cemeteries_seas_adj_diff_scaled <- scale(VIE_cemeteries_seas_adj_diff[-1])
VIE_schloss_schonbrunn_seas_adj_diff_scaled <- scale(VIE_schloss_schonbrunn_seas_adj_diff[-1])
VIE_universitat_wien_seas_adj_diff_scaled <- scale(VIE_universitat_wien_seas_adj_diff[-1])
VIE_osterreich_ungarn_seas_adj_diff_scaled <- scale(VIE_osterreich_ungarn_seas_adj_diff)
VIE_wiener_ringstrasse_seas_adj_diff_scaled <- scale(VIE_wiener_ringstrasse_seas_adj_diff[-1])
VIE_der_kuss_seas_adj_diff_scaled <- scale(VIE_der_kuss_seas_adj_diff[-1])
VIE_organisation_erdolexportierender_lander_seas_adj_diff_scaled <- scale(VIE_organisation_erdolexportierender_lander_seas_adj_diff[-1])
VIE_donauinsel_seas_adj_diff_scaled <- scale(VIE_donauinsel_seas_adj_diff[-1])
VIE_nationalbibliothek_seas_adj_diff_scaled <- scale(VIE_nationalbibliothek_seas_adj_diff[-1])
VIE_botschaft_usa_seas_adj_diff_scaled <- scale(VIE_botschaft_usa_seas_adj_diff[-1])

VIE_xreg <- data.frame(sport = VIE_sport_seas_adj_diff_scaled, 
                       council_housing = VIE_council_housing_seas_adj_diff_scaled, 
                       institutions_organizations = VIE_institutions_organizations_seas_adj_diff_scaled,
                       history = VIE_history_seas_adj_diff_scaled, 
                       township = VIE_township_seas_adj_diff_scaled, 
                       places_of_worship = VIE_places_of_worship_seas_adj_diff_scaled, 
                       companies = VIE_companies_seas_adj_diff_scaled, 
                       bus_stops_and_stations = VIE_bus_stops_and_stations_seas_adj_diff_scaled, 
                       mountains = VIE_mountains_seas_adj_diff_scaled, 
                       transmitters = VIE_transmitters_seas_adj_diff_scaled, 
                       embassies = VIE_embassies_seas_adj_diff_scaled, 
                       streets_and_squares = VIE_streets_and_squares_seas_adj_diff_scaled, 
                       rivers_and_parks = VIE_rivers_and_parks_seas_adj_diff_scaled, 
                       museums = VIE_museums_seas_adj_diff_scaled,
                       towers = VIE_towers_seas_adj_diff_scaled, 
                       buildings = VIE_buildings_seas_adj_diff_scaled, 
                       hospitals = VIE_hospitals_seas_adj_diff_scaled, 
                       libraries = VIE_libraries_seas_adj_diff_scaled, 
                       statues_and_fountains = VIE_statues_and_fountains_seas_adj_diff_scaled, 
                       high_education = VIE_high_education_seas_adj_diff_scaled,
                       bridges = VIE_bridges_seas_adj_diff_scaled, 
                       theatres = VIE_theatres_seas_adj_diff_scaled, 
                       cemeteries = VIE_cemeteries_seas_adj_diff_scaled, 
                       schloss_schonbrunn = VIE_schloss_schonbrunn_seas_adj_diff_scaled,
                       universitat_wien = VIE_universitat_wien_seas_adj_diff_scaled, 
                       osterreich_ungarn = VIE_osterreich_ungarn_seas_adj_diff_scaled,
                       wiener_ringstrass = VIE_wiener_ringstrasse_seas_adj_diff_scaled,
                       der_kuss = VIE_der_kuss_seas_adj_diff_scaled,
                       organisation_erdolexportierender_lander = VIE_organisation_erdolexportierender_lander_seas_adj_diff_scaled,
                       donauinsel = VIE_donauinsel_seas_adj_diff_scaled,
                       nationalbibliothek = VIE_nationalbibliothek_seas_adj_diff_scaled,
                       botschaft_usa = VIE_botschaft_usa_seas_adj_diff_scaled)

# plot time series

plot.ts(VIE_number_of_passenger_seas_adj_diff_scaled, main = "Number of passengers")
plot.ts(VIE_number_of_bookings_seas_adj_diff_scaled, main = "Number of bookings")
plot.ts(VIE_xreg[,1:10])
plot.ts(VIE_xreg[,11:20])
plot.ts(VIE_xreg[,21:30])
plot.ts(VIE_xreg[,31:32])

# try again with auto.arima and regressors

auto.arima(VIE_number_of_passenger_seas_adj_diff_scaled, xreg = VIE_xreg)
auto.arima(VIE_number_of_bookings_seas_adj_diff_scaled, xreg = VIE_xreg)

# check acf and pacf

acf(VIE_number_of_passenger_seas_adj_diff_scaled)
pacf(VIE_number_of_passenger_seas_adj_diff_scaled)

VIE_fit_passengers <- Arima(VIE_number_of_passenger_seas_adj_diff_scaled, order = c(0,0,0), xreg = VIE_xreg, include.mean = F)
VIE_fit_passengers

VIE_res_fit_passengers <- acf(VIE_fit_passengers$residuals, lag.max = 20)
Box.test(VIE_fit_passengers$residuals, lag = 20, type = "Ljung-Box")

acf(VIE_fit_passengers$residuals)
plotForecastErrors(VIE_fit_passengers$residuals)

acf(VIE_number_of_bookings_seas_adj_diff_scaled)
pacf(VIE_number_of_bookings_seas_adj_diff_scaled)

VIE_fit_bookings <- Arima(VIE_number_of_bookings_seas_adj_diff_scaled, order = c(0,0,0), xreg = VIE_xreg, include.mean = F)
VIE_fit_bookings

VIE_res_fit_bookings <- acf(VIE_fit_bookings$residuals, lag.max = 20)
Box.test(VIE_fit_bookings$residuals, lag = 20, type = "Ljung-Box")

acf(VIE_fit_bookings$residuals)
plotForecastErrors(VIE_fit_bookings$residuals)

# check p-value of parameters in the models

library(lmtest)

coeftest(BAR_fit_passengers)
coeftest(BAR_fit_bookings)

coeftest(BRU_fit_passengers)
coeftest(BRU_fit_bookings)

coeftest(VIE_fit_passengers)
coeftest(VIE_fit_bookings)

# plot confidence intervals for coefficients

library(plotrix)

BAR_pass_coeff <- data.frame(coeff=BAR_fit_passengers$coef,confint(BAR_fit_passengers, level = 0.90))
colnames(BAR_pass_coeff) <- c("coeff", "lower", "upper")

BAR_pass_coeff_select <-rbind(BAR_pass_coeff[3,], BAR_pass_coeff[5,],BAR_pass_coeff[11,], BAR_pass_coeff[14,])

BAR_pass_coeff_select <- BAR_pass_coeff_select %>%
  mutate(parameter = rownames(BAR_pass_coeff_select)) %>%
  arrange(coeff)

par(xaxt="n")
BAR_pass_ci <- plotCI(1:4, 
                      BAR_pass_coeff_select$coeff, 
                      ui = BAR_pass_coeff_select$upper, 
                      li = BAR_pass_coeff_select$lower, 
                      xlab = "Parameters", 
                      ylab = "Confidence intervals")
par(xaxt="s")
axis(1, at = seq(1,4, by = 1))

BAR_pass_coeff_select$parameter

BAR_book_coeff <- data.frame(coeff=BAR_fit_bookings$coef,confint(BAR_fit_bookings, level = 0.90))
colnames(BAR_book_coeff) <- c("coeff", "lower", "upper")

BAR_book_coeff_select <-rbind(BAR_book_coeff[3,], BAR_book_coeff[14,]) 

BAR_book_coeff_select <- BAR_book_coeff_select %>%
  mutate(parameter = rownames(BAR_book_coeff_select)) %>%
  arrange(coeff)

par(xaxt="n")
plotCI(1:2, 
       BAR_book_coeff_select$coeff, 
       ui = BAR_book_coeff_select$upper, 
       li = BAR_book_coeff_select$lower, 
       xlab = "Parameters", 
       ylab = "Confidence intervals")
par(xaxt="s")
axis(1, at = seq(1,2, by = 1))

BAR_book_coeff_select$parameter

BRU_pass_coeff <- data.frame(coeff=BRU_fit_passengers$coef,confint(BRU_fit_passengers, level = 0.90))
colnames(BRU_pass_coeff) <- c("coeff", "lower", "upper")

BRU_pass_coeff_select <-rbind(BRU_pass_coeff[4:6,],BRU_pass_coeff[9,])

BRU_pass_coeff_select <- BRU_pass_coeff_select %>%
  mutate(parameter = rownames(BRU_pass_coeff_select)) %>%
  arrange(coeff)

par(xaxt="n")
BRU_pass_ci <- plotCI(1:4, 
                      BRU_pass_coeff_select$coeff, 
                      ui = BRU_pass_coeff_select$upper, 
                      li = BRU_pass_coeff_select$lower, 
                      xlab = "Parameters", 
                      ylab = "Confidence intervals")
par(xaxt="s")
axis(1, at = seq(1,4, by = 1))

BRU_pass_coeff_select$parameter

BRU_book_coeff <- data.frame(coeff=BRU_fit_bookings$coef,confint(BRU_fit_bookings, level = 0.90))
colnames(BRU_book_coeff) <- c("coeff", "lower", "upper")

BRU_book_coeff_select <-rbind(BRU_book_coeff[4,], BRU_book_coeff[6,]) 

BRU_book_coeff_select <- BRU_book_coeff_select %>%
  mutate(parameter = rownames(BRU_book_coeff_select)) %>%
  arrange(coeff)

par(xaxt="n")
plotCI(1:2, 
       BRU_book_coeff_select$coeff, 
       ui = BRU_book_coeff_select$upper, 
       li = BRU_book_coeff_select$lower, 
       xlab = "Parameters", 
       ylab = "Confidence intervals")
par(xaxt="s")
axis(1, at = seq(1,2, by = 1))

BRU_book_coeff_select$parameter

VIE_pass_coeff <- data.frame(coeff=VIE_fit_passengers$coef,confint(VIE_fit_passengers, level = 0.90))
colnames(VIE_pass_coeff) <- c("coeff", "lower", "upper")

VIE_pass_coeff_select <-rbind(VIE_pass_coeff[3:8,],VIE_pass_coeff[10:15,], VIE_pass_coeff[17:24,])

VIE_pass_coeff_select <- VIE_pass_coeff_select %>%
  mutate(parameter = rownames(VIE_pass_coeff_select)) %>%
  arrange(coeff)

par(xaxt="n")
VIE_pass_ci <- plotCI(1:20, 
                      VIE_pass_coeff_select$coeff, 
                      ui = VIE_pass_coeff_select$upper, 
                      li = VIE_pass_coeff_select$lower, 
                      xlab = "Parameters", 
                      ylab = "Confidence intervals")
par(xaxt="s")
axis(1, at = seq(1,20, by = 1))

VIE_pass_coeff_select$parameter

VIE_book_coeff <- data.frame(coeff=VIE_fit_bookings$coef,confint(VIE_fit_bookings, level = 0.90))
colnames(VIE_book_coeff) <- c("coeff", "lower", "upper")

VIE_book_coeff_select <-rbind(VIE_book_coeff[4:8,], VIE_book_coeff[10,], VIE_book_coeff[12,], VIE_book_coeff[14:15,], VIE_book_coeff[17:19,], VIE_book_coeff[21:24,]) 

VIE_book_coeff_select <- VIE_book_coeff_select %>%
  mutate(parameter = rownames(VIE_book_coeff_select)) %>%
  arrange(coeff)

par(xaxt="n")
plotCI(1:16, 
       VIE_book_coeff_select$coeff, 
       ui = VIE_book_coeff_select$upper, 
       li = VIE_book_coeff_select$lower, 
       xlab = "Parameters", 
       ylab = "Confidence intervals")
par(xaxt="s")
axis(1, at = seq(1, 16, by = 1))

VIE_book_coeff_select$parameter

plot.new()
plot(BAR_number_of_passenger_seas_adj_diff_scaled, BAR_sagrada_familia_seas_adj_diff_scaled )
abline(lm(BAR_number_of_passenger_seas_adj_diff_scaled~BAR_sagrada_familia_seas_adj_diff_scaled), col = "red")

##### CROSS VALIDATION OF MODEL (NOT YET DONE)

# check model accuracy

library(caret)

ts.folds <- createTimeSlices(y=BAR_number_of_passenger_seas_adj_diff_scaled, initialWindow = 12, horizon = 1, fixedWindow = F)
xreg.folds <- createTimeSlices(y=BAR_xreg$public_transport, initialWindow = 12, horizon = 1, fixedWindow = F)
xreg.folds1 <- createTimeSlices(y=BAR_xreg$sport, initialWindow = 12, horizon = 1, fixedWindow = F)

ts.pred_test <- function(i) {
  mod <- Arima(BAR_number_of_passenger_seas_adj_diff_scaled[ts.folds$train[[i]]],
               order = c(1,0,0),
               xreg = BAR_xreg[xreg.folds$train[[i]]], 
               include.mean = F)
  f <- forecast.Arima(mod)$pred[1]
  v <- BAR_number_of_passenger_seas_adj_diff_scaled[ts.folds$test[[i]]]
  r <- BAR_xreg[xreg.folds$test[[i]]]
  c(v,r,f)
}
ts.res <- t(sapply(seq(1, length(ts.folds$train)), FUN = function(x) ts.pred_test(x)))


# test of accuracy over a small sample of last year's observations

BAR_passengers_y1 <- BAR_number_of_passenger_seas_adj_diff2[1:34]
BAR_passengers_y2 <- BAR_number_of_passenger_seas_adj_diff2[35:46]

xreg_Barc_ARR_y1 <- xreg_Barc_ARR[1:34,]
xreg_Barc_ARR_y2 <- xreg_Barc_ARR[35:46,]

BAR_passengers_est <- Arima(BAR_passengers_y1, order = c(2,0,0), xreg = xreg_Barc_ARR_y1)
BAR_passengers_for <- forecast.Arima(BAR_passengers_est, xreg = xreg_Barc_ARR_y2)

accuracy(BAR_passengers_for, BAR_passengers_y2)

BAR_bookings_y1 <- BAR_number_of_bookings_seas_adj_diff2[1:34]
BAR_bookings_y2 <- BAR_number_of_bookings_seas_adj_diff2[35:46]

xreg_Barc_ARR_y1 <- xreg_Barc_ARR[1:34,]
xreg_Barc_ARR_y2 <- xreg_Barc_ARR[35:46,]

BAR_bookings_est <- Arima(BAR_bookings_y1, order = c(2,0,0), xreg = xreg_Barc_ARR_y1)
BAR_bookings_for <- forecast.Arima(BAR_bookings_est, xreg = xreg_Barc_ARR_y2)

accuracy(BAR_bookings_for, BAR_bookings_y2)

BRU_passengers_y1 <- BRU_number_of_passenger_seas_adj_diff2[1:34]
BRU_passengers_y2 <- BRU_number_of_passenger_seas_adj_diff2[35:46]

xreg_Bru_ARR_y1 <- xreg_Bru_ARR[1:34,]
xreg_Bru_ARR_y2 <- xreg_Bru_ARR[35:46,]

BRU_passengers_est <- Arima(BRU_passengers_y1, order = c(1,0,0), xreg = xreg_Bru_ARR_y1)
BRU_passengers_for <- forecast.Arima(BRU_passengers_est, xreg = xreg_Bru_ARR_y2)

accuracy(BRU_passengers_for, BRU_passengers_y2)

BRU_bookings_y1 <- BRU_number_of_bookings_seas_adj_diff2[1:34]
BRU_bookings_y2 <- BRU_number_of_bookings_seas_adj_diff2[35:46]

xreg_Bru_ARR_y1 <- xreg_Bru_ARR[1:34,]
xreg_Bru_ARR_y2 <- xreg_Bru_ARR[35:46,]

BRU_bookings_est <- Arima(BRU_bookings_y1, order = c(0,2,1), xreg = xreg_Bru_ARR_y1)
BRU_bookings_for <- forecast.Arima(BRU_bookings_est, xreg = xreg_Bru_ARR_y2)

accuracy(BRU_bookings_for, BRU_bookings_y2)

VIE_passengers_y1 <- VIE_number_of_passenger_seas_adj_diff2[1:34]
VIE_passengers_y2 <- VIE_number_of_passenger_seas_adj_diff2[35:46]

xreg_Vie_ARR_y1 <- xreg_Vie_ARR[1:34,]
xreg_Vie_ARR_y2 <- xreg_Vie_ARR[35:46,]

VIE_passengers_est <- Arima(VIE_passengers_y1, order = c(0,0,2), xreg = xreg_Vie_ARR_y1)
VIE_passengers_for <- forecast.Arima(VIE_passengers_est, xreg = xreg_Vie_ARR_y2)

accuracy(VIE_passengers_for, VIE_passengers_y2)

VIE_bookings_y1 <- VIE_number_of_bookings_seas_adj_diff2[1:34]
VIE_bookings_y2 <- VIE_number_of_bookings_seas_adj_diff2[35:46]

xreg_Vie_ARR_y1 <- xreg_Vie_ARR[1:34,]
xreg_Vie_ARR_y2 <- xreg_Vie_ARR[35:46,]

VIE_bookings_est <- Arima(VIE_bookings_y1, order = c(0,0,1), xreg = xreg_Vie_ARR_y1)
VIE_bookings_for <- forecast.Arima(VIE_bookings_est, xreg = xreg_Vie_ARR_y2)

accuracy(VIE_bookings_for, VIE_bookings_y2)

# test of accuracy over last month's observations

BAR_passengers_y1 <- BAR_number_of_passenger_seas_adj_diff2[1:45]
BAR_passengers_y2 <- BAR_number_of_passenger_seas_adj_diff2[46]

xreg_Barc_ARR_y1 <- xreg_Barc_ARR[1:45,]
xreg_Barc_ARR_y2 <- xreg_Barc_ARR[46,]

BAR_passengers_est <- Arima(BAR_passengers_y1, order = c(2,0,0), xreg = xreg_Barc_ARR_y1)
BAR_passengers_for <- forecast.Arima(BAR_passengers_est, xreg = xreg_Barc_ARR_y2)

accuracy(BAR_passengers_for, BAR_passengers_y2)

BAR_bookings_y1 <- BAR_number_of_bookings_seas_adj_diff2[1:45]
BAR_bookings_y2 <- BAR_number_of_bookings_seas_adj_diff2[46]

xreg_Barc_ARR_y1 <- xreg_Barc_ARR[1:45,]
xreg_Barc_ARR_y2 <- xreg_Barc_ARR[46,]

BAR_bookings_est <- Arima(BAR_bookings_y1, order = c(2,0,0), xreg = xreg_Barc_ARR_y1)
BAR_bookings_for <- forecast.Arima(BAR_bookings_est, xreg = xreg_Barc_ARR_y2)

accuracy(BAR_bookings_for, BAR_bookings_y2)

BRU_passengers_y1 <- BRU_number_of_passenger_seas_adj_diff2[1:45]
BRU_passengers_y2 <- BRU_number_of_passenger_seas_adj_diff2[46]

xreg_Bru_ARR_y1 <- xreg_Bru_ARR[1:45,]
xreg_Bru_ARR_y2 <- xreg_Bru_ARR[46,]

BRU_passengers_est <- Arima(BRU_passengers_y1, order = c(1,0,0), xreg = xreg_Bru_ARR_y1)
BRU_passengers_for <- forecast.Arima(BRU_passengers_est, xreg = xreg_Bru_ARR_y2)

accuracy(BRU_passengers_for, BRU_passengers_y2)

BRU_bookings_y1 <- BRU_number_of_bookings_seas_adj_diff2[1:45]
BRU_bookings_y2 <- BRU_number_of_bookings_seas_adj_diff2[46]

xreg_Bru_ARR_y1 <- xreg_Bru_ARR[1:45,]
xreg_Bru_ARR_y2 <- xreg_Bru_ARR[46,]

BRU_bookings_est <- Arima(BRU_bookings_y1, order = c(0,2,1), xreg = xreg_Bru_ARR_y1)
BRU_bookings_for <- forecast.Arima(BRU_bookings_est, xreg = xreg_Bru_ARR_y2)

accuracy(BRU_bookings_for, BRU_bookings_y2)

VIE_passengers_y1 <- VIE_number_of_passenger_seas_adj_diff2[1:45]
VIE_passengers_y2 <- VIE_number_of_passenger_seas_adj_diff2[46]

xreg_Vie_ARR_y1 <- xreg_Vie_ARR[1:45,]
xreg_Vie_ARR_y2 <- xreg_Vie_ARR[46,]

VIE_passengers_est <- Arima(VIE_passengers_y1, order = c(0,0,2), xreg = xreg_Vie_ARR_y1)
VIE_passengers_for <- forecast.Arima(VIE_passengers_est, xreg = xreg_Vie_ARR_y2)

accuracy(VIE_passengers_for, VIE_passengers_y2)

VIE_bookings_y1 <- VIE_number_of_bookings_seas_adj_diff2[1:45]
VIE_bookings_y2 <- VIE_number_of_bookings_seas_adj_diff2[46]

xreg_Vie_ARR_y1 <- xreg_Vie_ARR[1:45,]
xreg_Vie_ARR_y2 <- xreg_Vie_ARR[46,]

VIE_bookings_est <- Arima(VIE_bookings_y1, order = c(0,0,1), xreg = xreg_Vie_ARR_y1)
VIE_bookings_for <- forecast.Arima(VIE_bookings_est, xreg = xreg_Vie_ARR_y2)

accuracy(VIE_bookings_for, VIE_bookings_y2)

# remove last month in data and regressors and check the model

BAR_passenger_train <- head(BAR_number_of_passenger_seas_adj_diff2, -1)
BAR_bookings_train <- head(BAR_number_of_bookings_seas_adj_diff2, -1)
BAR_regressors_train <- head(xreg_Barc_ARR, -1)

BAR_ARR_test <- Arima(BAR_passenger_train, order = c(2,0,0), xreg = BAR_regressors_train)
BAR_OVER_test <- Arima(BAR_bookings_train, order = c(2,0,0), xreg = BAR_regressors_train)

# predict last observation

BAR_regressors_predict <- xreg_Barc_ARR[46,]

our_forecast <- forecast.Arima(BAR_ARR_test, xreg = BAR_regressors_predict)
our_forecast

mae <- abs(our_forecast$mean - BAR_number_of_passenger_seas_adj_diff2[46])

# remove last two months

BAR_passenger_train <- head(BAR_number_of_passenger_seas_adj_diff2, -2)
BAR_bookings_train <- head(BAR_number_of_bookings_seas_adj_diff2, -2)
BAR_regressors_train <- head(xreg_Barc_ARR, -2)

BAR_ARR_test <- Arima(BAR_passenger_train, order = c(2,0,0), xreg = BAR_regressors_train)
BAR_OVER_test <- Arima(BAR_bookings_train, order = c(2,0,0), xreg = BAR_regressors_train)

# predict last two observations

BAR_regressors_predict <- xreg_Barc_ARR[45:46,]

our_forecast <- forecast.Arima(BAR_ARR_test, xreg = BAR_regressors_predict)
our_forecast

new <- abs(our_forecast$mean - BAR_number_of_passenger_seas_adj_diff2[45:46])
mae <- cbind(mae,new)

# remove last three months

BAR_passenger_train <- head(BAR_number_of_passenger_seas_adj_diff2, -3)
BAR_bookings_train <- head(BAR_number_of_bookings_seas_adj_diff2, -3)
BAR_regressors_train <- head(xreg_Barc_ARR, -3)

BAR_ARR_test <- Arima(BAR_passenger_train, order = c(2,0,0), xreg = BAR_regressors_train)
BAR_OVER_test <- Arima(BAR_bookings_train, order = c(2,0,0), xreg = BAR_regressors_train)

# predict last three observations

BAR_regressors_predict <- xreg_Barc_ARR[44:46,]

our_forecast <- forecast.Arima(BAR_ARR_test, xreg = BAR_regressors_predict)
our_forecast

new <- abs(our_forecast$mean - BAR_number_of_passenger_seas_adj_diff2[44:46])
mae <- cbind(mae,new)

# remove last 4 months

BAR_passenger_train <- head(BAR_number_of_passenger_seas_adj_diff2, -4)
BAR_bookings_train <- head(BAR_number_of_bookings_seas_adj_diff2, -4)
BAR_regressors_train <- head(xreg_Barc_ARR, -4)

BAR_ARR_test <- Arima(BAR_passenger_train, order = c(2,0,0), xreg = BAR_regressors_train)
BAR_OVER_test <- Arima(BAR_bookings_train, order = c(2,0,0), xreg = BAR_regressors_train)

# predict last 4 observations

BAR_regressors_predict <- xreg_Barc_ARR[43:46,]

our_forecast <- forecast.Arima(BAR_ARR_test, xreg = BAR_regressors_predict)
our_forecast

new <- abs(our_forecast$mean - BAR_number_of_passenger_seas_adj_diff2[43:46])
mae <- cbind(mae,new)

# remove last 5 months

BAR_passenger_train <- head(BAR_number_of_passenger_seas_adj_diff2, -5)
BAR_bookings_train <- head(BAR_number_of_bookings_seas_adj_diff2, -5)
BAR_regressors_train <- head(xreg_Barc_ARR, -5)

BAR_ARR_test <- Arima(BAR_passenger_train, order = c(2,0,0), xreg = BAR_regressors_train)
BAR_OVER_test <- Arima(BAR_bookings_train, order = c(2,0,0), xreg = BAR_regressors_train)

# predict last 5 observations

BAR_regressors_predict <- xreg_Barc_ARR[42:46,]

our_forecast <- forecast.Arima(BAR_ARR_test, xreg = BAR_regressors_predict)
our_forecast

new <- abs(our_forecast$mean - BAR_number_of_passenger_seas_adj_diff2[42:46])
mae <- cbind(mae,new)

# remove last 6 months

BAR_passenger_train <- head(BAR_number_of_passenger_seas_adj_diff2, -6)
BAR_bookings_train <- head(BAR_number_of_bookings_seas_adj_diff2, -6)
BAR_regressors_train <- head(xreg_Barc_ARR, -6)

BAR_ARR_test <- Arima(BAR_passenger_train, order = c(2,0,0), xreg = BAR_regressors_train)
BAR_OVER_test <- Arima(BAR_bookings_train, order = c(2,0,0), xreg = BAR_regressors_train)

# predict last 6 observations

BAR_regressors_predict <- xreg_Barc_ARR[41:46,]

our_forecast <- forecast.Arima(BAR_ARR_test, xreg = BAR_regressors_predict)
our_forecast

new <- abs(our_forecast$mean - BAR_number_of_passenger_seas_adj_diff2[41:46])
mae <- cbind(mae,new)

# remove last 7 months

BAR_passenger_train <- head(BAR_number_of_passenger_seas_adj_diff2, -7)
BAR_bookings_train <- head(BAR_number_of_bookings_seas_adj_diff2, -7)
BAR_regressors_train <- head(xreg_Barc_ARR, -7)

BAR_ARR_test <- Arima(BAR_passenger_train, order = c(2,0,0), xreg = BAR_regressors_train)
BAR_OVER_test <- Arima(BAR_bookings_train, order = c(2,0,0), xreg = BAR_regressors_train)

# predict last 7 observations

BAR_regressors_predict <- xreg_Barc_ARR[40:46,]

our_forecast <- forecast.Arima(BAR_ARR_test, xreg = BAR_regressors_predict)
our_forecast

new <- abs(our_forecast$mean - BAR_number_of_passenger_seas_adj_diff2[40:46])
mae <- cbind(mae,new)

# remove last 8 months

BAR_passenger_train <- head(BAR_number_of_passenger_seas_adj_diff2, -8)
BAR_bookings_train <- head(BAR_number_of_bookings_seas_adj_diff2, -8)
BAR_regressors_train <- head(xreg_Barc_ARR, -8)

BAR_ARR_test <- Arima(BAR_passenger_train, order = c(2,0,0), xreg = BAR_regressors_train)
BAR_OVER_test <- Arima(BAR_bookings_train, order = c(2,0,0), xreg = BAR_regressors_train)

# predict last 8 observations

BAR_regressors_predict <- xreg_Barc_ARR[39:46,]

our_forecast <- forecast.Arima(BAR_ARR_test, xreg = BAR_regressors_predict)
our_forecast

new <- abs(our_forecast$mean - BAR_number_of_passenger_seas_adj_diff2[39:46])
mae <- cbind(mae,new)

# remove last 9 months

BAR_passenger_train <- head(BAR_number_of_passenger_seas_adj_diff2, -9)
BAR_bookings_train <- head(BAR_number_of_bookings_seas_adj_diff2, -9)
BAR_regressors_train <- head(xreg_Barc_ARR, -9)

BAR_ARR_test <- Arima(BAR_passenger_train, order = c(2,0,0), xreg = BAR_regressors_train)
BAR_OVER_test <- Arima(BAR_bookings_train, order = c(2,0,0), xreg = BAR_regressors_train)

# predict last 9 observations

BAR_regressors_predict <- xreg_Barc_ARR[38:46,]

our_forecast <- forecast.Arima(BAR_ARR_test, xreg = BAR_regressors_predict)
our_forecast

new <- abs(our_forecast$mean - BAR_number_of_passenger_seas_adj_diff2[38:46])
mae <- cbind(mae,new)

# remove last 10 months

BAR_passenger_train <- head(BAR_number_of_passenger_seas_adj_diff2, -10)
BAR_bookings_train <- head(BAR_number_of_bookings_seas_adj_diff2, -10)
BAR_regressors_train <- head(xreg_Barc_ARR, -10)

BAR_ARR_test <- Arima(BAR_passenger_train, order = c(2,0,0), xreg = BAR_regressors_train)
BAR_OVER_test <- Arima(BAR_bookings_train, order = c(2,0,0), xreg = BAR_regressors_train)

# predict last 10 observations

BAR_regressors_predict <- xreg_Barc_ARR[37:46,]

our_forecast <- forecast.Arima(BAR_ARR_test, xreg = BAR_regressors_predict)
our_forecast

new <- abs(our_forecast$mean - BAR_number_of_passenger_seas_adj_diff2[37:46])
mae <- cbind(mae,new)

# compute mean error

mean(mae, na.rm = T)

##### analyse single significant categories 

Barcelona_pageviews_item <- Barcelona_final %>%
  distinct(item, .keep_all = T) %>%
  left_join(Barcelona_pageviews_C, by = "item") 

Barcelona_sport <- Barcelona_pageviews_item%>%
  filter(id == 2)
Barcelona_sport$percentage <- scales::percent(Barcelona_sport$value/sum(Barcelona_sport$value))

Barcelona_theatres <- Barcelona_pageviews_item%>%
  filter(id == 6) %>%
  filter(!is.na(value))
Barcelona_theatres$percentage <- scales::percent(Barcelona_theatres$value/sum(Barcelona_theatres$value))

Barcelona_sagrada_familia <- Barcelona_pageviews_item%>%
  filter(id == 11) %>%
  filter(!is.na(value))
Barcelona_sagrada_familia$percentage <- scales::percent(Barcelona_sagrada_familia$value/sum(Barcelona_sagrada_familia$value))

Barcelona_for_model <- Barcelona_final %>%
  mutate(id = as.numeric(as.character(id)))
Barcelona_for_model$id[Barcelona_for_model$item == "Q7156"] <- '7156'
Barcelona_for_model$id[Barcelona_for_model$item == "Q1130050"] <- '1130050'

Barcelona_for_model_2 <- Barcelona_for_model %>%
  distinct(item, .keep_all = T)

Barcelona_for_model_ts <- Barcelona_reads_in_C %>%
  left_join(Barcelona_for_model_2, by = 'item') %>%
  select(-lat, -long)%>%
  filter(!is.na(id))%>%
  group_by(time, id)%>%
  summarise(value = sum(value))

Barcelona_for_model_ts <- dcast(Barcelona_for_model_ts, time ~ id) %>%
  mutate(time = as.Date(ts(1:48, frequency = 12, start = c(2012, 01))))

library(stringr)

Barcelona_OVER_model <- merge(Barcelona_for_model_ts, Barcelona_overnight_stays_t)
colnames(Barcelona_OVER_model) <- str_trim(colnames(Barcelona_OVER_model))
colnames(Barcelona_OVER_model) <- c("time", "public_transport", "museums", "sagrada_familia", "gran_teatro_del_liceo", "history", "institutions_organizations",
                              "monuments_and_fountains", "culture_and_art", "parks", "places_of_worship", "sport",
                              "high_education", "theatres", "buildings", "futbol_club_Barcelona", "streets_and_districts", 
                              "other_unclassified", "number_of_passengers", "residents_in_spain", "residents_abroad",
                              "germany", "austria", "belgium", "denmark", "finland", "france", "greece", "ireland",
                              "italy", "luxembourg", "netherlands", "poland", "portugal", "united_kingdom", 
                              "czech_republic", "sweden", "rest_of_eu", "norway", "russia", "switzerland", 
                              "rest_of_europe", "japan", "usa", "rest_of_america", "african_countries", "rest_of_world")

Barcelona_ARR_model <- merge(Barcelona_for_model_ts, Barcelona_arrivals_t)
colnames(Barcelona_ARR_model) <- str_trim(colnames(Barcelona_ARR_model))
colnames(Barcelona_ARR_model) <- c("time", "public_transport", "museums", "sagrada_familia", "gran_teatro_del_liceo", "history", "institutions_organizations",
                                   "monuments_and_fountains", "culture_and_art", "parks", "places_of_worship", "sport",
                                   "high_education", "theatres", "buildings", "futbol_club_Barcelona", "streets_and_districts", 
                                   "other_unclassified", "number_of_bookings", "residents_in_spain", "residents_abroad",
                                   "germany", "austria", "belgium", "denmark", "finland", "france", "greece", "ireland",
                                   "italy", "luxembourg", "netherlands", "poland", "portugal", "united_kingdom", 
                                   "czech_republic", "sweden", "rest_of_eu", "norway", "russia", "switzerland", 
                                   "rest_of_europe", "japan", "usa", "rest_of_america", "african_countries", "rest_of_world")

write.csv(Barcelona_OVER_model, "Barcelona_OVER_model.csv")
write.csv(Barcelona_ARR_model, "Barcelona_ARR_model.csv")

Barcelona_pageviews_article_model_ts3 <- Barcelona_pageviews_article_model_ts2 %>%
  select(time, sagrada_other, sagrada_es)

# Bruges

Bruges_pageviews_item <- Bruges_final %>%
  distinct(item, .keep_all = T) %>%
  left_join(Bruges_pageviews_C, by = "item") 

Bruges_streets_and_streams <- Bruges_pageviews_item %>%
  filter(id == 2)
Bruges_streets_and_streams$percentage <- scales::percent(Bruges_streets_and_streams$value/sum(Bruges_streets_and_streams$value))

Bruges_sport <- Bruges_pageviews_item %>%
  filter(id == 9)
Bruges_sport$percentage <- scales::percent(Bruges_sport$value/sum(Bruges_sport$value))

Bruges_districts <- Bruges_pageviews_item %>%
  filter(id == 10) %>%
  filter(!is.na(value))
Bruges_districts$percentage <- scales::percent(Bruges_districts$value/sum(Bruges_districts$value))

Bruges_places_of_worship <- Bruges_pageviews_item %>%
  filter(id == 11) %>%
  filter(!is.na(value))
Bruges_places_of_worship$percentage <- scales::percent(Bruges_places_of_worship$value/sum(Bruges_places_of_worship$value))

Bruges_for_model <- Bruges_final %>%
  mutate(id = as.numeric(as.character(id)))
Bruges_for_model$id[Bruges_for_model$item == "Q2441211"] <- '2441211'
Bruges_for_model$id[Bruges_for_model$item == "Q364698"] <- '364698'
Bruges_for_model$id[Bruges_for_model$item == "Q184383"] <- '184383'

Bruges_for_model$id[Bruges_for_model$item == "Q2676933"] <- '2676933'
Bruges_for_model$id[Bruges_for_model$item == "Q567833"] <- '567833'
Bruges_for_model$id[Bruges_for_model$item == "Q1108938"] <- '1108938'

Bruges_for_model_2 <- Bruges_for_model %>%
  distinct(item, .keep_all = T)

Bruges_for_model_ts <- Bruges_reads_in_C %>%
  left_join(Bruges_for_model_2, by = 'item') %>%
  select(-lat, -long)%>%
  filter(!is.na(id))%>%
  group_by(time, id)%>%
  summarise(value = sum(value))

Bruges_for_model_ts <- dcast(Bruges_for_model_ts, time ~ id) %>%
  mutate(time = as.Date(ts(1:48, frequency = 12, start = c(2012, 01))))

library(stringr)

Bruges_OVER_model <- merge(Bruges_for_model_ts, Bruges_overnight_stays_t)
colnames(Bruges_OVER_model) <- str_trim(colnames(Bruges_OVER_model))
colnames(Bruges_OVER_model) <- c("time", "public_transport", "districts", "places_of_worship", "grote_markt", "companies", "museums",
                           "zeebrugge", "streets_and_streams", "belfort_van_brugge", "sint_andries", "libraries", "cercle_brugge", "buildings", "high_education", "madonna_met_kind", "bridges_and_canals", 
                           "sport", "other_unclassified", "belgium", "netherlands", "germany",
                           "france", "united_kingdom", "luxembourg", "ireland", "denmark", "sweden", "finland", "italy",
                           "spain", "portugal", "greece", "austria", "poland", "czech_republic", 
                           "hungary", "romania", "norway", "switzerland", "russia", 
                           "usa", "canada", "japan", "china", "india", "israel", "turkey", 
                           "australia", "brazil", "other", "abroad", "number_of_bookings")

Bruges_ARR_model <- merge(Bruges_for_model_ts, Bruges_arrivals_t)
colnames(Bruges_ARR_model) <- str_trim(colnames(Bruges_ARR_model))
colnames(Bruges_ARR_model) <- c("time", "public_transport", "districts", "places_of_worship", "grote_markt", "companies", "museums",
                                "zeebrugge", "streets_and_streams", "belfort_van_brugge", "sint_andries", "libraries", "cercle_brugge", "buildings", "high_education", "madonna_met_kind", "bridges_and_canals", 
                                "sport", "other_unclassified", "belgium", "netherlands", "germany",
                                "france", "united_kingdom", "luxembourg", "ireland", "denmark", "sweden", "finland", "italy",
                                "spain", "portugal", "greece", "austria", "poland", "czech_republic", 
                                "hungary", "romania", "norway", "switzerland", "russia", 
                                "usa", "canada", "japan", "china", "india", "israel", "turkey", 
                                "australia", "brazil", "other", "abroad", "number_of_passengers")


write.csv(Bruges_ARR_model, 'Bruges_ARR_model2.csv')
write.csv(Bruges_OVER_model, 'Bruges_OVER_model2.csv')


# Vienna

Vienna_pageviews_item <- Vienna_final %>%
  distinct(item, .keep_all = T) %>%
  left_join(Vienna_pageviews_C, by = "item")

Vienna_council_housing <- Vienna_pageviews_item %>%
  filter(id == 2) %>%
  filter(!is.na(value))
Vienna_council_housing$percentage <- scales::percent(Vienna_council_housing$value/sum(Vienna_council_housing$value))

Vienna_institutions_organizations <- Vienna_pageviews_item %>%
  filter(id == 3) %>%
  filter(!is.na(value))
Vienna_institutions_organizations$percentage <- scales::percent(Vienna_institutions_organizations$value/sum(Vienna_institutions_organizations$value))

Vienna_history <- Vienna_pageviews_item %>%
  filter(id == 4) %>%
  filter(!is.na(value))
Vienna_history$percentage <- scales::percent(Vienna_history$value/sum(Vienna_history$value))

Vienna_transmitters <- Vienna_pageviews_item %>%
  filter(id == 17) %>%
  filter(!is.na(value))
Vienna_transmitters$percentage <- scales::percent(Vienna_transmitters$value/sum(Vienna_transmitters$value))

Vienna_embassies <- Vienna_pageviews_item %>%
  filter(id == 18) %>%
  filter(!is.na(value))
Vienna_embassies$percentage <- scales::percent(Vienna_embassies$value/sum(Vienna_embassies$value))

Vienna_streets_and_squares <- Vienna_pageviews_item %>%
  filter(id == 20) %>%
  filter(!is.na(value))
Vienna_streets_and_squares$percentage <- scales::percent(Vienna_streets_and_squares$value/sum(Vienna_streets_and_squares$value))

Vienna_museums <- Vienna_pageviews_item %>%
  filter(id == 27) %>%
  filter(!is.na(value))
Vienna_museums$percentage <- scales::percent(Vienna_museums$value/sum(Vienna_museums$value))

Vienna_buildings <- Vienna_pageviews_item %>%
  filter(id == 30) %>%
  filter(!is.na(value))
Vienna_buildings$percentage <- scales::percent(Vienna_buildings$value/sum(Vienna_buildings$value))

Vienna_hospitals <- Vienna_pageviews_item %>%
  filter(id == 33) %>%
  filter(!is.na(value))
Vienna_hospitals$percentage <- scales::percent(Vienna_hospitals$value/sum(Vienna_hospitals$value))

Vienna_libraries <- Vienna_pageviews_item %>%
  filter(id == 34) %>%
  filter(!is.na(value))
Vienna_libraries$percentage <- scales::percent(Vienna_libraries$value/sum(Vienna_libraries$value))

Vienna_statues_and_fountains <- Vienna_pageviews_item %>%
  filter(id == 35) %>%
  filter(!is.na(value))
Vienna_statues_and_fountains$percentage <- scales::percent(Vienna_statues_and_fountains$value/sum(Vienna_statues_and_fountains$value))

Vienna_high_education <- Vienna_pageviews_item %>%
  filter(id == 39) %>%
  filter(!is.na(value))
Vienna_high_education$percentage <- scales::percent(Vienna_high_education$value/sum(Vienna_high_education$value))

Vienna_bridges <- Vienna_pageviews_item %>%
  filter(id == 41) %>%
  filter(!is.na(value))
Vienna_bridges$percentage <- scales::percent(Vienna_bridges$value/sum(Vienna_bridges$value))

Vienna_for_model <- Vienna_final %>%
  mutate(id = as.numeric(as.character(id)))
Vienna_for_model$id[Vienna_for_model$item == "Q7795"] <- '7795'
Vienna_for_model$id[Vienna_for_model$item == "Q28513"] <- '28513'
Vienna_for_model$id[Vienna_for_model$item == "Q46232"] <- '46232'
Vienna_for_model$id[Vienna_for_model$item == "Q698487"] <- '698487'
Vienna_for_model$id[Vienna_for_model$item == "Q131330"] <- '131330'
Vienna_for_model$id[Vienna_for_model$item == "Q165980"] <- '165980'
Vienna_for_model$id[Vienna_for_model$item == "Q875343"] <- '875343'
Vienna_for_model$id[Vienna_for_model$item == "Q304037"] <- '304037'
Vienna_for_model$id[Vienna_for_model$item == "Q23249"] <- '23249'

Vienna_for_model_2 <- Vienna_for_model %>%
  distinct(item, .keep_all = T)

Vienna_for_model_ts <- Vienna_reads_in_C %>%
  left_join(Vienna_for_model_2, by = 'item') %>%
  select(-lat, -long)%>%
  filter(!is.na(id))%>%
  group_by(time, id)%>%
  summarise(value = sum(value))

Vienna_for_model_ts <- dcast(Vienna_for_model_ts, time ~ id) %>%
  mutate(time = as.Date(ts(1:48, frequency = 12, start = c(2012, 01))))

library(stringr)

Vienna_OVER_model <- merge(Vienna_for_model_ts, Vienna_OVER_tourism)
colnames(Vienna_OVER_model) <- str_trim(colnames(Vienna_OVER_model))
colnames(Vienna_OVER_model) <- c("time", "sport", "bus_stops_and_stations", "mountains", "schloss_schonbrunn", "universitat_wien", "transmitters", "embassies",
                                 "council_housing", "streets_and_squares", "rivers_and_parks","donauinsel", "museums", "towers", "osterreich_ungarn",
                                 "institutions_organizations", "buildings", "nationalbiliothek", "hospitals", "libraries", 
                                 "statues_and_founatins", "high_education", "history", "bridges",
                                 "theatres", "cemeteries", "wiener_ringstrasse", "township", "der_kuss", "places_of_worship", "organisation_erdolexportierender_lander","botschaft_usa", "companies", 
                                 "other_unclassified", "number_of_bookings")

Vienna_ARR_model <- merge(Vienna_for_model_ts, Vienna_ARR_tourism)
colnames(Vienna_ARR_model) <- str_trim(colnames(Vienna_ARR_model))
colnames(Vienna_ARR_model)<- c("time", "sport", "bus_stops_and_stations", "mountains", "schloss_schonbrunn", "universitat_wien", "transmitters", "embassies",
                               "council_housing", "streets_and_squares", "rivers_and_parks","donauinsel", "museums", "towers", "osterreich_ungarn",
                               "institutions_organizations", "buildings", "nationalbiliothek", "hospitals", "libraries", 
                               "statues_and_founatins", "high_education", "history", "bridges",
                               "theatres", "cemeteries", "wiener_ringstrasse", "township", "der_kuss", "places_of_worship", "organisation_erdolexportierender_lander","botschaft_usa", "companies", 
                               "other_unclassified", "number_of_passengers")

write.csv(Vienna_ARR_model, 'Vienna_ARR_model.csv')
write.csv(Vienna_OVER_model, 'Vienna_OVER_model.csv')

# CORRECTED MODELS FOR CITIES

# read data

Barcelona_ARR <- read.csv("C:/Users/Acer/Desktop/Wiki pilot/wikistats/Barcelona_ARR_model.csv", stringsAsFactors = F) %>%
  select(-X)
Bruges_ARR <- read.csv("C:/Users/Acer/Desktop/Wiki pilot/wikistats/Bruges_ARR_model.csv", stringsAsFactors = F) %>%
  select(-X, -belgium, -netherlands, -germany, - france, - united_kingdom, -luxembourg, -ireland, 
         -denmark, -sweden, -finland, -italy, -spain, -portugal, -greece, -austria, -poland, 
         -czech_republic, -hungary, -romania, -norway, -switzerland, -russia, -usa, 
         -canada, -japan, -china, -india, -israel, -turkey, -australia, -brazil, -other, -abroad)
Vienna_ARR <- read.csv("C:/Users/Acer/Desktop/Wiki pilot/wikistats/Vienna_ARR_model.csv", stringsAsFactors = F) %>%
  select(-X)

Barcelona_OVER <- read.csv("C:/Users/Acer/Desktop/Wiki pilot/wikistats/Barcelona_OVER_model.csv", stringsAsFactors = F) %>%
  select(-X)
Bruges_OVER <- read.csv("C:/Users/Acer/Desktop/Wiki pilot/wikistats/Bruges_OVER_model.csv", stringsAsFactors = F) %>%
  select(-X, -belgium, -netherlands, -germany, - france, - united_kingdom, -luxembourg, -ireland, 
         -denmark, -sweden, -finland, -italy, -spain, -portugal, -greece, -austria, -poland, 
         -czech_republic, -hungary, -romania, -norway, -switzerland, -russia, -usa, 
         -canada, -japan, -china, -india, -israel, -turkey, -australia, -brazil, -other, -abroad)
Vienna_OVER <- read.csv("C:/Users/Acer/Desktop/Wiki pilot/wikistats/Vienna_OVER_model.csv", stringsAsFactors = F) %>%
  select(-X)

# adjust series

Vienna_ARR <- Vienna_ARR %>%
  mutate(embassies = embassies + botschaft_usa,
         libraries = libraries + nationalbiliothek,
         bridges = bridges + donauinsel) %>%
  select(-botschaft_usa, - nationalbiliothek, -donauinsel)

Vienna_OVER <- Vienna_OVER %>%
  mutate(streets_and_squares = streets_and_squares + wiener_ringstrasse) %>%
  select(-wiener_ringstrasse)

Bruges_ARR <- Bruges_ARR %>%
  mutate(streets_and_streams = streets_and_streams + belfort_van_brugge) %>%
  select(-belfort_van_brugge)

Bruges_OVER <- Bruges_OVER %>%
  mutate(sport = sport + cercle_brugge) %>%
  select(-cercle_brugge)

Barcelona_OVER <- Barcelona_OVER %>%
  mutate(theatres = theatres + gran_teatro_del_liceo) %>%
  select(-gran_teatro_del_liceo)

# Transform into ts objects

Barcelona_ARR_ts <- ts(Barcelona_ARR[,2:19], frequency = 12, start = c(2012, 1))
Barcelona_OVER_ts <- ts(Barcelona_OVER[,2:18], frequency = 12, start = c(2012, 1))

Bruges_ARR_ts <- ts(Bruges_ARR[,2:16], frequency = 12, start = c(2012, 1))
Bruges_OVER_ts <- ts(Bruges_OVER[,2:16], frequency = 12, start = c(2012, 1))

Vienna_ARR_ts <- ts(Vienna_ARR[,2:32], frequency = 12, start = c(2012, 1))
Vienna_OVER_ts <- ts(Vienna_OVER[,2:34], frequency = 12, start = c(2012, 1))

# Plot time series

plot.ts(Barcelona_ARR_ts[, 1:9])
plot.ts(Barcelona_ARR_ts[, 10:18])

plot.ts(Barcelona_OVER_ts[, 1:9])
plot.ts(Barcelona_OVER_ts[, 10:17])

plot.ts(Bruges_ARR_ts[, 1:10])
plot.ts(Bruges_ARR_ts[, 11:19])

plot.ts(Bruges_OVER_ts[, 1:10])
plot.ts(Bruges_OVER_ts[, 11:19])

plot.ts(Vienna_ARR_ts[, 1:8])
plot.ts(Vienna_ARR_ts[, 9:16])
plot.ts(Vienna_ARR_ts[, 17:24])
plot.ts(Vienna_ARR_ts[, 25:31])

plot.ts(Vienna_OVER_ts[, 1:8])
plot.ts(Vienna_OVER_ts[, 9:16])
plot.ts(Vienna_OVER_ts[, 17:24])
plot.ts(Vienna_OVER_ts[, 25:33])

# VIENNA

# Vienna ARR

VIE_sport_components <- decompose(Vienna_ARR_ts[,1])
plot(VIE_sport_components)
VIE_sport_seas_adj <- Vienna_ARR_ts[,1] - VIE_sport_components$seasonal
plot(VIE_sport_seas_adj)

VIE_council_housing_components <- decompose(Vienna_ARR_ts[,8])
plot(VIE_council_housing_components)
VIE_council_housing_seas_adj <- Vienna_ARR_ts[,8] - VIE_council_housing_components$seasonal
plot(VIE_council_housing_seas_adj)

VIE_institutions_organizations_components <- decompose(Vienna_ARR_ts[,14])
plot(VIE_institutions_organizations_components)
VIE_institutions_organizations_seas_adj <- Vienna_ARR_ts[,14] - VIE_institutions_organizations_components$seasonal
plot(VIE_institutions_organizations_seas_adj)

VIE_history_components <- decompose(Vienna_ARR_ts[,20])
plot(VIE_history_components)
VIE_history_seas_adj <- Vienna_ARR_ts[,20] - VIE_history_components$seasonal
plot(VIE_history_seas_adj)

VIE_township_components <- decompose(Vienna_ARR_ts[,25])
plot(VIE_township_components)
VIE_township_seas_adj <- Vienna_ARR_ts[,25] - VIE_township_components$seasonal
plot(VIE_township_seas_adj)

VIE_places_of_worship_components <- decompose(Vienna_ARR_ts[,27])
plot(VIE_places_of_worship_components)
VIE_places_of_worship_seas_adj <- Vienna_ARR_ts[,27] - VIE_places_of_worship_components$seasonal
plot(VIE_places_of_worship_seas_adj)

VIE_companies_components <- decompose(Vienna_ARR_ts[,29])
plot(VIE_companies_components)
VIE_companies_seas_adj <- Vienna_ARR_ts[,29] - VIE_companies_components$seasonal
plot(VIE_companies_seas_adj)

VIE_bus_stops_and_stations_components <- decompose(Vienna_ARR_ts[,2])
plot(VIE_bus_stops_and_stations_components)
VIE_bus_stops_and_stations_seas_adj <- Vienna_ARR_ts[,2] - VIE_bus_stops_and_stations_components$seasonal
plot(VIE_bus_stops_and_stations_seas_adj)

VIE_mountains_components <- decompose(Vienna_ARR_ts[,3])
plot(VIE_mountains_components)
VIE_mountains_seas_adj <- Vienna_ARR_ts[,3] - VIE_mountains_components$seasonal
plot(VIE_mountains_seas_adj)

VIE_transmitters_components <- decompose(Vienna_ARR_ts[,6])
plot(VIE_transmitters_components)
VIE_transmitters_seas_adj <- Vienna_ARR_ts[,6] - VIE_transmitters_components$seasonal
plot(VIE_transmitters_seas_adj)

VIE_embassies_components <- decompose(Vienna_ARR_ts[,7])
plot(VIE_embassies_components)
VIE_embassies_seas_adj <- Vienna_ARR_ts[,7] - VIE_embassies_components$seasonal
plot(VIE_embassies_seas_adj)

VIE_streets_and_squares_components <- decompose(Vienna_ARR_ts[,9])
plot(VIE_streets_and_squares_components)
VIE_streets_and_squares_seas_adj <- Vienna_ARR_ts[,9] - VIE_streets_and_squares_components$seasonal
plot(VIE_streets_and_squares_seas_adj)

VIE_rivers_and_parks_components <- decompose(Vienna_ARR_ts[,10])
plot(VIE_rivers_and_parks_components)
VIE_rivers_and_parks_seas_adj <- Vienna_ARR_ts[,10] - VIE_rivers_and_parks_components$seasonal
plot(VIE_rivers_and_parks_seas_adj)

VIE_museums_components <- decompose(Vienna_ARR_ts[,11])
plot(VIE_museums_components)
VIE_museums_seas_adj <- Vienna_ARR_ts[,11] - VIE_museums_components$seasonal
plot(VIE_museums_seas_adj)

VIE_towers_components <- decompose(Vienna_ARR_ts[,12])
plot(VIE_towers_components)
VIE_towers_seas_adj <- Vienna_ARR_ts[,12] - VIE_towers_components$seasonal
plot(VIE_towers_seas_adj)

VIE_buildings_components <- decompose(Vienna_ARR_ts[,15])
plot(VIE_buildings_components)
VIE_buildings_seas_adj <- Vienna_ARR_ts[,15] - VIE_buildings_components$seasonal
plot(VIE_buildings_seas_adj)

VIE_hospitals_components <- decompose(Vienna_ARR_ts[,16])
plot(VIE_hospitals_components)
VIE_hospitals_seas_adj <- Vienna_ARR_ts[,16] - VIE_hospitals_components$seasonal
plot(VIE_hospitals_seas_adj)

VIE_libraries_components <- decompose(Vienna_ARR_ts[,17])
plot(VIE_libraries_components)
VIE_libraries_seas_adj <- Vienna_ARR_ts[,17] - VIE_libraries_components$seasonal
plot(VIE_libraries_seas_adj)

VIE_statues_and_fountains_components <- decompose(Vienna_ARR_ts[,18])
plot(VIE_statues_and_fountains_components)
VIE_statues_and_fountains_seas_adj <- Vienna_ARR_ts[,18] - VIE_statues_and_fountains_components$seasonal
plot(VIE_statues_and_fountains_seas_adj)

VIE_high_education_components <- decompose(Vienna_ARR_ts[,19])
plot(VIE_high_education_components)
VIE_high_education_seas_adj <- Vienna_ARR_ts[,19] - VIE_high_education_components$seasonal
plot(VIE_high_education_seas_adj)

VIE_bridges_components <- decompose(Vienna_ARR_ts[,21])
plot(VIE_bridges_components)
VIE_bridges_seas_adj <- Vienna_ARR_ts[,21] - VIE_bridges_components$seasonal
plot(VIE_bridges_seas_adj)

VIE_theatres_components <- decompose(Vienna_ARR_ts[,22])
plot(VIE_theatres_components)
VIE_theatres_seas_adj <- Vienna_ARR_ts[,22] - VIE_theatres_components$seasonal
plot(VIE_theatres_seas_adj)

VIE_cemeteries_components <- decompose(Vienna_ARR_ts[,23])
plot(VIE_cemeteries_components)
VIE_cemeteries_seas_adj <- Vienna_ARR_ts[,23] - VIE_cemeteries_components$seasonal
plot(VIE_cemeteries_seas_adj)

VIE_schloss_schonbrunn_components <- decompose(Vienna_ARR_ts[,4])
plot(VIE_schloss_schonbrunn_components)
VIE_schloss_schonbrunn_seas_adj <- Vienna_ARR_ts[,4] - VIE_schloss_schonbrunn_components$seasonal
plot(VIE_schloss_schonbrunn_seas_adj)

VIE_universitat_wien_components <- decompose(Vienna_ARR_ts[,5])
plot(VIE_universitat_wien_components)
VIE_universitat_wien_seas_adj <- Vienna_ARR_ts[,5] - VIE_universitat_wien_components$seasonal
plot(VIE_universitat_wien_seas_adj)

VIE_osterreich_ungarn_components <- decompose(Vienna_ARR_ts[,13])
plot(VIE_osterreich_ungarn_components)
VIE_osterreich_ungarn_seas_adj <- Vienna_ARR_ts[,13] - VIE_osterreich_ungarn_components$seasonal
plot(VIE_osterreich_ungarn_seas_adj)

VIE_wiener_ringstrasse_components <- decompose(Vienna_ARR_ts[,24])
plot(VIE_wiener_ringstrasse_components)
VIE_wiener_ringstrasse_seas_adj <- Vienna_ARR_ts[,24] - VIE_wiener_ringstrasse_components$seasonal
plot(VIE_wiener_ringstrasse_seas_adj)

VIE_der_kuss_components <- decompose(Vienna_ARR_ts[,26])
plot(VIE_der_kuss_components)
VIE_der_kuss_seas_adj <- Vienna_ARR_ts[,26] - VIE_der_kuss_components$seasonal
plot(VIE_der_kuss_seas_adj)

VIE_organisation_erdolexportierender_lander_components <- decompose(Vienna_ARR_ts[,28])
plot(VIE_organisation_erdolexportierender_lander_components)
VIE_organisation_erdolexportierender_lander_seas_adj <- Vienna_ARR_ts[,28] - VIE_organisation_erdolexportierender_lander_components$seasonal
plot(VIE_organisation_erdolexportierender_lander_seas_adj)

VIE_number_of_passenger_components <- decompose(Vienna_ARR_ts[,31])
plot(VIE_number_of_passenger_components)
VIE_number_of_passenger_seas_adj <- Vienna_ARR_ts[,31] - VIE_number_of_passenger_components$seasonal
plot(VIE_number_of_passenger_seas_adj)

adf.test(VIE_number_of_passenger_seas_adj)

VIE_number_of_passenger_seas_adj_diff <- diff(VIE_number_of_passenger_seas_adj)

adf.test(VIE_sport_seas_adj)
adf.test(diff(VIE_sport_seas_adj))

VIE_sport_seas_adj_diff <- diff(VIE_sport_seas_adj)

adf.test(VIE_council_housing_seas_adj)
adf.test(diff(VIE_council_housing_seas_adj))

VIE_council_housing_seas_adj_diff <- diff(VIE_council_housing_seas_adj)

adf.test(VIE_institutions_organizations_seas_adj)
adf.test(diff(VIE_institutions_organizations_seas_adj))

VIE_institutions_organizations_seas_adj_diff <- diff(VIE_institutions_organizations_seas_adj)

adf.test(VIE_history_seas_adj)
adf.test(diff(VIE_history_seas_adj))
adf.test(diff(diff(VIE_history_seas_adj)))

VIE_history_seas_adj_diff <- diff(VIE_history_seas_adj, differences = 2)

adf.test(VIE_township_seas_adj)
adf.test(diff(VIE_township_seas_adj))
adf.test(diff(diff(VIE_township_seas_adj)))

VIE_township_seas_adj_diff <- diff(VIE_township_seas_adj, differences = 2)

adf.test(VIE_places_of_worship_seas_adj)
adf.test(diff(VIE_places_of_worship_seas_adj))
adf.test(diff(diff(VIE_places_of_worship_seas_adj)))

VIE_places_of_worship_seas_adj_diff <- diff(VIE_places_of_worship_seas_adj, differences = 2)

adf.test(VIE_companies_seas_adj)
adf.test(diff(VIE_companies_seas_adj))

VIE_companies_seas_adj_diff <- diff(VIE_companies_seas_adj)

adf.test(VIE_bus_stops_and_stations_seas_adj)
adf.test(diff(VIE_bus_stops_and_stations_seas_adj))

VIE_bus_stops_and_stations_seas_adj_diff <- diff(VIE_bus_stops_and_stations_seas_adj)

adf.test(VIE_mountains_seas_adj)

VIE_mountains_seas_adj_diff <- diff(VIE_mountains_seas_adj)

adf.test(VIE_transmitters_seas_adj)
adf.test(diff(VIE_transmitters_seas_adj))

VIE_transmitters_seas_adj_diff <- diff(VIE_transmitters_seas_adj)

adf.test(VIE_embassies_seas_adj)
adf.test(diff(VIE_embassies_seas_adj))

VIE_embassies_seas_adj_diff <- diff(VIE_embassies_seas_adj)

adf.test(VIE_streets_and_squares_seas_adj)
adf.test(diff(VIE_streets_and_squares_seas_adj))

VIE_streets_and_squares_seas_adj_diff <- diff(VIE_streets_and_squares_seas_adj)

adf.test(VIE_rivers_and_parks_seas_adj)
adf.test(diff(VIE_rivers_and_parks_seas_adj))

VIE_rivers_and_parks_seas_adj_diff <- diff(VIE_rivers_and_parks_seas_adj)

adf.test(VIE_museums_seas_adj)

VIE_museums_seas_adj_diff <- diff(VIE_museums_seas_adj)

adf.test(VIE_towers_seas_adj)
adf.test(diff(VIE_towers_seas_adj))

VIE_towers_seas_adj_diff <- diff(VIE_towers_seas_adj)

adf.test(VIE_buildings_seas_adj)
adf.test(diff(VIE_buildings_seas_adj))
adf.test(diff(diff(VIE_buildings_seas_adj)))

VIE_buildings_seas_adj_diff <- diff(VIE_buildings_seas_adj, differences = 2)

adf.test(VIE_hospitals_seas_adj)
adf.test(diff(VIE_hospitals_seas_adj))

VIE_hospitals_seas_adj_diff <- diff(VIE_hospitals_seas_adj)

adf.test(VIE_libraries_seas_adj)
adf.test(diff(VIE_libraries_seas_adj))

VIE_libraries_seas_adj_diff <- diff(VIE_libraries_seas_adj)

adf.test(VIE_statues_and_fountains_seas_adj)
adf.test(diff(VIE_statues_and_fountains_seas_adj))

VIE_statues_and_fountains_seas_adj_diff <- diff(VIE_statues_and_fountains_seas_adj)

adf.test(VIE_high_education_seas_adj)
adf.test(diff(VIE_high_education_seas_adj))
adf.test(diff(diff(VIE_high_education_seas_adj)))

VIE_high_education_seas_adj_diff <- diff(VIE_high_education_seas_adj, differences = 2)

adf.test(VIE_bridges_seas_adj)

VIE_bridges_seas_adj_diff <- diff(VIE_bridges_seas_adj)

adf.test(VIE_theatres_seas_adj)
adf.test(diff(VIE_theatres_seas_adj))

VIE_theatres_seas_adj_diff <- diff(VIE_theatres_seas_adj)

adf.test(VIE_cemeteries_seas_adj)
adf.test(diff(VIE_cemeteries_seas_adj))

VIE_cemeteries_seas_adj_diff <- diff(VIE_cemeteries_seas_adj)

adf.test(VIE_schloss_schonbrunn_seas_adj)
adf.test(diff(VIE_schloss_schonbrunn_seas_adj))

VIE_schloss_schonbrunn_seas_adj_diff <- diff(VIE_schloss_schonbrunn_seas_adj)

adf.test(VIE_universitat_wien_seas_adj)
adf.test(diff(VIE_universitat_wien_seas_adj))

VIE_universitat_wien_seas_adj_diff <- diff(VIE_universitat_wien_seas_adj)

adf.test(VIE_osterreich_ungarn_seas_adj)
adf.test(diff(VIE_osterreich_ungarn_seas_adj))
adf.test(diff(diff(VIE_osterreich_ungarn_seas_adj)))

VIE_osterreich_ungarn_seas_adj_diff <- diff(VIE_osterreich_ungarn_seas_adj, differences = 2)

adf.test(VIE_wiener_ringstrasse_seas_adj)
adf.test(diff(VIE_wiener_ringstrasse_seas_adj))

VIE_wiener_ringstrasse_seas_adj_diff <- diff(VIE_wiener_ringstrasse_seas_adj)

adf.test(VIE_der_kuss_seas_adj)
adf.test(diff(VIE_der_kuss_seas_adj))

VIE_der_kuss_seas_adj_diff <- diff(VIE_der_kuss_seas_adj)

adf.test(VIE_organisation_erdolexportierender_lander_seas_adj)
adf.test(diff(VIE_organisation_erdolexportierender_lander_seas_adj))

VIE_organisation_erdolexportierender_lander_seas_adj_diff <- diff(VIE_organisation_erdolexportierender_lander_seas_adj)

VIE_number_of_passenger_seas_adj_diff_scaled <- scale(VIE_number_of_passenger_seas_adj_diff[-1])

VIE_sport_seas_adj_diff_scaled <- scale(VIE_sport_seas_adj_diff[-1])
VIE_council_housing_seas_adj_diff_scaled <- scale(VIE_council_housing_seas_adj_diff[-1])
VIE_institutions_organizations_seas_adj_diff_scaled <- scale(VIE_institutions_organizations_seas_adj_diff[-1])
VIE_history_seas_adj_diff_scaled <- scale(VIE_history_seas_adj_diff)
VIE_township_seas_adj_diff_scaled <- scale(VIE_township_seas_adj_diff)
VIE_places_of_worship_seas_adj_diff_scaled <- scale(VIE_places_of_worship_seas_adj_diff)
VIE_companies_seas_adj_diff_scaled <- scale(VIE_companies_seas_adj_diff[-1])
VIE_bus_stops_and_stations_seas_adj_diff_scaled <- scale(VIE_bus_stops_and_stations_seas_adj_diff[-1])
VIE_mountains_seas_adj_diff_scaled <- scale(VIE_mountains_seas_adj_diff[-1])
VIE_transmitters_seas_adj_diff_scaled <- scale(VIE_transmitters_seas_adj_diff[-1])
VIE_embassies_seas_adj_diff_scaled <- scale(VIE_embassies_seas_adj_diff[-1])
VIE_streets_and_squares_seas_adj_diff_scaled <- scale(VIE_streets_and_squares_seas_adj_diff[-1])
VIE_rivers_and_parks_seas_adj_diff_scaled <- scale(VIE_rivers_and_parks_seas_adj_diff[-1])
VIE_museums_seas_adj_diff_scaled <- scale(VIE_museums_seas_adj_diff[-1])
VIE_towers_seas_adj_diff_scaled <- scale(VIE_towers_seas_adj_diff[-1])
VIE_buildings_seas_adj_diff_scaled <- scale(VIE_buildings_seas_adj_diff)
VIE_hospitals_seas_adj_diff_scaled <- scale(VIE_hospitals_seas_adj_diff[-1])
VIE_libraries_seas_adj_diff_scaled <- scale(VIE_libraries_seas_adj_diff[-1])
VIE_statues_and_fountains_seas_adj_diff_scaled <- scale(VIE_statues_and_fountains_seas_adj_diff[-1]) 
VIE_high_education_seas_adj_diff_scaled <- scale(VIE_high_education_seas_adj_diff)
VIE_bridges_seas_adj_diff_scaled <- scale(VIE_bridges_seas_adj_diff[-1]) 
VIE_theatres_seas_adj_diff_scaled <- scale(VIE_theatres_seas_adj_diff[-1])
VIE_cemeteries_seas_adj_diff_scaled <- scale(VIE_cemeteries_seas_adj_diff[-1])
VIE_schloss_schonbrunn_seas_adj_diff_scaled <- scale(VIE_schloss_schonbrunn_seas_adj_diff[-1])
VIE_universitat_wien_seas_adj_diff_scaled <- scale(VIE_universitat_wien_seas_adj_diff[-1])
VIE_osterreich_ungarn_seas_adj_diff_scaled <- scale(VIE_osterreich_ungarn_seas_adj_diff)
VIE_wiener_ringstrasse_seas_adj_diff_scaled <- scale(VIE_wiener_ringstrasse_seas_adj_diff[-1])
VIE_der_kuss_seas_adj_diff_scaled <- scale(VIE_der_kuss_seas_adj_diff[-1])
VIE_organisation_erdolexportierender_lander_seas_adj_diff_scaled <- scale(VIE_organisation_erdolexportierender_lander_seas_adj_diff[-1])

VIE_xreg <- data.frame(institutions_organizations = VIE_institutions_organizations_seas_adj_diff_scaled,
                       history = VIE_history_seas_adj_diff_scaled, 
                       places_of_worship = VIE_places_of_worship_seas_adj_diff_scaled, 
                       companies = VIE_companies_seas_adj_diff_scaled, 
                       mountains = VIE_mountains_seas_adj_diff_scaled, 
                       streets_and_squares = VIE_streets_and_squares_seas_adj_diff_scaled, 
                       rivers_and_parks = VIE_rivers_and_parks_seas_adj_diff_scaled, 
                       museums = VIE_museums_seas_adj_diff_scaled,
                       buildings = VIE_buildings_seas_adj_diff_scaled, 
                       high_education = VIE_high_education_seas_adj_diff_scaled,
                       cemeteries = VIE_cemeteries_seas_adj_diff_scaled, 
                       schloss_schonbrunn = VIE_schloss_schonbrunn_seas_adj_diff_scaled,
                       universitat_wien = VIE_universitat_wien_seas_adj_diff_scaled, 
                       osterreich_ungarn = VIE_osterreich_ungarn_seas_adj_diff_scaled,
                       wiener_ringstrass = VIE_wiener_ringstrasse_seas_adj_diff_scaled,
                       der_kuss = VIE_der_kuss_seas_adj_diff_scaled,
                       organisation_erdolexportierender_lander = VIE_organisation_erdolexportierender_lander_seas_adj_diff_scaled)

# plot time series

plot.ts(VIE_number_of_passenger_seas_adj_diff_scaled, main = "Number of passengers")
plot.ts(VIE_xreg[,1:10])
plot.ts(VIE_xreg[,11:20])
plot.ts(VIE_xreg[,21:29])

acf(VIE_number_of_passenger_seas_adj_diff_scaled)
pacf(VIE_number_of_passenger_seas_adj_diff_scaled)

VIE_fit_passengers <- Arima(VIE_number_of_passenger_seas_adj_diff_scaled, order = c(0,0,0), xreg = VIE_xreg, include.mean = F)
VIE_fit_passengers

VIE_res_fit_passengers <- acf(VIE_fit_passengers$residuals, lag.max = 20)
Box.test(VIE_fit_passengers$residuals, lag = 20, type = "Ljung-Box")

acf(VIE_fit_passengers$residuals)
plotForecastErrors(VIE_fit_passengers$residuals)

coeftest(VIE_fit_passengers)

# Vienna OVER

VIE_sport_components <- decompose(Vienna_OVER_ts[,1])
plot(VIE_sport_components)
VIE_sport_seas_adj <- Vienna_OVER_ts[,1] - VIE_sport_components$seasonal
plot(VIE_sport_seas_adj)

VIE_council_housing_components <- decompose(Vienna_OVER_ts[,8])
plot(VIE_council_housing_components)
VIE_council_housing_seas_adj <- Vienna_OVER_ts[,8] - VIE_council_housing_components$seasonal
plot(VIE_council_housing_seas_adj)

VIE_institutions_organizations_components <- decompose(Vienna_OVER_ts[,15])
plot(VIE_institutions_organizations_components)
VIE_institutions_organizations_seas_adj <- Vienna_OVER_ts[,15] - VIE_institutions_organizations_components$seasonal
plot(VIE_institutions_organizations_seas_adj)

VIE_history_components <- decompose(Vienna_OVER_ts[,22])
plot(VIE_history_components)
VIE_history_seas_adj <- Vienna_OVER_ts[,22] - VIE_history_components$seasonal
plot(VIE_history_seas_adj)

VIE_township_components <- decompose(Vienna_OVER_ts[,26])
plot(VIE_township_components)
VIE_township_seas_adj <- Vienna_OVER_ts[,26] - VIE_township_components$seasonal
plot(VIE_township_seas_adj)

VIE_places_of_worship_components <- decompose(Vienna_OVER_ts[,28])
plot(VIE_places_of_worship_components)
VIE_places_of_worship_seas_adj <- Vienna_OVER_ts[,28] - VIE_places_of_worship_components$seasonal
plot(VIE_places_of_worship_seas_adj)

VIE_companies_components <- decompose(Vienna_OVER_ts[,31])
plot(VIE_companies_components)
VIE_companies_seas_adj <- Vienna_OVER_ts[,31] - VIE_companies_components$seasonal
plot(VIE_companies_seas_adj)

VIE_bus_stops_and_stations_components <- decompose(Vienna_OVER_ts[,2])
plot(VIE_bus_stops_and_stations_components)
VIE_bus_stops_and_stations_seas_adj <- Vienna_OVER_ts[,2] - VIE_bus_stops_and_stations_components$seasonal
plot(VIE_bus_stops_and_stations_seas_adj)

VIE_mountains_components <- decompose(Vienna_OVER_ts[,3])
plot(VIE_mountains_components)
VIE_mountains_seas_adj <- Vienna_OVER_ts[,3] - VIE_mountains_components$seasonal
plot(VIE_mountains_seas_adj)

VIE_transmitters_components <- decompose(Vienna_OVER_ts[,6])
plot(VIE_transmitters_components)
VIE_transmitters_seas_adj <- Vienna_OVER_ts[,6] - VIE_transmitters_components$seasonal
plot(VIE_transmitters_seas_adj)

VIE_embassies_components <- decompose(Vienna_OVER_ts[,7])
plot(VIE_embassies_components)
VIE_embassies_seas_adj <- Vienna_OVER_ts[,7] - VIE_embassies_components$seasonal
plot(VIE_embassies_seas_adj)

VIE_streets_and_squares_components <- decompose(Vienna_OVER_ts[,9])
plot(VIE_streets_and_squares_components)
VIE_streets_and_squares_seas_adj <- Vienna_OVER_ts[,9] - VIE_streets_and_squares_components$seasonal
plot(VIE_streets_and_squares_seas_adj)

VIE_rivers_and_parks_components <- decompose(Vienna_OVER_ts[,10])
plot(VIE_rivers_and_parks_components)
VIE_rivers_and_parks_seas_adj <- Vienna_OVER_ts[,10] - VIE_rivers_and_parks_components$seasonal
plot(VIE_rivers_and_parks_seas_adj)

VIE_museums_components <- decompose(Vienna_OVER_ts[,12])
plot(VIE_museums_components)
VIE_museums_seas_adj <- Vienna_OVER_ts[,12] - VIE_museums_components$seasonal
plot(VIE_museums_seas_adj)

VIE_towers_components <- decompose(Vienna_OVER_ts[,13])
plot(VIE_towers_components)
VIE_towers_seas_adj <- Vienna_OVER_ts[,13] - VIE_towers_components$seasonal
plot(VIE_towers_seas_adj)

VIE_buildings_components <- decompose(Vienna_OVER_ts[,16])
plot(VIE_buildings_components)
VIE_buildings_seas_adj <- Vienna_OVER_ts[,16] - VIE_buildings_components$seasonal
plot(VIE_buildings_seas_adj)

VIE_hospitals_components <- decompose(Vienna_OVER_ts[,18])
plot(VIE_hospitals_components)
VIE_hospitals_seas_adj <- Vienna_OVER_ts[,18] - VIE_hospitals_components$seasonal
plot(VIE_hospitals_seas_adj)

VIE_libraries_components <- decompose(Vienna_OVER_ts[,19])
plot(VIE_libraries_components)
VIE_libraries_seas_adj <- Vienna_OVER_ts[,19] - VIE_libraries_components$seasonal
plot(VIE_libraries_seas_adj)

VIE_statues_and_fountains_components <- decompose(Vienna_OVER_ts[,20])
plot(VIE_statues_and_fountains_components)
VIE_statues_and_fountains_seas_adj <- Vienna_OVER_ts[,20] - VIE_statues_and_fountains_components$seasonal
plot(VIE_statues_and_fountains_seas_adj)

VIE_high_education_components <- decompose(Vienna_OVER_ts[,21])
plot(VIE_high_education_components)
VIE_high_education_seas_adj <- Vienna_OVER_ts[,21] - VIE_high_education_components$seasonal
plot(VIE_high_education_seas_adj)

VIE_bridges_components <- decompose(Vienna_OVER_ts[,23])
plot(VIE_bridges_components)
VIE_bridges_seas_adj <- Vienna_OVER_ts[,23] - VIE_bridges_components$seasonal
plot(VIE_bridges_seas_adj)

VIE_theatres_components <- decompose(Vienna_OVER_ts[,24])
plot(VIE_theatres_components)
VIE_theatres_seas_adj <- Vienna_OVER_ts[,24] - VIE_theatres_components$seasonal
plot(VIE_theatres_seas_adj)

VIE_cemeteries_components <- decompose(Vienna_OVER_ts[,25])
plot(VIE_cemeteries_components)
VIE_cemeteries_seas_adj <- Vienna_OVER_ts[,25] - VIE_cemeteries_components$seasonal
plot(VIE_cemeteries_seas_adj)

VIE_schloss_schonbrunn_components <- decompose(Vienna_OVER_ts[,4])
plot(VIE_schloss_schonbrunn_components)
VIE_schloss_schonbrunn_seas_adj <- Vienna_OVER_ts[,4] - VIE_schloss_schonbrunn_components$seasonal
plot(VIE_schloss_schonbrunn_seas_adj)

VIE_universitat_wien_components <- decompose(Vienna_OVER_ts[,5])
plot(VIE_universitat_wien_components)
VIE_universitat_wien_seas_adj <- Vienna_OVER_ts[,5] - VIE_universitat_wien_components$seasonal
plot(VIE_universitat_wien_seas_adj)

VIE_osterreich_ungarn_components <- decompose(Vienna_OVER_ts[,14])
plot(VIE_osterreich_ungarn_components)
VIE_osterreich_ungarn_seas_adj <- Vienna_OVER_ts[,14] - VIE_osterreich_ungarn_components$seasonal
plot(VIE_osterreich_ungarn_seas_adj)

VIE_der_kuss_components <- decompose(Vienna_OVER_ts[,27])
plot(VIE_der_kuss_components)
VIE_der_kuss_seas_adj <- Vienna_OVER_ts[,27] - VIE_der_kuss_components$seasonal
plot(VIE_der_kuss_seas_adj)

VIE_nationalbibliothek_components <- decompose(Vienna_OVER_ts[,17])
plot(VIE_nationalbibliothek_components)
VIE_nationalbibliothek_seas_adj <- Vienna_OVER_ts[,17] - VIE_nationalbibliothek_components$seasonal
plot(VIE_nationalbibliothek_seas_adj)

VIE_donauinsel_components <- decompose(Vienna_OVER_ts[,11])
plot(VIE_donauinsel_components)
VIE_donauinsel_seas_adj <- Vienna_OVER_ts[,11] - VIE_donauinsel_components$seasonal
plot(VIE_donauinsel_seas_adj)

VIE_botschaft_usa_components <- decompose(Vienna_OVER_ts[,30])
plot(VIE_botschaft_usa_components)
VIE_botschaft_usa_seas_adj <- Vienna_OVER_ts[,30] - VIE_botschaft_usa_components$seasonal
plot(VIE_botschaft_usa_seas_adj)

VIE_organisation_erdolexportierender_lander_components <- decompose(Vienna_OVER_ts[,29])
plot(VIE_organisation_erdolexportierender_lander_components)
VIE_organisation_erdolexportierender_lander_seas_adj <- Vienna_OVER_ts[,29] - VIE_organisation_erdolexportierender_lander_components$seasonal
plot(VIE_organisation_erdolexportierender_lander_seas_adj)


VIE_number_of_bookings_components <- decompose(Vienna_OVER_ts[,33])
plot(VIE_number_of_bookings_components)
VIE_number_of_bookings_seas_adj <- Vienna_OVER_ts[,33] - VIE_number_of_bookings_components$seasonal
plot(VIE_number_of_bookings_seas_adj)

adf.test(VIE_number_of_bookings_seas_adj)

VIE_number_of_bookings_seas_adj_diff <- diff(VIE_number_of_bookings_seas_adj)

VIE_sport_seas_adj_diff <- diff(VIE_sport_seas_adj)

adf.test(VIE_council_housing_seas_adj)
adf.test(diff(VIE_council_housing_seas_adj))

VIE_council_housing_seas_adj_diff <- diff(VIE_council_housing_seas_adj)

adf.test(VIE_institutions_organizations_seas_adj)
adf.test(diff(VIE_institutions_organizations_seas_adj))

VIE_institutions_organizations_seas_adj_diff <- diff(VIE_institutions_organizations_seas_adj)

adf.test(VIE_history_seas_adj)
adf.test(diff(VIE_history_seas_adj))
adf.test(diff(diff(VIE_history_seas_adj)))

VIE_history_seas_adj_diff <- diff(VIE_history_seas_adj, differences = 2)

adf.test(VIE_township_seas_adj)
adf.test(diff(VIE_township_seas_adj))
adf.test(diff(diff(VIE_township_seas_adj)))

VIE_township_seas_adj_diff <- diff(VIE_township_seas_adj, differences = 2)

adf.test(VIE_places_of_worship_seas_adj)
adf.test(diff(VIE_places_of_worship_seas_adj))
adf.test(diff(diff(VIE_places_of_worship_seas_adj)))

VIE_places_of_worship_seas_adj_diff <- diff(VIE_places_of_worship_seas_adj, differences = 2)

adf.test(VIE_companies_seas_adj)
adf.test(diff(VIE_companies_seas_adj))

VIE_companies_seas_adj_diff <- diff(VIE_companies_seas_adj)

adf.test(VIE_bus_stops_and_stations_seas_adj)
adf.test(diff(VIE_bus_stops_and_stations_seas_adj))

VIE_bus_stops_and_stations_seas_adj_diff <- diff(VIE_bus_stops_and_stations_seas_adj)

adf.test(VIE_mountains_seas_adj)

VIE_mountains_seas_adj_diff <- diff(VIE_mountains_seas_adj)

adf.test(VIE_transmitters_seas_adj)
adf.test(diff(VIE_transmitters_seas_adj))

VIE_transmitters_seas_adj_diff <- diff(VIE_transmitters_seas_adj)

adf.test(VIE_embassies_seas_adj)
adf.test(diff(VIE_embassies_seas_adj))

VIE_embassies_seas_adj_diff <- diff(VIE_embassies_seas_adj)

adf.test(VIE_streets_and_squares_seas_adj)
adf.test(diff(VIE_streets_and_squares_seas_adj))

VIE_streets_and_squares_seas_adj_diff <- diff(VIE_streets_and_squares_seas_adj)

adf.test(VIE_rivers_and_parks_seas_adj)
adf.test(diff(VIE_rivers_and_parks_seas_adj))

VIE_rivers_and_parks_seas_adj_diff <- diff(VIE_rivers_and_parks_seas_adj)

adf.test(VIE_museums_seas_adj)

VIE_museums_seas_adj_diff <- diff(VIE_museums_seas_adj)

adf.test(VIE_towers_seas_adj)
adf.test(diff(VIE_towers_seas_adj))

VIE_towers_seas_adj_diff <- diff(VIE_towers_seas_adj)

adf.test(VIE_buildings_seas_adj)
adf.test(diff(VIE_buildings_seas_adj))
adf.test(diff(diff(VIE_buildings_seas_adj)))

VIE_buildings_seas_adj_diff <- diff(VIE_buildings_seas_adj, differences = 2)

adf.test(VIE_hospitals_seas_adj)
adf.test(diff(VIE_hospitals_seas_adj))

VIE_hospitals_seas_adj_diff <- diff(VIE_hospitals_seas_adj)

adf.test(VIE_libraries_seas_adj)
adf.test(diff(VIE_libraries_seas_adj))

VIE_libraries_seas_adj_diff <- diff(VIE_libraries_seas_adj)

adf.test(VIE_statues_and_fountains_seas_adj)
adf.test(diff(VIE_statues_and_fountains_seas_adj))

VIE_statues_and_fountains_seas_adj_diff <- diff(VIE_statues_and_fountains_seas_adj)

adf.test(VIE_high_education_seas_adj)
adf.test(diff(VIE_high_education_seas_adj))
adf.test(diff(diff(VIE_high_education_seas_adj)))

VIE_high_education_seas_adj_diff <- diff(VIE_high_education_seas_adj, differences = 2)

adf.test(VIE_bridges_seas_adj)

VIE_bridges_seas_adj_diff <- diff(VIE_bridges_seas_adj)

adf.test(VIE_theatres_seas_adj)
adf.test(diff(VIE_theatres_seas_adj))

VIE_theatres_seas_adj_diff <- diff(VIE_theatres_seas_adj)

adf.test(VIE_cemeteries_seas_adj)
adf.test(diff(VIE_cemeteries_seas_adj))

VIE_cemeteries_seas_adj_diff <- diff(VIE_cemeteries_seas_adj)

adf.test(VIE_schloss_schonbrunn_seas_adj)
adf.test(diff(VIE_schloss_schonbrunn_seas_adj))

VIE_schloss_schonbrunn_seas_adj_diff <- diff(VIE_schloss_schonbrunn_seas_adj)

adf.test(VIE_universitat_wien_seas_adj)
adf.test(diff(VIE_universitat_wien_seas_adj))

VIE_universitat_wien_seas_adj_diff <- diff(VIE_universitat_wien_seas_adj)

adf.test(VIE_osterreich_ungarn_seas_adj)
adf.test(diff(VIE_osterreich_ungarn_seas_adj))
adf.test(diff(diff(VIE_osterreich_ungarn_seas_adj)))

VIE_osterreich_ungarn_seas_adj_diff <- diff(VIE_osterreich_ungarn_seas_adj, differences = 2)

adf.test(VIE_der_kuss_seas_adj)
adf.test(diff(VIE_der_kuss_seas_adj))

VIE_der_kuss_seas_adj_diff <- diff(VIE_der_kuss_seas_adj)

adf.test(VIE_organisation_erdolexportierender_lander_seas_adj)
adf.test(diff(VIE_organisation_erdolexportierender_lander_seas_adj))

VIE_organisation_erdolexportierender_lander_seas_adj_diff <- diff(VIE_organisation_erdolexportierender_lander_seas_adj)

adf.test(VIE_donauinsel_seas_adj)
adf.test(diff(VIE_donauinsel_seas_adj))

VIE_donauinsel_seas_adj_diff <- diff(VIE_donauinsel_seas_adj)

adf.test(VIE_nationalbibliothek_seas_adj)
adf.test(diff(VIE_nationalbibliothek_seas_adj))

VIE_nationalbibliothek_seas_adj_diff <- diff(VIE_nationalbibliothek_seas_adj)

adf.test(VIE_botschaft_usa_seas_adj)
adf.test(diff(VIE_botschaft_usa_seas_adj))

VIE_botschaft_usa_seas_adj_diff <- diff(VIE_botschaft_usa_seas_adj)

VIE_number_of_bookings_seas_adj_diff_scaled <- scale(VIE_number_of_bookings_seas_adj_diff[-1])

VIE_sport_seas_adj_diff_scaled <- scale(VIE_sport_seas_adj_diff[-1])
VIE_council_housing_seas_adj_diff_scaled <- scale(VIE_council_housing_seas_adj_diff[-1])
VIE_institutions_organizations_seas_adj_diff_scaled <- scale(VIE_institutions_organizations_seas_adj_diff[-1])
VIE_history_seas_adj_diff_scaled <- scale(VIE_history_seas_adj_diff)
VIE_township_seas_adj_diff_scaled <- scale(VIE_township_seas_adj_diff)
VIE_places_of_worship_seas_adj_diff_scaled <- scale(VIE_places_of_worship_seas_adj_diff)
VIE_companies_seas_adj_diff_scaled <- scale(VIE_companies_seas_adj_diff[-1])
VIE_bus_stops_and_stations_seas_adj_diff_scaled <- scale(VIE_bus_stops_and_stations_seas_adj_diff[-1])
VIE_mountains_seas_adj_diff_scaled <- scale(VIE_mountains_seas_adj_diff[-1])
VIE_transmitters_seas_adj_diff_scaled <- scale(VIE_transmitters_seas_adj_diff[-1])
VIE_embassies_seas_adj_diff_scaled <- scale(VIE_embassies_seas_adj_diff[-1])
VIE_streets_and_squares_seas_adj_diff_scaled <- scale(VIE_streets_and_squares_seas_adj_diff[-1])
VIE_rivers_and_parks_seas_adj_diff_scaled <- scale(VIE_rivers_and_parks_seas_adj_diff[-1])
VIE_museums_seas_adj_diff_scaled <- scale(VIE_museums_seas_adj_diff[-1])
VIE_towers_seas_adj_diff_scaled <- scale(VIE_towers_seas_adj_diff[-1])
VIE_buildings_seas_adj_diff_scaled <- scale(VIE_buildings_seas_adj_diff)
VIE_hospitals_seas_adj_diff_scaled <- scale(VIE_hospitals_seas_adj_diff[-1])
VIE_libraries_seas_adj_diff_scaled <- scale(VIE_libraries_seas_adj_diff[-1])
VIE_statues_and_fountains_seas_adj_diff_scaled <- scale(VIE_statues_and_fountains_seas_adj_diff[-1]) 
VIE_high_education_seas_adj_diff_scaled <- scale(VIE_high_education_seas_adj_diff)
VIE_bridges_seas_adj_diff_scaled <- scale(VIE_bridges_seas_adj_diff[-1]) 
VIE_theatres_seas_adj_diff_scaled <- scale(VIE_theatres_seas_adj_diff[-1])
VIE_cemeteries_seas_adj_diff_scaled <- scale(VIE_cemeteries_seas_adj_diff[-1])
VIE_schloss_schonbrunn_seas_adj_diff_scaled <- scale(VIE_schloss_schonbrunn_seas_adj_diff[-1])
VIE_universitat_wien_seas_adj_diff_scaled <- scale(VIE_universitat_wien_seas_adj_diff[-1])
VIE_osterreich_ungarn_seas_adj_diff_scaled <- scale(VIE_osterreich_ungarn_seas_adj_diff)
VIE_der_kuss_seas_adj_diff_scaled <- scale(VIE_der_kuss_seas_adj_diff[-1])
VIE_organisation_erdolexportierender_lander_seas_adj_diff_scaled <- scale(VIE_organisation_erdolexportierender_lander_seas_adj_diff[-1])
VIE_donauinsel_seas_adj_diff_scaled <- scale(VIE_donauinsel_seas_adj_diff[-1])
VIE_nationalbibliothek_seas_adj_diff_scaled <- scale(VIE_nationalbibliothek_seas_adj_diff[-1])
VIE_botschaft_usa_seas_adj_diff_scaled <- scale(VIE_botschaft_usa_seas_adj_diff[-1])

VIE_xreg <- data.frame(institutions_organizations = VIE_institutions_organizations_seas_adj_diff_scaled,
  history = VIE_history_seas_adj_diff_scaled, 
  township = VIE_township_seas_adj_diff_scaled, 
  places_of_worship = VIE_places_of_worship_seas_adj_diff_scaled, 
  companies = VIE_companies_seas_adj_diff_scaled, 
  mountains = VIE_mountains_seas_adj_diff_scaled, 
  embassies = VIE_embassies_seas_adj_diff_scaled, 
  rivers_and_parks = VIE_rivers_and_parks_seas_adj_diff_scaled, 
  museums = VIE_museums_seas_adj_diff_scaled,
  buildings = VIE_buildings_seas_adj_diff_scaled, 
  libraries = VIE_libraries_seas_adj_diff_scaled, 
  high_education = VIE_high_education_seas_adj_diff_scaled,
  bridges = VIE_bridges_seas_adj_diff_scaled, 
  theatres = VIE_theatres_seas_adj_diff_scaled, 
  cemeteries = VIE_cemeteries_seas_adj_diff_scaled, 
  schloss_schonbrunn = VIE_schloss_schonbrunn_seas_adj_diff_scaled,
  universitat_wien = VIE_universitat_wien_seas_adj_diff_scaled, 
  osterreich_ungarn = VIE_osterreich_ungarn_seas_adj_diff_scaled,
  der_kuss = VIE_der_kuss_seas_adj_diff_scaled,
  organisation_erdolexportierender_lander = VIE_organisation_erdolexportierender_lander_seas_adj_diff_scaled,
  donauinsel = VIE_donauinsel_seas_adj_diff_scaled,
  nationalbibliothek = VIE_nationalbibliothek_seas_adj_diff_scaled,
  botschaft_usa = VIE_botschaft_usa_seas_adj_diff_scaled)

plot.ts(VIE_number_of_bookings_seas_adj_diff_scaled, main = "Number of bookings")
plot.ts(VIE_xreg[,1:10])
plot.ts(VIE_xreg[,11:20])
plot.ts(VIE_xreg[,21:30])
plot.ts(VIE_xreg[,31])

auto.arima(VIE_number_of_bookings_seas_adj_diff_scaled, xreg = VIE_xreg)

acf(VIE_number_of_bookings_seas_adj_diff_scaled)
pacf(VIE_number_of_bookings_seas_adj_diff_scaled)

VIE_fit_bookings <- Arima(VIE_number_of_bookings_seas_adj_diff_scaled, order = c(0,0,0), xreg = VIE_xreg, include.mean = F)
VIE_fit_bookings

VIE_res_fit_bookings <- acf(VIE_fit_bookings$residuals, lag.max = 20)
Box.test(VIE_fit_bookings$residuals, lag = 20, type = "Ljung-Box")

acf(VIE_fit_bookings$residuals)
plotForecastErrors(VIE_fit_bookings$residuals)

coeftest(VIE_fit_bookings)

# BRUGES

# Bruges ARR

BRU_buildings_components <- decompose(Bruges_ARR_ts[,10])
plot(BRU_buildings_components)
BRU_buildings_seas_adj <- Bruges_ARR_ts[,10] - BRU_buildings_components$seasonal
plot(BRU_buildings_seas_adj)

BRU_bridges_and_canals_components <- decompose(Bruges_ARR_ts[,12])
plot(BRU_bridges_and_canals_components)
BRU_bridges_and_canals_seas_adj <- Bruges_ARR_ts[,12] - BRU_bridges_and_canals_components$seasonal
plot(BRU_bridges_and_canals_seas_adj)

BRU_sport_components <- decompose(Bruges_ARR_ts[,13])
plot(BRU_sport_components)
BRU_sport_seas_adj <- Bruges_ARR_ts[,13] - BRU_sport_components$seasonal
plot(BRU_sport_seas_adj)

BRU_districts_components <- decompose(Bruges_ARR_ts[,2])
plot(BRU_districts_components)
BRU_districts_seas_adj <- Bruges_ARR_ts[,2] - BRU_districts_components$seasonal
plot(BRU_districts_seas_adj)

BRU_zeebrugge_components <- decompose(Bruges_ARR_ts[,6])
plot(BRU_zeebrugge_components)
BRU_zeebrugge_seas_adj <- Bruges_ARR_ts[,6] - BRU_zeebrugge_components$seasonal
plot(BRU_zeebrugge_seas_adj)

BRU_cercle_brugge_components <- decompose(Bruges_ARR_ts[,9])
plot(BRU_cercle_brugge_components)
BRU_cercle_brugge_seas_adj <- Bruges_ARR_ts[,9] - BRU_cercle_brugge_components$seasonal
plot(BRU_cercle_brugge_seas_adj)

BRU_number_of_passenger_components <- decompose(Bruges_ARR_ts[,15])
plot(BRU_number_of_passenger_components)
BRU_number_of_passenger_seas_adj <- Bruges_ARR_ts[,15] - BRU_number_of_passenger_components$seasonal
plot(BRU_number_of_passenger_seas_adj)

library(tseries)

adf.test(BRU_number_of_passenger_seas_adj)
adf.test(diff(BRU_number_of_passenger_seas_adj))

BRU_number_of_passenger_seas_adj_diff <- diff(BRU_number_of_passenger_seas_adj)

adf.test(BRU_buildings_seas_adj)
adf.test(diff(BRU_buildings_seas_adj))

BRU_buildings_seas_adj_diff <- diff(BRU_buildings_seas_adj)

adf.test(BRU_bridges_and_canals_seas_adj)
adf.test(diff(BRU_bridges_and_canals_seas_adj))

BRU_bridges_and_canals_seas_adj_diff <- diff(BRU_bridges_and_canals_seas_adj)

adf.test(BRU_sport_seas_adj)
adf.test(diff(BRU_sport_seas_adj))

BRU_sport_seas_adj_diff <- diff(BRU_sport_seas_adj)

adf.test(BRU_districts_seas_adj)
adf.test(diff(BRU_districts_seas_adj))

BRU_districts_seas_adj_diff <- diff(BRU_districts_seas_adj)

adf.test(BRU_zeebrugge_seas_adj)
adf.test(diff(BRU_zeebrugge_seas_adj))

BRU_zeebrugge_seas_adj_diff <- diff(BRU_zeebrugge_seas_adj)

adf.test(BRU_cercle_brugge_seas_adj)
adf.test(diff(BRU_cercle_brugge_seas_adj))
adf.test(diff(diff(BRU_cercle_brugge_seas_adj)))

BRU_cercle_brugge_seas_adj_diff <- diff(BRU_cercle_brugge_seas_adj, differences = 2)

BRU_number_of_passenger_seas_adj_diff_scaled <- scale(BRU_number_of_passenger_seas_adj_diff[-1])

BRU_buildings_seas_adj_diff_scaled <- scale(BRU_buildings_seas_adj_diff[-1])
BRU_bridges_and_canals_seas_adj_diff_scaled <- scale(BRU_bridges_and_canals_seas_adj_diff[-1])
BRU_sport_seas_adj_diff_scaled <- scale(BRU_sport_seas_adj_diff[-1])
BRU_districts_seas_adj_diff_scaled <- scale(BRU_districts_seas_adj_diff[-1])
BRU_zeebrugge_seas_adj_diff_scaled <- scale(BRU_zeebrugge_seas_adj_diff[-1])
BRU_cercle_brugge_seas_adj_diff_scaled <- scale(BRU_cercle_brugge_seas_adj_diff)

BRU_xreg <- data.frame(buildings = BRU_buildings_seas_adj_diff_scaled, 
                       bridges_and_canals = BRU_bridges_and_canals_seas_adj_diff_scaled, 
                       sport = BRU_sport_seas_adj_diff_scaled,
                       districts = BRU_districts_seas_adj_diff_scaled,
                       zeebrugge = BRU_zeebrugge_seas_adj_diff_scaled,
                       cercle_brugge = BRU_cercle_brugge_seas_adj_diff_scaled)

acf(BRU_number_of_passenger_seas_adj_diff_scaled)
pacf(BRU_number_of_passenger_seas_adj_diff_scaled)

BRU_fit_passengers <- Arima(BRU_number_of_passenger_seas_adj_diff_scaled, order = c(1,0,0), xreg = BRU_xreg, include.mean = F)
BRU_fit_passengers

BRU_res_fit_passengers <- acf(BRU_fit_passengers$residuals, lag.max = 20)
Box.test(BRU_fit_passengers$residuals, lag = 20, type = "Ljung-Box")

acf(BRU_fit_passengers$residuals)
plotForecastErrors(BRU_fit_passengers$residuals)

coeftest(BRU_fit_passengers)

# Bruges OVER

BRU_streets_and_streams_components <- decompose(Bruges_OVER_ts[,7])
plot(BRU_streets_and_streams_components)
BRU_streets_and_streams_seas_adj <- Bruges_OVER_ts[,7] - BRU_streets_and_streams_components$seasonal
plot(BRU_streets_and_streams_seas_adj)

BRU_buildings_components <- decompose(Bruges_OVER_ts[,10])
plot(BRU_buildings_components)
BRU_buildings_seas_adj <- Bruges_OVER_ts[,10] - BRU_buildings_components$seasonal
plot(BRU_buildings_seas_adj)

BRU_bridges_and_canals_components <- decompose(Bruges_OVER_ts[,12])
plot(BRU_bridges_and_canals_components)
BRU_bridges_and_canals_seas_adj <- Bruges_OVER_ts[,12] - BRU_bridges_and_canals_components$seasonal
plot(BRU_bridges_and_canals_seas_adj)

BRU_districts_components <- decompose(Bruges_OVER_ts[,2])
plot(BRU_districts_components)
BRU_districts_seas_adj <- Bruges_OVER_ts[,2] - BRU_districts_components$seasonal
plot(BRU_districts_seas_adj)

BRU_companies_components <- decompose(Bruges_OVER_ts[,4])
plot(BRU_companies_components)
BRU_companies_seas_adj <- Bruges_OVER_ts[,4] - BRU_companies_components$seasonal
plot(BRU_companies_seas_adj)

BRU_zeebrugge_components <- decompose(Bruges_OVER_ts[,6])
plot(BRU_zeebrugge_components)
BRU_zeebrugge_seas_adj <- Bruges_OVER_ts[,6] - BRU_zeebrugge_components$seasonal
plot(BRU_zeebrugge_seas_adj)

BRU_belfort_van_brugge_components <- decompose(Bruges_OVER_ts[,8])
plot(BRU_belfort_van_brugge_components)
BRU_belfort_van_brugge_seas_adj <- Bruges_OVER_ts[,8] - BRU_belfort_van_brugge_components$seasonal
plot(BRU_belfort_van_brugge_seas_adj)

BRU_number_of_bookings_components <- decompose(Bruges_OVER_ts[,15])
plot(BRU_number_of_bookings_components)
BRU_number_of_bookings_seas_adj <- Bruges_OVER_ts[,15] - BRU_number_of_bookings_components$seasonal
plot(BRU_number_of_bookings_seas_adj)

adf.test(BRU_number_of_bookings_seas_adj)
adf.test(diff(BRU_number_of_bookings_seas_adj))

BRU_number_of_bookings_seas_adj_diff <- diff(BRU_number_of_bookings_seas_adj)

adf.test(BRU_streets_and_streams_seas_adj)
adf.test(diff(BRU_streets_and_streams_seas_adj))
adf.test(diff(diff(BRU_streets_and_streams_seas_adj)))

BRU_streets_and_streams_seas_adj_diff <- diff(BRU_streets_and_streams_seas_adj, differences = 2)

adf.test(BRU_buildings_seas_adj)
adf.test(diff(BRU_buildings_seas_adj))

BRU_buildings_seas_adj_diff <- diff(BRU_buildings_seas_adj)

adf.test(BRU_bridges_and_canals_seas_adj)
adf.test(diff(BRU_bridges_and_canals_seas_adj))

BRU_bridges_and_canals_seas_adj_diff <- diff(BRU_bridges_and_canals_seas_adj)

adf.test(BRU_districts_seas_adj)
adf.test(diff(BRU_districts_seas_adj))

BRU_districts_seas_adj_diff <- diff(BRU_districts_seas_adj)

adf.test(BRU_companies_seas_adj)
adf.test(diff(BRU_companies_seas_adj))

BRU_companies_seas_adj_diff <- diff(BRU_companies_seas_adj)

adf.test(BRU_zeebrugge_seas_adj)
adf.test(diff(BRU_zeebrugge_seas_adj))

BRU_zeebrugge_seas_adj_diff <- diff(BRU_zeebrugge_seas_adj)

adf.test(BRU_belfort_van_brugge_seas_adj)
adf.test(diff(BRU_belfort_van_brugge_seas_adj))

BRU_belfort_van_brugge_seas_adj_diff <- diff(BRU_belfort_van_brugge_seas_adj)

BRU_number_of_bookings_seas_adj_diff_scaled <- scale(BRU_number_of_bookings_seas_adj_diff[-1])

BRU_streets_and_streams_seas_adj_diff_scaled <- scale(BRU_streets_and_streams_seas_adj_diff)
BRU_buildings_seas_adj_diff_scaled <- scale(BRU_buildings_seas_adj_diff[-1])
BRU_bridges_and_canals_seas_adj_diff_scaled <- scale(BRU_bridges_and_canals_seas_adj_diff[-1])
BRU_districts_seas_adj_diff_scaled <- scale(BRU_districts_seas_adj_diff[-1])
BRU_companies_seas_adj_diff_scaled <- scale(BRU_companies_seas_adj_diff[-1])
BRU_zeebrugge_seas_adj_diff_scaled <- scale(BRU_zeebrugge_seas_adj_diff[-1])
BRU_belfort_van_brugge_seas_adj_diff_scaled <- scale(BRU_belfort_van_brugge_seas_adj_diff[-1])

BRU_xreg <- data.frame(streets_and_streams = BRU_streets_and_streams_seas_adj_diff_scaled, 
                       buildings = BRU_buildings_seas_adj_diff_scaled, 
                       bridges_and_canals = BRU_bridges_and_canals_seas_adj_diff_scaled, 
                       districts = BRU_districts_seas_adj_diff_scaled,
                       companies = BRU_companies_seas_adj_diff_scaled,
                       zeebrugge = BRU_zeebrugge_seas_adj_diff_scaled,
                       belfort_van_brugge = BRU_belfort_van_brugge_seas_adj_diff_scaled)

acf(BRU_number_of_bookings_seas_adj_diff_scaled)
pacf(BRU_number_of_bookings_seas_adj_diff_scaled)

BRU_fit_bookings <- Arima(BRU_number_of_bookings_seas_adj_diff_scaled, order = c(1,0,0), xreg = BRU_xreg, include.mean = F)
BRU_fit_bookings

BRU_res_fit_bookings <- acf(BRU_fit_bookings$residuals, lag.max = 20)
Box.test(BRU_fit_bookings$residuals, lag = 20, type = "Ljung-Box")

acf(BRU_fit_bookings$residuals)
plotForecastErrors(BRU_fit_bookings$residuals)

coeftest(BRU_fit_bookings)

# BARCELONA

# Barcelona ARR

BAR_sport_components <- decompose(Barcelona_ARR_ts[,11])
plot(BAR_sport_components)
BAR_sport_seas_adj <- Barcelona_ARR_ts[,11] - BAR_sport_components$seasonal
plot(BAR_sport_seas_adj)

BAR_gran_teatro_del_liceo_components <- decompose(Barcelona_ARR_ts[,4])
plot(BAR_gran_teatro_del_liceo_components)
BAR_gran_teatro_del_liceo_seas_adj <- Barcelona_ARR_ts[,4] - BAR_gran_teatro_del_liceo_components$seasonal
plot(BAR_gran_teatro_del_liceo_seas_adj)

BAR_theatres_components <- decompose(Barcelona_ARR_ts[,13])
plot(BAR_theatres_components)
BAR_theatres_seas_adj <- Barcelona_ARR_ts[,13] - BAR_theatres_components$seasonal
plot(BAR_theatres_seas_adj)

BAR_institutions_organizations_components <- decompose(Barcelona_ARR_ts[,6])
plot(BAR_institutions_organizations_components)
BAR_institutions_organizations_seas_adj <- Barcelona_ARR_ts[,6] - BAR_institutions_organizations_components$seasonal
plot(BAR_institutions_organizations_seas_adj)

BAR_parks_components <- decompose(Barcelona_ARR_ts[,9])
plot(BAR_parks_components)
BAR_parks_seas_adj <- Barcelona_ARR_ts[,9] - BAR_parks_components$seasonal
plot(BAR_parks_seas_adj)

BAR_futbol_club_barcelona_components <- decompose(Barcelona_ARR_ts[,15])
plot(BAR_futbol_club_barcelona_components)
BAR_futbol_club_barcelona_seas_adj <- Barcelona_ARR_ts[,15] - BAR_futbol_club_barcelona_components$seasonal
plot(BAR_futbol_club_barcelona_seas_adj)

BAR_number_of_passenger_components <- decompose(Barcelona_ARR_ts[,18])
plot(BAR_number_of_passenger_components)
BAR_number_of_passenger_seas_adj <- Barcelona_ARR_ts[,18] - BAR_number_of_passenger_components$seasonal
plot(BAR_number_of_passenger_seas_adj)

adf.test(BAR_number_of_passenger_seas_adj)
adf.test(diff(BAR_number_of_passenger_seas_adj))

BAR_number_of_passenger_seas_adj_diff <- diff(BAR_number_of_passenger_seas_adj)

adf.test(BAR_sport_seas_adj)
adf.test(diff(BAR_sport_seas_adj))

BAR_sport_seas_adj_diff <- diff(BAR_sport_seas_adj)

adf.test(BAR_gran_teatro_del_liceo_seas_adj)
adf.test(diff(BAR_gran_teatro_del_liceo_seas_adj))

BAR_gran_teatro_del_liceo_seas_adj_diff <- diff(BAR_gran_teatro_del_liceo_seas_adj)

adf.test(BAR_theatres_seas_adj)
adf.test(diff(BAR_theatres_seas_adj))
adf.test(diff(diff(BAR_theatres_seas_adj)))

BAR_theatres_seas_adj_diff <- diff(BAR_theatres_seas_adj, differences = 2)

adf.test(BAR_institutions_organizations_seas_adj)
adf.test(diff(BAR_institutions_organizations_seas_adj))

BAR_institutions_organizations_seas_adj_diff <- diff(BAR_institutions_organizations_seas_adj)

adf.test(BAR_parks_seas_adj)
adf.test(diff(BAR_parks_seas_adj))

BAR_parks_seas_adj_diff <- diff(BAR_parks_seas_adj)

adf.test(BAR_futbol_club_barcelona_seas_adj)
adf.test(diff(BAR_futbol_club_barcelona_seas_adj))

BAR_futbol_club_barcelona_seas_adj_diff <- diff(BAR_futbol_club_barcelona_seas_adj)

BAR_number_of_passenger_seas_adj_diff <- BAR_number_of_passenger_seas_adj_diff[6:47]

BAR_number_of_passenger_seas_adj_diff_scaled <- scale(BAR_number_of_passenger_seas_adj_diff)

BAR_sport_seas_adj_diff <- BAR_sport_seas_adj_diff[6:47]
BAR_gran_teatro_del_liceo_seas_adj_diff <- BAR_gran_teatro_del_liceo_seas_adj_diff[6:47]
BAR_theatres_seas_adj_diff <- BAR_theatres_seas_adj_diff[6:47]
BAR_institutions_organizations_seas_adj_diff <- BAR_institutions_organizations_seas_adj_diff[6:47]
BAR_parks_seas_adj_diff <- BAR_parks_seas_adj_diff[6:47]
BAR_futbol_club_barcelona_seas_adj_diff <- BAR_futbol_club_barcelona_seas_adj_diff[6:47]

BAR_sport_seas_adj_diff_scaled <- scale(BAR_sport_seas_adj_diff)
BAR_gran_teatro_del_liceo_seas_adj_diff_scaled <- scale(BAR_gran_teatro_del_liceo_seas_adj_diff)
BAR_theatres_seas_adj_diff_scaled <- scale(BAR_theatres_seas_adj_diff)
BAR_institutions_organizations_seas_adj_diff_scaled <- scale(BAR_institutions_organizations_seas_adj_diff)
BAR_parks_seas_adj_diff_scaled <- scale(BAR_parks_seas_adj_diff)
BAR_futbol_club_barcelona_seas_adj_diff_scaled <- scale(BAR_futbol_club_barcelona_seas_adj_diff)

BAR_xreg<- data.frame(sport = BAR_sport_seas_adj_diff_scaled, 
                      gran_teatro_del_liceo = BAR_gran_teatro_del_liceo_seas_adj_diff_scaled,     
                      theatres = BAR_theatres_seas_adj_diff_scaled, 
                      institutions_organizations = BAR_institutions_organizations_seas_adj_diff_scaled, 
                      parks = BAR_parks_seas_adj_diff_scaled, 
                      futbol_club_barcelona = BAR_futbol_club_barcelona_seas_adj_diff_scaled)

acf(BAR_number_of_passenger_seas_adj_diff_scaled)
pacf(BAR_number_of_passenger_seas_adj_diff_scaled)

BAR_fit_passengers <- Arima(BAR_number_of_passenger_seas_adj_diff_scaled, order = c(0,0,0), xreg = BAR_xreg, include.mean = F)
BAR_fit_passengers

BAR_res_fit_passengers <- acf(BAR_fit_passengers$residuals, lag.max = 20)
Box.test(BAR_fit_passengers$residuals, lag = 20, type = "Ljung-Box")

acf(BAR_fit_passengers$residuals)
plotForecastErrors(BAR_fit_passengers$residuals)

coeftest(BAR_fit_passengers)

# Barcelona OVER

BAR_sport_components <- decompose(Barcelona_OVER_ts[,10])
plot(BAR_sport_components)
BAR_sport_seas_adj <- Barcelona_OVER_ts[,10] - BAR_sport_components$seasonal
plot(BAR_sport_seas_adj)

BAR_parks_components <- decompose(Barcelona_OVER_ts[,8])
plot(BAR_parks_components)
BAR_parks_seas_adj <- Barcelona_OVER_ts[,8] - BAR_parks_components$seasonal
plot(BAR_parks_seas_adj)

BAR_futbol_club_barcelona_components <- decompose(Barcelona_OVER_ts[,14])
plot(BAR_futbol_club_barcelona_components)
BAR_futbol_club_barcelona_seas_adj <- Barcelona_OVER_ts[,14] - BAR_futbol_club_barcelona_components$seasonal
plot(BAR_futbol_club_barcelona_seas_adj)

BAR_number_of_bookings_components <- decompose(Barcelona_OVER_ts[,17])
plot(BAR_number_of_bookings_components)
BAR_number_of_bookings_seas_adj <- Barcelona_OVER_ts[,17] - BAR_number_of_bookings_components$seasonal
plot(BAR_number_of_bookings_seas_adj)


adf.test(BAR_number_of_bookings_seas_adj)

BAR_number_of_bookings_seas_adj_diff <- diff(BAR_number_of_bookings_seas_adj)

adf.test(BAR_sport_seas_adj)
adf.test(diff(BAR_sport_seas_adj))
BAR_sport_seas_adj_diff <- diff(BAR_sport_seas_adj)

adf.test(BAR_parks_seas_adj)
adf.test(diff(BAR_parks_seas_adj))
BAR_parks_seas_adj_diff <- diff(BAR_parks_seas_adj)

adf.test(BAR_futbol_club_barcelona_seas_adj)
adf.test(diff(BAR_futbol_club_barcelona_seas_adj))
BAR_futbol_club_barcelona_seas_adj_diff <- diff(BAR_futbol_club_barcelona_seas_adj)

BAR_number_of_bookings_seas_adj_diff <- BAR_number_of_bookings_seas_adj_diff[6:47]

BAR_number_of_bookings_seas_adj_diff_scaled <- scale(BAR_number_of_bookings_seas_adj_diff)

BAR_sport_seas_adj_diff <- BAR_sport_seas_adj_diff[6:47]
BAR_parks_seas_adj_diff <- BAR_parks_seas_adj_diff[6:47]
BAR_futbol_club_barcelona_seas_adj_diff <- BAR_futbol_club_barcelona_seas_adj_diff[6:47]

BAR_sport_seas_adj_diff_scaled <- scale(BAR_sport_seas_adj_diff)
BAR_parks_seas_adj_diff_scaled <- scale(BAR_parks_seas_adj_diff)
BAR_futbol_club_barcelona_seas_adj_diff_scaled <- scale(BAR_futbol_club_barcelona_seas_adj_diff)

BAR_xreg<- data.frame(sport = BAR_sport_seas_adj_diff_scaled, 
                      parks = BAR_parks_seas_adj_diff_scaled, 
                      futbol_club_barcelona = BAR_futbol_club_barcelona_seas_adj_diff_scaled)

acf(BAR_number_of_bookings_seas_adj_diff_scaled)
pacf(BAR_number_of_bookings_seas_adj_diff_scaled)

BAR_fit_bookings <- Arima(BAR_number_of_bookings_seas_adj_diff_scaled, order = c(0,0,0), xreg = BAR_xreg, include.mean = F)
BAR_fit_bookings

BAR_res_fit_bookings <- acf(BAR_fit_bookings$residuals, lag.max = 20)
Box.test(BAR_fit_bookings$residuals, lag = 20, type = "Ljung-Box")

acf(BAR_fit_bookings$residuals)
plotForecastErrors(BAR_fit_bookings$residuals)

coeftest(BAR_fit_bookings)
