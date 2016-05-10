options(scipen = 999)

# Attach packages used
library(dplyr)
library(reshape2)
library(urltools)
library(ggplot2)
library(rworldmap)
source("scripts/r/whs_data_man.R")
source("scripts/r/whs_get_all_redirects.R")

# Constants
WHS_FILE <- paste0(WHS_DIR, "/whs.csv")
ARTICLES_FILE <- paste0(WHS_DIR, "/whs_redirect_targets_origins.csv")
WIKISTATS_FILE <- paste0(WHS_DIR, "/whs_wikistats_month.csv")
COUNTRY_CODES_FILE <- paste0(WHS_DIR, "/country_codes.csv")
MAIN_PAGE_WIKISTATS_FILE <- "main_page_wikistats_month.csv"
WIKIPEDIA_TS_FILE <- paste0(WHS_DIR, "/wikipedia_ts_file.csv")
  
WHS_CULTURE_DATASET <- "reports/culture/whs_culture.csv"
WHS_CULTURE_MAP_DATA <- "reports/culture/whs_culture_map.csv"
WHS_CULTURE_MAP <- "reports/culture/whs_culture_map.png"
WHS_CULTURE_TS_DATA <- "reports/culture/whs_culture_ts.csv"
WHS_CULTURE_TS_DATA_AFRICA <- "reports/culture/whs_culture_ts_africa.csv"
WHS_CULTURE_TS_DATA_ASIA <- "reports/culture/whs_culture_ts_asia.csv"
WHS_CULTURE_TS_DATA_AMERICA <- "reports/culture/whs_culture_ts_america.csv"
WHS_CULTURE_TS_DATA_EUROPA <- "reports/culture/whs_culture_ts_europa.csv"
WHS_CULTURE_TS_DATA_OCEANIA <- "reports/culture/whs_culture_ts_oceania.csv"
WHS_CULTURE_TS_PLOT <- "reports/culture/whs_culture_ts_plot.png"
WHS_TOP_20 <- "reports/culture/whs_top_20.csv"
WHS_TOP_20_PLOT_LONG <- "reports/culture/whs_top_20_plot_LONG.png"
WHS_TOP_20_PLOT_MEDIUM <- "reports/culture/whs_top_20_plot_MEDIUM.png"
WHS_TOP_20_PLOT_SHORT <- "reports/culture/whs_top_20_plot_SHORT.png"
WHS_TOP_5_EN <- "reports/culture/whs_top_5_en.csv"
WHS_TOP_5_EN_PLOT <- "reports/culture/whs_top_5_en_plot.png"
WHS_TOP_5_ES <- "reports/culture/whs_top_5_es.csv"
WHS_TOP_5_ES_PLOT_LONG <- "reports/culture/whs_top_5_es_plot_LONG.png"
WHS_TOP_5_ES_PLOT_SHORT <- "reports/culture/whs_top_5_es_plot_SHORT.png"
WHS_TOP_5_DE <- "reports/culture/whs_top_5_de.csv"
WHS_TOP_5_DE_PLOT <- "reports/culture/whs_top_5_de_plot.png"
WHS_TOP_5_FR <- "reports/culture/whs_top_5_fr.csv"
WHS_TOP_5_FR_PLOT <- "reports/culture/whs_top_5_fr_plot.png"
WHS_TOP_5_RU <- "reports/culture/whs_top_5_ru.csv"
WHS_TOP_5_RU_PLOT <- "reports/culture/whs_top_5_ru_plot.png"
WHS_TOP_5_IT <- "reports/culture/whs_top_5_it.csv"
WHS_TOP_5_IT_PLOT <- "reports/culture/whs_top_5_it_plot.png"

EUR_LAT_MIN <- 36
EUR_LAT_MAX <- 71
EUR_LONG_MIN <- -20
EUR_LONG_MAX <- 59

