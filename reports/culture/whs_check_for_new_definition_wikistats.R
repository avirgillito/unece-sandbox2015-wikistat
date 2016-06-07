rm(list=ls())

# Attach packages used
library(dplyr)
library(reshape2)
library(ggplot2)
source("scripts/r/whs_data_man.R")

WHS_FILE <- paste0(WHS_DIR, "/whs.csv")
WIKISTATS_FILE <- paste0(WHS_DIR, "/whs_wikistats_month.csv")
ARTICLES_FILE <- paste0(WHS_DIR, "/whs_redirect_targets_origins.csv")

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

# Put times as variables and add the new variables: average before May and average after May
## 2015: 3-months period shifted in time
### MAY
whs_wikistats_check <- whs_wikistats %>%
  dcast(whs_id ~ time, value.var = "value", fun.aggregate = sum, na.rm = TRUE) %>%
  select(whs_id:T2015.12) %>%
  mutate(avg_before = (T2015.02*28 + T2015.03*31 + T2015.04*30)/89) %>%
  mutate(avg_after = (T2015.06*30 + T2015.07*31 + T2015.08*31)/92) %>%
  mutate(diff = (avg_after - avg_before)/(T2015.02*28 + T2015.03*31 + T2015.04*30 + T2015.06*30 + T2015.07*31 + T2015.08*31))
  
May <- whs_wikistats_check$diff

# APRIL
whs_wikistats_check <- whs_wikistats %>%
  dcast(whs_id ~ time, value.var = "value", fun.aggregate = sum, na.rm = TRUE) %>%
  select(whs_id:T2015.12) %>%
  mutate(avg_before = (T2015.01*31 + T2015.02*28 + T2015.03*31)/90) %>%
  mutate(avg_after = (T2015.05*31 + T2015.06*30 + T2015.07*31)/92) %>%
  mutate(diff = (avg_after - avg_before)/(T2015.01*31 + T2015.02*28 + T2015.03*31 + T2015.05*31 + T2015.06*30 + T2015.07*31))

April <- whs_wikistats_check$diff
  
# JANUARY
whs_wikistats_check <- whs_wikistats %>%
  dcast(whs_id ~ time, value.var = "value", fun.aggregate = sum, na.rm = TRUE) %>%
  select(whs_id:T2015.12) %>%
  mutate(avg_before = (T2014.10*31 + T2014.11*30 + T2014.12*31)/92) %>%
  mutate(avg_after = (T2015.02*28 + T2015.03*31 + T2015.04*30)/89) %>%
  mutate(diff = (avg_after - avg_before)/(T2014.10*31 + T2014.11*30 + T2014.12*31 + T2015.02*28 + T2015.03*31 + T2015.04*30))

January <- whs_wikistats_check$diff

# FEBRUARY
whs_wikistats_check <- whs_wikistats %>%
  dcast(whs_id ~ time, value.var = "value", fun.aggregate = sum, na.rm = TRUE) %>%
  select(whs_id:T2015.12) %>%
  mutate(avg_before = (T2014.11*30 + T2014.12*31 + T2015.01*31)/92) %>%
  mutate(avg_after = (T2015.03*31 + T2015.04*30 + T2015.05*31)/92) %>%
  mutate(diff = (avg_after - avg_before)/(T2014.11*30 + T2014.12*31 + T2015.01*31 + T2015.03*31 + T2015.04*30+ T2015.05*31))

February <- whs_wikistats_check$diff

# MARCH
whs_wikistats_check <- whs_wikistats %>%
  dcast(whs_id ~ time, value.var = "value", fun.aggregate = sum, na.rm = TRUE) %>%
  select(whs_id:T2015.12) %>%
  mutate(avg_before = (T2014.12*31 + T2015.01*31 + T2015.02*28)/90) %>%
  mutate(avg_after = (T2015.04*30 + T2015.05*31 + T2015.06*30)/91) %>%
  mutate(diff = (avg_after - avg_before)/(T2014.12*31 + T2015.01*31 + T2015.02*28 + T2015.04*30+ T2015.05*31 + T2015.06*30))

March <- whs_wikistats_check$diff

