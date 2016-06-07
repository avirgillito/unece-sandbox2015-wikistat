### TOURISM PILOT (ALTERNATIVE VERSION)

### For the tourism pilot we used Wikidata, but in the beginning the idea was to follow the same procedure
### as for the World Heritage Sites. 

### So here it is the script with the procedure that we would have followed. It is only a PARTIAL script.

### It does the following:
### 1. starting from a chosen language, it gets all the outlinks from the main article of the city;
### 2. it then adds an id and gets all the language versions of those articles
### 3. it merges the previous procedure in different languages (usually English and the city spoken language)
###    to get a list of unique articles
### 4. it adds the redirects

### From here we would have chosen to get also the outlinks from this list of articles and then get the 
### geo coordinates from the html, in order to consider only articles that effectively have coordinates. 

### Finally we would have got the pageviews and proceeded as in the Wikidata case. 

### BARCELONA

library(dplyr)
source("scripts/r/wiki_tools.R")
source("scripts/r/whs_data_man.R")
source("scripts/r/redirects_target_and_origin_for_cities.R")
source("scripts/r/lang_ver_df.R")

### Get also all the outlinks from the articles of the city

### Barcelona in English

# Get language versions of article of the city
Barcelona <- data.frame(getLangVersion("Barcelona"))
lang <- attr(Barcelona, "row.names")

# Create a data frame with language and articles
Barcelona <- data.frame(lang, Barcelona)
Barcelona$lang_orig <- NULL

# Add the starting article in the language I chose
starting <- data.frame("en", "Barcelona")
names(starting) <- c("lang", "article")

rownames(Barcelona) <- NULL
names(Barcelona) <- c("lang", "article")

Barcelona <- rbind(Barcelona, starting)
Barcelona$article <- as.character(Barcelona$article)

rm(starting)

# Filter considering only the chosen language
Barcelona <- Barcelona %>%
  filter( lang == 'en')

# Add linked articles
Linked <- data.frame(lang = 'en', article = getLinkedArticles(getWikiMarkup("Barcelona", lang = "en")))

# Merge two datasets
Barcelona <- rbind(Barcelona, Linked)
rm(Linked)

# Delete # which creates problems
Barcelona[533,2] <- gsub(Barcelona$article[533], "#", "Local public transport" )

# Get articles wiki markup and add id for city
Barcelona <- Barcelona %>%
  mutate(wm = getWikiMarkup(article, lang),
         target = "",
         origins_checked = FALSE) %>%
  select(lang, article) %>%
  mutate(id = paste(lang,article, sep = "."))

# Transform article into character 
Barcelona$article <- as.character(Barcelona$article)

# Get all language versions of articles
Barcelona_all_lang <- getLangVersion_df(Barcelona, lang_orig = "es")

Barcelona_all_lang <- Barcelona_all_lang %>%
  filter( lang == 'bg' | lang == 'cs' | lang == 'da' | lang == 'de' | lang == 'el' | lang == 'en' | lang == 'es' |
            lang == 'et' | lang == 'fi' | lang == 'fr' | lang == 'ga' | lang == 'hr' | lang == 'hu' | lang == 'is' | 
            lang == 'it' | lang == 'lt' | lang == 'lv' | lang == 'mk' | lang == 'mt' | lang == 'nl' | lang == 'no'| 
            lang == 'pl' | lang == 'pt' | lang == 'ro' | lang == 'ru' | lang == 'sk' | lang == 'sl' | lang == 'sq'| 
            lang == 'sr' | lang == 'sv' | lang == 'tr')

hdfs.init()

# Get Wikimarkup
Barcelona_all_lang <- Barcelona_all_lang %>%
  mutate(wm = getWikiMarkup(article, lang),
         target = "",
         origins_checked = FALSE)

#hdfs.init()

# Save file
write.csv(Barcelona_all_lang, "Barcelona_all_lang.csv")


### Barcelona in Spanish

# Get language versions of article of the city
Barcelona <- data.frame(getLangVersion("Barcelona"), lang_orig = "es")
lang <- attr(Barcelona, "row.names")