# Read UNESCO official list of WHS and restrict it to sites nominated before 2015
whs <- read_csv(WHS_FILE, fileEncoding="utf-8") %>%
  mutate(whs_id = as.numeric(as.character(id_number))) %>%
  select(whs_id, latitude, longitude, site, category, date_inscribed, iso_code) %>%
  filter(category %in% c("Cultural", "Mixed"), date_inscribed < 2015) %>%
  select(-date_inscribed)

# Read list of Wikipedia articles related to WHS
whs_articles <- read_csv(ARTICLES_FILE, fileEncoding="utf-8") %>%
  mutate(article = normalize(as.character(article))) %>%
  select(whs_id, lang, article) %>%
  distinct()

# Delete 3 mistaken records assigning articles 'Ragusa_(CroÃ¡cia)', 'Dubrovnique'
# and 'Dubrovnik' in Portuguese Wikipedia to WHS id 1024 ('Late Baroque Towns of 
# the Val di Noto (South-Eastern Sicily)')
whs_articles <- whs_articles %>%
  filter(!(lang == "pt" & 
             article %in% c("Dubrovnik", 
                            "Dubrovnique", 
                            "Ragusa_(CroÃ¡cia)") & 
             whs_id == 1024))

# Get wikistats (Wikipedia page views statistics)
whs_wikistats <- 
  
  # Read wikistats data file
  read_csv(WIKISTATS_FILE, fileEncoding="utf-8") %>%	
  
  # Join WHS code with wikistats
  left_join(whs_articles, by = c("lang", "article")) %>%
  
  # Aggregate wikistats by WHS
  group_by(lang, whs_id, time) %>%
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
         substr(time, 2, 5) == "2015") %>%
  
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


# 2. Time-series of monthly page views by continent 

## Extraction of wikistats about 'Main Page' in different languages

# Get all language versions of Main Page
lang <- c("bg", "cs", "da", "de", "el",
          "en", "es", "et", "fi", "fr",
          "ga", "hr", "hu", "is", "it", 
          "lt", "lv", "mk", "mt", "nl",
          "no", "pl", "pt", "ro", "ru", 
          "sk", "sl", "sq", "sr", "sv", 
          "tr") 

article <- c("Начална_страница", "Hlavní_strana", "Forside", "Wikipedia:Hauptseite", "Πύλη:Κύρια", 
             "Main_Page", "Wikipedia:Portada", "Esileht", "Wikipedia:Etusivu", "Wikipédia:Accueil_principal", 
             "Príomhleathanach", "Glavna_stranica", "Kezdőlap", "Forsíða", "Pagina_principale", 
             "Pagrindinis_puslapis", "Sākumlapa", "Главна_страница", "Il-Paġna_prinċipali", "Hoofdpagina", 
             "Portal:Forside", "Wikipedia:Strona_główna", "Wikipédia:Página_principal", "Pagina_principală", "Заглавная_страница", 
             "Hlavná_stránka", "Glavna_stran", "Faqja_kryesore", "Главна_страна", "Portal:Huvudsida", 
             "Ana_Sayfa") 

main_page <- data.frame(lang, article)
main_page$article <- as.character(main_page$article)

# Get articles wiki markup
main_page <- main_page %>%
  mutate(wm = getWikiMarkup(article, lang),
         target = "",
         origins_checked = FALSE)

# Add redirects targets and origins
main_page <- main_page %>%
  add_redirect_targets() %>%
  add_redirect_origins() %>%
  select(-wm)

# Create a text file for each group of words in each language
articles <- main_page$article
lang <- main_page$lang
make_extract_config(articles, lang)

# After running this script, you will receive instructions on how to extract page views 

# DONT'T RUN!!!!! Load the wikistats into R (this function has PROBLEMS in normalize function)
main_page_wikistats <- read_wikistats()

# Alternative way to load wikistats into R without having errors 
hdfs.init()
data_file = paste0("hdfs:/user/", Sys.info()[["user"]], "/many_lang_extraction/part-m-00000")
header_file = paste0("hdfs:/user/", Sys.info()[["user"]], "/many_lang_extraction/part-m-00001")
header <- read_lines(header_file) %>%
  strsplit("[\t| ]") %>%
  unlist() %>%
  gsub(x = ., pattern = "'", replacement = "")
