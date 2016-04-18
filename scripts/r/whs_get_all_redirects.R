# This scripts reads the list of articles selected in all language versions of
# Wikipedia, gets all the redirecting articles and saves them as a data frame.

# Load required libraries
library(dplyr)
library(reshape2)

# Load auxiliar functions
source("./scripts/r/whs_data_man.R")

# Constants
IN_FILE <- paste0(WHS_DIR, "/whs_articles.csv")
OUT_FILE <- paste0(WHS_DIR, "/whs_redirect_targets_origins.csv")

LANGUAGES <- c("bg", "cs", "da", "de", "el", "en", "es", "et", "fi", "fr", "ga", 
	       "hr", "hu", "is", "it", "lt", "lv", "mk", "mt", "nl", "no", "pl", 
	       "pt", "ro", "ru", "sk", "sl", "sq", "sr", "sv", "tr")

# This function adds redirect targets to a list of articles.
# It uses the fields: wm, target, lang
add_redirect_targets <- function(articles) {
	# Check if there are redirect articles
	if (all(!is_redirect(articles$wm) | articles$target != "")) return (articles)
	
	# Get targets
	targets <- articles %>%
		filter(is_redirect(wm), target == "") %>%
		mutate(target = get_redirect_target(wm),
		       article = target,
		       target = "",
		       wm = getWikiMarkup(article, lang))

	# If targets are also redirects then recursively resolve redirects
	if (any(is_redirect(targets$wm))) {
		targets <- add_redirect_targets(targets)
	}
	
	# Add targets to the list of articles and eliminate duplicates
	res <- articles %>%
		union(targets) %>%
		distinct()
	
	# Return result
	return(res)

}

# This function converts a vector to data frame including its attributes as fields
as.data.frame.attr <- function(v) {
	return(data.frame(origin = as.character(v), lang = attr(v, "lang")))
}

# This function adds redirect origins to a list of articles.
add_redirect_origins <- function(articles) {
	# Check if there are articles to be checked for redirect origins
	if (all(articles$origins_checked)) return (articles)
	
	# Flag articles as checked for redirect origins
	to_check <- !articles$origins_checked
	articles$origins_checked <- TRUE
	
	# Get redirect origins
	origins <- get_redirect_origins(articles[to_check, "article"], articles[to_check, "lang"]) %>%
		plyr::ldply(.fun = as.data.frame.attr, .id = "article")
	
	# Check if there are redirect origins
	if (all(is.na(origins$origin))) return (articles)
	
	# Process origins found
	origins <- origins%>%
		filter(!is.na(origin)) %>%
		left_join(articles, by = c("article", "lang")) %>%
		select(whs_id, lang, article, origin) %>%
		mutate(target = article,
		       article = as.character(origin),
		       wm = getWikiMarkup(article, lang),
		       origins_checked = FALSE) %>%
		select(-origin)
	
	# Add origins to the list of articles that are not already there
	res <- origins %>%
		anti_join(articles, by = c("lang", "article")) %>%
		union(articles)

	# If there are any new articles in the list then recursively get their origins
	if (any(!res$origins_checked)) {
		res <- add_redirect_origins(res)
	}
	
	# Return result
	return(res)
	
}

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
	mutate(wm = getWikiMarkup(article, lang),
	       target = "",
	       origins_checked = FALSE)

# Add redirects targets and origins
print("Getting redirect targets and origins.")
whs_articles <- whs_articles %>%
	add_redirect_targets() %>%
	add_redirect_origins() %>%
	select(-wm)

# Save data frame to disk
write_csv(whs_articles, OUT_FILE, row.names = FALSE, fileEncoding = "UTF-8")


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