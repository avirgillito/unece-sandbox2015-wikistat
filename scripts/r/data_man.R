
# Constants
DATA_FOLDER <- "./data"
RAW_DATA_FOLDER <- paste(DATA_FOLDER, "raw", sep="/")
WIKI_MARKUP_FOLDER <- paste(DATA_FOLDER, "wikimarkup", sep="/")
HTML_FOLDER <- paste(DATA_FOLDER, "html", sep="/")
ARCHIVE_DATA_FOLDER <- paste(DATA_FOLDER, "archive", sep="/")
DATA_LOG_FILE <- "data.log"

# Load required packages
library(logging)

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
	if (!file.exists(ARCHIVE_DATA_FOLDER)) {
		dir.create(ARCHIVE_DATA_FOLDER)
		loginfo(paste0("Data archive folder '", ARCHIVE_DATA_FOLDER, "' created."), 
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