header <- paste0("T", header)
header[1:2] <- c("project", "article")
main_page_wikistats <- read_table(data_file, col.names = header, quote = "")
# run these lines one by one
a <- normalize(main_page_wikistats$article[1:500])
b <- normalize(main_page_wikistats$article[501:1000])
c <- normalize(main_page_wikistats$article[1001:1500])
d <- normalize(main_page_wikistats$article[1501:1987])
main_page_wikistats$article <- c(a,b,c,d)

main_page_wikistats <- main_page_wikistats %>%
  transform(lang = substr(project, 1, 2)) %>%
  select(-project) %>%
  melt(id.vars = c("lang", "article"), variable.name = "time") %>%
  group_by(lang, article, time) %>%
  summarise(value = sum(value))

## Save data to disk
write.csv(main_page_wikistats, MAIN_PAGE_WIKISTATS_FILE, row.names=FALSE, fileEncoding="utf-8")

## Create time-series

# Time series of Main Page

# Summarize all Main Page in all languages
main_page_ts <- main_page_wikistats %>%
  group_by(time) %>%
  summarise(value = sum(value))
  
##### WARNING! We do not consider Main Page anymore, we consider pageviews of the entire Wikipedia

# Time series of entire Wikipedia
wikipedia_ts <- read_csv(WIKIPEDIA_TS_FILE) %>%
  melt(variable.name = "time")

names(wikipedia_ts) <- c("time", "lang", "value")

wikipedia_ts <- wikipedia_ts %>%
  group_by(time) %>%
  summarise(value = sum(value))

# Time series of WHS

# Add data for continents
country_codes <- read_csv(COUNTRY_CODES_FILE)

# Summarize all WHS in alla languages
whs_culture_ts <- whs_wikistats 
  
whs_culture_ts$iso_code <- substr(whs_culture_ts$iso_code, 1,2)

# Unify the two datasets and aggregate by months and continent
whs_culture_ts <- whs_culture_ts %>%
  left_join(country_codes, by="iso_code") %>%
  group_by(time, continent) %>%
  summarise(value = sum(value)) 

# Create one dataset for each continent and add column with index
whs_culture_ts_africa <- whs_culture_ts %>%
  filter(continent == "Africa")
whs_culture_ts_africa$index <- whs_culture_ts_africa$value/wikipedia_ts$value
whs_culture_ts_africa <- select(whs_culture_ts_africa, time, index) 
names(whs_culture_ts_africa)[2] <- "africa"

whs_culture_ts_america <- whs_culture_ts %>%
  filter(continent == "America")
whs_culture_ts_america <- whs_culture_ts_america[-49,]
whs_culture_ts_america$index <- whs_culture_ts_america$value/wikipedia_ts$value
whs_culture_ts_america <- select(whs_culture_ts_america, time, index) 
names(whs_culture_ts_america)[2] <- "america"

whs_culture_ts_asia <- whs_culture_ts %>%
  filter(continent == "Asia")
whs_culture_ts_asia <- whs_culture_ts_asia[-49,]
whs_culture_ts_asia$index <- whs_culture_ts_asia$value/wikipedia_ts$value
whs_culture_ts_asia <- select(whs_culture_ts_asia, time, index) 
names(whs_culture_ts_asia)[2] <- "asia"

whs_culture_ts_europe <- whs_culture_ts %>%
  filter(continent == "Europe")
whs_culture_ts_europe <- whs_culture_ts_europe[-49,]
whs_culture_ts_europe$index <- whs_culture_ts_europe$value/wikipedia_ts$value
whs_culture_ts_europe <- select(whs_culture_ts_europe, time, index) 
names(whs_culture_ts_europe)[2] <- "europe"

whs_culture_ts_oceania <- whs_culture_ts %>%
  filter(continent == "Oceania")
whs_culture_ts_oceania$index <- whs_culture_ts_oceania$value/wikipedia_ts$value
whs_culture_ts_oceania <- select(whs_culture_ts_oceania, time, index) 
names(whs_culture_ts_oceania)[2] <- "oceania"

