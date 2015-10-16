
# Constants
DATA_FOLDER <- "./data"
RAW_DATA_FOLDER <- paste(DATA_FOLDER, "raw", sep="/")
WIKI_MARKUP_FOLDER <- paste(DATA_FOLDER, "wikimarkup", sep="/")
HTML_FOLDER <- paste(DATA_FOLDER, "html", sep="/")
DATA_LOG_FILE <- "data.log"

WHS_UNESCO_URL <- "http://whc.unesco.org/en/list/xml/"
WHS_RAW_FILE <- "whc-sites.xml"
WHS_FILE <- "whs.csv"
WHS_ARTICLES_FILE <- "whsArticles.RData"

WP_URL <- "https://<lang>.wikipedia.org/wiki/"
WIKISTATS_URL <- "http://dumps.wikimedia.org/other/pagecounts-ez/merged/"
API_URL_WP <- "https://<lang>.wikipedia.org/w/api.php"
API_URL_WPM <- "http://wikipedia-miner.cms.waikato.ac.nz/services/"
API_URL_CATSCAN <- "http://tools.wmflabs.org/catscan2/catscan2.php"

CONTINENTS <- c("Africa", "the_Americas", "Northern_and_Central_Asia", 
                "Western_Asia", "Eastern_Asia", "Southern_Asia", 
                "Southeast_Asia", "Northern_Europe", "Western_Europe", 
                "Eastern_Europe", "Southern_Europe", "Oceania")

