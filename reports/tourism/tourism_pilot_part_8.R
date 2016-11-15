# TOURISM PILOT (PART 8)

# New maps and plots

# Barcelona categories

# public transport
Barcelona_public_transport_items <- Barcelona_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_final, by = "item") %>%
  filter(id == 1) %>%
  left_join(Barcelona_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  mutate(lang = lang.x) %>%
  left_join(Barcelona_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))

# sport
Barcelona_sport_items <- Barcelona_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_final, by = "item") %>%
  filter(id == 2) %>%
  left_join(Barcelona_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  mutate(lang = lang.x) %>%
  left_join(Barcelona_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))

# high education
Barcelona_high_education_items <- Barcelona_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_final, by = "item") %>%
  filter(id == 3) %>%
  left_join(Barcelona_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  mutate(lang = lang.x) %>%
  left_join(Barcelona_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))

# theatres
Barcelona_theatres_items <- Barcelona_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_final, by = "item") %>%
  filter(id == 6) %>%
  left_join(Barcelona_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  mutate(lang = lang.x) %>%
  left_join(Barcelona_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))

# buildings
Barcelona_buildings_items <- Barcelona_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_final, by = "item") %>%
  filter(id == 7) %>%
  left_join(Barcelona_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  mutate(lang = lang.x) %>%
  left_join(Barcelona_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))

# streets and districts
Barcelona_streets_and_districts_items <- Barcelona_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_final, by = "item") %>%
  filter(id == 9) %>%
  left_join(Barcelona_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  mutate(lang = lang.x) %>%
  left_join(Barcelona_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))

# museums
Barcelona_museums_items <- Barcelona_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_final, by = "item") %>%
  filter(id == 10) %>%
  left_join(Barcelona_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  mutate(lang = lang.x) %>%
  left_join(Barcelona_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))

# sagrada familia
Barcelona_sagrada_familia_items <- Barcelona_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_final, by = "item") %>%
  filter(id == 11) %>%
  left_join(Barcelona_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  mutate(lang = lang.x) %>%
  left_join(Barcelona_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))

# history
Barcelona_history_items <- Barcelona_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_final, by = "item") %>%
  filter(id == 12) %>%
  left_join(Barcelona_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  mutate(lang = lang.x) %>%
  left_join(Barcelona_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))

# institutions/organizations
Barcelona_institutions_organizations_items <- Barcelona_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_final, by = "item") %>%
  filter(id == 13) %>%
  left_join(Barcelona_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  mutate(lang = lang.x) %>%
  left_join(Barcelona_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))

# monuments and fountains
Barcelona_monuments_and_fountains_items <- Barcelona_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_final, by = "item") %>%
  filter(id == 15) %>%
  left_join(Barcelona_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  mutate(lang = lang.x) %>%
  left_join(Barcelona_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))


# culture and art
Barcelona_culture_and_art_items <- Barcelona_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_final, by = "item") %>%
  filter(id == 16) %>%
  left_join(Barcelona_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  mutate(lang = lang.x) %>%
  left_join(Barcelona_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))

# parks
Barcelona_parks_items <- Barcelona_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_final, by = "item") %>%
  filter(id == 17) %>%
  left_join(Barcelona_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  mutate(lang = lang.x) %>%
  left_join(Barcelona_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))


# places of worship
Barcelona_places_of_worship_items <- Barcelona_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_final, by = "item") %>%
  filter(id == 18) %>%
  left_join(Barcelona_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  mutate(lang = lang.x) %>%
  left_join(Barcelona_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))


write.csv(Barcelona_C_final, "Barcelona_C_final.csv", fileEncoding = "UTF-8")
write.csv(Barcelona_public_transport_items, "Barcelona_public_transport_items.csv", fileEncoding = "UTF-8")
write.csv(Barcelona_sport_items, "Barcelona_sport_items.csv", fileEncoding = "UTF-8")
write.csv(Barcelona_high_education_items, "Barcelona_high_education_items.csv", fileEncoding = "UTF-8")
write.csv(Barcelona_theatres_items, "Barcelona_theatres_items.csv", fileEncoding = "UTF-8")
write.csv(Barcelona_buildings_items, "Barcelona_buildings_items.csv", fileEncoding = "UTF-8")
write.csv(Barcelona_streets_and_districts_items, "Barcelona_streets_and_districts_items.csv", fileEncoding = "UTF-8")
write.csv(Barcelona_museums_items, "Barcelona_museums_items.csv", fileEncoding = "UTF-8")
write.csv(Barcelona_sagrada_familia_items, "Barcelona_sagrada_familia_items.csv", fileEncoding = "UTF-8")
write.csv(Barcelona_history_items, "Barcelona_history_items.csv", fileEncoding = "UTF-8")
write.csv(Barcelona_institutions_organizations_items, "Barcelona_institutions_organizations_items.csv", fileEncoding = "UTF-8")
write.csv(Barcelona_monuments_and_fountains_items, "Barcelona_monuments_and_fountains_items.csv", fileEncoding = "UTF-8")
write.csv(Barcelona_culture_and_art_items, "Barcelona_culture_and_art_items.csv", fileEncoding = "UTF-8")
write.csv(Barcelona_parks_items, "Barcelona_parks_items.csv", fileEncoding = "UTF-8")
write.csv(Barcelona_places_of_worship_items, "Barcelona_places_of_worship_items.csv", fileEncoding = "UTF-8")

Barcelona_C_final <- read.csv("C:/Users/signose/Desktop/data_for_maps/Barcelona_C_final.csv") %>%
  select(-X) %>%
  distinct(item)
Barcelona_public_transport_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Barcelona_public_transport_items.csv") %>%
  select(-X)
Barcelona_sport_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Barcelona_sport_items.csv") %>%
  select(-X)
Barcelona_high_education_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Barcelona_high_education_items.csv") %>%
  select(-X)
Barcelona_theatres_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Barcelona_theatres_items.csv") %>%
  select(-X)
Barcelona_buildings_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Barcelona_buildings_items.csv") %>%
  select(-X)
Barcelona_streets_and_districts_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Barcelona_streets_and_districts_items.csv") %>%
  select(-X)
Barcelona_museums_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Barcelona_museums_items.csv") %>%
  select(-X)
Barcelona_sagrada_familia_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Barcelona_sagrada_familia_items.csv") %>%
  select(-X)
Barcelona_history_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Barcelona_history_items.csv") %>%
  select(-X)
Barcelona_institutions_organizations_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Barcelona_institutions_organizations_items.csv") %>%
  select(-X)
Barcelona_monuments_and_fountains_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Barcelona_monuments_and_fountains_items.csv") %>%
  select(-X)
Barcelona_culture_and_art_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Barcelona_culture_and_art_items.csv") %>%
  select(-X)
Barcelona_parks_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Barcelona_parks_items.csv") %>%
  select(-X)
Barcelona_places_of_worship_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Barcelona_places_of_worship_items.csv") %>%
  select(-X)


Red <- colorQuantile("Reds", NULL, n = 8)
Green <- colorQuantile("Greens", NULL, n = 8)
Blue <- colorQuantile("Blues", NULL, n = 8)
Purple <- colorQuantile("Purples", NULL, n = 8)
Grey <- colorQuantile("Greys", NULL, n = 8)
Orange <- colorQuantile("Oranges", NULL, n = 8)
Pink <- colorQuantile("RdPu", NULL, n=8)