# Create one final dataset unified by month with the global time-series (all continents aggregated) 
# and the time-series for each continent (in a format suitable for ggplot2)

# First read data and group by month
whs_culture_ts <- whs_culture_ts %>%
  group_by(time) %>%
  summarise(value = sum(value))

# Create index for global variable
whs_culture_ts <- whs_culture_ts[-49,]
whs_culture_ts$index <- whs_culture_ts$value/wikipedia_ts$value
whs_culture_ts <- select(whs_culture_ts, time, index) 
names(whs_culture_ts)[2] <- "global"

# Create dataframe with global variable and a variable for each continent
whs_culture_ts <- data.frame(whs_culture_ts$time, whs_culture_ts$global, whs_culture_ts_africa$africa, whs_culture_ts_america$america, whs_culture_ts_asia$asia, whs_culture_ts_europe$europe, whs_culture_ts_oceania$oceania)
names(whs_culture_ts) <- c("time", "Global", "Africa", "America", "Asia", "Europe", "Oceania")

# Adjust the way the time variable is displayed
whs_culture_ts <- melt(whs_culture_ts, id = "time") %>%
  mutate(year = substr(time, 2, 5)) %>%
  mutate(month = substr(time, 7, 8)) 
whs_culture_ts$time <- paste(whs_culture_ts$year, whs_culture_ts$month)
whs_culture_ts$year <- NULL
whs_culture_ts$month <- NULL

# Save data to disk
write.csv(whs_culture_ts, WHS_CULTURE_TS_DATA, row.names=FALSE, fileEncoding="utf-8")

# Create plot for time-series
whs_culture_ts_plot <- ggplot(whs_culture_ts, aes(x = time, y = value, group = variable, colour = variable)) +
                              geom_line () +
                              ggtitle("Index of page views of Wikipedia articles related to World Heritage Sites") +
                              xlab("") +
                              ylab("index") +
                              theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
                              scale_x_discrete(breaks = c("2012 03", "2012 07", "2012 11", 
                                                          "2013 03", "2013 07", "2013 11",
                                                          "2014 03", "2014 07", "2014 11",
                                                          "2015 03", "2015 07", "2015 11")) 


# Save the chart
ggsave(WHS_CULTURE_TS_PLOT, whs_culture_ts_plot)

# 3. Top 20 WHS in 2015

options(scipen = 999)

## Select data
whs_2015 <- whs_wikistats %>%
  
  # Select only pageviews of 2015
  filter(substr(time, 2, 5) == "2015")

# Consider only the first iso code (in case of WHS on multiple countries)
whs_2015$iso_code <- substr(whs_2015$iso_code, 1,2)

# Add data for EU and non EU
country_codes <- read_csv(COUNTRY_CODES_FILE)

# Unify the two datasets
whs_top_20 <- 
  
  # Unify by iso code
  left_join(whs_2015, country_codes, by="iso_code") %>%
  
  # Sum by WHS
  group_by(whs_id, site, EU) %>%
  summarise(value = sum(value)) %>%
  group_by() %>%
  arrange(desc(value)) %>%
  slice(1:20)

# Save data to disk
write.csv(whs_top_20, WHS_TOP_20, row.names=FALSE, fileEncoding="utf-8")

## Create chart

