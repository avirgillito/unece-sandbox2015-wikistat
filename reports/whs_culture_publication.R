# Attach packages used
library(dplyr)
library(reshape2)
library(urltools)
library(ggplot2)
library(rworldmap)
source("scripts/r/whs_data_man.R")

# Constants
WHS_FILE <- paste0(WHS_DIR, "/whs.csv")
ARTICLES_FILE <- paste0(WHS_DIR, "/whs_redirect_targets_origins.csv")
WIKISTATS_FILE <- paste0(WHS_DIR, "/whs_wikistats_month.csv")

WHS_CULTURE_DATASET <- "reports/culture/whs_culture.csv"
WHS_CULTURE_MAP_DATA <- "reports/culture/whs_culture_map.csv"
WHS_CULTURE_MAP <- "reports/culture/whs_culture_map.png"
WHS_CULTURE_TS_DATA <- "reports/culture/whs_culture_ts.csv"

EUR_LAT_MIN <- 36
EUR_LAT_MAX <- 71
EUR_LONG_MIN <- -20
EUR_LONG_MAX <- 59

# Read UNESCO official list of WHS and restrict it to sites nominated before 2015
whs <- read_csv(WHS_FILE, fileEncoding="UTF-8") %>%
	mutate(whs_id = as.numeric(as.character(id_number))) %>%
	select(whs_id, latitude, longitude, site, category, date_inscribed) %>%
	filter(category %in% c("Cultural", "Mixed"), date_inscribed < 2015) %>%
	select(-date_inscribed)

# Read list of Wikipedia articles related to WHS
whs_articles <- read_csv(ARTICLES_FILE, fileEncoding="UTF-8") %>%
	mutate(article = normalize(as.character(article))) %>%
	select(whs_id, lang, article) %>%
	distinct()

# Delete 3 mistaken records assigning articles 'Ragusa_(Croácia)', 'Dubrovnique'
# and 'Dubrovnik' in Portuguese Wikipedia to WHS id 1024 ('Late Baroque Towns of 
# the Val di Noto (South-Eastern Sicily)')
whs_articles <- whs_articles %>%
	filter(!(lang == "pt" & 
		 	article %in% c("Dubrovnik", 
		 		       "Dubrovnique", 
		 		       "Ragusa_(Croácia)") & 
		 	whs_id == 1024))

# Get wikistats (Wikipedia page views statistics)
whs_wikistats <- 
	
	# Read wikistats data file
	read_csv(WIKISTATS_FILE, fileEncoding="UTF-8") %>%	
	
	# Join WHS code with wikistats
	left_join(whs_articles, by = c("lang", "article")) %>%
	
	# Aggregate wikistats by WHS
	group_by(lang, whs_id, month) %>%
	summarise(value = sum(value)) %>%
	
	# Link to main WHS table
	right_join(whs, by = "whs_id")

# Save dataset to disk
write.csv(whs_wikistats, WHS_CULTURE_DATASET, row.names=FALSE, fileEncoding="utf-8")

###############
# Outputs

# 1. Create map

## Select data
whs_culture_map <- whs_wikistats %>%
	
	# Restrict whs to Europe and wikistats to 2015
	filter(latitude >= EUR_LAT_MIN, latitude <= EUR_LAT_MAX, 
	       longitude >= EUR_LONG_MIN, longitude <= EUR_LONG_MAX,
	       substr(month, 2, 5) == "2015") %>%
	
	# Aggregate Wikipedia language versions and months
	group_by(whs_id, longitude, latitude) %>%
	summarise(value = sum(value))

## Save data to disk
write.csv(whs_culture_map, WHS_CULTURE_MAP_DATA, row.names=FALSE, fileEncoding="utf-8")

## Create map for control purposes
newmap <- getMap(resolution = "low")
map_plot <- ggplot(data = newmap) + 
	xlim(EUR_LONG_MIN, EUR_LONG_MAX) + 
	ylim(EUR_LAT_MIN, EUR_LAT_MAX) +
	geom_path(aes(x=long, y=lat, group=group), color='gray') + coord_equal() +
	geom_point(aes(x = longitude, y = latitude, size = value), data = whs_culture_map, alpha = .5)
ggsave(WHS_CULTURE_MAP, map_plot)


# 2. Create time-series

## Select data
whs_culture_ts <- whs_wikistats %>%
	
	# Aggregate Wikipedia language versions and months
	group_by(month) %>%
	summarise(value = sum(value))

## Save data to disk
write.csv(whs_culture_ts, WHS_CULTURE_TS_DATA, row.names=FALSE, fileEncoding="utf-8")