# JUNE
whs_wikistats_check <- whs_wikistats %>%
  dcast(whs_id ~ time, value.var = "value", fun.aggregate = sum, na.rm = TRUE) %>%
  select(whs_id:T2015.12) %>%
  mutate(avg_before = (T2015.03*31 + T2015.04*30 + T2015.05*31)/92) %>%
  mutate(avg_after = (T2015.07*31 + T2015.08*31 + T2015.09*30)/92) %>%
  mutate(diff = (avg_after - avg_before)/(T2015.03*31 + T2015.04*30 + T2015.05*31 + T2015.07*31+ T2015.08*31 + T2015.09*30))

June <- whs_wikistats_check$diff

# JULY
whs_wikistats_check <- whs_wikistats %>%
  dcast(whs_id ~ time, value.var = "value", fun.aggregate = sum, na.rm = TRUE) %>%
  select(whs_id:T2015.12) %>%
  mutate(avg_before = (T2015.04*30 + T2015.05*31 + T2015.06*30)/91) %>%
  mutate(avg_after = (T2015.08*31 + T2015.09*30 + T2015.10*31)/92) %>%
  mutate(diff = (avg_after - avg_before)/(T2015.04*30 + T2015.05*31 + T2015.06*30 + T2015.08*31+ T2015.09*30 + T2015.10*31))

July <- whs_wikistats_check$diff

# AUGUST
whs_wikistats_check <- whs_wikistats %>%
  dcast(whs_id ~ time, value.var = "value", fun.aggregate = sum, na.rm = TRUE) %>%
  select(whs_id:T2015.12) %>%
  mutate(avg_before = (T2015.05*31 + T2015.06*30 + T2015.07*31)/92) %>%
  mutate(avg_after = (T2015.09*30 + T2015.10*31 + T2015.11*30)/91) %>%
  mutate(diff = (avg_after - avg_before)/(T2015.05*31 + T2015.06*30 + T2015.07*31+ T2015.09*30 + T2015.10*31 + T2015.11*30))

August <- whs_wikistats_check$diff

# SEPTEMBER
whs_wikistats_check <- whs_wikistats %>%
  dcast(whs_id ~ time, value.var = "value", fun.aggregate = sum, na.rm = TRUE) %>%
  select(whs_id:T2015.12) %>%
  mutate(avg_before = (T2015.06*30 + T2015.07*31 + T2015.08*31)/92) %>%
  mutate(avg_after = (T2015.10*31 + T2015.11*30 + T2015.12*31)/92) %>%
  mutate(diff = (avg_after - avg_before)/(T2015.06*30 + T2015.07*31+ T2015.08*31 + T2015.10*31 + T2015.11*30 + T2015.12*31))

September <- whs_wikistats_check$diff

Diff <- as.data.frame(cbind(whs_wikistats_check$whs_id, January, February, March, April, May, June, July, August, September))

# Plot the results
Diff_melted <- melt(Diff, id = "V1")

whs_wikistats_check_plot <- ggplot(Diff_melted, aes(x=V1, y=value, fill=variable)) +
  geom_area(stat = "identity") +
  xlab("World Heritage Sites") +
  ylab("Difference") +
  ggtitle("Difference between previous and following 3-months period") +
  theme(legend.position="right")  

## Different years but same pediod: month of May excluded
### 2015
whs_wikistats_check <- whs_wikistats %>%
  dcast(whs_id ~ time, value.var = "value", fun.aggregate = sum, na.rm = TRUE) %>%
  select(whs_id:T2015.12) %>%
  mutate(avg_before = (T2015.02*28 + T2015.03*31 + T2015.04*30)/89) %>%
  mutate(avg_after = (T2015.06*30 + T2015.07*31 + T2015.08*31)/92) %>%
  mutate(diff = (avg_after - avg_before)/(T2015.02*28 + T2015.03*31 + T2015.04*30 + T2015.06*30 + T2015.07*31 + T2015.08*31))

y_2015 <- whs_wikistats_check$diff

# 2014
whs_wikistats_check <- whs_wikistats %>%
  dcast(whs_id ~ time, value.var = "value", fun.aggregate = sum, na.rm = TRUE) %>%
  select(whs_id:T2015.12) %>%
  mutate(avg_before = (T2014.02*28 + T2014.03*31 + T2014.04*30)/89) %>%
  mutate(avg_after = (T2014.06*30 + T2014.07*31 + T2014.08*31)/92) %>%
  mutate(diff = (avg_after - avg_before)/(T2014.02*28 + T2014.03*31 + T2014.04*30 + T2014.06*30 + T2014.07*31 + T2014.08*31))

y_2014 <- whs_wikistats_check$diff

