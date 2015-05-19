source("./scripts/r/whs_aux.R")


# Get list of WHS
downloadWHS(overwrite=FALSE)
whsData <- loadWHS()

# Get list of English wikipedia articles associated to WHS
## Extraction of articles based on categorisation as WHS
whsArticles <- getWhsArticlesFromCategories()

## Extraction of articles based on articles with list of WHS
downloadWhsArticles(overwrite=FALSE)
whsArticles <- loadWhsArticles()

# Get WHS id number for each article
wmd <- getWikiMarkup(whsArticles$title)

data$id_number <- as.numeric(NA)
for (i in 1:length(data$title)) {
        if (is.na(data$id_number)) {
                wmd <- getWikiMarkup(data$title[i])
                if (isRedirect(wmd)) wikiMarkup <- getWikiMarkup(getRedirect(wmd))
                data$id_number[i] <- getWhsIdNumber(wmd)
        }
}




# Atribution of at least one article to each WHS
whsData$article_id <- NA
for (i in 1:nrow(whsArticles)) {
        whs$article_id[whs$id_number == whsArticles$id_number[i]] <- whsArticles$id[i]
}

# Identify WHS without any article associated
missing <- whs[is.na(whs$article_id), c("id_number", "date_inscribed", "criteria_txt", "category","site", "states", "region", "location")]



# Save list of articles in text file for extraction of page views time-series
artFile <- file("data/articles.txt", open="w", encoding="UTF-8")
lapply(whsArticles, FUN=function(x) writeLines(x, con=artFile))
close(artFile)



# Match WHS scrapped from wikipedia with official list from UNESCO
match <- sapply(names(whsArticles), FUN=function(x) getClosest(x, whsData[,"site"]))
whsData$wikipedia <- NA  # Site name in wikipedia
for (i in 1:length(whsArticles)) {
        index <- whsData$site == match[i]
        
        whsData[index, "wikipedia"] <- names(whsArticles[i])
        #whsData[index, "distance"] <- names(whsArticles[i])
}

tmp <- whsData[, c("site", "wikipedia")]


library(stringdist)
m <- stringdistmatrix(whsData[,"site"], names(whsArticles), method="lv", useNames = TRUE)
for (i in 1:length(whsArticles)) {
        minDist <- min(m[, i])
        minDistIndex <- m[, i] == minDist
        if (minDist == 0) {
                whsData[minDistIndex, "wikipedia"] <- names(whsArticles[i])
        } else {
                rowMin <- min(m[minDistIndex, ])
                
        }
}

# Alternative way of doing the association
s <- matrix(0, nrow=nrow(m), ncol=ncol(m))
for (i in 1:nrow(m)) {
        if (sum(s[i, ]) == 0){
                for (j in 1:ncol(m)) {
                        if (sum(s[, j]) == 0) {
                                if (m[i, j] == min(m[i, ]) && m[i, j] == min(m[, j])) 
                                        s[i, j] <- 1
                        }
                }
                
        }
}

}

# Report on assignments to WHS found in wikipedia
multi <- length(colnames(m)[colSums(s[, ]) > 1])
paste("WHS in wikipedia assigned to more than 1 WHS in official list:", multi)
if (multi > 0) {
        #colnames(m)[colSums(s[, ]) > 1]
}

none <- length(colnames(m)[colSums(s[, ]) == 0])
paste("WHS in wikipedia NOT assigned to any WHS in official list:", none)
if (none > 0) {
        #colnames(m)[colSums(s[, ]) == 0]
}

# Report on assignments to WHS official list
multi <- length(rownames(m)[rowSums(s[, ]) > 1])
paste("Official WHS assigned to more than 1 WHS in wikipedia:", multi)
if (multi > 0) {
        rownames(m)[rowSums(s[, ]) > 1]
}

none <- length(rownames(m)[rowSums(s[, ]) == 0])
paste("Official WHS NOT assigned to any WHS in wikipedia:", none)
if (none > 0) {
        #rownames(m)[rowSums(s[, ]) == 0]
}

# Create correspondence list
key <- data.frame(WHS=rownames(m), wiki.en=rep(NA, nrow(m)), dist=numeric(nrow(m)))
for (i in 1: nrow(m)) {
        key[i, "wiki.en"] <- colnames(m)[s[i, ] == 1][1]
        key[i, "dist"] <- m[i, s[i, ] == 1][1]
}

# Build second iteration of matching




# Get corresponding articles in Italian
whsArticles.it <- translateArticlesList(whsArticles)