AMPERSAND_CODES <- setNames(
	c("\u0022", "\u0026", "\u0027", "\u003C", "\u003E", "\u00A0", "\u00A1",
	  "\u00A2", "\u00A3", "\u00A4", "\u00A5", "\u00A6", "\u00A7", "\u00A8",
	  "\u00A9", "\u00AA", "\u00AB", "\u00AC", "\u00AD", "\u00AE", "\u00AF",
	  "\u00B0", "\u00B1", "\u00B2", "\u00B3", "\u00B4", "\u00B5", "\u00B6",
	  "\u00B7", "\u00B8", "\u00B9", "\u00BA", "\u00BB", "\u00BC", "\u00BD",
	  "\u00BE", "\u00BF", "\u00C0", "\u00C1", "\u00C2", "\u00C3", "\u00C4",
	  "\u00C5", "\u00C6", "\u00C7", "\u00C8", "\u00C9", "\u00CA", "\u00CB",
	  "\u00CC", "\u00CD", "\u00CE", "\u00CF", "\u00D0", "\u00D1", "\u00D2",
	  "\u00D3", "\u00D4", "\u00D5", "\u00D6", "\u00D7", "\u00D8", "\u00D9",
	  "\u00DA", "\u00DB", "\u00DC", "\u00DD", "\u00DE", "\u00DF", "\u00E0",
	  "\u00E1", "\u00E2", "\u00E3", "\u00E4", "\u00E5", "\u00E6", "\u00E7",
	  "\u00E8", "\u00E9", "\u00EA", "\u00EB", "\u00EC", "\u00ED", "\u00EE",
	  "\u00EF", "\u00F0", "\u00F1", "\u00F2", "\u00F3", "\u00F4", "\u00F5",
	  "\u00F6", "\u00F7", "\u00F8", "\u00F9", "\u00FA", "\u00FB", "\u00FC",
	  "\u00FD", "\u00FE", "\u00FF", "\u0152", "\u0153", "\u0160", "\u0161",
	  "\u0178", "\u0192", "\u02C6", "\u02DC", "\u0391", "\u0392", "\u0393",
	  "\u0394", "\u0395", "\u0396", "\u0397", "\u0398", "\u0399", "\u039A",
	  "\u039B", "\u039C", "\u039D", "\u039E", "\u039F", "\u03A0", "\u03A1",
	  "\u03A3", "\u03A4", "\u03A5", "\u03A6", "\u03A7", "\u03A8", "\u03A9",
	  "\u03B1", "\u03B2", "\u03B3", "\u03B4", "\u03B5", "\u03B6", "\u03B7",
	  "\u03B8", "\u03B9", "\u03BA", "\u03BB", "\u03BC", "\u03BD", "\u03BE",
	  "\u03BF", "\u03C0", "\u03C1", "\u03C2", "\u03C3", "\u03C4", "\u03C5",
	  "\u03C6", "\u03C7", "\u03C8", "\u03C9", "\u03D1", "\u03D2", "\u03D6",
	  "\u2002", "\u2003", "\u2009", "\u200C", "\u200D", "\u200E", "\u200F",
	  "\u2013", "\u2014", "\u2018", "\u2019", "\u201A", "\u201C", "\u201D",
	  "\u201E", "\u2020", "\u2021", "\u2022", "\u2026", "\u2030", "\u2032",
	  "\u2033", "\u2039", "\u203A", "\u203E", "\u2044", "\u20AC", "\u2111",
	  "\u2118", "\u211C", "\u2122", "\u2135", "\u2190", "\u2191", "\u2192",
	  "\u2193", "\u2194", "\u21B5", "\u21D0", "\u21D1", "\u21D2", "\u21D3",
	  "\u21D4", "\u2200", "\u2202", "\u2203", "\u2205", "\u2207", "\u2208",
	  "\u2209", "\u220B", "\u220F", "\u2211", "\u2212", "\u2217", "\u221A",
	  "\u221D", "\u221E", "\u2220", "\u2227", "\u2228", "\u2229", "\u222A",
	  "\u222B", "\u2234", "\u223C", "\u2245", "\u2248", "\u2260", "\u2261",
	  "\u2264", "\u2265", "\u2282", "\u2283", "\u2284", "\u2286", "\u2287",
	  "\u2295", "\u2297", "\u22A5", "\u22C5", "\u22EE", "\u2308", "\u2309",
	  "\u230A", "\u230B", "\u2329", "\u232A", "\u25CA", "\u2660", "\u2663",
	  "\u2665"),
	c("quot", "amp", "apos", "lt", "gt", "nbsp", "iexcl", "cent", "pound",
	  "curren", "yen", "brvbar", "sect", "uml", "copy", "ordf", "laquo", 
	  "not", "shy", "reg", "macr", "deg", "plusmn", "sup2", "sup3", "acute", 
	  "micro", "para", "middot", "cedil", "sup1", "ordm", "raquo", "frac14", 
	  "frac12", "frac34", "iquest", "Agrave", "Aacute", "Acirc", "Atilde", 
	  "Auml", "Aring", "AElig", "Ccedil", "Egrave", "Eacute", "Ecirc", 
	  "Euml", "Igrave", "Iacute", "Icirc", "Iuml", "ETH", "Ntilde", 
	  "Ograve", "Oacute", "Ocirc", "Otilde", "Ouml", "times", "Oslash", 
	  "Ugrave", "Uacute", "Ucirc", "Uuml", "Yacute", "THORN", "szlig", 
	  "agrave", "aacute", "acirc", "atilde", "auml", "aring", "aelig", 
	  "ccedil", "egrave", "eacute", "ecirc", "euml", "igrave", "iacute", 
	  "icirc", "iuml", "eth", "ntilde", "ograve", "oacute", "ocirc", 
	  "otilde", "ouml", "divide", "oslash", "ugrave", "uacute", "ucirc", 
	  "uuml", "yacute", "thorn", "yuml", "OElig", "oelig", "Scaron", 
	  "scaron", "Yuml", "fnof", "circ", "tilde", "Alpha", "Beta", "Gamma", 
	  "Delta", "Epsilon", "Zeta", "Eta", "Theta", "Iota", "Kappa", "Lambda", 
	  "Mu", "Nu", "Xi", "Omicron", "Pi", "Rho", "Sigma", "Tau", "Upsilon", 
	  "Phi", "Chi", "Psi", "Omega", "alpha", "beta", "gamma", "delta", 
	  "epsilon", "zeta", "eta", "theta", "iota", "kappa", "lambda", "mu", 
	  "nu", "xi", "omicron", "pi", "rho", "sigmaf", "sigma", "tau", "upsilon",
	  "phi", "chi", "psi", "omega", "thetasym", "upsih", "piv", "ensp", "emsp",
	  "thinsp", "zwnj", "zwj", "lrm", "rlm", "ndash", "mdash", "lsquo", "rsquo",
	  "sbquo", "ldquo", "rdquo", "bdquo", "dagger", "Dagger", "bull", "hellip",
	  "permil", "prime", "Prime", "lsaquo", "rsaquo", "oline", "frasl", "euro",
	  "image", "weierp", "real", "trade", "alefsym", "larr", "uarr", "rarr", "darr",
	  "harr", "crarr", "lArr", "uArr", "rArr", "dArr", "hArr", "forall", "part",
	  "exist", "empty", "nabla", "isin", "notin", "ni", "prod", "sum", "minus",
	  "lowast", "radic", "prop", "infin", "ang", "and", "or", "cap", "cup", "int",
	  "there4", "sim", "cong", "asymp", "ne", "equiv", "le", "ge", "sub", "sup",
	  "nsub", "sube", "supe", "oplus", "otimes", "perp", "sdot", "vellip", "lceil",
	  "rceil", "lfloor", "rfloor", "lang", "rang", "loz", "spades", "clubs",
	  "hearts")
)

# Load required packages
library(jsonlite)
library(logging)
library(XML)
library(gsubfn)

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
        if (!file.exists(HTML_FOLDER)) {
        	dir.create(HTML_FOLDER)
        	loginfo(paste0("Html data folder '", HTML_FOLDER, "' created."), 
        		logger="data.log")
        }
}

# This function removes html ampersand character codes.
# Function based on solution provided by Karsten W. in 
# http://stackoverflow.com/questions/21790957/unescape-html-nn-sequences
removeAmpersandCodes <- function(html) {
	# Vectorise function
	if (length(html) > 1) {
		res <- sapply(html, FUN=strdehtml)
		names(res) <- NULL
	} else {
		# Replace ampersand encoding
		res <- gsubfn("&#([0-9]+);", function(x) rawToChar(as.raw(as.numeric(x))), html)
		res <- gsubfn("&([^;]+);", function(x) AMPERSAND_CODES[x], res)
	}
	
	# Return result
	return(res)
}