# Create a data frame with language and articles
Barcelona <- data.frame(lang, Barcelona)
Barcelona$lang_orig <- NULL

# Add the starting article in the language I chose
starting <- data.frame("es", "Barcelona")
names(starting) <- c("lang", "article")

rownames(Barcelona) <- NULL
names(Barcelona) <- c("lang", "article")

Barcelona <- rbind(Barcelona, starting)
Barcelona$article <- as.character(Barcelona$article)

rm(starting)

# Filter considering only the chosen language
Barcelona <- Barcelona %>%
  filter( lang == 'es')

# Add linked articles
Linked <- data.frame(lang = 'es', article = getLinkedArticles(getWikiMarkup("Barcelona", lang = "es")))

# Merge two datasets
Barcelona <- rbind(Barcelona, Linked)
rm(Linked)

# Get articles wiki markup and add id for city
Barcelona <- Barcelona %>%
  mutate(wm = getWikiMarkup(article, lang),
         target = "",
         origins_checked = FALSE) %>%
  select(lang, article) %>%
  mutate(id = paste(lang,article, sep = "."))

# Transform article into character and delete # which creates problems
Barcelona$article <- as.character(Barcelona$article)
#Barcelona[534,2] <- gsub(Barcelona$article[533], "#", "Local public transport" )

# Get all language versions of articles
Barcelona_all_lang <- getLangVersion_df(Barcelona, lang_orig = "es")

Barcelona_all_lang <- Barcelona_all_lang %>%
  filter( lang == 'bg' | lang == 'cs' | lang == 'da' | lang == 'de' | lang == 'el' | lang == 'en' | lang == 'es' |
            lang == 'et' | lang == 'fi' | lang == 'fr' | lang == 'ga' | lang == 'hr' | lang == 'hu' | lang == 'is' | 
            lang == 'it' | lang == 'lt' | lang == 'lv' | lang == 'mk' | lang == 'mt' | lang == 'nl' | lang == 'no'| 
            lang == 'pl' | lang == 'pt' | lang == 'ro' | lang == 'ru' | lang == 'sk' | lang == 'sl' | lang == 'sq'| 
            lang == 'sr' | lang == 'sv' | lang == 'tr')

hdfs.init()

# Get Wikimarkup
Barcelona_all_lang <- Barcelona_all_lang %>%
  mutate(wm = getWikiMarkup(article, lang),
         target = "",
         origins_checked = FALSE)

# Save file
write.csv(Barcelona_all_lang, "Barcelona_all_lang_ES.csv")

# Merge of English and Spanish

Barcelona_EN <- read.table("Barcelona_all_lang.csv", sep = ",", header = T, stringsAsFactors = F, fileEncoding = "utf-8") %>%
  select(-X)
Barcelona_ES <- read.table("Barcelona_all_lang_ES.csv", sep = ",", header = T, stringsAsFactors = F, fileEncoding = "utf-8") %>%
  select(-X)

hdfs.init()

Barcelona_lang_and_redirects <- Barcelona_ES %>%
  left_join(Barcelona_EN, by = c("lang", "article", "wm", "target", "origins_checked")) %>%
  select(-id.y) %>%
  mutate(id = id.x) %>%
  select(-id.x)

hdfs.init()

Barcelona_lang_and_redirects$target <- ""

# Add redirects targets and origins

Barcelona_lang_and_redirects <- Barcelona_lang_and_redirects %>%
  add_redirect_targets() 

#Barcelona_lang_and_redirects <- read.table("/ichec/home/users/bogomil/temp/test_unicode_one.csv", sep = ",", header = T, stringsAsFactors = F, fileEncoding = "utf-8")

hdfs.init()

Barcelona_lang_and_redirects <- Barcelona_lang_and_redirects %>%
  add_redirect_origins() 

# Save file
write.csv(Barcelona_lang_and_redirects, "Barcelona_lang_and_redirects_ORIGINS_TARGETS.csv")

### BRUGES

### Bruges in English