m <- leaflet(Barcelona_C_final) %>%
  addProviderTiles("CartoDB.Positron")%>%
  addCircleMarkers(data = Barcelona_public_transport_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Red(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "Public transport") %>%
  addCircleMarkers(data = Barcelona_sport_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Green(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "Sport") %>%
  addCircleMarkers(data = Barcelona_high_education_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Blue(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "High education") %>%
  addCircleMarkers(data = Barcelona_theatres_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Purple(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "Theatres") %>%
  addCircleMarkers(data = Barcelona_buildings_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Grey(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "Buildings") %>%
  addCircleMarkers(data = Barcelona_streets_and_districts_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Orange(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "Streets and districts") %>%
  addCircleMarkers(data = Barcelona_museums_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Pink(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "Museums") %>%
  addCircleMarkers(data = Barcelona_sagrada_familia_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Red(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "Sagrada Familia") %>%
  addCircleMarkers(data = Barcelona_history_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Green(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "History") %>%
  addCircleMarkers(data = Barcelona_institutions_organizations_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Blue(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "Institutions/organizations") %>%
  addCircleMarkers(data = Barcelona_monuments_and_fountains_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Purple(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "Monuments and fountains") %>%
  addCircleMarkers(data = Barcelona_culture_and_art_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Grey(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "Culture and art") %>%
  addCircleMarkers(data = Barcelona_parks_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Orange(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "Parks") %>%
  addCircleMarkers(data = Barcelona_places_of_worship_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Pink(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "Places of worship") %>%
  addLegend(position = c("bottomright"), colorNumeric("Reds", NULL, n=8),  values = ~value) %>%
  addLayersControl(overlayGroups = c("Public transport", "Sport", "High education", "Theatres", "Buildings", "Streets and districts", "Museums", "Sagrada Familia", "History", "Institutions/organizations", "Monuments and fountains", "Culture and art", "Parks", "Places of worship"), options = layersControlOptions(collapsed = FALSE))
m

# new version

pal <-  c("#636363", "#a1d99b", "#e9a3c9", "#e34a33", "#8c510a", "#1b9e77", "#dd3497", "#74a9cf","#2ca25f", "#7570b3", "#b2182b",  "#fed976", "#02818a", "#8856a7")
labels <- c( "Buildings", "Culture and art", "High education", "History","Institutions/organizations","Libraries", "Monuments and fountains",  "Museums", "Parks",  "Places of worship",  "Public transport", "Sport", "Streets and districts","Theatres")

m <- leaflet(Barcelona_C_final) %>%
  addProviderTiles("CartoDB.Positron", group = "CartoDB")%>%
  addProviderTiles("Esri.WorldImagery", group = "Esri World Imagery")%>%
  addCircleMarkers(data = Barcelona_buildings_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#636363", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Buildings") %>%
  addCircleMarkers(data = Barcelona_culture_and_art_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#a1d99b", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Culture and art") %>%
  addCircleMarkers(data = Barcelona_high_education_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#e9a3c9", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "High education") %>%
  addCircleMarkers(data = Barcelona_history_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#e34a33", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "History") %>%
  addCircleMarkers(data = Barcelona_institutions_organizations_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#8c510a", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Institutions/organizations") %>%
  addCircleMarkers(data = Barcelona_monuments_and_fountains_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#dd3497", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Monuments and fountains") %>%
  addCircleMarkers(data = Barcelona_museums_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#74a9cf", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Museums") %>%
  addCircleMarkers(data = Barcelona_parks_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#2ca25f", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Parks") %>%
  addCircleMarkers(data = Barcelona_places_of_worship_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#7570b3", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Places of worship") %>%
  addCircleMarkers(data = Barcelona_public_transport_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#b2182b", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Public transport") %>%
  addCircleMarkers(data = Barcelona_sport_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#fed976", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Sport") %>%
  addCircleMarkers(data = Barcelona_streets_and_districts_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#02818a", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Streets and districts") %>%
  addCircleMarkers(data = Barcelona_theatres_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#8856a7", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Theatres") %>%
  addLegend(position = c("bottomright"), colors = ~pal,  labels = ~labels) %>%
  addLegend(position = c("topright"), colors = c("snow"),  
            labels = c("<b>BARCELONA map of points of interest by category</b>")) %>%  
  addLegend(position = c("topright"), colors = c("snow", "snow", "snow", "snow", "snow", "snow", "snow", "snow", "snow", "snow"),  
            labels = c("<i>INSTRUCTIONS:</i>", "",
                       "On the bottomleft, choose the layout of the map",
                       "(satellite version from Esri or clean version from CartoDB)",
                       "and flag the categories you want to display on the map", "---",
                       "On the bottomright, a legend of the categories is available.", "---",
                       "Click on one point of interest to see its name and to link",
                       "to the related Spanish Wikipedia article.")) %>%
  addLegend(position = c("bottomleft"), colors = c("snow"),  
            labels = c("<b>The use of Wikipedia for Tourism statistics</b> (EUROSTAT & University of Bergamo)"))%>%
  #addLegend(position = c("topright"), colors = c("snow", "snow"),  labels = c("Welcome to the Eurostat pilot", "the use of Wikipedia for Tourism statistics")) %>%
  addLayersControl(position = c("bottomleft"), baseGroups = c("CartoDB", "Esri World Imagery"),
                   overlayGroups = c("Buildings", "Culture and art", "High education", "History","Institutions/organizations","Libraries", "Monuments and fountains",  "Museums", "Parks",  "Places of worship",  "Public transport", "Sport", "Streets and districts","Theatres"), options = layersControlOptions(collapsed = FALSE)) #%>%
#hideGroup(c("Culture and art","Sport", "Institutions/organizations", "History", "Places of worship", "Public transport", "Streets and districts", "Parks", "Museums",  "Libraries", "Monuments and fountains", "High education", "Theatres"))
m

saveWidget(widget = m, file="Barcelona_categories_map.html", selfcontained = FALSE)

# Bruges categories

# public transport
Bruges_public_transport_items <- Bruges_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Bruges_final, by = "item") %>%
  filter(id == 1) %>%
  left_join(Bruges_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  mutate(lang = lang.x) %>%
  left_join(Bruges_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))


Bruges_streets_and_streams_items <- Bruges_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Bruges_final, by = "item") %>%
  filter(id == 2) %>%
  left_join(Bruges_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x)%>%
  mutate(lang = lang.x) %>%
  left_join(Bruges_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))


Bruges_libraries_items <- Bruges_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Bruges_final, by = "item") %>%
  filter(id == 3) %>%
  left_join(Bruges_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  mutate(lang = lang.x) %>%
  left_join(Bruges_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))


Bruges_buildings_items <- Bruges_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Bruges_final, by = "item") %>%
  filter(id == 4) %>%
  left_join(Bruges_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  mutate(lang = lang.x) %>%
  left_join(Bruges_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))

Bruges_high_education_items <- Bruges_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Bruges_final, by = "item") %>%
  filter(id == 5) %>%
  left_join(Bruges_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  mutate(lang = lang.x) %>%
  left_join(Bruges_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))

Bruges_companies_items <- Bruges_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Bruges_final, by = "item") %>%
  filter(id == 13) %>%
  left_join(Bruges_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  mutate(lang = lang.x) %>%
  left_join(Bruges_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))

Bruges_bridges_and_canals_items <- Bruges_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Bruges_final, by = "item") %>%
  filter(id == 8) %>%
  left_join(Bruges_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x)%>%
  mutate(lang = lang.x) %>%
  left_join(Bruges_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))

Bruges_districts_items <- Bruges_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Bruges_final, by = "item") %>%
  filter(id == 10) %>%
  left_join(Bruges_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  mutate(lang = lang.x) %>%
  left_join(Bruges_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))

Bruges_places_of_worship_items <- Bruges_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Bruges_final, by = "item") %>%
  filter(id == 11) %>%
  left_join(Bruges_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  mutate(lang = lang.x) %>%
  left_join(Bruges_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))

Bruges_museums_items <- Bruges_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Bruges_final, by = "item") %>%
  filter(id == 14) %>%
  left_join(Bruges_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  mutate(lang = lang.x) %>%
  left_join(Bruges_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))

Bruges_sport_items <- Bruges_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Bruges_final, by = "item") %>%
  filter(id == 9) %>%
  left_join(Bruges_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  mutate(lang = lang.x) %>%
  left_join(Bruges_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))


write.csv(Bruges_C_final, "Bruges_C_final.csv", fileEncoding = "UTF-8")
write.csv(Bruges_public_transport_items, "Bruges_public_transport_items.csv", fileEncoding = "UTF-8")
write.csv(Bruges_streets_and_streams_items, "Bruges_streets_and_streams_items.csv", fileEncoding = "UTF-8")
write.csv(Bruges_libraries_items, "Bruges_libraries_items.csv", fileEncoding = "UTF-8")
write.csv(Bruges_buildings_items, "Bruges_buildings_items.csv", fileEncoding = "UTF-8")
write.csv(Bruges_high_education_items, "Bruges_high_education_items.csv", fileEncoding = "UTF-8")
write.csv(Bruges_companies_items, "Bruges_companies_items.csv", fileEncoding = "UTF-8")
write.csv(Bruges_bridges_and_canals_items, "Bruges_bridges_and_canals_items.csv", fileEncoding = "UTF-8")
write.csv(Bruges_sport_items, "Bruges_sport_items.csv", fileEncoding = "UTF-8")
write.csv(Bruges_districts_items, "Bruges_districts_items.csv", fileEncoding = "UTF-8")
write.csv(Bruges_places_of_worship_items, "Bruges_places_of_worship_items.csv", fileEncoding = "UTF-8")
write.csv(Bruges_museums_items, "Bruges_museums_items.csv", fileEncoding = "UTF-8")

Bruges_C_final <- read.csv("C:/Users/signose/Desktop/data_for_maps/Bruges_C_final.csv") %>%
  select(-X, -wm) %>%
  distinct(item)
Bruges_public_transport_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Bruges_public_transport_items.csv") %>%
  select(-X)
Bruges_streets_and_streams_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Bruges_streets_and_streams_items.csv") %>%
  select(-X)
Bruges_libraries_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Bruges_libraries_items.csv") %>%
  select(-X)
Bruges_buildings_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Bruges_buildings_items.csv") %>%
  select(-X)
Bruges_high_education_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Bruges_high_education_items.csv") %>%
  select(-X)
Bruges_companies_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Bruges_companies_items.csv") %>%
  select(-X)
Bruges_bridges_and_canals_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Bruges_bridges_and_canals_items.csv") %>%
  select(-X)
Bruges_sport_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Bruges_sport_items.csv") %>%
  select(-X)
Bruges_districts_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Bruges_districts_items.csv") %>%
  select(-X)
Bruges_places_of_worship_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Bruges_places_of_worship_items.csv") %>%
  select(-X)
Bruges_museums_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Bruges_museums_items.csv") %>%
  select(-X)

m <- leaflet(Bruges_C_final) %>%
  addProviderTiles("CartoDB.Positron")%>%
  addCircleMarkers(data = Bruges_public_transport_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Red(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "Public transport") %>%
  addCircleMarkers(data = Bruges_streets_and_streams_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Green(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "Streets and streams") %>%
  addCircleMarkers(data = Bruges_libraries_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Blue(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "Libraries") %>%
  addCircleMarkers(data = Bruges_buildings_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Purple(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "Buildings") %>%
  addCircleMarkers(data = Bruges_high_education_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Grey(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "High education") %>%
  addCircleMarkers(data = Bruges_companies_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Orange(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "Companies") %>%
  addCircleMarkers(data = Bruges_bridges_and_canals_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Pink(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "Bridges and canals") %>%
  addCircleMarkers(data = Bruges_sport_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Red(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "Sport") %>%
  addCircleMarkers(data = Bruges_districts_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Green(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "Districts") %>%
  addCircleMarkers(data = Bruges_places_of_worship_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Blue(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "Places of worship") %>%
  addCircleMarkers(data = Bruges_museums_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Purple(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "Museums") %>%
  addLegend(position = c("bottomright"), colorNumeric("Reds", NULL, n=8),  values = ~value) %>%
  addLayersControl(overlayGroups = c("Public transport", "Streets and streams", "Libraries", "Buildings", "High education", "Companies", "Bridges and canals", "Sport", "Districts", "Places of worship", "Museums"), options = layersControlOptions(collapsed = FALSE))
m

# new version

pal <-  c("#3182bd", "#636363", "#999999" ,"#41ab5d", "#e9a3c9",  "#1b9e77", "#74a9cf", "#7570b3", "#b2182b",  "#fed976", "#02818a")
labels <- c("Bridges and canals", "Buildings", "Companies", "Districts" ,"High education", "Libraries",  "Museums",  "Places of worship",  "Public transport", "Sport", "Streets and streams")


m <- leaflet(Bruges_C_final) %>%
  addProviderTiles("CartoDB.Positron", group = "CartoDB")%>%
  addProviderTiles("Esri.WorldImagery", group = "Esri World Imagery")%>%
  addCircleMarkers(data = Bruges_bridges_and_canals_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#3182bd", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Bridges and canals") %>%
  addCircleMarkers(data = Bruges_buildings_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#636363", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Buildings") %>%
  addCircleMarkers(data = Bruges_companies_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#999999", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Companies") %>%
  addCircleMarkers(data = Bruges_districts_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#41ab5d", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Streets and districts") %>%
  addCircleMarkers(data = Bruges_high_education_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#e9a3c9", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "High education") %>%
  addCircleMarkers(data = Bruges_libraries_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#1b9e77", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Libraries") %>%
  addCircleMarkers(data = Bruges_museums_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#74a9cf", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Museums") %>%
  addCircleMarkers(data = Bruges_places_of_worship_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#7570b3", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Places of worship") %>%
  addCircleMarkers(data = Bruges_public_transport_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#b2182b", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Public transport") %>%
  addCircleMarkers(data = Bruges_sport_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#fed976", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Sport") %>%
  addCircleMarkers(data = Bruges_streets_and_streams_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#02818a", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Streets and streams") %>%
  addLegend(position = c("bottomright"), colors = ~pal,  labels = ~labels) %>%
  addLegend(position = c("topright"), colors = c("snow"),  
            labels = c("<b>BRUGES map of points of interest by category</b>")) %>%  
  addLegend(position = c("topright"), colors = c("snow", "snow", "snow", "snow", "snow", "snow", "snow", "snow", "snow", "snow"),  
            labels = c("<i>INSTRUCTIONS:</i>", "",
                       "On the bottomleft, choose the layout of the map",
                       "(satellite version from Esri or clean version from CartoDB)",
                       "and flag the categories you want to display on the map", "---",
                       "On the bottomright, a legend of the categories is available.", "---",
                       "Click on one point of interest to see its name and to link",
                       "to the related Dutch Wikipedia article.")) %>%
  addLegend(position = c("bottomleft"), colors = c("snow"),  
            labels = c("<b>The use of Wikipedia for Tourism statistics</b> (EUROSTAT & University of Bergamo)"))%>%
  #addLegend(position = c("topright"), colors = c("snow", "snow"),  labels = c("Welcome to the Eurostat pilot", "the use of Wikipedia for Tourism statistics")) %>%
  addLayersControl(position = c("bottomleft"), baseGroups = c("CartoDB", "Esri World Imagery"),
                   overlayGroups = c("Bridges and canals", "Buildings", "Companies", "Districts" ,"High education", "Libraries",  "Museums",  "Places of worship",  "Public transport", "Sport", "Streets and streams"), options = layersControlOptions(collapsed = FALSE)) #%>%
m

saveWidget(widget = m, file="Bruges_categories_map.html", selfcontained = FALSE)

# Vienna

Vienna_sport_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 1) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  mutate(lang = lang.x) %>%
  left_join(Vienna_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))


Vienna_council_housing_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 2) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  mutate(lang = lang.x) %>%
  left_join(Vienna_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))

Vienna_institutions_organizations_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 3) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  mutate(lang = lang.x) %>%
  left_join(Vienna_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))

Vienna_history_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 4) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  mutate(lang = lang.x) %>%
  left_join(Vienna_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))

Vienna_township_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 5) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  mutate(lang = lang.x) %>%
  left_join(Vienna_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))

Vienna_places_of_worship_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 7) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  mutate(lang = lang.x) %>%
  left_join(Vienna_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))

Vienna_companies_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 9) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  mutate(lang = lang.x) %>%
  left_join(Vienna_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))

Vienna_bus_stops_and_stations_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 12) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  mutate(lang = lang.x) %>%
  left_join(Vienna_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))

Vienna_mountains_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 13) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  mutate(lang = lang.x) %>%
  left_join(Vienna_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))

Vienna_transmitters_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 17) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  mutate(lang = lang.x) %>%
  left_join(Vienna_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))

Vienna_embassies_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 18) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  mutate(lang = lang.x) %>%
  left_join(Vienna_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))

Vienna_streets_and_squares_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 20) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  mutate(lang = lang.x) %>%
  left_join(Vienna_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))

Vienna_rivers_and_parks_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 21) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  mutate(lang = lang.x) %>%
  left_join(Vienna_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))

Vienna_museums_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 27) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x)%>%
  mutate(lang = lang.x) %>%
  left_join(Vienna_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))

Vienna_towers_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 28) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  mutate(lang = lang.x) %>%
  left_join(Vienna_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))

Vienna_buildings_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 30) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  mutate(lang = lang.x) %>%
  left_join(Vienna_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))

Vienna_hospitals_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 33) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  mutate(lang = lang.x) %>%
  left_join(Vienna_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))

Vienna_libraries_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 34) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  mutate(lang = lang.x) %>%
  left_join(Vienna_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))

Vienna_statues_and_fountains_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 35) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  mutate(lang = lang.x) %>%
  left_join(Vienna_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))

Vienna_high_education_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 39) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x)%>%
  mutate(lang = lang.x) %>%
  left_join(Vienna_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))

Vienna_bridges_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 41) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  mutate(lang = lang.x) %>%
  left_join(Vienna_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))

Vienna_theatres_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 44) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  mutate(lang = lang.x) %>%
  left_join(Vienna_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))

Vienna_cemeteries_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 45) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  mutate(lang = lang.x) %>%
  left_join(Vienna_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article, "'>", article, "</a></b>", "<br>number of page views: ", value))

