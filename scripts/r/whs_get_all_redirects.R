# This scripts reads the list of articles selected in all language versions of
# Wikipedia, gets all the redirecting articles and saves them as a data frame.

# Load required libraries
library(dplyr)
library(reshape2)

# Load auxiliar functions
source("./scripts/r/whs_data_man.R")

# Constants
IN_FILE <- paste0(WHS_DIR, "/whs_articles.csv")
OUT_FILE <- paste0(WHS_DIR, "/whs_redirects.csv")
LANGUAGES <- c("bg", "cs", "da", "de", "el", "en", "es", "et", "fi", "fr", "ga", 
	       "hr", "hu", "is", "it", "lt", "lv", "mk", "mt", "nl", "no", "pl", 
	       "pt", "ro", "ru", "sk", "sl", "sq", "sr", "sv", "tr")

# Read list of articles
print("Getting list of WHS articles.")
if (!file_exists(IN_FILE)) {
	stop(paste("Could not find file with list of articles in all languages:",
		   IN_FILE))
}
whs_articles <- read_csv(IN_FILE, fileEncoding = "UTF-8") %>%
	filter(lang %in% LANGUAGES) %>%
	mutate(article = gsub("_", " ", as.character(article))) %>%
        distinct()

# Get articles wiki markup
print("Getting wiki markup of articles.")
whs_articles <- whs_articles %>%
	mutate(wm = getWikiMarkup(article, lang))

# Get final targets of redirecting articles
# If there are articles which redirect to other articles, then get target articles
if (any(is_redirect(whs_articles$wm))) {
	whs_articles <- whs_articles %>%
		mutate(target = get_redirect_final_target(wm, lang)) %>%
		select(-wm)
}

# Replace redirect articles by their final targets
whs_articles <- whs_articles %>%
        filter(target != "") %>%
        mutate(article = target,
               target = "") %>%
        union(whs_articles) %>%
        distinct() %>%
        filter(target == "")

# Get redirect articles
print("Getting redirects to WHS articles.")
redir <- get_redirect(whs_articles$article, whs_articles$lang)

# ## Convert list to data frame
# for (i in 1:nrow(whs_articles)) {
# 	whs_id <- whs_articles$whs_id[i]
# 	
# 	# Add row for English article
# 	lang <- "en"
# 	article_title <- as.character(whs_articles_en$article[i])
# 	
# 	# If data frame doesn't exist then create it
# 	if (!exists("whs_articles")) {
# 		whs_articles <- data.frame(whs_id = whs_id, lang = lang, 
# 					   article = article_title)
# 		row.names(whs_articles) <- NULL
# 		whs_articles$whs_id <- as.factor(whs_articles$whs_id)
# 		whs_articles$lang <- as.factor(whs_articles$lang)
# 		whs_articles$article <- as.character(whs_articles$article)
# 	} else {
# 		t <- data.frame(whs_id = as.factor(whs_id), lang = lang, 
# 				article = article_title)
# 		t$whs_id <- as.factor(t$whs_id)
# 		row.names(t) <- NULL
# 		whs_articles <- rbind(whs_articles, t)
# 	}
# 	
# 	# Add rows for languages other than English
# 	langList <- redir[[i]]
# 	if (!is.null(langList)) {
# 		t <- cbind(whs_id, lang = names(langList), article = langList)
# 		row.names(t) <- NULL
# 		whs_articles <- rbind(whs_articles, t)
# 	}
# }
# 
# # Remove references to sections in names of articles
# whs_articles$article <- get_no_section(whs_articles$article)
# 
# # Save data frame to disk
# write_csv(whs_articles, OUT_FILE, row.names = FALSE, fileEncoding = "UTF-8")