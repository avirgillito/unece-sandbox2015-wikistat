source("./scripts/r/whs_aux.R")

# Get list of WHS
downloadWHS(overwrite=FALSE)
whsData <- loadWHS()

# Get list of English wikipedia articles associated to WHS
downloadWhsArticles(overwrite=FALSE)
whsArticles <- loadWhsArticles()

# Save list of articles in text file for extraction of page views time-series
artFile <- file("data/articles.txt", open="w", encoding="UTF-8")
lapply(whsArticles, FUN=function(x) writeLines(x, con=artFile))
close(artFile)



# Match WHS scrapped from wikipedia with official list from UNESCO
match <- sapply(names(whsArticles), FUN=function(x) getClosest(x, whsData[,"site"]))
whsData$wikipedia <- NA
whsData$wikipedia[match] <- names(whsArticles)

match <- sapply(whsData[,"site"], FUN=function(x) getClosest(x, names(whsArticles)))


# Get corresponding articles in Italian
whsArticles.it <- translateArticlesList(whsArticles)