write.csv(Vienna_C_final, "Vienna_C_final.csv", fileEncoding = "UTF-8")
write.csv(Vienna_sport_items, "Vienna_sport_items.csv", fileEncoding = "UTF-8")
write.csv(Vienna_council_housing_items, "Vienna_council_housing_items.csv", fileEncoding = "UTF-8")
write.csv(Vienna_institutions_organizations_items, "Vienna_institutions_organizations_items.csv", fileEncoding = "UTF-8")
write.csv(Vienna_history_items, "Vienna_history_items.csv", fileEncoding = "UTF-8")
write.csv(Vienna_township_items, "Vienna_township_items.csv", fileEncoding = "UTF-8")
write.csv(Vienna_places_of_worship_items, "Vienna_places_of_worship_items.csv", fileEncoding = "UTF-8")
write.csv(Vienna_companies_items, "Vienna_companies_items.csv", fileEncoding = "UTF-8")
write.csv(Vienna_bus_stops_and_stations_items, "Vienna_bus_stops_and_stations_items.csv", fileEncoding = "UTF-8")
write.csv(Vienna_mountains_items, "Vienna_mountains_items.csv", fileEncoding = "UTF-8")
write.csv(Vienna_transmitters_items, "Vienna_transmitters_items.csv", fileEncoding = "UTF-8")
write.csv(Vienna_embassies_items, "Vienna_embassies_items.csv", fileEncoding = "UTF-8")
write.csv(Vienna_streets_and_squares_items, "Vienna_streets_and_squares_items.csv", fileEncoding = "UTF-8")
write.csv(Vienna_rivers_and_parks_items, "Vienna_rivers_and_parks_items.csv", fileEncoding = "UTF-8")
write.csv(Vienna_museums_items, "Vienna_museums_items.csv", fileEncoding = "UTF-8")
write.csv(Vienna_towers_items, "Vienna_towers_items.csv", fileEncoding = "UTF-8")
write.csv(Vienna_buildings_items, "Vienna_buildings_items.csv", fileEncoding = "UTF-8")
write.csv(Vienna_hospitals_items, "Vienna_hospitals_items.csv", fileEncoding = "UTF-8")
write.csv(Vienna_libraries_items, "Vienna_libraries_items.csv", fileEncoding = "UTF-8")
write.csv(Vienna_statues_and_fountains_items, "Vienna_statues_and_fountains_items.csv", fileEncoding = "UTF-8")
write.csv(Vienna_high_education_items, "Vienna_high_education_items.csv", fileEncoding = "UTF-8")
write.csv(Vienna_bridges_items, "Vienna_bridges_items.csv", fileEncoding = "UTF-8")
write.csv(Vienna_theatres_items, "Vienna_theatres_items.csv", fileEncoding = "UTF-8")
write.csv(Vienna_cemeteries_items, "Vienna_cemeteries_items.csv", fileEncoding = "UTF-8")

Vienna_C_final <- read.csv("C:/Users/signose/Desktop/data_for_maps/Vienna_C_final.csv") %>%
  select(-X, -wm) %>%
  distinct(item)
Vienna_sport_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Vienna_sport_items.csv") %>%
  select(-X)
Vienna_council_housing_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Vienna_council_housing_items.csv") %>%
  select(-X)
Vienna_institutions_organizations_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Vienna_institutions_organizations_items.csv") %>%
  select(-X)
Vienna_history_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Vienna_history_items.csv") %>%
  select(-X)
Vienna_township_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Vienna_township_items.csv") %>%
  select(-X)
Vienna_places_of_worship_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Vienna_places_of_worship_items.csv") %>%
  select(-X)
Vienna_companies_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Vienna_companies_items.csv") %>%
  select(-X)
Vienna_bus_stops_and_stations_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Vienna_bus_stops_and_stations_items.csv") %>%
  select(-X)
Vienna_mountains_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Vienna_mountains_items.csv") %>%
  select(-X)
Vienna_transmitters_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Vienna_transmitters_items.csv") %>%
  select(-X)
Vienna_embassies_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Vienna_embassies_items.csv") %>%
  select(-X)
Vienna_streets_and_squares_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Vienna_streets_and_squares_items.csv") %>%
  select(-X)
Vienna_rivers_and_parks_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Vienna_rivers_and_parks_items.csv") %>%
  select(-X)
Vienna_museums_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Vienna_museums_items.csv") %>%
  select(-X)
Vienna_towers_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Vienna_towers_items.csv") %>%
  select(-X)
Vienna_buildings_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Vienna_buildings_items.csv") %>%
  select(-X)
Vienna_hospitals_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Vienna_hospitals_items.csv") %>%
  select(-X)
Vienna_libraries_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Vienna_libraries_items.csv") %>%
  select(-X)
Vienna_statues_and_fountains_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Vienna_statues_and_fountains_items.csv") %>%
  select(-X)
Vienna_high_education_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Vienna_high_education_items.csv") %>%
  select(-X)
Vienna_bridges_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Vienna_bridges_items.csv") %>%
  select(-X)
Vienna_theatres_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Vienna_theatres_items.csv") %>%
  select(-X)
Vienna_cemeteries_items <- read.csv("C:/Users/signose/Desktop/data_for_maps/Vienna_cemeteries_items.csv") %>%
  select(-X)

