source("./scripts/r/whs_aux.R")

# Get list of WHS
print("Getting list of World Heritage Sites (WHS) from UNESCO website...")
downloadWHS(overwrite=FALSE)
whsData <- loadWHS()
fileName <- paste0(DATA_FOLDER, "/whs.csv")
write.csv(whsData, file=fileName)
print(paste0("List of WHS saved in '", fileName, "'."))

# Get list of English wikipedia articles associated to WHS
## Extraction of articles based on categorisation as WHS
print("Getting list of WHS wikipedia articles based on their categorisation...")
whsArticles <- getWhsArticlesFromCategories()
print("Done.")

## Extraction of articles based on articles with list of WHS
#downloadWhsArticles(overwrite=FALSE)
#whsArticles <- loadWhsArticles()

# Get WHS id number for each article
print("Getting wiki markup for the list of articles...")
wmd <- getWikiMarkup(whsArticles$title)
print(paste0("Articles wiki markup saved in '", WIKI_MARKUP_FOLDER, "'."))
print("Scrapping WHS reference numbers from the wiki markup of articles...")
whsId <- getWhsIdNumber(wmd)
print("Done.")

# Save file with list of articles
select <- !is.na(whsId)
data <- data.frame(article=whsArticles$title[select], whs_id=whsId[select])
fileName <- paste0(DATA_FOLDER, "/whsArticles.csv")
write.csv(data, file=fileName, fileEncoding="UTF-8")
print(paste0("List of articles with whs ID saved in '", fileName, "'."))