# Analysis of language versions of WHS articles

## Load required libraries
library(dplyr)
library(reshape2)

## Load auxiliar functions
source("./scripts/r/whs_aux.R")

## Get list of whs articles in english wikipedia
fileName <- paste0(DATA_FOLDER, "/whsArticles.csv")
whsArticles <- read.csv(fileName, fileEncoding="UTF-8")

## Get language versions of articles
langVer <- getLangVersion(whsArticles$article)

## Convert list to data frame
for (i in 1:nrow(whsArticles)) {
	whs_id <- whsArticles$whs_id[i]
	
	# Add row for English article
	lang <- "en"
	article_title <- as.character(whsArticles$article[i])
	
	# If data frame doesn't exist then create it
	if (!exists("whsArticlesLang")) {
		whsArticlesLang <- data.frame(whs_id = whs_id, lang = lang, 
					      article = article_title)
		row.names(whsArticlesLang) <- NULL
		whsArticlesLang$whs_id <- as.factor(whsArticlesLang$whs_id)
		whsArticlesLang$lang <- as.factor(whsArticlesLang$lang)
		whsArticlesLang$article <- as.character(whsArticlesLang$article)
	} else {
		t <- data.frame(whs_id = as.factor(whs_id), lang = lang, article = article_title)
		t$whs_id <- as.factor(t$whs_id)
		row.names(t) <- NULL
		whsArticlesLang <- rbind(whsArticlesLang, t)
	}
	
	# Add rows for languages other than English
	langList <- langVer[[i]]
	if (!is.null(langList)) {
		t <- cbind(whs_id, lang = names(langList), article = langList)
		row.names(t) <- NULL
		whsArticlesLang <- rbind(whsArticlesLang, t)
	}
}

## Save data frame to disk
fileName <- paste0(DATA_FOLDER, "/whsArticlesLang.csv")
write.csv(whsArticlesLang, fileName, row.names = FALSE, fileEncoding = "UTF-8")