m <- leaflet(Vienna_C_final) %>%
  addProviderTiles("CartoDB.Positron")%>%
  addCircleMarkers(data = Vienna_sport_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Red(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "Sport") %>%
  addCircleMarkers(data = Vienna_council_housing_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Green(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "Council housing") %>%
  addCircleMarkers(data = Vienna_institutions_organizations_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Blue(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "Institutions/organizations") %>%
  addCircleMarkers(data = Vienna_history_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Purple(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "History") %>%
  addCircleMarkers(data = Vienna_township_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Grey(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "Township") %>%
  addCircleMarkers(data = Vienna_places_of_worship_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Orange(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "Places of worship") %>%
  addCircleMarkers(data = Vienna_companies_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Pink(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "Companies") %>%
  addCircleMarkers(data = Vienna_bus_stops_and_stations_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Red(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "Bus stops and stations") %>%
  addCircleMarkers(data = Vienna_mountains_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Green(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "Mountains") %>%
  addCircleMarkers(data = Vienna_transmitters_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Blue(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "Transmitters") %>%
  addCircleMarkers(data = Vienna_embassies_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Purple(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "Embassies") %>%
  addCircleMarkers(data = Vienna_streets_and_squares_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Grey(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "Streets and squares") %>%
  addCircleMarkers(data = Vienna_rivers_and_parks_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Orange(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "Rivers and parks") %>%
  addCircleMarkers(data = Vienna_museums_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Pink(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "Museums") %>%
  addCircleMarkers(data = Vienna_towers_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Red(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "Towers") %>%
  addCircleMarkers(data = Vienna_buildings_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Green(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "Buildings") %>%
  addCircleMarkers(data = Vienna_hospitals_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Blue(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "Hospitals") %>%
  addCircleMarkers(data = Vienna_libraries_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Purple(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "Libraries") %>%
  addCircleMarkers(data = Vienna_statues_and_fountains_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Grey(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "Statues and fountains") %>%
  addCircleMarkers(data = Vienna_high_education_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Orange(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "High education") %>%
  addCircleMarkers(data = Vienna_bridges_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Pink(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "Bridges") %>%
  addCircleMarkers(data = Vienna_theatres_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Red(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "Theatres") %>%
  addCircleMarkers(data = Vienna_cemeteries_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = ~Green(value), fillOpacity = 0.6, popup = ~article.x, options =markerOptions(opacity = 0), group = "Cemeteries") %>%
  addLegend(position = c("bottomright"), colorNumeric("Reds", NULL, n=8),  values = ~value) %>%
  addLayersControl(overlayGroups = c("Sport", "Council housing", "Institutions/organizations", "History", "Township", "Places of worship", "Companies", "Bus stops and stations", "Mountains", "Transmitters", "Embassies", "Streets and squares", "Rivers and parks", "Museums", "Towers", "Buildings", "Hospitals", "Libraries", "Statues and fountains", "High education", "Bridges", "Theatres", "Cemeteries"), options = layersControlOptions(collapsed = FALSE))
m

# new version

pal <-  c("#3182bd", "#636363", "#252525","#999999","#045a8d", "#e7298a", "#e9a3c9", "#e34a33", "#d73027","#8c510a", "#1b9e77", "#dd3497", "#00441b", "#74a9cf", "#7570b3", "#b2182b", "#2ca25f", "#fed976", "#02818a", "#8856a7", "#f46d43", "#810f7c", "#7f2704")
labels <- c("Bridges", "Buildings", "Cemeteries", "Companies","Council housing","Embassies", "High education", "History", "Hospitals", "Institutions/organizations","Libraries", "Monuments and fountains", "Mountains", "Museums", "Places of worship",  "Public transport", "Rivers and parks", "Sport", "Streets and squares","Theatres", "Towers", "Township", "Transmitters")


m <- leaflet(Vienna_C_final) %>%
  addProviderTiles("CartoDB.Positron")%>%
  addProviderTiles("Esri.WorldImagery", group = "Esri World Imagery")%>%
  addCircleMarkers(data = Vienna_bridges_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#3182bd", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Bridges") %>%
  addCircleMarkers(data = Vienna_buildings_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#636363", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Buildings") %>%
  addCircleMarkers(data = Vienna_cemeteries_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#252525", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Cemeteries") %>%
  addCircleMarkers(data = Vienna_companies_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#999999", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Companies") %>%
  addCircleMarkers(data = Vienna_council_housing_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#045a8d", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Council housing") %>%
  addCircleMarkers(data = Vienna_embassies_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#e7298a", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Embassies") %>%
  addCircleMarkers(data = Vienna_high_education_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor ="#e9a3c9", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "High education") %>%
  addCircleMarkers(data = Vienna_history_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#e34a33", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "History") %>%
  addCircleMarkers(data = Vienna_hospitals_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#d73027", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Hospitals") %>%
  addCircleMarkers(data = Vienna_institutions_organizations_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#8c510a", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Institutions/organizations") %>%
  addCircleMarkers(data = Vienna_libraries_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#1b9e77", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Libraries") %>%
  addCircleMarkers(data = Vienna_statues_and_fountains_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#dd3497", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Monuments and fountains") %>%
  addCircleMarkers(data = Vienna_mountains_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#00441b", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Mountains") %>%
  addCircleMarkers(data = Vienna_museums_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#74a9cf", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Museums") %>%
  addCircleMarkers(data = Vienna_places_of_worship_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#7570b3", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Places of worship") %>%
  addCircleMarkers(data = Vienna_bus_stops_and_stations_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#b2182b", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Public transport") %>%
  addCircleMarkers(data = Vienna_rivers_and_parks_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#2ca25f", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Rivers and parks") %>%
  addCircleMarkers(data = Vienna_sport_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#fed976", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Sport") %>%
  addCircleMarkers(data = Vienna_streets_and_squares_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#02818a", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Streets and squares") %>%
  addCircleMarkers(data = Vienna_theatres_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#8856a7", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Theatres") %>%
  addCircleMarkers(data = Vienna_towers_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#f46d43", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Towers") %>%
  addCircleMarkers(data = Vienna_township_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#810f7c", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Township") %>%
  addCircleMarkers(data = Vienna_transmitters_items, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#7f2704", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Transmitters") %>%
  #addCircleMarkers(data = cities_coord, ~long, ~lat, radius = 0, options = markerOptions(opacity = 0), clusterOptions = markerClusterOptions()) %>%
  addLegend(position = c("bottomright"), colors = ~pal,  labels = ~labels) %>%
  addLegend(position = c("topright"), colors = c("snow"),  
            labels = c("<b>VIENNA map of points of interest by category</b>")) %>%  
  addLegend(position = c("topright"), colors = c("snow", "snow", "snow", "snow", "snow", "snow", "snow", "snow", "snow", "snow"),  
            labels = c("<i>INSTRUCTIONS:</i>", "",
                       "On the bottomleft, choose the layout of the map",
                       "(satellite version from Esri or clean version from CartoDB)",
                       "and flag the categories you want to display on the map", "---",
                       "On the bottomright, a legend of the categories is available.", "---",
                       "Click on one point of interest to see its name and to link",
                       "to the related German Wikipedia article.")) %>%
  addLegend(position = c("bottomleft"), colors = c("snow"),  
            labels = c("<b>The use of Wikipedia for Tourism statistics</b> (EUROSTAT & University of Bergamo)"))%>%
  #addLegend(position = c("topright"), colors = c("snow", "snow"),  labels = c("Welcome to the Eurostat pilot", "the use of Wikipedia for Tourism statistics")) %>%
  addLayersControl(position = c("bottomleft"), baseGroups = c("CartoDB", "Esri World Imagery"),
                   overlayGroups = c("Bridges", "Buildings", "Cemeteries", "Companies","Council housing","Embassies", "High education", "History", "Hospitals", "Institutions/organizations","Libraries", "Monuments and fountains", "Mountains", "Museums", "Places of worship",  "Public transport", "Rivers and parks", "Sport", "Streets and squares","Theatres", "Towers", "Township", "Transmitters"), options = layersControlOptions(collapsed = FALSE)) #%>%
#hideGroup(c("Bridges and canals", "Companies", "Sport", "Institutions/organizations", "History", "Places of worship", "Public transport", "Streets and districts", "Rivers and parks", "Museums",  "Libraries", "Monuments and fountains", "High education", "Theatres"))
m


saveWidget(widget = m, file="Vienna_categories_map.html", selfcontained = FALSE)

# Fourth map with the three cities and only common categories

Barcelona_public_transport_items_2 <- Barcelona_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_final, by = "item") %>%
  filter(id == 1) %>%
  left_join(Barcelona_C_final, by = "item") 

for (i in 1:nrow(Barcelona_public_transport_items_2)) {
  if (Barcelona_public_transport_items_2$lang.y[i] == "en") {
    Barcelona_public_transport_items_2$article[i] <- Barcelona_public_transport_items_2$article.y[i]
    Barcelona_public_transport_items_2$lang[i] <- Barcelona_public_transport_items_2$lang.y[i]
  } else {
    Barcelona_public_transport_items_2$article[i] <- Barcelona_public_transport_items_2$article.x[i]
    Barcelona_public_transport_items_2$lang[i] <- Barcelona_public_transport_items_2$lang.x[i]
  }
}

Barcelona_public_transport_items_3 <- Barcelona_public_transport_items_2 %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x, -article.x, -article.y, -lang.x, -lang.y)%>%
  arrange(item, lang) %>%
  distinct(item, .keep_all = T) %>%
  left_join(Barcelona_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article.y, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article.y, "'>", article.y, "</a></b>", "<br>number of page views: ", value )) 

# sport
Barcelona_sport_items_2 <- Barcelona_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_final, by = "item") %>%
  filter(id == 2) %>%
  left_join(Barcelona_C_final, by = "item") 

for (i in 1:nrow(Barcelona_sport_items_2)) {
  if (Barcelona_sport_items_2$lang.y[i] == "en") {
    Barcelona_sport_items_2$article[i] <- Barcelona_sport_items_2$article.y[i]
    Barcelona_sport_items_2$lang[i] <- Barcelona_sport_items_2$lang.y[i]
  } else {
    Barcelona_sport_items_2$article[i] <- Barcelona_sport_items_2$article.x[i]
    Barcelona_sport_items_2$lang[i] <- Barcelona_sport_items_2$lang.x[i]
  }
}

Barcelona_sport_items_3 <- Barcelona_sport_items_2 %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x, -article.x, -article.y, -lang.x, -lang.y) %>%
  arrange(item, lang) %>%
  distinct(item, .keep_all = T) %>%
  left_join(Barcelona_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article.y, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article.y, "'>", article.y, "</a></b>", "<br>number of page views: ", value )) 

# high education
Barcelona_high_education_items_2 <- Barcelona_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_final, by = "item") %>%
  filter(id == 3) %>%
  left_join(Barcelona_C_final, by = "item") 

for (i in 1:nrow(Barcelona_high_education_items_2)) {
  if (Barcelona_high_education_items_2$lang.y[i] == "en") {
    Barcelona_high_education_items_2$article[i] <- Barcelona_high_education_items_2$article.y[i]
    Barcelona_high_education_items_2$lang[i] <- Barcelona_high_education_items_2$lang.y[i]
  } else {
    Barcelona_high_education_items_2$article[i] <- Barcelona_high_education_items_2$article.x[i]
    Barcelona_high_education_items_2$lang[i] <- Barcelona_high_education_items_2$lang.x[i]
  }
}

Barcelona_high_education_items_3 <- Barcelona_high_education_items_2 %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x, -article.x, -article.y, -lang.x, -lang.y) %>%
  arrange(item, lang) %>%
  distinct(item, .keep_all = T) %>%
  left_join(Barcelona_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article.y, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article.y, "'>", article.y, "</a></b>", "<br>number of page views: ", value )) 

# theatres
Barcelona_theatres_items_2 <- Barcelona_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_final, by = "item") %>%
  filter(id == 6) %>%
  left_join(Barcelona_C_final, by = "item") 

for (i in 1:nrow(Barcelona_theatres_items_2)) {
  if (Barcelona_theatres_items_2$lang.y[i] == "en") {
    Barcelona_theatres_items_2$article[i] <- Barcelona_theatres_items_2$article.y[i]
    Barcelona_theatres_items_2$lang[i] <- Barcelona_theatres_items_2$lang.y[i]
  } else {
    Barcelona_theatres_items_2$article[i] <- Barcelona_theatres_items_2$article.x[i]
    Barcelona_theatres_items_2$lang[i] <- Barcelona_theatres_items_2$lang.x[i]
  }
}

Barcelona_theatres_items_3 <- Barcelona_theatres_items_2 %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x, -article.x, -article.y, -lang.x, -lang.y) %>%
  arrange(item, lang) %>%
  distinct(item, .keep_all = T) %>%
  left_join(Barcelona_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article.y, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article.y, "'>", article.y, "</a></b>", "<br>number of page views: ", value )) 

# buildings
Barcelona_buildings_items_2 <- Barcelona_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_final, by = "item") %>%
  filter(id == 7) %>%
  left_join(Barcelona_C_final, by = "item") 

for (i in 1:nrow(Barcelona_buildings_items_2)) {
  if (Barcelona_buildings_items_2$lang.y[i] == "en") {
    Barcelona_buildings_items_2$article[i] <- Barcelona_buildings_items_2$article.y[i]
    Barcelona_buildings_items_2$lang[i] <- Barcelona_buildings_items_2$lang.y[i]
  } else {
    Barcelona_buildings_items_2$article[i] <- Barcelona_buildings_items_2$article.x[i]
    Barcelona_buildings_items_2$lang[i] <- Barcelona_buildings_items_2$lang.x[i]
  }
}

Barcelona_buildings_items_3 <- Barcelona_buildings_items_2 %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x, -article.x, -article.y, -lang.x, -lang.y) %>%
  arrange(item, lang) %>%
  distinct(item, .keep_all = T) %>%
  left_join(Barcelona_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article.y, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article.y, "'>", article.y, "</a></b>", "<br>number of page views: ", value )) 

# streets and districts
Barcelona_streets_and_districts_items_2 <- Barcelona_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_final, by = "item") %>%
  filter(id == 9) %>%
  left_join(Barcelona_C_final, by = "item") 

for (i in 1:nrow(Barcelona_streets_and_districts_items_2)) {
  if (Barcelona_streets_and_districts_items_2$lang.y[i] == "en") {
    Barcelona_streets_and_districts_items_2$article[i] <- Barcelona_streets_and_districts_items_2$article.y[i]
    Barcelona_streets_and_districts_items_2$lang[i] <- Barcelona_streets_and_districts_items_2$lang.y[i]
  } else {
    Barcelona_streets_and_districts_items_2$article[i] <- Barcelona_streets_and_districts_items_2$article.x[i]
    Barcelona_streets_and_districts_items_2$lang[i] <- Barcelona_streets_and_districts_items_2$lang.x[i]
  }
}

Barcelona_streets_and_districts_items_3 <- Barcelona_streets_and_districts_items_2 %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x, -article.x, -article.y, -lang.x, -lang.y) %>%
  arrange(item, lang) %>%
  distinct(item, .keep_all = T)%>%
  left_join(Barcelona_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article.y, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article.y, "'>", article.y, "</a></b>", "<br>number of page views: ", value )) 

# museums
Barcelona_museums_items_2 <- Barcelona_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_final, by = "item") %>%
  filter(id == 10) %>%
  left_join(Barcelona_C_final, by = "item") 

for (i in 1:nrow(Barcelona_museums_items_2)) {
  if (Barcelona_museums_items_2$lang.y[i] == "en") {
    Barcelona_museums_items_2$article[i] <- Barcelona_museums_items_2$article.y[i]
    Barcelona_museums_items_2$lang[i] <- Barcelona_museums_items_2$lang.y[i]
  } else {
    Barcelona_museums_items_2$article[i] <- Barcelona_museums_items_2$article.x[i]
    Barcelona_museums_items_2$lang[i] <- Barcelona_museums_items_2$lang.x[i]
  }
}

Barcelona_museums_items_3 <- Barcelona_museums_items_2 %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x, -article.x, -article.y, -lang.x, -lang.y) %>%
  arrange(item, lang) %>%
  distinct(item, .keep_all = T) %>%
  left_join(Barcelona_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article.y, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article.y, "'>", article.y, "</a></b>", "<br>number of page views: ", value )) 

# history
Barcelona_history_items_2 <- Barcelona_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_final, by = "item") %>%
  filter(id == 12) %>%
  left_join(Barcelona_C_final, by = "item") 

for (i in 1:nrow(Barcelona_history_items_2)) {
  if (Barcelona_history_items_2$lang.y[i] == "en") {
    Barcelona_history_items_2$article[i] <- Barcelona_history_items_2$article.y[i]
    Barcelona_history_items_2$lang[i] <- Barcelona_history_items_2$lang.y[i]
  } else {
    Barcelona_history_items_2$article[i] <- Barcelona_history_items_2$article.x[i]
    Barcelona_history_items_2$lang[i] <- Barcelona_history_items_2$lang.x[i]
  }
}

Barcelona_history_items_3 <- Barcelona_history_items_2 %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x, -article.x, -article.y, -lang.x, -lang.y) %>%
  arrange(item, lang) %>%
  distinct(item, .keep_all = T) %>%
  left_join(Barcelona_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article.y, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article.y, "'>", article.y, "</a></b>", "<br>number of page views: ", value )) 

# institutions/organizations
Barcelona_institutions_organizations_items_2 <- Barcelona_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_final, by = "item") %>%
  filter(id == 13) %>%
  left_join(Barcelona_C_final, by = "item") 

for (i in 1:nrow(Barcelona_institutions_organizations_items_2)) {
  if (Barcelona_institutions_organizations_items_2$lang.y[i] == "en") {
    Barcelona_institutions_organizations_items_2$article[i] <- Barcelona_institutions_organizations_items_2$article.y[i]
    Barcelona_institutions_organizations_items_2$lang[i] <- Barcelona_institutions_organizations_items_2$lang.y[i]
  } else {
    Barcelona_institutions_organizations_items_2$article[i] <- Barcelona_institutions_organizations_items_2$article.x[i]
    Barcelona_institutions_organizations_items_2$lang[i] <- Barcelona_institutions_organizations_items_2$lang.x[i]
  }
}

Barcelona_institutions_organizations_items_3 <- Barcelona_institutions_organizations_items_2 %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x, -article.x, -article.y, -lang.x, -lang.y) %>%
  arrange(item, lang) %>%
  distinct(item, .keep_all = T) %>%
  left_join(Barcelona_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article.y, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article.y, "'>", article.y, "</a></b>", "<br>number of page views: ", value )) 

# monuments and fountains
Barcelona_monuments_and_fountains_items_2 <- Barcelona_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_final, by = "item") %>%
  filter(id == 15) %>%
  left_join(Barcelona_C_final, by = "item") 

for (i in 1:nrow(Barcelona_monuments_and_fountains_items_2)) {
  if (Barcelona_monuments_and_fountains_items_2$lang.y[i] == "en") {
    Barcelona_monuments_and_fountains_items_2$article[i] <- Barcelona_monuments_and_fountains_items_2$article.y[i]
    Barcelona_monuments_and_fountains_items_2$lang[i] <- Barcelona_monuments_and_fountains_items_2$lang.y[i]
  } else {
    Barcelona_monuments_and_fountains_items_2$article[i] <- Barcelona_monuments_and_fountains_items_2$article.x[i]
    Barcelona_monuments_and_fountains_items_2$lang[i] <- Barcelona_monuments_and_fountains_items_2$lang.x[i]
  }
}

Barcelona_monuments_and_fountains_items_3 <- Barcelona_monuments_and_fountains_items_2 %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x, -article.x, -article.y, -lang.x, -lang.y) %>%
  arrange(item, lang) %>%
  distinct(item, .keep_all = T) %>%
  left_join(Barcelona_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article.y, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article.y, "'>", article.y, "</a></b>", "<br>number of page views: ", value )) 

# parks
Barcelona_parks_items_2 <- Barcelona_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_final, by = "item") %>%
  filter(id == 17) %>%
  left_join(Barcelona_C_final, by = "item") 

for (i in 1:nrow(Barcelona_parks_items_2)) {
  if (Barcelona_parks_items_2$lang.y[i] == "en") {
    Barcelona_parks_items_2$article[i] <- Barcelona_parks_items_2$article.y[i]
    Barcelona_parks_items_2$lang[i] <- Barcelona_parks_items_2$lang.y[i]
  } else {
    Barcelona_parks_items_2$article[i] <- Barcelona_parks_items_2$article.x[i]
    Barcelona_parks_items_2$lang[i] <- Barcelona_parks_items_2$lang.x[i]
  }
}

Barcelona_parks_items_3 <- Barcelona_parks_items_2 %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x, -article.x, -article.y, -lang.x, -lang.y) %>%
  arrange(item, lang) %>%
  distinct(item, .keep_all = T)%>%
  left_join(Barcelona_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article.y, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article.y, "'>", article.y, "</a></b>", "<br>number of page views: ", value )) 

# places of worship
Barcelona_places_of_worship_items_2 <- Barcelona_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_final, by = "item") %>%
  filter(id == 18) %>%
  left_join(Barcelona_C_final, by = "item") 

for (i in 1:nrow(Barcelona_places_of_worship_items_2)) {
  if (Barcelona_places_of_worship_items_2$lang.y[i] == "en") {
    Barcelona_places_of_worship_items_2$article[i] <- Barcelona_places_of_worship_items_2$article.y[i]
    Barcelona_places_of_worship_items_2$lang[i] <- Barcelona_places_of_worship_items_2$lang.y[i]
  } else {
    Barcelona_places_of_worship_items_2$article[i] <- Barcelona_places_of_worship_items_2$article.x[i]
    Barcelona_places_of_worship_items_2$lang[i] <- Barcelona_places_of_worship_items_2$lang.x[i]
  }
}

Barcelona_places_of_worship_items_3 <- Barcelona_places_of_worship_items_2 %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x, -article.x, -article.y, -lang.x, -lang.y) %>%
  arrange(item, lang) %>%
  distinct(item, .keep_all = T) %>%
  left_join(Barcelona_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article.y, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article.y, "'>", article.y, "</a></b>", "<br>number of page views: ", value )) 

# Bruges

Bruges_public_transport_items_2 <- Bruges_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Bruges_final, by = "item") %>%
  filter(id == 1) %>%
  left_join(Bruges_C_final, by = "item") 

for (i in 1:nrow(Bruges_public_transport_items_2)) {
  if (Bruges_public_transport_items_2$lang.y[i] == "en") {
    Bruges_public_transport_items_2$article[i] <- Bruges_public_transport_items_2$article.y[i]
    Bruges_public_transport_items_2$lang[i] <- Bruges_public_transport_items_2$lang.y[i]
  } else {
    Bruges_public_transport_items_2$article[i] <- Bruges_public_transport_items_2$article.x[i]
    Bruges_public_transport_items_2$lang[i] <- Bruges_public_transport_items_2$lang.x[i]
  }
}

Bruges_public_transport_items_3 <- Bruges_public_transport_items_2 %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x, -article.x, -article.y, -lang.x, -lang.y) %>%
  arrange(item, lang) %>%
  distinct(item, .keep_all = T) %>%
  left_join(Bruges_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article.y, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article.y, "'>", article.y, "</a></b>", "<br>number of page views: ", value )) 

Bruges_streets_and_streams_items_2 <- Bruges_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Bruges_final, by = "item") %>%
  filter(id == 2) %>%
  left_join(Bruges_C_final, by = "item") 

for (i in 1:nrow(Bruges_streets_and_streams_items_2)) {
  if (Bruges_streets_and_streams_items_2$lang.y[i] == "en") {
    Bruges_streets_and_streams_items_2$article[i] <- Bruges_streets_and_streams_items_2$article.y[i]
    Bruges_streets_and_streams_items_2$lang[i] <- Bruges_streets_and_streams_items_2$lang.y[i]
  } else {
    Bruges_streets_and_streams_items_2$article[i] <- Bruges_streets_and_streams_items_2$article.x[i]
    Bruges_streets_and_streams_items_2$lang[i] <- Bruges_streets_and_streams_items_2$lang.x[i]
  }
}

Bruges_streets_and_streams_items_3 <- Bruges_streets_and_streams_items_2 %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x, -article.x, -article.y, -lang.x, -lang.y) %>%
  arrange(item, lang) %>%
  distinct(item, .keep_all = T) %>%
  left_join(Bruges_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article.y, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article.y, "'>", article.y, "</a></b>", "<br>number of page views: ", value )) 

Bruges_libraries_items_2 <- Bruges_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Bruges_final, by = "item") %>%
  filter(id == 3) %>%
  left_join(Bruges_C_final, by = "item") 

for (i in 1:nrow(Bruges_libraries_items_2)) {
  if (Bruges_libraries_items_2$lang.y[i] == "en") {
    Bruges_libraries_items_2$article[i] <- Bruges_libraries_items_2$article.y[i]
    Bruges_libraries_items_2$lang[i] <- Bruges_libraries_items_2$lang.y[i]
  } else {
    Bruges_libraries_items_2$article[i] <- Bruges_libraries_items_2$article.x[i]
    Bruges_libraries_items_2$lang[i] <- Bruges_libraries_items_2$lang.x[i]
  }
}

Bruges_libraries_items_3 <- Bruges_libraries_items_2 %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x, -article.x, -article.y, -lang.x, -lang.y) %>%
  arrange(item, lang) %>%
  distinct(item, .keep_all = T) %>%
  left_join(Bruges_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article.y, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article.y, "'>", article.y, "</a></b>", "<br>number of page views: ", value )) 