###First version: long names
whs_top_20_plot <- ggplot(whs_top_20, aes(reorder(site,value), value, fill=factor(EU))) + 
  geom_bar(stat="identity") +
  coord_flip() +
  ggtitle("Top 20 World Heritage Sites in number of \n views of related Wikipedia articles in 2015 (*)") +
  scale_fill_discrete(name="", labels=c("non EU", "EU")) +
  scale_y_continuous(breaks = waiver()) +
  theme(legend.position="bottom") +
  theme(axis.title.x = element_blank()) +
  theme(axis.title.y = element_blank()) +
  scale_x_discrete(labels=c("Archaeological Site of Troy [Ref:849]", "Stonehenge, Avebury and Associated Sites [Ref:373]", "Rio de Janeiro: Carioca Landscapes between the Mountain and the Sea [Ref:1100]", "Historic Centre of Warsaw [Ref:30]", "Kremlin and Red Square, Moscow [Ref:545]", "Historic Sanctuary of Machu Picchu [Ref:274]", "Venice and its Lagoon [Ref:394]", "Archaeological Areas of Pompei, Herculaneum and Torre Annunziata [Ref:829]", "Historic Centre of Prague [Ref:616]", "Historic Centre of Mexico City and Xochimilco [Ref:412]", "Vatican City [Ref:286]", "Budapest, Banks of the Danube, Buda Castle Quarter and Andrássy Avenue [Ref:400]", "Historic Centre of Vienna [Ref:1033]", "Taj Mahal [Ref:252]", "The Great Wall [Ref:438]", "Statue of Liberty [Ref:307]", "Auschwitz Birkenau [Ref:31]", "Historic Areas of Istanbul [Ref:356]", "Historic Centre of Rome [Ref:91]", "Paris, Banks of the Seine [Ref:600]"))
                            
# Save the chart
ggsave(WHS_TOP_20_PLOT_LONG, whs_top_20_plot)

###Second version: medium names
whs_top_20_plot <- ggplot(whs_top_20, aes(reorder(site,value), value, fill=factor(EU))) + 
  geom_bar(stat="identity") +
  coord_flip() +
  ggtitle("Top 20 World Heritage Sites in number of \n views of related Wikipedia articles in 2015 (*)") +
  scale_fill_discrete(name="", labels=c("non EU", "EU")) +
  scale_y_continuous(breaks = waiver()) +
  theme(legend.position="bottom") +
  theme(axis.title.x = element_blank()) +
  theme(axis.title.y = element_blank()) +
  scale_x_discrete(labels=c("Archaeological Site of Troy [Ref:849]", "Stonehenge, Avebury and Associated Sites [Ref:373]", "Rio de Janeiro [Ref:1100]", "Historic Centre of Warsaw [Ref:30]", "Kremlin and Red Square, Moscow [Ref:545]", "Historic Sanctuary of Machu Picchu [Ref:274]", "Venice and its Lagoon [Ref:394]", "Archaeological Areas of Pompei [Ref:829]", "Historic Centre of Prague [Ref:616]", "Historic Centre of Mexico City and Xochimilco [Ref:412]", "Vatican City [Ref:286]", "Budapest [Ref:400]", "Historic Centre of Vienna [Ref:1033]", "Taj Mahal [Ref:252]", "The Great Wall [Ref:438]", "Statue of Liberty [Ref:307]", "Auschwitz Birkenau [Ref:31]", "Historic Areas of Istanbul [Ref:356]", "Historic Centre of Rome [Ref:91]", "Paris, Banks of the Seine [Ref:600]"))

# Save the chart
ggsave(WHS_TOP_20_PLOT_MEDIUM, whs_top_20_plot)

###Third version: short names
whs_top_20_plot <- ggplot(whs_top_20, aes(reorder(site,value), value, fill=factor(EU))) + 
  geom_bar(stat="identity") +
  coord_flip() +
  ggtitle("Top 20 World Heritage Sites in number of \n views of related Wikipedia articles in 2015 (*)") +
  scale_fill_discrete(name="", labels=c("non EU", "EU")) +
  scale_y_continuous(breaks = waiver()) +
  theme(legend.position="bottom") +
  theme(axis.title.x = element_blank()) +
  theme(axis.title.y = element_blank()) +
  scale_x_discrete(labels=c("Archaeological Site of Troy [Ref:849]", "Stonehenge [Ref:373]", "Rio de Janeiro [Ref:1100]", "Historic Centre of Warsaw [Ref:30]", "Kremlin and Red Square, Moscow [Ref:545]", "Historic Sanctuary of Machu Picchu [Ref:274]", "Venice and its Lagoon [Ref:394]", "Archaeological Areas of Pompei [Ref:829]", "Historic Centre of Prague [Ref:616]", "Historic Centre of Mexico City [Ref:412]", "Vatican City [Ref:286]", "Budapest [Ref:400]", "Historic Centre of Vienna [Ref:1033]", "Taj Mahal [Ref:252]", "The Great Wall [Ref:438]", "Statue of Liberty [Ref:307]", "Auschwitz Birkenau [Ref:31]", "Historic Areas of Istanbul [Ref:356]", "Historic Centre of Rome [Ref:91]", "Paris, Banks of the Seine [Ref:600]"))

