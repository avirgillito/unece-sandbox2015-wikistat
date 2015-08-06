# Analysis of the WHS

## Get list of WHS
downloadWHS(overwrite=FALSE)
whsData <- loadWHS()

## Restrict list to sites nominated before 2015
whsData <- whsData[whsData$date_inscribed != "2015", ]

## How many are there?
nrow(whsData)

## Which types of WHS?
table(whsData$category)
plot(table(whsData$date_inscribed), type="l")
table(whsData[, c("region", "category")])

## Get list of whs articles in english wikipedia
fileName <- paste0(DATA_FOLDER, "/whsArticles.csv")
whsArticles <- read.csv(fileName)

# Check number of articles by whs
t<-table(whsArticles$whs_id)
t<-as.data.frame(t)