# 2013
whs_wikistats_check <- whs_wikistats %>%
  dcast(whs_id ~ time, value.var = "value", fun.aggregate = sum, na.rm = TRUE) %>%
  select(whs_id:T2015.12) %>%
  mutate(avg_before = (T2013.02*28 + T2013.03*31 + T2013.04*30)/89) %>%
  mutate(avg_after = (T2013.06*30 + T2013.07*31 + T2013.08*31)/92) %>%
  mutate(diff = (avg_after - avg_before)/(T2013.02*28 + T2013.03*31 + T2015.03*30 + T2015.03*30 + T2013.07*31 + T2013.08*31))

y_2013 <- whs_wikistats_check$diff

# 2012
whs_wikistats_check <- whs_wikistats %>%
  dcast(whs_id ~ time, value.var = "value", fun.aggregate = sum, na.rm = TRUE) %>%
  select(whs_id:T2015.12) %>%
  mutate(avg_before = (T2012.02*29 + T2012.03*31 + T2012.04*30)/89) %>%
  mutate(avg_after = (T2012.06*30 + T2012.07*31 + T2012.08*31)/92) %>%
  mutate(diff = (avg_after - avg_before)/(T2012.02*29 + T2012.03*31 + T2012.04*30 + T2012.06*30 + T2012.07*31 + T2012.08*31))

y_2012 <- whs_wikistats_check$diff

Diff_years <- as.data.frame(cbind(whs_wikistats_check$whs_id, y_2012, y_2013, y_2014, y_2015))

# Plot the results
Diff_melted_years <- melt(Diff_years, id = "V1")

whs_wikistats_check_plot_years <- ggplot(Diff_melted_years, aes(x=V1, y=value, fill=variable)) +
  geom_area(stat = "identity") +
  xlab("World Heritage Sites") +
  ylab("Difference") +
  ggtitle("Difference between previous and following 3-months period") +
  theme(legend.position="right")  

### Box plots of the results
# Months
ggplot(Diff_melted, aes(variable, value)) +
  geom_boxplot()

# Years
ggplot(Diff_melted_years, aes(variable, value)) +
  geom_boxplot()

### Analysis of January, May and September of different years

# JANUARY 2015
whs_wikistats_check <- whs_wikistats %>%
  dcast(whs_id ~ time, value.var = "value", fun.aggregate = sum, na.rm = TRUE) %>%
  select(whs_id:T2015.12) %>%
  mutate(avg_before = (T2014.10*31 + T2014.11*30 + T2014.12*31)/92) %>%
  mutate(avg_after = (T2015.02*28 + T2015.03*31 + T2015.04*30)/89) %>%
  mutate(diff = (avg_after - avg_before)/(T2014.10*31 + T2014.11*30 + T2014.12*31 + T2015.02*28 + T2015.03*31 + T2015.04*30))

January_2015 <- whs_wikistats_check$diff

### MAY 2015
whs_wikistats_check <- whs_wikistats %>%
  dcast(whs_id ~ time, value.var = "value", fun.aggregate = sum, na.rm = TRUE) %>%
  select(whs_id:T2015.12) %>%
  mutate(avg_before = (T2015.02*28 + T2015.03*31 + T2015.04*30)/89) %>%
  mutate(avg_after = (T2015.06*30 + T2015.07*31 + T2015.08*31)/92) %>%
  mutate(diff = (avg_after - avg_before)/(T2015.02*28 + T2015.03*31 + T2015.04*30 + T2015.06*30 + T2015.07*31 + T2015.08*31))

May_2015 <- whs_wikistats_check$diff

# SEPTEMBER 2015
whs_wikistats_check <- whs_wikistats %>%
  dcast(whs_id ~ time, value.var = "value", fun.aggregate = sum, na.rm = TRUE) %>%
  select(whs_id:T2015.12) %>%
  mutate(avg_before = (T2015.06*30 + T2015.07*31 + T2015.08*31)/92) %>%
  mutate(avg_after = (T2015.10*31 + T2015.11*30 + T2015.12*31)/92) %>%
  mutate(diff = (avg_after - avg_before)/(T2015.06*30 + T2015.07*31+ T2015.08*31 + T2015.10*31 + T2015.11*30 + T2015.12*31))

September_2015 <- whs_wikistats_check$diff