Bruges_buildings_items_2 <- Bruges_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Bruges_final, by = "item") %>%
  filter(id == 4) %>%
  left_join(Bruges_C_final, by = "item") 

for (i in 1:nrow(Bruges_buildings_items_2)) {
  if (Bruges_buildings_items_2$lang.y[i] == "en") {
    Bruges_buildings_items_2$article[i] <- Bruges_buildings_items_2$article.y[i]
    Bruges_buildings_items_2$lang[i] <- Bruges_buildings_items_2$lang.y[i]
  } else {
    Bruges_buildings_items_2$article[i] <- Bruges_buildings_items_2$article.x[i]
    Bruges_buildings_items_2$lang[i] <- Bruges_buildings_items_2$lang.x[i]
  }
}

Bruges_buildings_items_3 <- Bruges_buildings_items_2 %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x, -article.x, -article.y, -lang.x, -lang.y) %>%
  arrange(item, lang) %>%
  distinct(item, .keep_all = T)%>%
  left_join(Bruges_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article.y, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article.y, "'>", article.y, "</a></b>", "<br>number of page views: ", value )) 

Bruges_high_education_items_2 <- Bruges_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Bruges_final, by = "item") %>%
  filter(id == 5) %>%
  left_join(Bruges_C_final, by = "item") 

for (i in 1:nrow(Bruges_high_education_items_2)) {
  if (Bruges_high_education_items_2$lang.y[i] == "en") {
    Bruges_high_education_items_2$article[i] <- Bruges_high_education_items_2$article.y[i]
    Bruges_high_education_items_2$lang[i] <- Bruges_high_education_items_2$lang.y[i]
  } else {
    Bruges_high_education_items_2$article[i] <- Bruges_high_education_items_2$article.x[i]
    Bruges_high_education_items_2$lang[i] <- Bruges_high_education_items_2$lang.x[i]
  }
}

Bruges_high_education_items_3 <- Bruges_high_education_items_2 %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x, -article.x, -article.y, -lang.x, -lang.y) %>%
  arrange(item, lang) %>%
  distinct(item, .keep_all = T)%>%
  left_join(Bruges_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article.y, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article.y, "'>", article.y, "</a></b>", "<br>number of page views: ", value )) 

Bruges_companies_items_2 <- Bruges_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Bruges_final, by = "item") %>%
  filter(id == 13) %>%
  left_join(Bruges_C_final, by = "item") 

for (i in 1:nrow(Bruges_companies_items_2)) {
  if (Bruges_companies_items_2$lang.y[i] == "en") {
    Bruges_companies_items_2$article[i] <- Bruges_companies_items_2$article.y[i]
    Bruges_companies_items_2$lang[i] <- Bruges_companies_items_2$lang.y[i]
  } else {
    Bruges_companies_items_2$article[i] <- Bruges_companies_items_2$article.x[i]
    Bruges_companies_items_2$lang[i] <- Bruges_companies_items_2$lang.x[i]
  }
}

Bruges_companies_items_3 <- Bruges_companies_items_2 %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x, -article.x, -article.y, -lang.x, -lang.y) %>%
  arrange(item, lang) %>%
  distinct(item, .keep_all = T)%>%
  left_join(Bruges_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article.y, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article.y, "'>", article.y, "</a></b>", "<br>number of page views: ", value )) 

Bruges_bridges_and_canals_items_2 <- Bruges_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Bruges_final, by = "item") %>%
  filter(id == 8) %>%
  left_join(Bruges_C_final, by = "item") 

for (i in 1:nrow(Bruges_bridges_and_canals_items_2)) {
  if (Bruges_bridges_and_canals_items_2$lang.y[i] == "en") {
    Bruges_bridges_and_canals_items_2$article[i] <- Bruges_bridges_and_canals_items_2$article.y[i]
    Bruges_bridges_and_canals_items_2$lang[i] <- Bruges_bridges_and_canals_items_2$lang.y[i]
  } else {
    Bruges_bridges_and_canals_items_2$article[i] <- Bruges_bridges_and_canals_items_2$article.x[i]
    Bruges_bridges_and_canals_items_2$lang[i] <- Bruges_bridges_and_canals_items_2$lang.x[i]
  }
}

Bruges_bridges_and_canals_items_3 <- Bruges_bridges_and_canals_items_2 %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x, -article.x, -article.y, -lang.x, -lang.y) %>%
  arrange(item, lang) %>%
  distinct(item, .keep_all = T) %>%
  left_join(Bruges_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article.y, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article.y, "'>", article.y, "</a></b>", "<br>number of page views: ", value )) 

Bruges_districts_items_2 <- Bruges_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Bruges_final, by = "item") %>%
  filter(id == 10) %>%
  left_join(Bruges_C_final, by = "item") 

for (i in 1:nrow(Bruges_districts_items_2)) {
  if (Bruges_districts_items_2$lang.y[i] == "en") {
    Bruges_districts_items_2$article[i] <- Bruges_districts_items_2$article.y[i]
    Bruges_districts_items_2$lang[i] <- Bruges_districts_items_2$lang.y[i]
  } else {
    Bruges_districts_items_2$article[i] <- Bruges_districts_items_2$article.x[i]
    Bruges_districts_items_2$lang[i] <- Bruges_districts_items_2$lang.x[i]
  }
}

Bruges_districts_items_3 <- Bruges_districts_items_2 %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x, -article.x, -article.y, -lang.x, -lang.y) %>%
  arrange(item, lang) %>%
  distinct(item, .keep_all = T)%>%
  left_join(Bruges_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article.y, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article.y, "'>", article.y, "</a></b>", "<br>number of page views: ", value )) 

Bruges_places_of_worship_items_2 <- Bruges_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Bruges_final, by = "item") %>%
  filter(id == 11) %>%
  left_join(Bruges_C_final, by = "item") 

for (i in 1:nrow(Bruges_places_of_worship_items_2)) {
  if (Bruges_places_of_worship_items_2$lang.y[i] == "en") {
    Bruges_places_of_worship_items_2$article[i] <- Bruges_places_of_worship_items_2$article.y[i]
    Bruges_places_of_worship_items_2$lang[i] <- Bruges_places_of_worship_items_2$lang.y[i]
  } else {
    Bruges_places_of_worship_items_2$article[i] <- Bruges_places_of_worship_items_2$article.x[i]
    Bruges_places_of_worship_items_2$lang[i] <- Bruges_places_of_worship_items_2$lang.x[i]
  }
}

Bruges_places_of_worship_items_3 <- Bruges_places_of_worship_items_2 %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x, -article.x, -article.y, -lang.x, -lang.y) %>%
  arrange(item, lang) %>%
  distinct(item, .keep_all = T) %>%
  left_join(Bruges_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article.y, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article.y, "'>", article.y, "</a></b>", "<br>number of page views: ", value )) 

Bruges_museums_items_2 <- Bruges_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Bruges_final, by = "item") %>%
  filter(id == 14) %>%
  left_join(Bruges_C_final, by = "item") 

for (i in 1:nrow(Bruges_museums_items_2)) {
  if (Bruges_museums_items_2$lang.y[i] == "en") {
    Bruges_museums_items_2$article[i] <- Bruges_museums_items_2$article.y[i]
    Bruges_museums_items_2$lang[i] <- Bruges_museums_items_2$lang.y[i]
  } else {
    Bruges_museums_items_2$article[i] <- Bruges_museums_items_2$article.x[i]
    Bruges_museums_items_2$lang[i] <- Bruges_museums_items_2$lang.x[i]
  }
}

