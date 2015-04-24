
# Constants
DATA_FOLDER <- "./data/"
RAW_DATA_FOLDER <- paste(DATA_FOLDER, "raw/", sep="")
DATA_LOG_FILE <- "data.log"

WHS_UNESCO_URL <- "http://whc.unesco.org/en/list/xml/"
WHS_RAW_FILE <- "whc-sites.xml"
WHS_FILE <- "whc.RData"

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

# This function downloads the raw file with the official list of worl heritage 
# sites published by UNESCO and produces a clean data file.
downloadWHS <- function(overwrite = FALSE) {
        whsRawFileName <- paste0(RAW_DATA_FOLDER, WHS_RAW_FILE)
        whsFileName <- paste0(DATA_FOLDER, WHS_FILE)
        
        # If raw file does not exist or is to be overwritten then download and convert it
        rawFileExists <- file.exists(whsRawFileName)
        if (!rawFileExists || overwrite) {
                
                # Download file
                download.file(WHS_UNESCO_URL, whsRawFileName, mode = "wb")
                loginfo(paste("WHS raw file downloaded from", WHS_UNESCO_URL), logger="data.log")   
                if (rawFileExists) logwarn("WHS raw file overwritten.", logger="data.log")
                
                # Convert it to data frame
                whs <- xmlToDataFrame(whsRawFileName)
                loginfo("WHS raw file converted to data frame", logger="data.log")
                
                # Save data frame to disk
                fileExists <- file.exists(whsFileName)
                save(whs, file=whsFileName)
                loginfo("WHS data frame saved to disk")
                if (fileExists) logwarn("WHS raw file overwritten.", logger="data.log")
                
        }
        
        
        # Return data frame
        whs
}

# This function gets the available translations of the article passed as 
# parameter
getWikipediaTranslations <- function(article) {
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
        
        # gsub does not escape properly the square brakets, so we have to replace them
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