# JANUARY 2014
whs_wikistats_check <- whs_wikistats %>%
  dcast(whs_id ~ time, value.var = "value", fun.aggregate = sum, na.rm = TRUE) %>%
  select(whs_id:T2015.12) %>%
  mutate(avg_before = (T2013.10*31 + T2013.11*30 + T2013.12*31)/92) %>%
  mutate(avg_after = (T2014.02*28 + T2014.03*31 + T2014.04*30)/89) %>%
  mutate(diff = (avg_after - avg_before)/(T2013.10*31 + T2013.11*30 + T2013.12*31 + T2014.02*28 + T2014.03*31 + T2014.04*30))

January_2014 <- whs_wikistats_check$diff

### MAY 2014
whs_wikistats_check <- whs_wikistats %>%
  dcast(whs_id ~ time, value.var = "value", fun.aggregate = sum, na.rm = TRUE) %>%
  select(whs_id:T2015.12) %>%
  mutate(avg_before = (T2014.02*28 + T2014.03*31 + T2014.04*30)/89) %>%
  mutate(avg_after = (T2014.06*30 + T2014.07*31 + T2014.08*31)/92) %>%
  mutate(diff = (avg_after - avg_before)/(T2014.02*28 + T2014.03*31 + T2014.04*30 + T2014.06*30 + T2014.07*31 + T2014.08*31))

May_2014 <- whs_wikistats_check$diff

# SEPTEMBER 2014
whs_wikistats_check <- whs_wikistats %>%
  dcast(whs_id ~ time, value.var = "value", fun.aggregate = sum, na.rm = TRUE) %>%
  select(whs_id:T2015.12) %>%
  mutate(avg_before = (T2014.06*30 + T2014.07*31 + T2014.08*31)/92) %>%
  mutate(avg_after = (T2014.10*31 + T2014.11*30 + T2014.12*31)/92) %>%
  mutate(diff = (avg_after - avg_before)/(T2014.06*30 + T2014.07*31+ T2014.08*31 + T2014.10*31 + T2014.11*30 + T2014.12*31))

September_2014 <- whs_wikistats_check$diff

# JANUARY 2013
whs_wikistats_check <- whs_wikistats %>%
  dcast(whs_id ~ time, value.var = "value", fun.aggregate = sum, na.rm = TRUE) %>%
  select(whs_id:T2015.12) %>%
  mutate(avg_before = (T2012.10*31 + T2012.11*30 + T2012.12*31)/92) %>%
  mutate(avg_after = (T2013.02*28 + T2013.03*31 + T2013.04*30)/89) %>%
  mutate(diff = (avg_after - avg_before)/(T2012.10*31 + T2012.11*30 + T2012.12*31 + T2013.02*28 + T2013.03*31 + T2013.04*30))

January_2013 <- whs_wikistats_check$diff

### MAY 2013
whs_wikistats_check <- whs_wikistats %>%
  dcast(whs_id ~ time, value.var = "value", fun.aggregate = sum, na.rm = TRUE) %>%
  select(whs_id:T2015.12) %>%
  mutate(avg_before = (T2013.02*28 + T2013.03*31 + T2013.04*30)/89) %>%
  mutate(avg_after = (T2013.06*30 + T2013.07*31 + T2013.08*31)/92) %>%
  mutate(diff = (avg_after - avg_before)/(T2013.02*28 + T2013.03*31 + T2013.04*30 + T2013.06*30 + T2013.07*31 + T2013.08*31))

May_2013 <- whs_wikistats_check$diff

# SEPTEMBER 2013
whs_wikistats_check <- whs_wikistats %>%
  dcast(whs_id ~ time, value.var = "value", fun.aggregate = sum, na.rm = TRUE) %>%
  select(whs_id:T2015.12) %>%
  mutate(avg_before = (T2013.06*30 + T2013.07*31 + T2013.08*31)/92) %>%
  mutate(avg_after = (T2013.10*31 + T2013.11*30 + T2013.12*31)/92) %>%
  mutate(diff = (avg_after - avg_before)/(T2013.06*30 + T2013.07*31+ T2013.08*31 + T2013.10*31 + T2013.11*30 + T2013.12*31))

September_2013 <- whs_wikistats_check$diff

