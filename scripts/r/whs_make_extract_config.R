# This script reads the list of articles in all language versions versions from a table in CSV format, 


# Load required libraries
library(dplyr)
library(urltools)
library(reshape2)

# Load auxiliar functions
source("scripts/r/wiki_tools.R")
source("scripts/r/whs_data_man.R")

# Constants
IN_FILE_ART <- paste0(WHS_DIR, "/whs_articles.csv")
IN_FILE_ART <- paste0(WHS_DIR, "/whs_redirects.csv")
IN_FILE_STATS <- "./data/wikistats.txt"

# Output directory needs to be in the local file system
OUT_DIR <- "./scripts/bash/"
OUT_FILE_CFG <- paste0(OUT_DIR, "multilang_extraction.cfg")

LANGUAGES <- c("bg", "cs", "da", "de", "el", "en", "es", "et", "fi", "fr", "ga", 
	       "hr", "hu", "is", "it", "lt", "lv", "mk", "mt", "nl", "no", "pl", 
	       "pt", "ro", "ru", "sk", "sl", "sq", "sr", "sv", "tr")



# Get list of whs articles in all language versions of Wikipedia
whs_articles <- read_csv(IN_FILE_ART, fileEncoding = "UTF-8") %>%
	filter(lang %in% LANGUAGES)

whs_articles <- melt(whs_articles, id.vars = c("whs_id", "lang"), 
		      variable.name = "type", value.name = "article")

# Get articles time-series already obtained
whs_stats <- read.table(IN_FILE_STATS, header = T) %>%
	mutate(article = url_decode(as.character(article))) %>%
	mutate(lang = substr(project, 1, 2)) %>%
	select(-project)

# Filter articles to only those for which time-series are missing
whs_articles2 <- whs_articles %>%
	anti_join(whs_stats, by = c("lang", "article"))

# Encode names of articles
whs_articles$article <- gsub(" ", "_", whs_articles$article)
#whs_articles$article <- encode_article_name(whs_articles$article)

## Create lists of articles per language and config file for ts extraction
lines <- c('outdir="/user/fernando/many_lang_extraction/"',
	   'tempdir="/user/fernando/temp/"')
seq <- 1
for (l in LANGUAGES) {
	articles <- whs_articles %>%
		filter(lang == l) %>%
		select(article)
	if (nrow(articles) > 0) {
		
		# Write list of articles for language
		file_name <- paste0("./data/whs_articles_", l, ".txt")
		writeLines(as.character(articles$article), file_name)
		
		# Add articles list file to conf
		line <- paste0('proj', seq, '="', l, '.z ./data/whs_articles_', l, '.txt ',
			       '/projects/wikistats/views_processed_2012-2013/articles_time-series_', 
			       l, ' /projects/wikistats/views_processed_2014-2015/articles_time-series_', 
			       l, '"')
		lines <- c(lines, line)
		seq <- seq + 1
	}
}

# Write config file
writeLines(lines, OUT_FILE_CFG, sep = "\n")