# Save the chart
ggsave(WHS_TOP_20_PLOT_SHORT, whs_top_20_plot)


# 4. Top 5 by language

## Select data
whs_language <- whs_wikistats

# Consider only the first iso code (in case of WHS on multiple countries)
whs_language$iso_code <- substr(whs_language$iso_code, 1,2)

# Add data for EU and non EU
country_codes <- read_csv(COUNTRY_CODES_FILE)

# Unify the two datasets
whs_top_5_lang <- 
  
  # Unify by iso code
  left_join(whs_language, country_codes, by="iso_code")

## English
whs_top_5_en <- whs_top_5_lang %>%
  
  # Sum by WHS
  filter(lang == 'en') %>%
  group_by(whs_id, site, country)  %>%
  summarise(value = sum(value)) %>%
  group_by() %>%
  arrange(desc(value)) %>%
  slice(1:5)

# Add column that indicate spoken language or not
whs_top_5_en$spoken <- ifelse(whs_top_5_en$country == "United States of America" | whs_top_5_en$country == "India"  ,"1", "0")

# Save data to disk
write.csv(whs_top_5_en, WHS_TOP_5_EN, row.names=FALSE, fileEncoding="utf-8")

# Create chart
whs_top_5_en_plot <- ggplot(whs_top_5_en, aes(reorder(site, value), value, fill=factor(spoken))) + 
  geom_bar(stat="identity") + 
  coord_flip() +
  ggtitle("Top 5 World Heritage Sites in number of views \n of related English Wikipedia articles (*)") +
  scale_fill_discrete(name="", labels=c("non spoken language", "spoken language")) +
  scale_y_continuous(breaks = waiver()) +
  theme(axis.title.x = element_blank()) +
  theme(axis.title.y = element_blank()) +
  theme(legend.position="bottom") +
  scale_x_discrete(labels=c("Statue of Liberty [Ref:307]", "Historic Centre of Rome [Ref:91]", "The Great Wall [Ref:438]", "Paris, Banks of the Seine [Ref:600]", "Taj Mahal [Ref:252]")) 

# Save the chart
ggsave(WHS_TOP_5_EN_PLOT, whs_top_5_en_plot)


## Spanish
whs_top_5_es <- whs_top_5_lang %>%
  
  # Sum by WHS
  filter(lang == 'es') %>%
  group_by(whs_id, site, country)  %>%
  summarise(value = sum(value)) %>%
  group_by() %>%
  arrange(desc(value)) %>%
  slice(1:5)

# Add column that indicate spoken language or not
whs_top_5_es$spoken <- ifelse(whs_top_5_es$country == "Mexico" | whs_top_5_es$country == "Peru", "1", "0")

# Save data to disk
write.csv(whs_top_5_es, WHS_TOP_5_ES, row.names=FALSE, fileEncoding="utf-8")

# Create chart

### Long version
whs_top_5_es_plot <- ggplot(whs_top_5_es, aes(reorder(site, value), value, fill=factor(spoken))) + 
  geom_bar(stat="identity") + 
  coord_flip() +
  ggtitle("Top 5 World Heritage Sites in number of views \n of related Spanish Wikipedia articles (*)") +
  scale_fill_discrete(name="", labels=c("non spoken language", "spoken language")) +
  scale_y_continuous(breaks = waiver()) +
  theme(axis.title.x = element_blank()) +
  theme(axis.title.y = element_blank()) +
  theme(legend.position="bottom") +
  scale_x_discrete(labels=c("Paris, Banks of the Seine [Ref:600]", "Historic Centre of Rome [Ref:91]", "Pre-Hispanic City of Teotihuacan [Ref:414]", "Historic Sanctuary of Machu Picchu [Ref:274]", "Historic Centre of Mexico City and Xochimilco [Ref:412]")) 