Bruges_museums_items_3 <- Bruges_museums_items_2 %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x, -article.x, -article.y, -lang.x, -lang.y) %>%
  arrange(item, lang) %>%
  distinct(item, .keep_all = T) %>%
  left_join(Bruges_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article.y, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article.y, "'>", article.y, "</a></b>", "<br>number of page views: ", value )) 

Bruges_sport_items_2 <- Bruges_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Bruges_final, by = "item") %>%
  filter(id == 9) %>%
  left_join(Bruges_C_final, by = "item") 

for (i in 1:nrow(Bruges_sport_items_2)) {
  if (Bruges_sport_items_2$lang.y[i] == "en") {
    Bruges_sport_items_2$article[i] <- Bruges_sport_items_2$article.y[i]
    Bruges_sport_items_2$lang[i] <- Bruges_sport_items_2$lang.y[i]
  } else {
    Bruges_sport_items_2$article[i] <- Bruges_sport_items_2$article.x[i]
    Bruges_sport_items_2$lang[i] <- Bruges_sport_items_2$lang.x[i]
  }
}

Bruges_sport_items_3 <- Bruges_sport_items_2 %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x, -article.x, -article.y, -lang.x, -lang.y) %>%
  arrange(item, lang) %>%
  distinct(item, .keep_all = T) %>%
  left_join(Bruges_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article.y, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article.y, "'>", article.y, "</a></b>", "<br>number of page views: ", value )) 

# Vienna

Vienna_sport_items_2 <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 1) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(lang.x = as.character(lang.x),
         lang.y = as.character(lang.y))

for (i in 1:nrow(Vienna_sport_items_2)) {
  if (Vienna_sport_items_2$lang.y[i] == "en") {
    Vienna_sport_items_2$article[i] <- Vienna_sport_items_2$article.y[i]
    Vienna_sport_items_2$lang[i] <- Vienna_sport_items_2$lang.y[i]
  } else {
    Vienna_sport_items_2$article[i] <- Vienna_sport_items_2$article.x[i]
    Vienna_sport_items_2$lang[i] <- Vienna_sport_items_2$lang.x[i]
  }
}

Vienna_sport_items_3 <- Vienna_sport_items_2 %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x, -article.x, -article.y, -lang.x, -lang.y) %>%
  arrange(item, lang) %>%
  distinct(item, .keep_all = T) %>%
  left_join(Vienna_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article.y, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article.y, "'>", article.y, "</a></b>", "<br>number of page views: ", value )) 

Vienna_institutions_organizations_items_2 <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 3) %>%
  left_join(Vienna_C_final, by = "item")  %>%
  mutate(lang.x = as.character(lang.x),
         lang.y = as.character(lang.y))

for (i in 1:nrow(Vienna_institutions_organizations_items_2)) {
  if (Vienna_institutions_organizations_items_2$lang.y[i] == "en") {
    Vienna_institutions_organizations_items_2$article[i] <- Vienna_institutions_organizations_items_2$article.y[i]
    Vienna_institutions_organizations_items_2$lang[i] <- Vienna_institutions_organizations_items_2$lang.y[i]
  } else {
    Vienna_institutions_organizations_items_2$article[i] <- Vienna_institutions_organizations_items_2$article.x[i]
    Vienna_institutions_organizations_items_2$lang[i] <- Vienna_institutions_organizations_items_2$lang.x[i]
  }
}

Vienna_institutions_organizations_items_3 <- Vienna_institutions_organizations_items_2 %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x, -article.x, -article.y, -lang.x, -lang.y) %>%
  arrange(item, lang) %>%
  distinct(item, .keep_all = T) %>%
  left_join(Vienna_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article.y, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article.y, "'>", article.y, "</a></b>", "<br>number of page views: ", value )) 


Vienna_history_items_2 <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 4) %>%
  left_join(Vienna_C_final, by = "item")  %>%
  mutate(lang.x = as.character(lang.x),
         lang.y = as.character(lang.y))

for (i in 1:nrow(Vienna_history_items_2)) {
  if (Vienna_history_items_2$lang.y[i] == "en") {
    Vienna_history_items_2$article[i] <- Vienna_history_items_2$article.y[i]
    Vienna_history_items_2$lang[i] <- Vienna_history_items_2$lang.y[i]
  } else {
    Vienna_history_items_2$article[i] <- Vienna_history_items_2$article.x[i]
    Vienna_history_items_2$lang[i] <- Vienna_history_items_2$lang.x[i]
  }
}

Vienna_history_items_3 <- Vienna_history_items_2 %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x, -article.x, -article.y, -lang.x, -lang.y) %>%
  arrange(item, lang) %>%
  distinct(item, .keep_all = T) %>%
  left_join(Vienna_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article.y, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article.y, "'>", article.y, "</a></b>", "<br>number of page views: ", value )) 

Vienna_places_of_worship_items_2 <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 7) %>%
  left_join(Vienna_C_final, by = "item")  %>%
  mutate(lang.x = as.character(lang.x),
         lang.y = as.character(lang.y))

for (i in 1:nrow(Vienna_places_of_worship_items_2)) {
  if (Vienna_places_of_worship_items_2$lang.y[i] == "en") {
    Vienna_places_of_worship_items_2$article[i] <- Vienna_places_of_worship_items_2$article.y[i]
    Vienna_places_of_worship_items_2$lang[i] <- Vienna_places_of_worship_items_2$lang.y[i]
  } else {
    Vienna_places_of_worship_items_2$article[i] <- Vienna_places_of_worship_items_2$article.x[i]
    Vienna_places_of_worship_items_2$lang[i] <- Vienna_places_of_worship_items_2$lang.x[i]
  }
}

Vienna_places_of_worship_items_3 <- Vienna_places_of_worship_items_2 %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x, -article.x, -article.y, -lang.x, -lang.y) %>%
  arrange(item, lang) %>%
  distinct(item, .keep_all = T)%>%
  left_join(Vienna_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article.y, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article.y, "'>", article.y, "</a></b>", "<br>number of page views: ", value )) 

Vienna_companies_items_2 <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 9) %>%
  left_join(Vienna_C_final, by = "item")  %>%
  mutate(lang.x = as.character(lang.x),
         lang.y = as.character(lang.y))

for (i in 1:nrow(Vienna_companies_items_2)) {
  if (Vienna_companies_items_2$lang.y[i] == "en") {
    Vienna_companies_items_2$article[i] <- Vienna_companies_items_2$article.y[i]
    Vienna_companies_items_2$lang[i] <- Vienna_companies_items_2$lang.y[i]
  } else {
    Vienna_companies_items_2$article[i] <- Vienna_companies_items_2$article.x[i]
    Vienna_companies_items_2$lang[i] <- Vienna_companies_items_2$lang.x[i]
  }
}

Vienna_companies_items_3 <- Vienna_companies_items_2 %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x, -article.x, -article.y, -lang.x, -lang.y) %>%
  arrange(item, lang) %>%
  distinct(item, .keep_all = T) %>%
  left_join(Vienna_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article.y, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article.y, "'>", article.y, "</a></b>", "<br>number of page views: ", value )) 

Vienna_bus_stops_and_stations_items_2 <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 12) %>%
  left_join(Vienna_C_final, by = "item")  %>%
  mutate(lang.x = as.character(lang.x),
         lang.y = as.character(lang.y))

for (i in 1:nrow(Vienna_bus_stops_and_stations_items_2)) {
  if (Vienna_bus_stops_and_stations_items_2$lang.y[i] == "en") {
    Vienna_bus_stops_and_stations_items_2$article[i] <- Vienna_bus_stops_and_stations_items_2$article.y[i]
    Vienna_bus_stops_and_stations_items_2$lang[i] <- Vienna_bus_stops_and_stations_items_2$lang.y[i]
  } else {
    Vienna_bus_stops_and_stations_items_2$article[i] <- Vienna_bus_stops_and_stations_items_2$article.x[i]
    Vienna_bus_stops_and_stations_items_2$lang[i] <- Vienna_bus_stops_and_stations_items_2$lang.x[i]
  }
}

Vienna_bus_stops_and_stations_items_3 <- Vienna_bus_stops_and_stations_items_2 %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x, -article.x, -article.y, -lang.x, -lang.y) %>%
  arrange(item, lang) %>%
  distinct(item, .keep_all = T) %>%
  left_join(Vienna_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article.y, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article.y, "'>", article.y, "</a></b>", "<br>number of page views: ", value )) 

Vienna_streets_and_squares_items_2 <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 20) %>%
  left_join(Vienna_C_final, by = "item")  %>%
  mutate(lang.x = as.character(lang.x),
         lang.y = as.character(lang.y))

for (i in 1:nrow(Vienna_streets_and_squares_items_2)) {
  if (Vienna_streets_and_squares_items_2$lang.y[i] == "en") {
    Vienna_streets_and_squares_items_2$article[i] <- Vienna_streets_and_squares_items_2$article.y[i]
    Vienna_streets_and_squares_items_2$lang[i] <- Vienna_streets_and_squares_items_2$lang.y[i]
  } else {
    Vienna_streets_and_squares_items_2$article[i] <- Vienna_streets_and_squares_items_2$article.x[i]
    Vienna_streets_and_squares_items_2$lang[i] <- Vienna_streets_and_squares_items_2$lang.x[i]
  }
}

Vienna_streets_and_squares_items_3 <- Vienna_streets_and_squares_items_2 %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x, -article.x, -article.y, -lang.x, -lang.y) %>%
  arrange(item, lang) %>%
  distinct(item, .keep_all = T) %>%
  left_join(Vienna_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article.y, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article.y, "'>", article.y, "</a></b>", "<br>number of page views: ", value )) 

Vienna_rivers_and_parks_items_2 <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 21) %>%
  left_join(Vienna_C_final, by = "item")  %>%
  mutate(lang.x = as.character(lang.x),
         lang.y = as.character(lang.y))

for (i in 1:nrow(Vienna_rivers_and_parks_items_2)) {
  if (Vienna_rivers_and_parks_items_2$lang.y[i] == "en") {
    Vienna_rivers_and_parks_items_2$article[i] <- Vienna_rivers_and_parks_items_2$article.y[i]
    Vienna_rivers_and_parks_items_2$lang[i] <- Vienna_rivers_and_parks_items_2$lang.y[i]
  } else {
    Vienna_rivers_and_parks_items_2$article[i] <- Vienna_rivers_and_parks_items_2$article.x[i]
    Vienna_rivers_and_parks_items_2$lang[i] <- Vienna_rivers_and_parks_items_2$lang.x[i]
  }
}

Vienna_rivers_and_parks_items_3 <- Vienna_rivers_and_parks_items_2 %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x, -article.x, -article.y, -lang.x, -lang.y) %>%
  arrange(item, lang) %>%
  distinct(item, .keep_all = T) %>%
  left_join(Vienna_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article.y, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article.y, "'>", article.y, "</a></b>", "<br>number of page views: ", value )) 

Vienna_museums_items_2 <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 27) %>%
  left_join(Vienna_C_final, by = "item")  %>%
  mutate(lang.x = as.character(lang.x),
         lang.y = as.character(lang.y))

for (i in 1:nrow(Vienna_museums_items_2)) {
  if (Vienna_museums_items_2$lang.y[i] == "en") {
    Vienna_museums_items_2$article[i] <- Vienna_museums_items_2$article.y[i]
    Vienna_museums_items_2$lang[i] <- Vienna_museums_items_2$lang.y[i]
  } else {
    Vienna_museums_items_2$article[i] <- Vienna_museums_items_2$article.x[i]
    Vienna_museums_items_2$lang[i] <- Vienna_museums_items_2$lang.x[i]
  }
}

Vienna_museums_items_3 <- Vienna_museums_items_2 %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x, -article.x, -article.y, -lang.x, -lang.y) %>%
  arrange(item, lang) %>%
  distinct(item, .keep_all = T) %>%
  left_join(Vienna_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article.y, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article.y, "'>", article.y, "</a></b>", "<br>number of page views: ", value )) 

Vienna_buildings_items_2 <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 30) %>%
  left_join(Vienna_C_final, by = "item")  %>%
  mutate(lang.x = as.character(lang.x),
         lang.y = as.character(lang.y))

for (i in 1:nrow(Vienna_buildings_items_2)) {
  if (Vienna_buildings_items_2$lang.y[i] == "en") {
    Vienna_buildings_items_2$article[i] <- Vienna_buildings_items_2$article.y[i]
    Vienna_buildings_items_2$lang[i] <- Vienna_buildings_items_2$lang.y[i]
  } else {
    Vienna_buildings_items_2$article[i] <- Vienna_buildings_items_2$article.x[i]
    Vienna_buildings_items_2$lang[i] <- Vienna_buildings_items_2$lang.x[i]
  }
}