# Get language versions of article of the city
Bruges <- data.frame(getLangVersion("Bruges"))
lang <- attr(Bruges, "row.names")

# Create a data frame with language and articles
Bruges <- data.frame(lang, Bruges)
Bruges$lang_orig <- NULL

# Add the starting article in the language I chose
starting <- data.frame("en", "Bruges")
names(starting) <- c("lang", "article")

rownames(Bruges) <- NULL
names(Bruges) <- c("lang", "article")

Bruges <- rbind(Bruges, starting)
Bruges$article <- as.character(Bruges$article)

rm(starting)

# Filter considering only the chosen language
Bruges <- Bruges %>%
  filter( lang == 'en')

# Add linked articles
Linked <- data.frame(lang = 'en', article = getLinkedArticles(getWikiMarkup("Bruges", lang = "en")))

# Merge two datasets
Bruges <- rbind(Bruges, Linked)
rm(Linked)

# Delete # which creates problems
#Bruges[533,2] <- gsub(Bruges$article[533], "#", "Local public transport" )

# Get articles wiki markup and add id for city
Bruges <- Bruges %>%
  mutate(wm = getWikiMarkup(article, lang),
         target = "",
         origins_checked = FALSE) %>%
  select(lang, article) %>%
  mutate(id = paste(lang,article, sep = "."))

# Transform article into character 
Bruges$article <- as.character(Bruges$article)

# Get all language versions of articles
Bruges_all_lang <- getLangVersion_df(Bruges, lang_orig = "es")

Bruges_all_lang <- Bruges_all_lang %>%
  filter( lang == 'bg' | lang == 'cs' | lang == 'da' | lang == 'de' | lang == 'el' | lang == 'en' | lang == 'es' |
            lang == 'et' | lang == 'fi' | lang == 'fr' | lang == 'ga' | lang == 'hr' | lang == 'hu' | lang == 'is' | 
            lang == 'it' | lang == 'lt' | lang == 'lv' | lang == 'mk' | lang == 'mt' | lang == 'nl' | lang == 'no'| 
            lang == 'pl' | lang == 'pt' | lang == 'ro' | lang == 'ru' | lang == 'sk' | lang == 'sl' | lang == 'sq'| 
            lang == 'sr' | lang == 'sv' | lang == 'tr')

hdfs.init()

# Get Wikimarkup
Bruges_all_lang <- Bruges_all_lang %>%
  mutate(wm = getWikiMarkup(article, lang),
         target = "",
         origins_checked = FALSE)

#hdfs.init()

# Save file
write.csv(Bruges_all_lang, "Bruges_all_lang.csv")

### Bruges in French

# Get language versions of article of the city
Bruges <- data.frame(getLangVersion("Bruges"), lang_orig = "fr")
lang <- attr(Bruges, "row.names")

# Create a data frame with language and articles
Bruges <- data.frame(lang, Bruges)
Bruges$lang_orig <- NULL

# Add the starting article in the language I chose
starting <- data.frame("fr", "Bruges")
names(starting) <- c("lang", "article")

rownames(Bruges) <- NULL
names(Bruges) <- c("lang", "article")

Bruges <- rbind(Bruges, starting)
Bruges$article <- as.character(Bruges$article)

rm(starting)

# Filter considering only the chosen language
Bruges <- Bruges %>%
  filter( lang == 'fr')

# Add linked articles
Linked <- data.frame(lang = 'fr', article = getLinkedArticles(getWikiMarkup("Bruges", lang = "fr")))

# Merge two datasets
Bruges <- rbind(Bruges, Linked)
rm(Linked)

# Get articles wiki markup and add id for city
Bruges <- Bruges %>%
  mutate(wm = getWikiMarkup(article, lang),
         target = "",
         origins_checked = FALSE) %>%
  select(lang, article) %>%
  mutate(id = paste(lang,article, sep = "."))

# Transform article into character and delete # which creates problems
Bruges$article <- as.character(Bruges$article)
#Bruges[534,2] <- gsub(Bruges$article[533], "#", "Local public transport" )