# Save the chart
ggsave(WHS_TOP_5_ES_PLOT_LONG, whs_top_5_es_plot)

### Short version
whs_top_5_es_plot <- ggplot(whs_top_5_es, aes(reorder(site, value), value, fill=factor(spoken))) + 
  geom_bar(stat="identity") + 
  coord_flip() +
  ggtitle("Top 5 World Heritage Sites in number of views \n of related Spanish Wikipedia articles (*)") +
  scale_fill_discrete(name="", labels=c("non spoken language", "spoken language")) +
  scale_y_continuous(breaks = waiver()) +
  theme(axis.title.x = element_blank()) +
  theme(axis.title.y = element_blank()) +
  theme(legend.position="bottom") +
  scale_x_discrete(labels=c("Paris, Banks of the Seine [Ref:600]", "Historic Centre of Rome [Ref:91]", "Pre-Hispanic City of Teotihuacan [Ref:414]", "Historic Sanctuary of Machu Picchu [Ref:274]", "Historic Centre of Mexico City [Ref:412]")) 

# Save the chart
ggsave(WHS_TOP_5_ES_PLOT_SHORT, whs_top_5_es_plot)

## German
whs_top_5_de <- whs_top_5_lang %>%
  
  # Sum by WHS
  filter(lang == 'de') %>%
  group_by(whs_id, site, country)  %>%
  summarise(value = sum(value)) %>%
  group_by() %>%
  arrange(desc(value)) %>%
  slice(1:5)

# Add column that indicate spoken language or not
whs_top_5_de$spoken <- ifelse(whs_top_5_de$country == "Austria", "1", "0")

# Save data to disk
write.csv(whs_top_5_de, WHS_TOP_5_DE, row.names=FALSE, fileEncoding="utf-8")

# Create chart
whs_top_5_de_plot <- ggplot(whs_top_5_de, aes(reorder(site, value), value, fill=factor(spoken))) + 
  geom_bar(stat="identity") + 
  coord_flip() +
  ggtitle("Top 5 World Heritage Sites in number of views \n of related German Wikipedia articles (*)") +
  scale_fill_discrete(name="", labels=c("non spoken language", "spoken language")) +
  scale_y_continuous(breaks = waiver()) +
  theme(axis.title.x = element_blank()) +
  theme(axis.title.y = element_blank()) +
  theme(legend.position="bottom") +
  scale_x_discrete(labels=c("Historic Centre of Prague [Ref:616]", "Historic Areas of Istanbul [Ref:356]", "Historic Centre of Rome [Ref:91]", "Paris, Banks of the Seine [Ref:600]", "Historic Centre of Vienna [Ref:1033]")) 

# Save the chart
ggsave(WHS_TOP_5_DE_PLOT, whs_top_5_de_plot)

## French
whs_top_5_fr <- whs_top_5_lang %>%
  
  # Sum by WHS
  filter(lang == 'fr') %>%
  group_by(whs_id, site, country)  %>%
  summarise(value = sum(value)) %>%
  group_by() %>%
  arrange(desc(value)) %>%
  slice(1:5)

# Add column that indicate spoken language or not
whs_top_5_fr$spoken <- ifelse(whs_top_5_fr$country == "France", "1", "0")

# Save data to disk
write.csv(whs_top_5_fr, WHS_TOP_5_FR, row.names=FALSE, fileEncoding="utf-8")