getPlainText <- function(html) {
	# Remove html tags
	html <- gsub("<.*?>", "", html)
	
	# Remove new lines
	html <- gsub("\n", " ", html)
	
	# Decode html ampersand character codes
	html <- strdehtml(html)
	
	# Return result
	return(html)
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
        
        # If new raw file downloaded or CSV file non-existent then create it
        fileExists <- file.exists(whsFileName)
        if (!fileExists || newFile) {
                
                # Convert raw file to data frame
                whs <- xmlToDataFrame(whsRawFileName)
                message <- paste0("WHS raw file '", whsRawFileName, 
                                  "' converted to data frame.")
                loginfo(message, logger="data.log")
                
                # Remove html tags
                whs$historical_description <- getPlainText(whs$historical_description)
                whs$justification <- getPlainText(whs$justification)
                whs$long_description <- getPlainText(whs$long_description)
                whs$short_description <- getPlainText(whs$short_description)
                
                # Save data frame to disk
                write.csv(whs, file=whsFileName, row.names=FALSE, fileEncoding="UTF-8")
                message <- paste0("WHS data frame '", whsFileName, 
                                  "' saved to disk.")
                loginfo(message, logger="data.log")
                if (fileExists) logwarn("WHS data frame file overwritten.", 
                                        logger="data.log")
        }
}

# This function returns the list of wikistats dumpfiles available from WMF
wikistatsFiles <- function() {
	# Get directory listing web page
	lines <- readLines(WIKISTATS_URL)
	
	# Extract wikistats dump files info from lines
	m <- regexec('<a href="(pagecounts-[0-9]{4}-[0-9]{2}-views-ge-5.bz2).+([0-9]{2}-[A-Z][a-z]{2}-[0-9]{4}[ ]+[0-9]{2}:[0-9]{2})[ ]+([0-9]+)', lines)
	result <- regmatches(lines, m)
	
	# Convert info from a list into a matrix
	for (s in result) {
		if (length(s) > 0) {
			record <- s[2:4]
			if (exists("dfr")) {
				dfr <- rbind(dfr, record)
			} else {
				dfr <- record
			}
			
		}
	}
	
	# Convert result to data frame
	dfr <- as.data.frame(dfr)
	names(dfr) <- c("name", "date", "size")
	dfr$size <- as.numeric(as.character(dfr$size))
	dfr$date <- strptime(dfr$date, format="%d-%b-%Y %H:%M")
	row.names(dfr) <- NULL
	
	# Return result
	dfr
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

# This function returns the html output of a wikipedia article.
getHtml <- function(article, lang="en", refresh=FALSE) {
	# Vectorised function
	if (length(article) > 1) {
		html <- sapply(article, FUN=getHtml)
		names(html) <- NULL
	} else {
		# Replace spaces for underscores
		articleName <- gsub(" ", "_", article)
		
		# Compose file name of stored html
		CheckDataFolderExists()
		validArticleName <- gsub("[:*?<>|/\"]", "_", articleName)
		fileName <- paste0(HTML_FOLDER, "/", lang, "_", 
				   validArticleName, ".html")
		
		# If html was never downloaded then do it
		if (!file.exists(fileName) || refresh) {
			lang_url <- gsub("<lang>", lang, WP_URL)
			art_url <- paste0(lang_url, articleName)
			
			# Create temporary file name, because on Windows the 
			# external download tool does not store the file with 
			# the name in the utf-8 encoding.
			fileName.temp <- "temp_file.html"
			
			# Download wiki markup
			download.file(art_url, fileName.temp, quiet=TRUE, method="curl")
			
			# Change file name from original encoding
			file.rename(fileName.temp, fileName)
		}
		
		# Read html file
		html <- paste(readLines(fileName), collapse = "")
	}
	
	# Return wiki markup of article
	return(html)
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

# This function returns the names of the articles to which the wikiMarkup link.
getLinkedArticles <- function(wikiMarkup) {
	# gsub does not escape properly the square brakets, so replace them
	wikiMarkup <- gsub("\\[", "<", wikiMarkup)
	wikiMarkup <- gsub("\\]", ">", wikiMarkup)
	
	# Identify links to other articles
	m <- gregexpr("<<[^>]+>>", wikiMarkup)
	articles <- unlist(regmatches(wikiMarkup, m))
	
	# Remove links to images and categories
	sel <- !grepl(".:.", articles)
	articles <- articles[sel]
	
	# Extract titles of articles linked to
	articles <- gsub("<<([^>|]+)\\|*[^>]*>>", "\\1", articles)
	
	# Remove references to sections of articles
	articles <- gsub("(.+)#.*", "\\1", articles)
	
	# Remove duplicated articles
	articles <- unique(articles)
	
	# Return articles names
	articles
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

