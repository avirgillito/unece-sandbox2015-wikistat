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
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value))) 

# sport
Barcelona_sport_items <- Barcelona_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_final, by = "item") %>%
  filter(id == 2) %>%
  left_join(Barcelona_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value))) 

# high education
Barcelona_high_education_items <- Barcelona_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_final, by = "item") %>%
  filter(id == 3) %>%
  left_join(Barcelona_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value))) 

# theatres
Barcelona_theatres_items <- Barcelona_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_final, by = "item") %>%
  filter(id == 6) %>%
  left_join(Barcelona_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value))) 

# buildings
Barcelona_buildings_items <- Barcelona_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_final, by = "item") %>%
  filter(id == 7) %>%
  left_join(Barcelona_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value))) 

# streets and districts
Barcelona_streets_and_districts_items <- Barcelona_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_final, by = "item") %>%
  filter(id == 9) %>%
  left_join(Barcelona_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value))) 

# museums
Barcelona_museums_items <- Barcelona_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_final, by = "item") %>%
  filter(id == 10) %>%
  left_join(Barcelona_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value)))  

# sagrada familia
Barcelona_sagrada_familia_items <- Barcelona_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_final, by = "item") %>%
  filter(id == 11) %>%
  left_join(Barcelona_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value))) 

# history
Barcelona_history_items <- Barcelona_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_final, by = "item") %>%
  filter(id == 12) %>%
  left_join(Barcelona_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value))) 

# institutions/organizations
Barcelona_institutions_organizations_items <- Barcelona_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_final, by = "item") %>%
  filter(id == 13) %>%
  left_join(Barcelona_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value))) 

# monuments and fountains
Barcelona_monuments_and_fountains_items <- Barcelona_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_final, by = "item") %>%
  filter(id == 15) %>%
  left_join(Barcelona_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value))) 

# culture and art
Barcelona_culture_and_art_items <- Barcelona_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_final, by = "item") %>%
  filter(id == 16) %>%
  left_join(Barcelona_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value)))  

# parks
Barcelona_parks_items <- Barcelona_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_final, by = "item") %>%
  filter(id == 17) %>%
  left_join(Barcelona_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value))) 

# places of worship
Barcelona_places_of_worship_items <- Barcelona_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Barcelona_final, by = "item") %>%
  filter(id == 18) %>%
  left_join(Barcelona_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value))) 

write.csv(Barcelona_C_final, "Barcelona_C_final.csv")
write.csv(Barcelona_public_transport_items, "Barcelona_public_transport_items.csv")
write.csv(Barcelona_sport_items, "Barcelona_sport_items.csv")
write.csv(Barcelona_high_education_items, "Barcelona_high_education_items.csv")
write.csv(Barcelona_theatres_items, "Barcelona_theatres_items.csv")
write.csv(Barcelona_buildings_items, "Barcelona_buildings_items.csv")
write.csv(Barcelona_streets_and_districts_items, "Barcelona_streets_and_districts_items.csv")
write.csv(Barcelona_museums_items, "Barcelona_museums_items.csv")
write.csv(Barcelona_sagrada_familia_items, "Barcelona_sagrada_familia_items.csv")
write.csv(Barcelona_history_items, "Barcelona_history_items.csv")
write.csv(Barcelona_institutions_organizations_items, "Barcelona_institutions_organizations_items.csv")
write.csv(Barcelona_monuments_and_fountains_items, "Barcelona_monuments_and_fountains_items.csv")
write.csv(Barcelona_culture_and_art_items, "Barcelona_culture_and_art_items.csv")
write.csv(Barcelona_parks_items, "Barcelona_parks_items.csv")
write.csv(Barcelona_places_of_worship_items, "Barcelona_places_of_worship_items.csv")

Barcelona_C_final <- read.csv("C:/Users/signose/Desktop/data_for_maps/Barcelona_C_final.csv") %>%
  select(-X)
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
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value))) 

Bruges_streets_and_streams_items <- Bruges_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Bruges_final, by = "item") %>%
  filter(id == 2) %>%
  left_join(Bruges_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value))) 

Bruges_libraries_items <- Bruges_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Bruges_final, by = "item") %>%
  filter(id == 3) %>%
  left_join(Bruges_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value))) 

Bruges_buildings_items <- Bruges_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Bruges_final, by = "item") %>%
  filter(id == 4) %>%
  left_join(Bruges_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value))) 

Bruges_high_education_items <- Bruges_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Bruges_final, by = "item") %>%
  filter(id == 5) %>%
  left_join(Bruges_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value))) 

Bruges_companies_items <- Bruges_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Bruges_final, by = "item") %>%
  filter(id == 13) %>%
  left_join(Bruges_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value))) 

Bruges_bridges_and_canals_items <- Bruges_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Bruges_final, by = "item") %>%
  filter(id == 8) %>%
  left_join(Bruges_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value))) 

Bruges_districts_items <- Bruges_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Bruges_final, by = "item") %>%
  filter(id == 10) %>%
  left_join(Bruges_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value))) 

Bruges_places_of_worship_items <- Bruges_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Bruges_final, by = "item") %>%
  filter(id == 11) %>%
  left_join(Bruges_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value))) 

