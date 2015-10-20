
# Constants
CONTINENTS <- c("Africa", "the_Americas", "Northern_and_Central_Asia", 
                "Western_Asia", "Eastern_Asia", "Southern_Asia", 
                "Southeast_Asia", "Northern_Europe", "Western_Europe", 
                "Eastern_Europe", "Southern_Europe", "Oceania")



# Load required packages


# This function gets the list of the English wikipedia articles for each world 
# heritage site for the continent passed as parameter
getWhsArticles <- function(continent){
        # Get markup text of wikipedia article with list of sites for continent
        article <- paste0("List_of_World_Heritage_Sites_in_", continent)
        wikiMarkup <- getWikiMarkup(article)
        
        # Enter info in log
        message <- paste0("Downloaded list of WHS articles for '", 
                          continent, "'.")
        loginfo(message, logger="data.log")
        
        # Convert lines of markup into a vector
        lines <- strsplit(wikiMarkup, split="\n")[[1]]
        
        # Select markup lines corresponding to first column of every row of table
        lines <- grep('! scope="row" \\|', lines, value=TRUE)
        
        # Clean lines to leave only name  and articles names
        lines <- gsub('! scope="row" \\|', "", lines)
        lines <- gsub('<sup>\\{\\{†\\|alt=In danger\\}\\}</sup>[ ]*', "", lines)
        lines <- gsub('\\{\\{sort\\|[^\\|]+\\|', "", lines)
        lines <- gsub('\\}\\}', "", lines)
        
        # gsub does not escape properly the square brakets, so replace them
        lines <- gsub("\\[", "<", lines)
        lines <- gsub("\\]", ">", lines)
        
        # Trimm lines
        lines <- gsub("^[ ]+", "", lines)
        lines <- gsub("[ ]+$", "", lines)
        lines <- gsub("[ ]{2,}", " ", lines)
        
        # Get sites names
        sites <- gsub("<<([^>]+)\\|[^>]+>>", "\\1", lines)
        sites <- gsub("<<([^>]+)>>", "\\1", sites)
        
        # Get sites articles
        m <- gregexpr("<<[^>]+>>", lines)
        articles <- regmatches(lines, m)
        articles <- lapply(articles, FUN=function(x) gsub("<<([^>]+)\\|([^>]+)>>", "\\2", x))
        articles <- lapply(articles, FUN=function(x) gsub("<<([^>]+)>>", "\\1", x))
        names(articles) <- sites
        
        # Return list of sites with articles associated
        articles
}

# This function gets the lists of articles in the language passed as parameter 
# for the world heritage sites in all continents in the world.
getWhsArticlesFromLists <- function() {
        # Get articles for all continents
        articles <- lapply(CONTINENTS, FUN=function(x) getWhsArticles(x))
        whsArticles <- do.call("c", articles)
        
        # Convert articles to desired language
        #tmp <- lapply(whsArticles, FUN=function(x) )
        
        # Save list of articles to disk
        whsArticlesFileName <- paste(DATA_FOLDER, WHS_ARTICLES_FILE, sep="/")
        save(whsArticles, file=whsArticlesFileName)
        message <- paste0("WHS articles list '", whsArticlesFileName, 
                          "' saved to disk.")
        loginfo(message, logger="data.log")
}

# This function returns a data frame with a list of WHS articles from the 
# English wikipedia, based on their categorisation as WHS.
getWhsArticlesFromCategories <- function() {
        # Get all articles in category 'World Heritage Sites by continent'
        data <- catScan(c("World Heritage Sites by continent",
                          "World Heritage Sites in the United Kingdom",
                          "World Heritage Sites in the Republic of Ireland",
                          "World Heritage Sites in Catalonia",
        		  "World Heritage Sites in Austria"), 
                        combination="union",
                        depth=2)
        
        # Return data frame with list of articles
        data
}

# This function gets the WHS id number for an article based on the presence of 
# an appropriate InfoBox in wiki markup code of the article.
# This function is vectorised.
getWhsIdNumber <- function(wikiMarkup) {
        # Vectorised function
        if (length(wikiMarkup) > 1) {
                result <- sapply(wikiMarkup, FUN=getWhsIdNumber)
                names(result) <- NULL
        }
        else {
                
                # Check validity of parameter
                if (is.null(wikiMarkup)) 
                        stop("WikiMarkup of WHS article is empty.")
                if (isRedirect(wikiMarkup))
                        wikiMarkup <- getWikiMarkup(getRedirect(wikiMarkup))
                
                # Get WHS id number from wiki markup code
                if (grepl("Infobox World Heritage Site", wikiMarkup)) {
                        m <- regexec("[' '|\t]*\\|[' '|\t]*ID[' '|\t]*=[' '|\t]*([0-9]+)[a-z]*", wikiMarkup)
                        result <- as.numeric(regmatches(wikiMarkup, m)[[1]][2])
                }
                else if (grepl("designation1[' '|\t]*=[' '|\t]*WHS", wikiMarkup) 
                         || grepl("designation1[' '|\t]*=[' '|\t]*World Heritage Site", wikiMarkup)) {
                        m <- regexec("designation1_number[' '|\t]*=[' '|\t]*[^' ']*[' ']*([0-9]+)[a-z]*\\]", wikiMarkup)
                        result <- as.numeric(regmatches(wikiMarkup, m)[[1]][2])
                }
                else if (grepl("designation2[' '|\t]*=[' '|\t]*WHS", wikiMarkup) 
                         || grepl("designation2[' '|\t]*=[' '|\t]*World Heritage Site", wikiMarkup)) {
                        m <- regexec("designation2_number[' '|\t]*=[' '|\t]*[^' ']*[' ']*([0-9]+)[a-z]*\\]", wikiMarkup)
                        result <- as.numeric(regmatches(wikiMarkup, m)[[1]][2])
                }
                else if (grepl("whs_number[' '|\t]*=[' '|\t]*[0-9]+", wikiMarkup)) {
                        m <- regexec("whs_number[' '|\t]*=[' '|\t]*([0-9]+)", wikiMarkup)
                        result <- as.numeric(regmatches(wikiMarkup, m)[[1]][2])
                }
                else result <- NA
        }
        
        # Return result
        return(result)
}

downloadWhsArticles <- function(overwrite = FALSE) {
        whsArticlesFileName <- paste(DATA_FOLDER, WHS_ARTICLES_FILE, sep="/")
        
        # If data folder does not exist then create it
        CheckDataFolderExists()
        
        # If raw file does not exist or is to be overwritten then download it
        fileExists <- file.exists(whsArticlesFileName)
        if (!fileExists || overwrite) {
                
                # Get English articles for all continents
                articles <- lapply(CONTINENTS, FUN=function(x) getWhsArticles(x))
                whsArticles <- do.call("c", articles)
                
                # Save list of articles to disk
                save(whsArticles, file=whsArticlesFileName)
                message <- paste0("WHS articles list '", whsArticlesFileName, 
                                  "' saved to disk.")
                loginfo(message, logger="data.log")   
                if (fileExists) logwarn("WHS articles list overwritten.", 
                                        logger="data.log")
        }
}

loadWhsArticles <- function() {
        whsArticlesFileName <- paste(DATA_FOLDER, WHS_ARTICLES_FILE, sep="/")
        load(whsArticlesFileName)
        
        # Return articles list
        whsArticles
}

# This function returns from a vector 'alternatives' of strings passed as 
# parameter, the one closest to 'text'.
getClosest <- function(text, alternatives) {
        d <- adist(text, alternatives)
        alternatives[d == min(d)][1]
}

