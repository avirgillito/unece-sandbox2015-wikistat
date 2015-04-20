
# Constants
DATA_FOLDER <- "./data/"
RAW_DATA_FOLDER <- paste(DATA_FOLDER, "raw/", sep="")
DATA_LOG_FILE <- "data_log.log"

URL_UNESCO_WHS <- "http://whc.unesco.org/en/list/xls/"
FILE_NAME_UNESCO_WHS <- "whc-sites.xls"

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

# Set up data logger
addHandler(writeToFile, logger="data.log", file=paste(DATA_FOLDER, DATA_LOG_FILE, sep=""))

# This function downloads the Excel file with the official list of worl heritage 
# sites published by UNESCO and produces a clean data file.
downloadWHS <- function(overwrite = FALSE) {
        whsFileName <- paste(RAW_DATA_FOLDER, FILE_NAME_UNESCO_WHS, sep="")
        
        # Download file
        if (!file.exists(whsFileName)) {
                download.file(URL_UNESCO_WHS, whsFileName)
                loginfo("WHS Excel file downloaded.", logger="data.log")
        } else if (overwrite) {
                download.file(URL_UNESCO_WHS, whsFileName)
                loginfo("WHS Excel file downloaded.", logger="data.log")
                logwarn("WHS Excel file overwritten.", logger="data.log")
        }
        
        
        
        # Get the list only from Excel file and save it to disk
        
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



