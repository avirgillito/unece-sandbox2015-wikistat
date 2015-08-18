# Analysis of the WHS

## Load required libraries
library(dplyr)
library(reshape2)

## Load auxiliar functions
source("./scripts/r/whs_aux.R")

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
whsArticles <- read.csv(fileName, fileEncoding="UTF-8")

# Check number of articles by whs
t <- table(whsArticles$whs_id)
t <- as.data.frame(t)
table(t$Freq)

### The highest number of articles is 17, for whs with id number '971' which corresponds to 'Churches of Chiloé'.
### The 17 articles correspond to each one of the churches.
filter(t, Freq==17)
filter(whsData, id_number==971)$site
filter(whsArticles, whs_id==971)

## Get articles with WHS ids which are not in the list
## Note: 'id_number' needs to be first converted to character because it is a favtor variable.
whsData <- mutate(whsData, whs_id = as.numeric(as.character(id_number)))
tmp <- left_join(whsArticles, whsData[, c("whs_id", "site")])
tmp[is.na(tmp$site),]

## Get WHS in list which do not have articles
tmp <- left_join(whsData[, c("whs_id", "site")], whsArticles)
tmp[is.na(tmp$X),]

## Load page views time-series for articles
fileName <- paste0(DATA_FOLDER, "/wikistats_en.txt")
whsStats <- read.table(fileName, header = T)
whsStats$article <- sapply(as.character(whsStats$article), FUN=URLdecode)

## Melt page views data frame
whsStats <- melt(whsStats, id.vars="article", variable.name="month")

## Compute total pageviews by article
articles <- group_by(whsStats, article)
statArticles <- summarise(articles, tot_pageviews=sum(value))
statArticles <- arrange(statArticles, desc(tot_pageviews))
top20 <- statArticles[1:20,]
top20$article <- as.character(top20$article)
ggplot(data=top20, aes(x=article, y=tot_pageviews)) +
        geom_bar(stat="identity")

## Get WHS articles without pageviews time-series
tmp <- left_join(whsArticles, statArticles, by = c("article2" = "article"))
nrow(tmp[is.na(tmp$tot_pageviews), "article"])

## Get WHS pageviews time-series for articles which are not listed
whsArticles$article2 <- gsub(",", "", whsArticles$article)
tmp <- left_join(statArticles, whsArticles, by = c("article" = "article2"))
