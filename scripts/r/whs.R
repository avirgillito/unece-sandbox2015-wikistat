source("./scripts/r/whs_aux.R")

# Get list of WHS
downloadWHS(overwrite=FALSE)
whsData <- loadWHS()

# Get list of English wikipedia articles associated to WHS
downloadWhsArticles(overwrite=FALSE)
whsArticles <- loadWhsArticles()

# Save list of articles in text file
artFile <- file("data/articles.txt", open="w", encoding="UTF-8")
lapply(whsArticles, FUN=function(x) writeLines(x, con=artFile))
close(artFile)

# Get corresponding articles in Italian
whsArticles.it <- translateArticlesList(whsArticles)
