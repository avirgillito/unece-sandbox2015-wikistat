
# Constants
DATA_FOLDER <- "./data"
RAW_DATA_FOLDER <- paste(DATA_FOLDER, "raw", sep="/")
WIKI_MARKUP_FOLDER <- paste(DATA_FOLDER, "wikimarkup", sep="/")
DATA_LOG_FILE <- "data.log"

WHS_UNESCO_URL <- "http://whc.unesco.org/en/list/xml/"
WHS_RAW_FILE <- "whc-sites.xml"
WHS_FILE <- "whc.RData"
WHS_ARTICLES_FILE <- "whsArticles.RData"

API_URL_WP <- "https://<lang>.wikipedia.org/w/api.php"
API_URL_WPM <- "http://wikipedia-miner.cms.waikato.ac.nz/services/"
API_URL_CATSCAN <- "http://tools.wmflabs.org/catscan2/catscan2.php"

CONTINENTS <- c("Africa", "the_Americas", "Northern_and_Central_Asia", 
                "Western_Asia", "Eastern_Asia", "Southern_Asia", 
                "Southeast_Asia", "Northern_Europe", "Western_Europe", 
                "Eastern_Europe", "Southern_Europe", "Oceania")

# Load required libraries
library(jsonlite)
library(logging)
library(XML)

# Set up data logger
addHandler(writeToFile, logger="data.log", 
           file=paste(DATA_FOLDER, DATA_LOG_FILE, sep="/"))

# This function checks if the data folder exist, and if it does not then 
# creates it together with its subfolders structure.
CheckDataFolderExists <- function() {
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
        if (!file.exists(WIKI_MARKUP_FOLDER)) {
                dir.create(WIKI_MARKUP_FOLDER)
                loginfo(paste0("Wiki markup data folder '", WIKI_MARKUP_FOLDER, "' created."), 
                        logger="data.log")
        }
}

# This function downloads the raw file with the official list of worl heritage 
# sites published by UNESCO and produces a clean data file.
downloadWHS <- function(overwrite = FALSE) {
        whsRawFileName <- paste(RAW_DATA_FOLDER, WHS_RAW_FILE, sep="/")
        whsFileName <- paste(DATA_FOLDER, WHS_FILE, sep="/")
        
        # If data folder does not exist then create it
        CheckDataFolderExists()
        
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
        } else {
                newFile <- FALSE
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
                write.csv(whs, file=whsFileName, fileEncoding="UTF-8")
                message <- paste0("WHS data frame '", whsFileName, 
                                  "' saved to disk.")
                loginfo(message, logger="data.log")
                if (fileExists) logwarn("WHS data frame file overwritten.", 
                                        logger="data.log")
        }
}

# This function returns the list of articles categorised in the categories passed as parameter.
# language=en&project=wikipedia&depth=0&categories=World+Heritage+Sites+in+Algeria&negcats=&comb%5Bsubset%5D=1&atleast_count=0&ns%5B0%5D=1&show_redirects=both&templates_yes=&templates_any=&templates_no=&outlinks_yes=&outlinks_any=&outlinks_no=&edits%5Bbots%5D=both&edits%5Banons%5D=both&edits%5Bflagged%5D=both&before=&after=&max_age=&larger=&smaller=&minlinks=&maxlinks=&min_redlink_count=1&min_topcat_count=1&sortby=none&sortorder=ascending&format=csv&ext_image_data=1&file_usage_data=1&doit=Do+it%21&interface_language=en
catScan <- function(categories, combination="subset", language="en", 
		    project="wikipedia", depth=0, namespaces="article") {
	# Process categories parameter
	categories <- gsub(" ", "+", categories)
	categories <- paste(categories, collapse = "%0D%0A")
	
	# Validate combination parameter
	# TODO: prepare code for several combinations
	# TODO: prepare error message for vectorised 'combination' parameter
	comb <- ""
	if ("subset" %in% combination) comb <- paste0(comb, "&comb[subset]=1")
	else if ("union" %in% combination) comb <- paste0(comb, "&comb[union]=1")
	if (comb == "")
		stop(paste0("Invalid categories combination specified: '", 
			    combination,
			    "'. Possible combinations: 'subset', 'union'."))
	
	# Validate namespaces parameter
	# TODO: prepare error message for vectorised 'namespaces' parameter
	ns <- ""
	if ("article" %in% namespaces) ns <- paste0(ns, "&ns[0]=1")
	if ("category" %in% namespaces) ns <- paste0(ns, "&ns[14]=1")
	if (ns == "")
		stop(paste0("No valid namespace specified in '", 
			    namespaces,
			    "'. Possible namespaces: 'article', 'category'."))
	
	# Compose query url
	query <- paste0(API_URL_CATSCAN, "?",
			"language=", language,
			"&project=", project,
			"&depth=", depth,
			"&categories=", categories,
			comb,
			ns,
			"&format=csv&doit=1")
	
	# Download to temporary file
	temp_file <- tempfile("catscan_", fileext = ".csv")
	download.file(query, temp_file, quiet = TRUE)
	
	# Load temporary file
	data <- read.csv(temp_file, skip=1, encoding="UTF-8")
	
	# Correct quotation marks escaped in CSV file
	levels(data$title) <- gsub("\\\\" , "\"", levels(data$title))
	
	# Delete temporary file
	file.remove(temp_file)
	
	# Return data
	data
}

