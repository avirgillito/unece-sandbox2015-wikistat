source("./scripts/r/whs_aux.R")

select_articles <- function(methods="categories") {
	# TODO: Check validity of methods of selection of articles
	
	# Get list of WHS
	print("Getting list of World Heritage Sites (WHS) from UNESCO website...")
	downloadWHS(overwrite=FALSE)
	whsData <- loadWHS()
	fileName <- paste0(DATA_FOLDER, "/whs.csv")
	write.csv(whsData, file=fileName)
	print(paste0("List of WHS saved in '", fileName, "'."))
	
	# Get list of English wikipedia articles associated to WHS
	## Extraction of articles based on categorisation as WHS
	if ("categories" %in% methods) {
		print("Getting list of WHS wikipedia articles based on their categorisation...")
		whsArticles <- getWhsArticlesFromCategories()
		print("Done.")
	}
	
	## Extraction of articles based on articles with list of WHS
	#downloadWhsArticles(overwrite=FALSE)
	#whsArticles <- loadWhsArticles()
	
	## If list of articles is empty then leave
	if (length(whsArticles) == 0) {
		warning
		print("No WHS wikipedia articles obtained based on their categorisation.")
	}
	
	# Get WHS id number for each article
	print("Getting wiki markup for the list of articles...")
	wmd <- getWikiMarkup(whsArticles$title)
	print(paste0("Articles wiki markup saved in '", WIKI_MARKUP_FOLDER, "'."))
	print("Scrapping WHS reference numbers from the wiki markup of articles...")
	whsId <- getWhsIdNumber(wmd)
	print("Done.")
	
	# Save files with list of articles and article names
	select <- !is.na(whsId)
	data <- data.frame(article=whsArticles$title[select], whs_id=whsId[select])
	fileName <- paste0(DATA_FOLDER, "/whsArticles.csv")
	write.csv(data, file=fileName, fileEncoding="UTF-8")
	print(paste0("List of articles with whs ID saved in '", fileName, "'."))
	fileName <- paste0(DATA_FOLDER, "/articles.txt")
	write.table(data[, "article"], row.names=FALSE, col.names=FALSE, quote=FALSE, file=fileName, fileEncoding="UTF-8")
	print(paste0("List of articles titles only saved in '", fileName, "'."))
}

select_articles()