# Get all language versions of articles
Bruges_all_lang <- getLangVersion_df(Bruges, lang_orig = "fr")

Bruges_all_lang <- Bruges_all_lang %>%
  filter( lang == 'bg' | lang == 'cs' | lang == 'da' | lang == 'de' | lang == 'el' | lang == 'en' | lang == 'es' |
            lang == 'et' | lang == 'fi' | lang == 'fr' | lang == 'ga' | lang == 'hr' | lang == 'hu' | lang == 'is' | 
            lang == 'it' | lang == 'lt' | lang == 'lv' | lang == 'mk' | lang == 'mt' | lang == 'nl' | lang == 'no'| 
            lang == 'pl' | lang == 'pt' | lang == 'ro' | lang == 'ru' | lang == 'sk' | lang == 'sl' | lang == 'sq'| 
            lang == 'sr' | lang == 'sv' | lang == 'tr')

hdfs.init()

# Get Wikimarkup
Bruges_all_lang <- Bruges_all_lang %>%
  mutate(wm = getWikiMarkup(article, lang),
         target = "",
         origins_checked = FALSE)

# Save file
write.csv(Bruges_all_lang, "Bruges_all_lang_FR.csv")

### Bruges in Dutch

# Get language versions of article of the city
Bruges <- data.frame(getLangVersion("Brugge"), lang_orig = "nl")
lang <- attr(Bruges, "row.names")

# Create a data frame with language and articles
Bruges <- data.frame(lang, Bruges)
Bruges$lang_orig <- NULL

# Add the starting article in the language I chose
starting <- data.frame("nl", "Brugge")
names(starting) <- c("lang", "article")

rownames(Bruges) <- NULL
names(Bruges) <- c("lang", "article")

Bruges <- rbind(Bruges, starting)
Bruges$article <- as.character(Bruges$article)

rm(starting)

# Filter considering only the chosen language
Bruges <- Bruges %>%
  filter( lang == 'nl')

# Add linked articles
Linked <- data.frame(lang = 'nl', article = getLinkedArticles(getWikiMarkup("Brugge", lang = "nl")))

# Merge two datasets
Bruges <- rbind(Bruges, Linked)
rm(Linked)

# Get articles wiki markup and add id for city
Bruges <- Bruges %>%
  mutate(wm = getWikiMarkup(article, lang),
         target = "",
         origins_checked = FALSE) %>%
  select(lang, article) %>%
  mutate(id = paste(lang,article, sep = "."))

# Transform article into character and delete # which creates problems
Bruges$article <- as.character(Bruges$article)
#Bruges[534,2] <- gsub(Bruges$article[533], "#", "Local public transport" )

# Get all language versions of articles
Bruges_all_lang <- getLangVersion_df(Bruges, lang_orig = "nl")

Bruges_all_lang <- Bruges_all_lang %>%
  filter( lang == 'bg' | lang == 'cs' | lang == 'da' | lang == 'de' | lang == 'el' | lang == 'en' | lang == 'es' |
            lang == 'et' | lang == 'fi' | lang == 'fr' | lang == 'ga' | lang == 'hr' | lang == 'hu' | lang == 'is' | 
            lang == 'it' | lang == 'lt' | lang == 'lv' | lang == 'mk' | lang == 'mt' | lang == 'nl' | lang == 'no'| 
            lang == 'pl' | lang == 'pt' | lang == 'ro' | lang == 'ru' | lang == 'sk' | lang == 'sl' | lang == 'sq'| 
            lang == 'sr' | lang == 'sv' | lang == 'tr')

hdfs.init()

# Get Wikimarkup
Bruges_all_lang <- Bruges_all_lang %>%
  mutate(wm = getWikiMarkup(article, lang),
         target = "",
         origins_checked = FALSE)

# Save file
write.csv(Bruges_all_lang, "Bruges_all_lang_NL.csv")

# Merge of English, French and Dutch

Bruges_EN <- read.table("Bruges_all_lang.csv", sep = ",", header = T, stringsAsFactors = F, fileEncoding = "utf-8") %>%
  select(-X)