# Create chart
whs_top_5_fr_plot <- ggplot(whs_top_5_fr, aes(reorder(site, value), value, fill=factor(spoken))) + 
  geom_bar(stat="identity") + 
  coord_flip() +
  ggtitle("Top 5 World Heritage Sites in number of views \n of related French Wikipedia articles (*)") +
  scale_fill_discrete(name="", labels=c("non spoken language", "spoken language")) +
  scale_y_continuous(breaks = waiver()) +
  theme(axis.title.x = element_blank()) +
  theme(axis.title.y = element_blank()) +
  theme(legend.position="bottom") +
  scale_x_discrete(labels=c("Bordeaux, Port of the Moon [Ref:1256]", "Historic Centre of Rome [Ref:91]", "Historic Site of Lyons [Ref:872]", "Statue of Liberty [Ref:307]", "Paris, Banks of the Seine [Ref:600]")) 

# Save the chart
ggsave(WHS_TOP_5_FR_PLOT, whs_top_5_fr_plot)

## Russian
whs_top_5_ru <- whs_top_5_lang %>%
  
  # Sum by WHS
  filter(lang == 'ru') %>%
  group_by(whs_id, site, country)  %>%
  summarise(value = sum(value)) %>%
  group_by() %>%
  arrange(desc(value)) %>%
  slice(1:5)

# Add column that indicate spoken language or not
whs_top_5_ru$spoken <- ifelse(whs_top_5_ru$country == "Russian Federation", "1", "0")

# Save data to disk
write.csv(whs_top_5_ru, WHS_TOP_5_RU, row.names=FALSE, fileEncoding="utf-8")

# Create chart
whs_top_5_ru_plot <- ggplot(whs_top_5_ru, aes(reorder(site, value), value, fill=factor(spoken))) + 
  geom_bar(stat="identity") + 
  coord_flip() +
  ggtitle("Top 5 World Heritage Sites in number of views \n of related Russian Wikipedia articles (*)") +
  scale_fill_discrete(name="", labels=c("non spoken language", "spoken language")) +
  scale_y_continuous(breaks = waiver()) +
  theme(axis.title.x = element_blank()) +
  theme(axis.title.y = element_blank()) +
  theme(legend.position="bottom") +
  scale_x_discrete(labels=c("Historic Centre of Rome [Ref:91]", "Auschwitz Birkenau [Ref:31]", "Historic Areas of Istanbul [Ref:356]", "Paris, Banks of the Seine [Ref:600]","Kremlin and Red Square, Moscow [Ref:545]")) 

# Save the chart
ggsave(WHS_TOP_5_RU_PLOT, whs_top_5_ru_plot)

## Italian
whs_top_5_it <- whs_top_5_lang %>%
  
  # Sum by WHS
  filter(lang == 'it') %>%
  group_by(whs_id, site, country)  %>%
  summarise(value = sum(value)) %>%
  group_by() %>%
  arrange(desc(value)) %>%
  slice(1:5)

# Add column that indicate spoken language or not
whs_top_5_it$spoken <- ifelse(whs_top_5_it$country == "Italy" | whs_top_5_it$country == "Holy See", "1", "0")

# Save data to disk
write.csv(whs_top_5_it, WHS_TOP_5_IT, row.names=FALSE, fileEncoding="utf-8")

# Create chart
whs_top_5_it_plot <- ggplot(whs_top_5_it, aes(reorder(site, value), value, fill=factor(spoken))) + 
  geom_bar(stat="identity") + 
  coord_flip() +
  ggtitle("Top 5 World Heritage Sites in number of views \n of related Italian Wikipedia articles (*)") +
  scale_fill_discrete(name="", labels=c("non spoken language", "spoken language")) +
  scale_y_continuous(breaks = waiver()) +
  theme(axis.title.x = element_blank()) +
  theme(axis.title.y = element_blank()) +
  theme(legend.position = "bottom") +
  scale_x_discrete(labels=c("Auschwitz Birkenau [Ref:31]", "Venice and its Lagoon [Ref:394]", "Paris, Banks of the Seine [Ref:600]", "Historic Centre of Naples [Ref:726]","Historic Centre of Rome [Ref:91]")) 

# Save the chart
ggsave(WHS_TOP_5_IT_PLOT, whs_top_5_it_plot)

