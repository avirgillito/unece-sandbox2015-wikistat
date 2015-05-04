source("./scripts/r/whs_aux.R")

# Get list of WHS
downloadWHS(overwrite=FALSE)
whsData <- loadWHS()

# Get list of wikipedia articles associated to WHS
downloadWhsArticles(overwrite=FALSE)
whsArticles <- loadWhsArticles()