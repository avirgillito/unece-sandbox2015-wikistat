source("./scripts/r/whs_aux.R")

downloadWHS(overwrite=FALSE)
whsData <- loadWHS()
