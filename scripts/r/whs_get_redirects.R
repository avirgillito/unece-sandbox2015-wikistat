# This script reads the list of WHS articles in all languages, filters them to
# 31 languages and writes, identifies articles which redirect to other articles,
# extracts the destination articles and writes the results in an CSV output
# file.

print("Let's start getting redirects.")

# Constants
IN_FILE <- "hdfs:/projects/wikistats/applications_data/whs/whs_articles.csv"
OUT_FILE <- "hdfs:/projects/wikistats/applications_data/whs/whs_redirect_targets.csv"
LANGUAGES <- c("bg", "cs", "da", "de", "el", "en", "es", "et", "fi", "fr", "ga", 
	       "hr", "hu", "is", "it", "lt", "lv", "mk", "mt", "nl", "no", "pl", 
	       "pt", "ro", "ru", "sk", "sl", "sq", "sr", "sv", "tr")

# Attach packages used
library(dplyr)

# Load auxiliar functions
source("scripts/r/wiki_tools.R")

# Read list of articles
print("Getting list of WHS articles.")

if (!file_exists(IN_FILE)) {
	stop(paste("Could not find file with list of articles in all languages:",
		   IN_FILE))
}

whs_articles <- read_csv(IN_FILE, fileEncoding = "UTF-8") %>%
	filter(lang %in% LANGUAGES) %>%
	mutate(article = gsub("_", " ", as.character(article)))

# Get articles wiki markup
print("Getting wiki markup of articles.")
whs_articles <- whs_articles %>%
	mutate(wm = getWikiMarkup(article, lang))

# If there are articles which redirect to other articles, then get target articles
if (any(is_redirect(whs_articles$wm))) {
	print("Articles with redirects were found. Getting destination articles.")
	res <- whs_articles %>%
		filter(is_redirect(wm)) %>%
		mutate(dest = get_redirect_target(wm)) %>%
		select(-wm)
	print(paste("Saving results in output file:", OUT_FILE))
	write_csv(res, OUT_FILE, row.names = FALSE, quote = TRUE, 
		  fileEncoding = "UTF-8")
} else {
	print("No articles with redirects were found.")
}