# JANUARY 2012
whs_wikistats_check <- whs_wikistats %>%
  dcast(whs_id ~ time, value.var = "value", fun.aggregate = sum, na.rm = TRUE) %>%
  select(whs_id:T2015.12) %>%
  mutate(avg_before = (T2011.10*31 + T2011.11*30 + T2011.12*31)/92) %>%
  mutate(avg_after = (T2012.02*29 + T2012.03*31 + T2012.04*30)/89) %>%
  mutate(diff = (avg_after - avg_before)/(T2011.10*31 + T2011.11*30 + T2011.12*31 + T2012.02*29 + T2012.03*31 + T2012.04*30))

January_2012 <- whs_wikistats_check$diff

### MAY 2012
whs_wikistats_check <- whs_wikistats %>%
  dcast(whs_id ~ time, value.var = "value", fun.aggregate = sum, na.rm = TRUE) %>%
  select(whs_id:T2015.12) %>%
  mutate(avg_before = (T2012.02*29 + T2012.03*31 + T2012.04*30)/89) %>%
  mutate(avg_after = (T2012.06*30 + T2012.07*31 + T2012.08*31)/92) %>%
  mutate(diff = (avg_after - avg_before)/(T2012.02*29 + T2012.03*31 + T2012.04*30 + T2012.06*30 + T2012.07*31 + T2012.08*31))

May_2012 <- whs_wikistats_check$diff

# SEPTEMBER 2012
whs_wikistats_check <- whs_wikistats %>%
  dcast(whs_id ~ time, value.var = "value", fun.aggregate = sum, na.rm = TRUE) %>%
  select(whs_id:T2015.12) %>%
  mutate(avg_before = (T2012.06*30 + T2012.07*31 + T2012.08*31)/92) %>%
  mutate(avg_after = (T2012.10*31 + T2012.11*30 + T2012.12*31)/92) %>%
  mutate(diff = (avg_after - avg_before)/(T2012.06*30 + T2012.07*31+ T2012.08*31 + T2012.10*31 + T2012.11*30 + T2012.12*31))

September_2012 <- whs_wikistats_check$diff

Diff_neutral <- as.data.frame(cbind(whs_wikistats_check$whs_id, January_2012, May_2012, September_2012, January_2013, May_2013, September_2013, January_2014, May_2014, September_2014, January_2015, May_2015, September_2015))

Diff_2015 <- as.data.frame(cbind(whs_wikistats_check$whs_id, January_2015, May_2015, September_2015))
Diff_2014 <- as.data.frame(cbind(whs_wikistats_check$whs_id, January_2014, May_2014, September_2014))
Diff_2013 <- as.data.frame(cbind(whs_wikistats_check$whs_id, January_2013, May_2013, September_2013))
Diff_2012 <- as.data.frame(cbind(whs_wikistats_check$whs_id, January_2012, May_2012, September_2012))

Diff_January <- as.data.frame(cbind(whs_wikistats_check$whs_id, January_2012, January_2013, January_2014, January_2015))
Diff_May <- as.data.frame(cbind(whs_wikistats_check$whs_id, May_2012, May_2013, May_2014, May_2015))
Diff_September <- as.data.frame(cbind(whs_wikistats_check$whs_id, September_2012, September_2013, September_2014, September_2015))

# Plot the results
Diff_neutral_melted <- melt(Diff_neutral, id = "V1")

Diff_2015_melted <- melt(Diff_2015, id = "V1")
Diff_2014_melted <- melt(Diff_2014, id = "V1")
Diff_2013_melted <- melt(Diff_2013, id = "V1")
Diff_2012_melted <- melt(Diff_2012, id = "V1")

Diff_January_melted <- melt(Diff_January, id = "V1")
Diff_May_melted <- melt(Diff_May, id = "V1")
Diff_September_melted <- melt(Diff_September, id = "V1")

## Boxplot

ggplot(Diff_neutral_melted, aes(variable, value)) +
  geom_boxplot()

## Boxplot by year

ggplot(Diff_2015_melted, aes(variable, value)) +
  geom_boxplot()

ggplot(Diff_2014_melted, aes(variable, value)) +
  geom_boxplot()

ggplot(Diff_2013_melted, aes(variable, value)) +
  geom_boxplot()

ggplot(Diff_2012_melted, aes(variable, value)) +
  geom_boxplot()

## Boxplot by month

ggplot(Diff_January_melted, aes(variable, value)) +
  geom_boxplot()

ggplot(Diff_May_melted, aes(variable, value)) +
  geom_boxplot()

ggplot(Diff_September_melted, aes(variable, value)) +
  geom_boxplot()