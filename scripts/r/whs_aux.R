
# Constants
DATA_FOLDER <- "./data/"
RAW_DATA_FOLDER <- paste(DATA_FOLDER, "raw/", sep="")
DATA_LOG_FILE <- "data.log"

WHS_UNESCO_URL <- "http://whc.unesco.org/en/list/xml/"
WHS_RAW_FILE <- "whc-sites.xml"
WHS_FILE <- "whc.RData"
WHS_ARTICLES_FILE <- "whsArticles.RData"

API_URL_WP <- "http://en.wikipedia.org/w/api.php"
API_URL_WPM <- "http://wikipedia-miner.cms.waikato.ac.nz/services/"
CONTINENTS <- c("Africa", "the_Americas", "Northern_and_Central_Asia", 
                "Western_Asia", "Eastern_Asia", "Southern_Asia", 
                "Southeast_Asia", "Northern_Europe", "Western_Europe", 
                "Eastern_Europe", "Southern_Europe", "Oceania")

# Load required libraries
library(jsonlite)
library(curl)
library(logging)
library(XML)

# Set up data logger
addHandler(writeToFile, logger="data.log", file=paste0(DATA_FOLDER, DATA_LOG_FILE))

# This function checks if the data folders do not exist, in which case it 
# creates them.
createDataFolders <- function() {
        if (!file.exists(DATA_FOLDER)) {
                dir.create(DATA_FOLDER)
                loginfo(paste0("Data folder '", DATA_FOLDER, "' created."), 
                               logger="data.log")
        }
        if (!file.exists(RAW_DATA_FOLDER)) {
                dir.create(RAW_DATA_FOLDER)
                loginfo(paste0("Raw data folder '", RAW_DATA_FOLDER, "' created."), 
                               logger="data.log")
        }
}

# This function downloads the raw file with the official list of worl heritage 
# sites published by UNESCO and produces a clean data file.
downloadWHS <- function(overwrite = FALSE) {
        whsRawFileName <- paste0(RAW_DATA_FOLDER, WHS_RAW_FILE)
        whsFileName <- paste0(DATA_FOLDER, WHS_FILE)
        
        # If folders does not exist then create them
        createDataFolders()
        
        # If raw file does not exist or is to be overwritten then download it
        rawFileExists <- file.exists(whsRawFileName)
        if (!rawFileExists || overwrite) {
                download.file(WHS_UNESCO_URL, whsRawFileName, mode = "wb")
                newFile <- TRUE
                message <- paste0("WHS raw file '", whsRawFileName, 
                                  "' downloaded from '", WHS_UNESCO_URL, "'.")
                loginfo(message, logger="data.log")   
                if (rawFileExists) logwarn("WHS raw file overwritten.", 
                                           logger="data.log")
        }
        
        # If new raw file downloaded or converted file non-existent then do it
        fileExists <- file.exists(whsFileName)
        if (!fileExists || newFile) {
                
                # Convert raw file to data frame
                whs <- xmlToDataFrame(whsRawFileName)
                message <- paste0("WHS raw file '", whsRawFileName, 
                                  "' converted to data frame.")
                loginfo(message, logger="data.log")
                
                # Save data frame to disk
                save(whs, file=whsFileName)
                message <- paste0("WHS data frame '", whsFileName, 
                                  "' saved to disk.")
                loginfo(message, logger="data.log")
                if (fileExists) logwarn("WHS data frame file overwritten.", 
                                        logger="data.log")
        }
}

# This function gets the available translations of the article passed as 
# parameter
getWikipediaTranslations <- function(article) {

# This function returns TRUE if the wikiMarkup redirects to another wiki page.
isRedirect <- function(wikiMarkup) {
        # Check if redirect text is present
        redirectLine <- grep('#REDIRECT', wikiMarkup)
        
        # Return result
        if (length(redirectLine) == 0) {
                return(FALSE)
        } else {
                return(TRUE)
        }
}

# This function returns the name of the article to which the wikiMarkup directs.
getRedirect <- function(wikiMarkup) {
        # Get line with redirect text
        redirectLine <- grep('#REDIRECT', wikiMarkup, value=TRUE)
        
        # gsub does not escape properly the square brakets, so replace them
        redirectLine <- gsub("\\[", "<", redirectLine)
        redirectLine <- gsub("\\]", ">", redirectLine)
        
        # Get article to which it redirects
        m <- gregexpr("<<[^>]+>>", redirectLine)
        article <- regmatches(redirectLine, m)
        article <- gsub("<<([^>]+)>>", "\\1", article)
        
        # Return article name
        article
}
        url <- paste0(API_URL_WPM,
                      "exploreArticle?title=", 
                      article, "&translations=true&responseFormat=json")
        data <- fromJSON(url)
        lang <- data$translations$text
        names(lang) <- data$translations$lang
        lang
}

# This function gets the list of world heritage sites for the continent passed 
# as parameter
getWHS <- function(continent){
        # Download wikipedia article with list of sites for continent
        article <- paste0("List_of_World_Heritage_Sites_in_", continent)
        url <- paste0(API_URL_WP,
                      "?format=json&action=query&titles=",
                      article,
                      "&prop=revisions&rvprop=content")
        data <- fromJSON(url)
        message <- paste0("Downloaded list of WHS articles for '", 
                          continent, "'.")
        loginfo(message, logger="data.log")
        
        # Get wiki markup of article
        wikiMarkup <- data$query$pages[[1]]$revisions[1, 3]
        
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

#  This function gets the lists of articles in the language passed as parameter 
# for the world heritage sites in all continents in the world.
getWhsAllArticles <- function(lang="en") {
        # Get English articles for all continents
        articles <- lapply(CONTINENTS, FUN=function(x) getWhsArticles(x))
        whsArticles <- do.call("c", articles)
        
        # Convert articles to desired language
        tmp <- lapply(whsArticles, FUN=function(x) )
        
        # Save list of articles to disk
        whsArticlesFileName <- paste0(DATA_FOLDER, WHS_ARTICLES_FILE)
        save(whsArticles, file=whsArticlesFileName)
        message <- paste0("WHS articles list '", whsArticlesFileName, 
                          "' saved to disk.")
        loginfo(message, logger="data.log")
}



