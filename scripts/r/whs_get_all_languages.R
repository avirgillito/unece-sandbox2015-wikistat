# This scripts reads the list of articles selected in the English Wikipedia,
# gets all the language versions of those articles and saves it as a data frame.

# Load required libraries
library(dplyr)
library(reshape2)

# Load auxiliar functions
source("./scripts/r/whs_data_man.R")

# Constants
IN_FILE <- paste0(WHS_DIR, "/whs_articles_en.csv")
OUT_FILE <- paste0(WHS_DIR, "/whs_articles.csv")

# Get list of whs articles in english wikipedia
whs_articles_en <- read_csv(IN_FILE, fileEncoding = "UTF-8")

# Get all other language versions of articles
langVer <- getLangVersion(whs_articles_en$article)

## Convert list to data frame
for (i in 1:nrow(whs_articles_en)) {
	whs_id <- whs_articles_en$whs_id[i]
	
	# Add row for English article
	lang <- "en"
	article_title <- as.character(whs_articles_en$article[i])
	
	# If data frame doesn't exist then create it
	if (!exists("whs_articles")) {
		whs_articles <- data.frame(whs_id = whs_id, lang = lang, 
					      article = article_title)
		row.names(whs_articles) <- NULL
		whs_articles$whs_id <- as.factor(whs_articles$whs_id)
		whs_articles$lang <- as.factor(whs_articles$lang)
		whs_articles$article <- as.character(whs_articles$article)
	} else {
		t <- data.frame(whs_id = as.factor(whs_id), lang = lang, 
				article = article_title)
		t$whs_id <- as.factor(t$whs_id)
		row.names(t) <- NULL
		whs_articles <- rbind(whs_articles, t)
	}
	
	# Add rows for languages other than English
	langList <- langVer[[i]]
	if (!is.null(langList)) {
		t <- cbind(whs_id, lang = names(langList), article = langList)
		row.names(t) <- NULL
		whs_articles <- rbind(whs_articles, t)
	}
}

# Remove references to sections in names of articles
whs_articles$article <- get_no_section(whs_articles$article)

# Save data frame to disk
write_csv(whs_articles, OUT_FILE, row.names = FALSE, fileEncoding = "UTF-8")