Vienna_buildings_items_3 <- Vienna_buildings_items_2 %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x, -article.x, -article.y, -lang.x, -lang.y) %>%
  arrange(item, lang) %>%
  distinct(item, .keep_all = T) %>%
  left_join(Vienna_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article.y, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article.y, "'>", article.y, "</a></b>", "<br>number of page views: ", value )) 

Vienna_libraries_items_2 <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 34) %>%
  left_join(Vienna_C_final, by = "item")  %>%
  mutate(lang.x = as.character(lang.x),
         lang.y = as.character(lang.y))

for (i in 1:nrow(Vienna_libraries_items_2)) {
  if (Vienna_libraries_items_2$lang.y[i] == "en") {
    Vienna_libraries_items_2$article[i] <- Vienna_libraries_items_2$article.y[i]
    Vienna_libraries_items_2$lang[i] <- Vienna_libraries_items_2$lang.y[i]
  } else {
    Vienna_libraries_items_2$article[i] <- Vienna_libraries_items_2$article.x[i]
    Vienna_libraries_items_2$lang[i] <- Vienna_libraries_items_2$lang.x[i]
  }
}

Vienna_libraries_items_3 <- Vienna_libraries_items_2 %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x, -article.x, -article.y, -lang.x, -lang.y) %>%
  arrange(item, lang) %>%
  distinct(item, .keep_all = T)%>%
  left_join(Vienna_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article.y, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article.y, "'>", article.y, "</a></b>", "<br>number of page views: ", value )) 

Vienna_statues_and_fountains_items_2 <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 35) %>%
  left_join(Vienna_C_final, by = "item")  %>%
  mutate(lang.x = as.character(lang.x),
         lang.y = as.character(lang.y))

for (i in 1:nrow(Vienna_statues_and_fountains_items_2)) {
  if (Vienna_statues_and_fountains_items_2$lang.y[i] == "en") {
    Vienna_statues_and_fountains_items_2$article[i] <- Vienna_statues_and_fountains_items_2$article.y[i]
    Vienna_statues_and_fountains_items_2$lang[i] <- Vienna_statues_and_fountains_items_2$lang.y[i]
  } else {
    Vienna_statues_and_fountains_items_2$article[i] <- Vienna_statues_and_fountains_items_2$article.x[i]
    Vienna_statues_and_fountains_items_2$lang[i] <- Vienna_statues_and_fountains_items_2$lang.x[i]
  }
}

Vienna_statues_and_fountains_items_3 <- Vienna_statues_and_fountains_items_2 %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x, -article.x, -article.y, -lang.x, -lang.y) %>%
  arrange(item, lang) %>%
  distinct(item, .keep_all = T) %>%
  left_join(Vienna_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article.y, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article.y, "'>", article.y, "</a></b>", "<br>number of page views: ", value )) 

Vienna_high_education_items_2 <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 39) %>%
  left_join(Vienna_C_final, by = "item")  %>%
  mutate(lang.x = as.character(lang.x),
         lang.y = as.character(lang.y))

for (i in 1:nrow(Vienna_high_education_items_2)) {
  if (Vienna_high_education_items_2$lang.y[i] == "en") {
    Vienna_high_education_items_2$article[i] <- Vienna_high_education_items_2$article.y[i]
    Vienna_high_education_items_2$lang[i] <- Vienna_high_education_items_2$lang.y[i]
  } else {
    Vienna_high_education_items_2$article[i] <- Vienna_high_education_items_2$article.x[i]
    Vienna_high_education_items_2$lang[i] <- Vienna_high_education_items_2$lang.x[i]
  }
}

Vienna_high_education_items_3 <- Vienna_high_education_items_2 %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x, -article.x, -article.y, -lang.x, -lang.y) %>%
  arrange(item, lang) %>%
  distinct(item, .keep_all = T) %>%
  left_join(Vienna_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article.y, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article.y, "'>", article.y, "</a></b>", "<br>number of page views: ", value )) 

Vienna_bridges_items_2 <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 41) %>%
  left_join(Vienna_C_final, by = "item")  %>%
  mutate(lang.x = as.character(lang.x),
         lang.y = as.character(lang.y))

for (i in 1:nrow(Vienna_bridges_items_2)) {
  if (Vienna_bridges_items_2$lang.y[i] == "en") {
    Vienna_bridges_items_2$article[i] <- Vienna_bridges_items_2$article.y[i]
    Vienna_bridges_items_2$lang[i] <- Vienna_bridges_items_2$lang.y[i]
  } else {
    Vienna_bridges_items_2$article[i] <- Vienna_bridges_items_2$article.x[i]
    Vienna_bridges_items_2$lang[i] <- Vienna_bridges_items_2$lang.x[i]
  }
}

Vienna_bridges_items_3 <- Vienna_bridges_items_2 %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x, -article.x, -article.y, -lang.x, -lang.y) %>%
  arrange(item, lang) %>%
  distinct(item, .keep_all = T) %>%
  left_join(Vienna_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article.y, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article.y, "'>", article.y, "</a></b>", "<br>number of page views: ", value )) 

Vienna_theatres_items_2 <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 44) %>%
  left_join(Vienna_C_final, by = "item")  %>%
  mutate(lang.x = as.character(lang.x),
         lang.y = as.character(lang.y))

for (i in 1:nrow(Vienna_theatres_items_2)) {
  if (Vienna_theatres_items_2$lang.y[i] == "en") {
    Vienna_theatres_items_2$article[i] <- Vienna_theatres_items_2$article.y[i]
    Vienna_theatres_items_2$lang[i] <- Vienna_theatres_items_2$lang.y[i]
  } else {
    Vienna_theatres_items_2$article[i] <- Vienna_theatres_items_2$article.x[i]
    Vienna_theatres_items_2$lang[i] <- Vienna_theatres_items_2$lang.x[i]
  }
}

Vienna_theatres_items_3 <- Vienna_theatres_items_2 %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x, -article.x, -article.y, -lang.x, -lang.y) %>%
  arrange(item, lang) %>%
  distinct(item, .keep_all = T) %>%
  left_join(Vienna_articles_in_C, by = c("item", "lang")) %>%
  group_by(item, article.y, lang, lat, long) %>%
  summarise(value = sum(as.numeric(value))) %>%
  mutate(link = paste0("<b><a href='http://", lang, ".wikipedia.org/wiki/", article.y, "'>", article.y, "</a></b>", "<br>number of page views: ", value )) 

write.csv(Barcelona_C_final, "Barcelona_C_final.csv", fileEncoding = "UTF-8")
write.csv(Barcelona_public_transport_items_3, "Barcelona_public_transport_items_3.csv", fileEncoding = "UTF-8")
write.csv(Barcelona_sport_items_3, "Barcelona_sport_items_3.csv", fileEncoding = "UTF-8")
write.csv(Barcelona_high_education_items_3, "Barcelona_high_education_items_3.csv", fileEncoding = "UTF-8")
write.csv(Barcelona_theatres_items_3, "Barcelona_theatres_items_3.csv", fileEncoding = "UTF-8")
write.csv(Barcelona_buildings_items_3, "Barcelona_buildings_items_3.csv", fileEncoding = "UTF-8")
write.csv(Barcelona_streets_and_districts_items_3, "Barcelona_streets_and_districts_items_3.csv", fileEncoding = "UTF-8")
write.csv(Barcelona_museums_items_3, "Barcelona_museums_items_3.csv", fileEncoding = "UTF-8")
write.csv(Barcelona_history_items_3, "Barcelona_history_items_3.csv", fileEncoding = "UTF-8")
write.csv(Barcelona_institutions_organizations_items_3, "Barcelona_institutions_organizations_items_3.csv", fileEncoding = "UTF-8")
write.csv(Barcelona_monuments_and_fountains_items_3, "Barcelona_monuments_and_fountains_items_3.csv", fileEncoding = "UTF-8")
write.csv(Barcelona_parks_items_3, "Barcelona_parks_items_3.csv", fileEncoding = "UTF-8")
write.csv(Barcelona_places_of_worship_items_3, "Barcelona_places_of_worship_items_3.csv", fileEncoding = "UTF-8")

write.csv(Bruges_C_final, "Bruges_C_final.csv", fileEncoding = "UTF-8")
write.csv(Bruges_public_transport_items_3, "Bruges_public_transport_items_3.csv", fileEncoding = "UTF-8")
write.csv(Bruges_streets_and_streams_items_3, "Bruges_streets_and_streams_items_3.csv", fileEncoding = "UTF-8")
write.csv(Bruges_libraries_items_3, "Bruges_libraries_items_3.csv", fileEncoding = "UTF-8")
write.csv(Bruges_buildings_items_3, "Bruges_buildings_items_3.csv", fileEncoding = "UTF-8")
write.csv(Bruges_high_education_items_3, "Bruges_high_education_items_3.csv", fileEncoding = "UTF-8")
write.csv(Bruges_companies_items_3, "Bruges_companies_items_3.csv", fileEncoding = "UTF-8")
write.csv(Bruges_bridges_and_canals_items_3, "Bruges_bridges_and_canals_items_3.csv", fileEncoding = "UTF-8")
write.csv(Bruges_sport_items_3, "Bruges_sport_items_3.csv", fileEncoding = "UTF-8")
write.csv(Bruges_districts_items_3, "Bruges_districts_items_3.csv", fileEncoding = "UTF-8")
write.csv(Bruges_places_of_worship_items_3, "Bruges_places_of_worship_items_3.csv", fileEncoding = "UTF-8")
write.csv(Bruges_museums_items_3, "Bruges_museums_items_3.csv", fileEncoding = "UTF-8")

write.csv(Vienna_C_final, "Vienna_C_final.csv", fileEncoding = "UTF-8")
write.csv(Vienna_sport_items_3, "Vienna_sport_items_3.csv", fileEncoding = "UTF-8")
write.csv(Vienna_institutions_organizations_items_3, "Vienna_institutions_organizations_items_3.csv", fileEncoding = "UTF-8")
write.csv(Vienna_history_items_3, "Vienna_history_items_3.csv", fileEncoding = "UTF-8")
write.csv(Vienna_places_of_worship_items_3, "Vienna_places_of_worship_items_3.csv", fileEncoding = "UTF-8")
write.csv(Vienna_companies_items_3, "Vienna_companies_items_3.csv", fileEncoding = "UTF-8")
write.csv(Vienna_bus_stops_and_stations_items_3, "Vienna_bus_stops_and_stations_items_3.csv", fileEncoding = "UTF-8")
write.csv(Vienna_streets_and_squares_items_3, "Vienna_streets_and_squares_items_3.csv", fileEncoding = "UTF-8")
write.csv(Vienna_rivers_and_parks_items_3, "Vienna_rivers_and_parks_items_3.csv", fileEncoding = "UTF-8")
write.csv(Vienna_museums_items_3, "Vienna_museums_items_3.csv", fileEncoding = "UTF-8")
write.csv(Vienna_buildings_items_3, "Vienna_buildings_items_3.csv", fileEncoding = "UTF-8")
write.csv(Vienna_libraries_items_3, "Vienna_libraries_items_3.csv", fileEncoding = "UTF-8")
write.csv(Vienna_statues_and_fountains_items_3, "Vienna_statues_and_fountains_items_3.csv", fileEncoding = "UTF-8")
write.csv(Vienna_high_education_items_3, "Vienna_high_education_items_3.csv", fileEncoding = "UTF-8")
write.csv(Vienna_bridges_items_3, "Vienna_bridges_items_3.csv", fileEncoding = "UTF-8")
write.csv(Vienna_theatres_items_3, "Vienna_theatres_items_3.csv", fileEncoding = "UTF-8")

Barcelona_C_final <- read.csv("C:/Users/signose/Desktop/data_for_maps/Barcelona_C_final.csv") %>%
  select(-X)
Barcelona_public_transport_items_3 <- read.csv("C:/Users/signose/Desktop/data_for_maps/Barcelona_public_transport_items_3.csv") %>%
  select(-X)
Barcelona_sport_items_3 <- read.csv("C:/Users/signose/Desktop/data_for_maps/Barcelona_sport_items_3.csv") %>%
  select(-X)
Barcelona_high_education_items_3 <- read.csv("C:/Users/signose/Desktop/data_for_maps/Barcelona_high_education_items_3.csv") %>%
  select(-X)
Barcelona_theatres_items_3 <- read.csv("C:/Users/signose/Desktop/data_for_maps/Barcelona_theatres_items_3.csv") %>%
  select(-X)
Barcelona_buildings_items_3 <- read.csv("C:/Users/signose/Desktop/data_for_maps/Barcelona_buildings_items_3.csv") %>%
  select(-X)