# This function returns the markup text of a wikipedia article.
getWikiMarkup <- function(article, lang="en", refresh=FALSE) {
        # Vectorised function
        if (length(article) > 1) {
                wikiMarkup <- sapply(article, FUN=getWikiMarkup)
                names(wikiMarkup) <- NULL
        } else {
                # Replace spaces for underscores
                articleName <- gsub(" ", "_", article)
                
                # Compose file name of stored wiki markup
                CheckDataFolderExists()
                validArticleName <- gsub("[:*?<>|/\"]", "_", articleName)
                fileName <- paste0(WIKI_MARKUP_FOLDER, "/", lang, "_", 
                                   validArticleName, ".json")
                
                # If wiki markup was never downloaded then do it
                if (!file.exists(fileName) || refresh) {
                        api_url <- gsub("<lang>", lang, API_URL_WP)
                        url <- paste0(api_url,
                                      "?format=json&action=query&titles=",
                                      articleName,
                                      "&prop=revisions&rvprop=content")
                        
                        # Create temporary file name, because on Windows the 
                        # external download tool does not store the file with 
                        # the name in the utf-8 encoding.
                        fileName.temp <- "temp_file.json"
                        
                        # Download wiki markup
                        download.file(url, fileName.temp, quiet=TRUE, method="curl")
                        
                        # Change file name from original encoding
                        file.rename(fileName.temp, fileName)
                }
                
                # Read json file
                json <- jsonlite::fromJSON(fileName)
                
                # Get wiki markup of article
                wikiMarkup <- json$query$pages[[1]]$revisions[1, 3]
        }
        
        # Return wiki markup of article
        return(wikiMarkup)
}

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
        # Split text in lines
        wikiMarkup <- strsplit(wikiMarkup, "\\n")[[1]]
        
        # Get line with redirect text
        redirectLine <- grep('#REDIRECT', wikiMarkup, value=TRUE)
        
        # gsub does not escape properly the square brakets, so replace them
        redirectLine <- gsub("\\[", "<", redirectLine)
        redirectLine <- gsub("\\]", ">", redirectLine)
        
        # Get article to which it redirects
        m <- gregexpr("<<[^>]+>>", redirectLine)
        article <- regmatches(redirectLine, m)
        article <- gsub("<<([^>]+)>>", "\\1", article)
        
        # If redirect includes reference to section then remove it
        if (grepl("#", article)) article <- gsub("(.+)#.*", "\\1", article)
        
        # Return article name
        article
}

# This function gets the available translations of the English version article 
# passed as parameter. If lang parameter is empty string then the list of all 
# translations is returned.
# This function is vectorised.
getLangVersion <- function(article, lang="") {
        # Vectorised function
        if (length(article) > 1) {
                result <- sapply(article, FUN=function(x) getLangVersion(x, lang))
                names(result) <- NULL
        }
        else {
                # Get wiki markup text of article to check if it is redirect
                articleWikiMarkup <- getWikiMarkup(article)
                
                # If wiki page is redirected then get reference
                if (isRedirect(articleWikiMarkup)) {
                        articleName <- getRedirect(articleWikiMarkup)
                } else {
                        articleName <- article
                }
                
                # Replace spaces for %20
                articleName <- gsub("[ |_]", "%20", articleName)
                
                # Query Wikipedia Miner for translations
                url <- paste0(API_URL_WPM,
                              "exploreArticle?title=", 
                              articleName, "&translations=true&responseFormat=json")
                data <- fromJSON(url)
                trans <- data$translations$text
                names(trans) <- data$translations$lang
                
                # Return translation requested or all of them
                if (lang == "" || lang == "en") {
                        result <- trans
                } else {
                        result <- trans[lang]
                } 
        }
        
        # Return result
        return(result)
}

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