Bruges_FR <- read.table("Bruges_all_lang_FR.csv", sep = ",", header = T, stringsAsFactors = F, fileEncoding = "utf-8") %>%
  select(-X)
Bruges_NL <- read.table("Bruges_all_lang_NL.csv", sep = ",", header = T, stringsAsFactors = F, fileEncoding = "utf-8") %>%
  select(-X)

Bruges_lang_and_redirects <- Bruges_FR %>%
  left_join(Bruges_NL, by = c("lang", "article", "wm", "target", "origins_checked")) %>%
  select(-id.y) %>%
  mutate(id = id.x) %>%
  select(-id.x)
left_join(Bruges_EN, by = c("lang", "article", "wm", "target", "origins_checked")) %>%
  select(-id.y) %>%
  mutate(id = id.x) %>%
  select(-id.x)

hdfs.init()

Bruges_lang_and_redirects$target <- ""

# Add redirects targets and origins

Bruges_lang_and_redirects <- Bruges_lang_and_redirects %>%
  add_redirect_targets() 

#Bruges_lang_and_redirects <- read.table("/ichec/home/users/bogomil/temp/test_unicode_one.csv", sep = ",", header = T, stringsAsFactors = F, fileEncoding = "utf-8")

Bruges_lang_and_redirects <- Bruges_lang_and_redirects %>%
  add_redirect_origins() 

# Save file
write.csv(Bruges_lang_and_redirects, "Bruges_lang_and_redirects_ORIGINS_TARGETS.csv")

### VIENNA

### Vienna in English

# Get language versions of article of the city
Vienna <- data.frame(getLangVersion("Vienna"))
lang <- attr(Vienna, "row.names")

# Create a data frame with language and articles
Vienna <- data.frame(lang, Vienna)
Vienna$lang_orig <- NULL

# Add the starting article in the language I chose
starting <- data.frame("en", "Vienna")
names(starting) <- c("lang", "article")

rownames(Vienna) <- NULL
names(Vienna) <- c("lang", "article")

Vienna <- rbind(Vienna, starting)
Vienna$article <- as.character(Vienna$article)

rm(starting)

# Filter considering only the chosen language
Vienna <- Vienna %>%
  filter( lang == 'en')

# Add linked articles
Linked <- data.frame(lang = 'en', article = getLinkedArticles(getWikiMarkup("Vienna", lang = "en")))

# Merge two datasets
Vienna <- rbind(Vienna, Linked)
rm(Linked)

# Delete # which creates problems
#Vienna[533,2] <- gsub(Vienna$article[533], "#", "Local public transport" )

# Get articles wiki markup and add id for city
Vienna <- Vienna %>%
  mutate(wm = getWikiMarkup(article, lang),
         target = "",
         origins_checked = FALSE) %>%
  select(lang, article) %>%
  mutate(id = paste(lang,article, sep = "."))

# Transform article into character 
Vienna$article <- as.character(Vienna$article)

# Get all language versions of articles
Vienna_all_lang <- getLangVersion_df(Vienna, lang_orig = "es")

Vienna_all_lang <- Vienna_all_lang %>%
  filter( lang == 'bg' | lang == 'cs' | lang == 'da' | lang == 'de' | lang == 'el' | lang == 'en' | lang == 'es' |
            lang == 'et' | lang == 'fi' | lang == 'fr' | lang == 'ga' | lang == 'hr' | lang == 'hu' | lang == 'is' | 
            lang == 'it' | lang == 'lt' | lang == 'lv' | lang == 'mk' | lang == 'mt' | lang == 'nl' | lang == 'no'| 
            lang == 'pl' | lang == 'pt' | lang == 'ro' | lang == 'ru' | lang == 'sk' | lang == 'sl' | lang == 'sq'| 
            lang == 'sr' | lang == 'sv' | lang == 'tr')

hdfs.init()

# Get Wikimarkup
Vienna_all_lang <- Vienna_all_lang %>%
  mutate(wm = getWikiMarkup(article, lang),
         target = "",
         origins_checked = FALSE)

#hdfs.init()