Bruges_museums_items <- Bruges_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Bruges_final, by = "item") %>%
  filter(id == 14) %>%
  left_join(Bruges_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value))) 

write.csv(Bruges_C_final, "Bruges_C_final.csv")
write.csv(Bruges_public_transport_items, "Bruges_public_transport_items.csv")
write.csv(Bruges_streets_and_streams_items, "Bruges_streets_and_streams_items.csv")
write.csv(Bruges_libraries_items, "Bruges_libraries_items.csv")
write.csv(Bruges_buildings_items, "Bruges_buildings_items.csv")
write.csv(Bruges_high_education_items, "Bruges_high_education_items.csv")
write.csv(Bruges_companies_items, "Bruges_companies_items.csv")
write.csv(Bruges_bridges_and_canals_items, "Bruges_bridges_and_canals_items.csv")
write.csv(Bruges_sport_items, "Bruges_sport_items.csv")
write.csv(Bruges_districts_items, "Bruges_districts_items.csv")
write.csv(Bruges_places_of_worship_items, "Bruges_places_of_worship_items.csv")
write.csv(Bruges_museums_items, "Bruges_museums_items.csv")

Bruges_C_final <- read.csv("C:/Users/signose/Desktop/data_for_maps/Bruges_C_final.csv") %>%
  select(-X)
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
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value)))


Vienna_council_housing_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 2) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value)))

Vienna_institutions_organizations_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 3) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value)))

Vienna_history_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 4) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value)))

Vienna_township_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 5) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value)))

Vienna_places_of_worship_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 7) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value)))

Vienna_companies_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 9) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value)))

Vienna_bus_stops_and_stations_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 12) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value)))

Vienna_mountains_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 13) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value)))

Vienna_transmitters_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 17) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value)))

Vienna_embassies_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 18) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value)))

Vienna_streets_and_squares_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 20) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value)))

Vienna_rivers_and_parks_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 21) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value)))

Vienna_museums_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 27) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value)))

Vienna_towers_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 28) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value)))

Vienna_buildings_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 30) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value)))

Vienna_hospitals_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 33) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value)))

Vienna_libraries_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 34) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value)))

Vienna_statues_and_fountains_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 35) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value)))

Vienna_high_education_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 39) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value)))

Vienna_bridges_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 41) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value)))

Vienna_theatres_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 44) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value)))

Vienna_cemeteries_items <- Vienna_reads_in_C %>%
  group_by(item) %>%
  summarise(value = sum(value)) %>%
  left_join(Vienna_final, by = "item") %>%
  filter(id == 45) %>%
  left_join(Vienna_C_final, by = "item") %>%
  mutate(value = value.x) %>%
  select(-value.y, -value.x) %>%
  group_by(item, article.x, lat, long) %>%
  summarise(value = sum(as.numeric(value)))

write.csv(Vienna_C_final, "Vienna_C_final.csv")
write.csv(Vienna_sport_items, "Vienna_sport_items.csv")
write.csv(Vienna_council_housing_items, "Vienna_council_housing_items.csv")
write.csv(Vienna_institutions_organizations_items, "Vienna_institutions_organizations_items.csv")
write.csv(Vienna_history_items, "Vienna_history_items.csv")
write.csv(Vienna_township_items, "Vienna_township_items.csv")
write.csv(Vienna_places_of_worship_items, "Vienna_places_of_worship_items.csv")
write.csv(Vienna_companies_items, "Vienna_companies_items.csv")
write.csv(Vienna_bus_stops_and_stations_items, "Vienna_bus_stops_and_stations_items.csv")
write.csv(Vienna_mountains_items, "Vienna_mountains_items.csv")
write.csv(Vienna_transmitters_items, "Vienna_transmitters_items.csv")
write.csv(Vienna_embassies_items, "Vienna_embassies_items.csv")
write.csv(Vienna_streets_and_squares_items, "Vienna_streets_and_squares_items.csv")
write.csv(Vienna_rivers_and_parks_items, "Vienna_rivers_and_parks_items.csv")
write.csv(Vienna_museums_items, "Vienna_museums_items.csv")
write.csv(Vienna_towers_items, "Vienna_towers_items.csv")
write.csv(Vienna_buildings_items, "Vienna_buildings_items.csv")
write.csv(Vienna_hospitals_items, "Vienna_hospitals_items.csv")
write.csv(Vienna_libraries_items, "Vienna_libraries_items.csv")
write.csv(Vienna_statues_and_fountains_items, "Vienna_statues_and_fountains_items.csv")
write.csv(Vienna_high_education_items, "Vienna_high_education_items.csv")
write.csv(Vienna_bridges_items, "Vienna_bridges_items.csv")
write.csv(Vienna_theatres_items, "Vienna_theatres_items.csv")
write.csv(Vienna_cemeteries_items, "Vienna_cemeteries_items.csv")

Vienna_C_final <- read.csv("C:/Users/signose/Desktop/data_for_maps/Vienna_C_final.csv") %>%
  select(-X)
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

saveWidget(widget = m, file="Vienna_categories_map.html", selfcontained = FALSE)
