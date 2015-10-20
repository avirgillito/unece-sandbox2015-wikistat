
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

list_archived_versions <- function(file) {
	# Check parameter
	if (missing(file)) stop ("file name is missing")
	
	# Remove path from file name
	file <- basename(file)
	
	# Split name from extension
	library(tools)
	ext <- file_ext(file)
	name <- file_path_sans_ext(file)
	
	# Compose search pattern
	pattern <- paste0(name, "_", "([^.]+)", ".", ext)
	
	# Get names of versions files
	versions <- list.files(ARCHIVE_DATA_FOLDER, pattern)
	
	# Extract dates from names of archived versions
	m <- regexec(pattern, versions)
	dates <- unlist(regmatches(versions, m))
	dates <- as.Date(dates, format = "%Y-%m-%d-%H-%M-%S")
	dates <- dates[!is.na(dates)]
	
	# Return dates of archived versions
	res <- versions
	attr(res, "date") <- dates
	return(res)
}

# This function returns the latest archived version of file at the date passed
# as parameter. If no date is passed then the currently latest version is
# returned.
get_from_archive <- function(file, date) {
	# Check parameters
	if (missing(file)) stop ("file name is missing")
	if (missing(date)) date <- Sys.Date()
	
	# Make sure date is of class Date
	date <- as.Date(date)
	
	# Get list of archived versions
	versions <- list_archived_versions(file)
	ver_dates <- attr(versions, "date")
	
	# Select latest version by date passed as parameter
	sel <- (ver_dates <= date)
	if (!any(sel)) {
		warning(paste0("no versions from ", date, 
			       " or before found in archive"))
		return()
	}
	latest_version <- max(ver_dates[ver_dates <= date])
	
	# Return name of archive file
	versions[ver_dates == latest_version]
}

# This function only copies to the archive if the file is different than the 
# most recent archived version.
copy_to_archive <- function(file_name) {
	# Check if file exists
	if (!file.exists(file_name)) 
		stop(paste0("file '", file_name, "' does not exist"))
	
	# Remove path
	base_name <- basename(file_name)
	
	# Remove extension
	library(tools)
	ext <- file_ext(base_name)
	sole_name <- file_path_sans_ext(base_name)
	
	# Get date of the file
	file_date <- strftime(file.mtime(file_name), format="%Y-%m-%d-%H-%M-%S")
	
	# Compose archive name
	arch_file_name <- paste0(ARCHIVE_DATA_FOLDER, "/", 
				 sole_name, "_", file_date, ".", ext)
	
	# Check if file is different to most recent archived version
	
	
	# Check if archive file already exists
	if (file.exists(arch_file_name)) stop("this is strange, there is already ")
	
	return(arch_file_name)
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