# Save file
write.csv(Vienna_all_lang, "Vienna_all_lang.csv")


### Vienna in German

# Get language versions of article of the city
Vienna <- data.frame(getLangVersion("Wien"), lang_orig = "de")
lang <- attr(Vienna, "row.names")

# Create a data frame with language and articles
Vienna <- data.frame(lang, Vienna)
Vienna$lang_orig <- NULL

# Add the starting article in the language I chose
starting <- data.frame("de", "Wien")
names(starting) <- c("lang", "article")

rownames(Vienna) <- NULL
names(Vienna) <- c("lang", "article")

Vienna <- rbind(Vienna, starting)
Vienna$article <- as.character(Vienna$article)

rm(starting)

# Filter considering only the chosen language
Vienna <- Vienna %>%
  filter( lang == 'de')

# Add linked articles
Linked <- data.frame(lang = 'de', article = getLinkedArticles(getWikiMarkup("Wien", lang = "de")))

# Merge two datasets
Vienna <- rbind(Vienna, Linked)
rm(Linked)

# Get articles wiki markup and add id for city
Vienna <- Vienna %>%
  mutate(wm = getWikiMarkup(article, lang),
         target = "",
         origins_checked = FALSE) %>%
  select(lang, article) %>%
  mutate(id = paste(lang,article, sep = "."))

# Transform article into character and delete # which creates problems
Vienna$article <- as.character(Vienna$article)
#Vienna[534,2] <- gsub(Vienna$article[533], "#", "Local public transport" )

# Get all language versions of articles
Vienna_all_lang <- getLangVersion_df(Vienna, lang_orig = "de")

Vienna_all_lang <- Vienna_all_lang %>%
  filter( lang == 'bg' | lang == 'cs' | lang == 'da' | lang == 'de' | lang == 'el' | lang == 'en' | lang == 'es' |
            lang == 'et' | lang == 'fi' | lang == 'fr' | lang == 'ga' | lang == 'hr' | lang == 'hu' | lang == 'is' | 
            lang == 'it' | lang == 'lt' | lang == 'lv' | lang == 'mk' | lang == 'mt' | lang == 'nl' | lang == 'no'| 
            lang == 'pl' | lang == 'pt' | lang == 'ro' | lang == 'ru' | lang == 'sk' | lang == 'sl' | lang == 'sq'| 
            lang == 'sr' | lang == 'sv' | lang == 'tr')

hdfs.init()

# Get Wikimarkup
Vienna_all_lang <- Vienna_all_lang %>%
  mutate(wm = getWikiMarkup(article, lang),
         target = "",
         origins_checked = FALSE)

# Save file
write.csv(Vienna_all_lang, "Vienna_all_lang_DE.csv")

# Merge of English and German

Vienna_EN <- read.table("Vienna_all_lang.csv", sep = ",", header = T, stringsAsFactors = F, fileEncoding = "utf-8") %>%
  select(-X)
Vienna_DE <- read.table("Vienna_all_lang_DE.csv", sep = ",", header = T, stringsAsFactors = F, fileEncoding = "utf-8") %>%
  select(-X)

Vienna_lang_and_redirects <- Vienna_DE %>%
  left_join(Vienna_EN, by = c("lang", "article", "wm", "target", "origins_checked")) %>%
  select(-id.y) %>%
  mutate(id = id.x) %>%
  select(-id.x)

hdfs.init()

Vienna_lang_and_redirects$target <- ""

# Add redirects targets and origins

Vienna_lang_and_redirects <- Vienna_lang_and_redirects %>%
  add_redirect_targets() 

#Vienna_lang_and_redirects <- read.table("/ichec/home/users/bogomil/temp/test_unicode_one.csv", sep = ",", header = T, stringsAsFactors = F, fileEncoding = "utf-8")

Vienna_lang_and_redirects <- Vienna_lang_and_redirects %>%
  add_redirect_origins() 

# Save file
write.csv(Vienna_lang_and_redirects, "Vienna_lang_and_redirects_ORIGINS_TARGETS.csv")

