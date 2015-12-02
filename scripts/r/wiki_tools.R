# Source dependencies
source("./scripts/r/data_man.R")

# Constants
WP_URL <- "https://<lang>.wikipedia.org/wiki/"
WIKISTATS_URL <- "http://dumps.wikimedia.org/other/pagecounts-ez/merged/"
API_URL_WP <- "https://<lang>.wikipedia.org/w/api.php"
API_URL_WPM <- "http://wikipedia-miner.cms.waikato.ac.nz/services/"
API_URL_CATSCAN <- "http://tools.wmflabs.org/catscan2/catscan2.php"
API_URL_MEDIAWIKI_EN <- "http://en.wikipedia.org/w/api.php"

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
library(XML)
library(gsubfn)

# This function removes html ampersand character codes.
# Function based on solution provided by Karsten W. in 
# http://stackoverflow.com/questions/21790957/unescape-html-nn-sequences
removeAmpersandCodes <- function(html) {
	# Vectorise function
	if (length(html) > 1) {
		res <- sapply(html, FUN=removeAmpersandCodes)
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
	html <- removeAmpersandCodes(html)
	
	# Return result
	return(html)
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
		check_data_folders(DATA_DIR_STR)
		validArticleName <- gsub("[:*?<>|/\"]", "_", articleName)
		fileName <- paste0(HTML_FOLDER, "/", lang, "_", 
				   validArticleName, ".html")
		
		# If html was never downloaded then do it
		if (!file_exists(fileName) || refresh) {
			lang_url <- gsub("<lang>", lang, WP_URL)
			art_url <- paste0(lang_url, articleName)
			
			# Create temporary file name, because on Windows the 
			# external download tool does not store the file with 
			# the name in the utf-8 encoding.
			fileName.temp <- "temp_file.html"
			
			# Download wiki markup
			download.file(art_url, fileName.temp, quiet=TRUE, method="curl")
			
			# Change file name from original encoding and move to HDFS
			if (!HDFS) {
				file.rename(fileName.temp, fileName)
			} else {
				hdfs.put(fileName.temp, fileName)
			}
		}
		
		# Read html file
		html <- paste(read_lines(fileName), collapse = "")
	}
	
	# Return wiki markup of article
	return(html)
}

# This function removes section references from articles titles.
remove_section_ref <- function(article) {
	return(sub("#.+$", "", article))
}

# This function returns the markup text of a wikipedia article.
# NOTE: It might be needed to create temporary file name, because on Windows the
# external download tool does not store the file with the name in the utf-8
# encoding.
getWikiMarkup <- function(article, lang="en", refresh=FALSE) {
	# Create data folders if they don't exit
	check_data_folders(DATA_DIR_STR)
	
	# Remove possible references to sections in the articles
	article <- remove_section_ref(article)
	
	# Replace spaces for underscores
	article_name <- gsub(" ", "_", article)
	
	# Compose file name of stored wiki markup
	valid_article_name <- gsub("[:*?<>|/\"]", "_", article_name)
	file_name <- paste0(WIKI_MARKUP_DIR, "/", lang, "_",  
			   valid_article_name, ".json")
	
	# Find out which files need to be downloaded
	to_download <- !file_exists(file_name) | refresh
	
	# Download files not in the cache
	if (any(to_download)) {
		
		# Compose url's from where to get the files
		url <- character(length(file_name))
		for (one_lang in unique(lang[to_download])) {
			api_url <- gsub("<lang>", one_lang, API_URL_WP)
			sel <- (lang == one_lang) & (to_download)
			url[sel] <- paste0(api_url,
					   "?format=json&action=query&titles=",
					   article_name[sel],
					   "&prop=revisions&rvprop=content")
		}
		
		# Download wiki markup of articles not in cache
		download_file(url[to_download], file_name[to_download])
	}	
	
	# Read json files and extract wiki markup
	res <- character(0)
	for (one_file in file_name) {
		text <- read_lines(one_file, collapse = TRUE)
		if (jsonlite::validate(text)) {
			json <- jsonlite::fromJSON(text)
			if ("missing" %in% names(json$query$pages[[1]])) {
				wiki_markup <- "ERROR: wikimarkup missing"
				warning(paste("wikimarkup missing in"), one_file)
			} else {
				wiki_markup <- json$query$pages[[1]]$revisions[1, 3]
			}
		} else {
			wiki_markup <- "ERROR: not valid json text"
			warning(paste("json text not valid in"), one_file)
		}
		if (is.null(wiki_markup)) {
			wiki_markup <- "ERROR: wikimarkup is null"
			warning(paste("null wikimarkup in"), one_file)
		}
		res <- c(res, wiki_markup)
	}
	
	# Return wiki markup of articles
	return(res)
}

# Language specific wikimarkup codes for redirecting articles
REDIR_WIKIMARKUP <- c(
	"#виж",			# BG
	"#PŘESMĚRUJ",		# CS
	"#REDIRECT",		# EN, DA, LV
	"#WEITERLEITUNG",	# DE
	"#ΑΝΑΚΑΤΕΥΘΥΝΣΗ",	# EL
	"#REDIRECCIÓN",		# ES
	"#SUUNA",		# ET
	"#REDIRECTION",		# FR
	"#OHJAUS",		# FI
	"#ATHSHEOLADH",		# GA
	"#PREUSMJERI",		# HR
	"#ÁTIRÁNYÍTÁS",		# HU
	"#TILVÍSUN",		# IS
	"#RINVIA", 		# IT
	"#PERADRESAVIMAS",	# LT
	"#ПРЕНАСОЧУВАЊЕ",	# MK
	"#RINDIRIZZA",		# MT
	"#DOORVERWIJZING",	# NL
	"#OMDIRIGERING",	# NO
	"#PATRZ",		# PL
	"#REDIRECIONAMENTO",	# PT
	"#REDIRECTEAZA",	# RO
	"#ПЕРЕНАПРАВЛЕНИЕ",	# RU
	"#PRESMERUJ",		# SK
	"#PREUSMERITEV",	# SL
	"#RIDREJTO",		# SQ
	"#ПРЕУСМЕРИ",		# SR
	"#OMDIRIGERING",	# SV
	"#YÖNLENDİRME"		# TR
	)

# This function returns TRUE if the wikiMarkup redirects to another wiki page.
# NOTE: This function is vectorised.
isRedirect <- function(wikiMarkup) {
	# Build regex
	redir_regex <- REDIR_WIKIMARKUP %>%
		paste(collapse = "|") %>%
		paste0("^(", ., ") *\\[\\[.+\\]\\]")
	
	# Return result
	return(grepl(redir_regex, wikiMarkup, ignore.case = TRUE, perl = TRUE))
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
		
		# Query Wikipedia API for translations
		url <- paste0(API_URL_MEDIAWIKI_EN,"?action=query",
			      "&titles=",
			      articleName,
			      "&prop=langlinks",
			      "&format=json",
			      "&lllimit=500")
		
		data <- fromJSON(url)
		langlinks <- data$query$pages[[1]]$langlinks
		trans <- langlinks$`*`
		names(trans) <- langlinks$lang
		
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