Barcelona_streets_and_districts_items_3 <- read.csv("C:/Users/signose/Desktop/data_for_maps/Barcelona_streets_and_districts_items_3.csv") %>%
  select(-X)
Barcelona_museums_items_3 <- read.csv("C:/Users/signose/Desktop/data_for_maps/Barcelona_museums_items_3.csv") %>%
  select(-X)
Barcelona_history_items_3 <- read.csv("C:/Users/signose/Desktop/data_for_maps/Barcelona_history_items_3.csv") %>%
  select(-X)
Barcelona_institutions_organizations_items_3 <- read.csv("C:/Users/signose/Desktop/data_for_maps/Barcelona_institutions_organizations_items_3.csv") %>%
  select(-X)
Barcelona_monuments_and_fountains_items_3 <- read.csv("C:/Users/signose/Desktop/data_for_maps/Barcelona_monuments_and_fountains_items_3.csv") %>%
  select(-X)
Barcelona_parks_items_3 <- read.csv("C:/Users/signose/Desktop/data_for_maps/Barcelona_parks_items_3.csv") %>%
  select(-X)
Barcelona_places_of_worship_items_3 <- read.csv("C:/Users/signose/Desktop/data_for_maps/Barcelona_places_of_worship_items_3.csv") %>%
  select(-X)

Bruges_C_final <- read.csv("C:/Users/signose/Desktop/data_for_maps/Bruges_C_final.csv") %>%
  select(-X)
Bruges_public_transport_items_3 <- read.csv("C:/Users/signose/Desktop/data_for_maps/Bruges_public_transport_items_3.csv") %>%
  select(-X)
Bruges_streets_and_streams_items_3 <- read.csv("C:/Users/signose/Desktop/data_for_maps/Bruges_streets_and_streams_items_3.csv") %>%
  select(-X)
Bruges_libraries_items_3 <- read.csv("C:/Users/signose/Desktop/data_for_maps/Bruges_libraries_items_3.csv") %>%
  select(-X)
Bruges_buildings_items_3 <- read.csv("C:/Users/signose/Desktop/data_for_maps/Bruges_buildings_items_3.csv") %>%
  select(-X)
Bruges_high_education_items_3 <- read.csv("C:/Users/signose/Desktop/data_for_maps/Bruges_high_education_items_3.csv") %>%
  select(-X)
Bruges_companies_items_3 <- read.csv("C:/Users/signose/Desktop/data_for_maps/Bruges_companies_items_3.csv") %>%
  select(-X)
Bruges_bridges_and_canals_items_3 <- read.csv("C:/Users/signose/Desktop/data_for_maps/Bruges_bridges_and_canals_items_3.csv") %>%
  select(-X)
Bruges_sport_items_3 <- read.csv("C:/Users/signose/Desktop/data_for_maps/Bruges_sport_items_3.csv") %>%
  select(-X)
Bruges_districts_items_3 <- read.csv("C:/Users/signose/Desktop/data_for_maps/Bruges_districts_items_3.csv") %>%
  select(-X)
Bruges_places_of_worship_items_3 <- read.csv("C:/Users/signose/Desktop/data_for_maps/Bruges_places_of_worship_items_3.csv") %>%
  select(-X)
Bruges_museums_items_3 <- read.csv("C:/Users/signose/Desktop/data_for_maps/Bruges_museums_items_3.csv") %>%
  select(-X)

Vienna_C_final <- read.csv("C:/Users/signose/Desktop/data_for_maps/Vienna_C_final.csv") %>%
  select(-X)
Vienna_sport_items_3 <- read.csv("C:/Users/signose/Desktop/data_for_maps/Vienna_sport_items_3.csv") %>%
  select(-X)
Vienna_institutions_organizations_items_3 <- read.csv("C:/Users/signose/Desktop/data_for_maps/Vienna_institutions_organizations_items_3.csv") %>%
  select(-X)
Vienna_history_items_3 <- read.csv("C:/Users/signose/Desktop/data_for_maps/Vienna_history_items_3.csv") %>%
  select(-X)
Vienna_places_of_worship_items_3 <- read.csv("C:/Users/signose/Desktop/data_for_maps/Vienna_places_of_worship_items_3.csv") %>%
  select(-X)
Vienna_companies_items_3 <- read.csv("C:/Users/signose/Desktop/data_for_maps/Vienna_companies_items_3.csv") %>%
  select(-X)
Vienna_bus_stops_and_stations_items_3 <- read.csv("C:/Users/signose/Desktop/data_for_maps/Vienna_bus_stops_and_stations_items_3.csv") %>%
  select(-X)
Vienna_streets_and_squares_items_3 <- read.csv("C:/Users/signose/Desktop/data_for_maps/Vienna_streets_and_squares_items_3.csv") %>%
  select(-X)
Vienna_rivers_and_parks_items_3 <- read.csv("C:/Users/signose/Desktop/data_for_maps/Vienna_rivers_and_parks_items_3.csv") %>%
  select(-X)
Vienna_museums_items_3 <- read.csv("C:/Users/signose/Desktop/data_for_maps/Vienna_museums_items_3.csv") %>%
  select(-X)
Vienna_buildings_items_3 <- read.csv("C:/Users/signose/Desktop/data_for_maps/Vienna_buildings_items_3.csv") %>%
  select(-X)
Vienna_libraries_items_3 <- read.csv("C:/Users/signose/Desktop/data_for_maps/Vienna_libraries_items_3.csv") %>%
  select(-X)
Vienna_statues_and_fountains_items_3 <- read.csv("C:/Users/signose/Desktop/data_for_maps/Vienna_statues_and_fountains_items_3.csv") %>%
  select(-X)
Vienna_high_education_items_3 <- read.csv("C:/Users/signose/Desktop/data_for_maps/Vienna_high_education_items_3.csv") %>%
  select(-X)
Vienna_bridges_items_3 <- read.csv("C:/Users/signose/Desktop/data_for_maps/Vienna_bridges_items_3.csv") %>%
  select(-X)
Vienna_theatres_items_3 <- read.csv("C:/Users/signose/Desktop/data_for_maps/Vienna_theatres_items_3.csv") %>%
  select(-X)


Cities <- rbind(Barcelona_C_final, Bruges_C_final, Vienna_C_final) 

cities_coord <- data.frame(city = c("Barcelona", "Bruges", "Vienna"), long = c(2.154007, 3.233333, 16.363449), lat = c(41.390205, 51.216667,	48.210033))

pal <-  c("#3182bd", "#636363", "#999999", "#e9a3c9", "#e34a33", "#8c510a", "#1b9e77", "#dd3497", "#74a9cf", "#7570b3", "#b2182b", "#2ca25f", "#fed976", "#02818a", "#8856a7")
#yellowgreen", "deeppink", "gold", "turquoise", "tomato", "purple", "forestgreen", "steelblue", "lightblue", "orchid", "red", "royalblue", "orangered", "orange", "gray")
labels <- c( "Bridges and canals", "Buildings", "Companies", "High education", "History","Institutions/organizations","Libraries", "Monuments and fountains",  "Museums", "Places of worship",  "Public transport", "Rivers and parks", "Sport", "Streets and districts","Theatres")

m <- leaflet(Cities) %>%
  addProviderTiles("CartoDB.Positron", group = "CartoDB")%>%
  addProviderTiles("Esri.WorldImagery", group = "Esri World Imagery")%>%
  addCircleMarkers(data = Bruges_bridges_and_canals_items_3, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#3182bd", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Bridges and canals") %>%
  addCircleMarkers(data = Barcelona_buildings_items_3, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#636363", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Buildings") %>%
  addCircleMarkers(data = Bruges_companies_items_3, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#999999", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Companies") %>%
  addCircleMarkers(data = Barcelona_high_education_items_3, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#e9a3c9", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "High education") %>%
  addCircleMarkers(data = Barcelona_history_items_3, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#e34a33", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "History") %>%
  addCircleMarkers(data = Barcelona_institutions_organizations_items_3, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#8c510a", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Institutions/organizations") %>%
  addCircleMarkers(data = Bruges_libraries_items_3, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#1b9e77", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Libraries") %>%
  addCircleMarkers(data = Barcelona_monuments_and_fountains_items_3, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#dd3497", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Monuments and fountains") %>%
  addCircleMarkers(data = Barcelona_museums_items_3, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#74a9cf", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Museums") %>%
  addCircleMarkers(data = Barcelona_places_of_worship_items_3, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#7570b3", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Places of worship") %>%
  addCircleMarkers(data = Barcelona_public_transport_items_3, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#b2182b", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Public transport") %>%
  addCircleMarkers(data = Barcelona_parks_items_3, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#2ca25f", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Rivers and parks") %>%
  addCircleMarkers(data = Barcelona_sport_items_3, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#fed976", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Sport") %>%
  addCircleMarkers(data = Barcelona_streets_and_districts_items_3, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#02818a", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Streets and districts") %>%
  addCircleMarkers(data = Barcelona_theatres_items_3, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#8856a7", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Theatres") %>%
  addCircleMarkers(data = Bruges_public_transport_items_3, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#b2182b", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Public transport") %>%
  addCircleMarkers(data = Bruges_streets_and_streams_items_3, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#02818a", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Streets and districts") %>%
  addCircleMarkers(data = Bruges_buildings_items_3, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#636363", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Buildings") %>%
  addCircleMarkers(data = Bruges_high_education_items_3, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#e9a3c9", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "High education") %>%
  addCircleMarkers(data = Bruges_sport_items_3, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#fed976", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Sport") %>%
  addCircleMarkers(data = Bruges_districts_items_3, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#02818a", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Streets and districts") %>%
  addCircleMarkers(data = Bruges_places_of_worship_items_3, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#7570b3", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Places of worship") %>%
  addCircleMarkers(data = Bruges_museums_items_3, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#74a9cf", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Museums") %>%
  addCircleMarkers(data = Vienna_sport_items_3, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#fed976", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Sport") %>%
  addCircleMarkers(data = Vienna_institutions_organizations_items_3, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#8c510a", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Institutions/organizations") %>%
  addCircleMarkers(data = Vienna_history_items_3, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#e34a33", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "History") %>%
  addCircleMarkers(data = Vienna_places_of_worship_items_3, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#7570b3", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Places of worship") %>%
  addCircleMarkers(data = Vienna_companies_items_3, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#999999", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Companies") %>%
  addCircleMarkers(data = Vienna_bus_stops_and_stations_items_3, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#b2182b", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Public transport") %>%
  addCircleMarkers(data = Vienna_streets_and_squares_items_3, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#02818a", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Streets and districts") %>%
  addCircleMarkers(data = Vienna_rivers_and_parks_items_3, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#2ca25f", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Rivers and parks") %>%
  addCircleMarkers(data = Vienna_museums_items_3, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#74a9cf", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Museums") %>%
  addCircleMarkers(data = Vienna_buildings_items_3, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#636363", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Buildings") %>%
  addCircleMarkers(data = Vienna_libraries_items_3, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#1b9e77", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Libraries") %>%
  addCircleMarkers(data = Vienna_statues_and_fountains_items_3, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#dd3497", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Monuments and fountains") %>%
  addCircleMarkers(data = Vienna_high_education_items_3, ~long, ~lat, radius = ~log(value), stroke = F, fillColor ="#e9a3c9", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "High education") %>%
  addCircleMarkers(data = Vienna_bridges_items_3, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#3182bd", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Bridges and canals") %>%
  addCircleMarkers(data = Vienna_theatres_items_3, ~long, ~lat, radius = ~log(value), stroke = F, fillColor = "#8856a7", fillOpacity = 0.6, popup = ~link, options =markerOptions(opacity = 0), group = "Theatres") %>%
  #addCircleMarkers(data = cities_coord, ~long, ~lat, radius = 0, options = markerOptions(opacity = 0), clusterOptions = markerClusterOptions()) %>%
  addLegend(position = c("bottomright"), colors = ~pal,  labels = ~labels) %>%
  addLegend(position = c("topright"), colors = c("snow", "snow"),  labels = c("Welcome to the Eurostat pilot", "the use of Wikipedia for Tourism statistics")) %>%
  addLayersControl(position = c("bottomleft"), baseGroups = c("CartoDB", "Esri World Imagery"),
                   overlayGroups = c("Sport", "Institutions/organizations", "History", "Places of worship", "Companies", "Public transport", "Streets and districts", "Rivers and parks", "Museums", "Buildings", "Libraries", "Monuments and fountains", "High education", "Bridges and canals", "Theatres"), options = layersControlOptions(collapsed = FALSE)) %>%
  hideGroup(c("Bridges and canals", "Companies", "Sport", "Institutions/organizations", "History", "Places of worship", "Public transport", "Streets and districts", "Rivers and parks", "Museums",  "Libraries", "Monuments and fountains", "High education", "Theatres"))
m

saveWidget(widget = m, file="Three_cities_categories_map.html", selfcontained = FALSE)
