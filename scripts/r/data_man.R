

# Constants
HDFS <- TRUE
if (HDFS) {
	DATA_DIR <- "hdfs:/projects/wikistats"
} else {
	DATA_DIR <- "./data"
}
WIKI_MARKUP_DIR <- paste(DATA_DIR, "wiki_cache/wikimarkup", sep="/")
REDIRECTS_DIR <- paste(DATA_DIR, "wiki_cache/redirects", sep="/")
HTML_DIR <- paste(DATA_DIR, "wiki_cache/html", sep="/")
DATA_DIR_STR <- c(DATA_DIR,
		  WIKI_MARKUP_DIR,
		  HTML_DIR)
DATA_LOG_FILE <- "applications_data/whs/data.log"

# Source dependencies
source("./scripts/r/wiki_tools.R")

# Load required packages
library(logging)
library(magrittr)
library(dplyr)
library(reshape2)
library(urltools)
if (HDFS) {
	library(rhdfs)
	hdfs.init()
}

# Set up data logger
writeToHdfs <- function (msg, handler, ...) {
	if (length(list(...)) && "dry" %in% names(list(...))) 
		return(exists("file", envir = handler))
	log_file <- with(handler, file)
	if (!HDFS) {
		cat(paste(msg, "\n", sep = ""), file = log_file, append = TRUE)
	} else {
		# Copy log file to local file system and add message
		temp_file <- tempfile()
		hdfs.get(log_file, temp_file)
		cat(paste(msg, "\n", sep = ""), file = temp_file, append = TRUE)
		
		# Workaround bug https://issues.apache.org/jira/browse/HADOOP-7199
		crc_file <- paste0(dirname(temp_file), "/.", basename(temp_file), ".crc")
		file.remove(crc_file)
		
		# Copy log file back to hdfs
		hdfs.put(temp_file, log_file)
	}
	
}
loginfo <- function(msg, logger = "") {
	user <- Sys.info()[["user"]]
	msg <- paste(user, msg, sep=":")
	logging::loginfo(msg, logger = logger)
}
logReset()
addHandler(writeToHdfs, logger="data.log", 
	   file=paste(DATA_DIR, DATA_LOG_FILE, sep="/"))

# This function returns TRUE if the file_path passed as paramter refers to a
# file stored in the HDFS.
is_in_hdfs <- function(file_path) {
	return(substring(file_path, 1, 5) == "hdfs:")
}

# This function returns the file_path passed as parameter without the 'hdfs:' at
# the beginning.
hdfs_path <- function(file_path) {
	return(sub("^hdfs:", "", file_path))
}

# This function works like base R function 'file.exists', but it also works on
# the HDFS if the global variable HDFS is set to TRUE.
# NOTE: This function is vectorised.
file_exists <- function(file) {
	# Identify hdfs files and local files
	hdfs_files <- is_in_hdfs(file)
	local_files <- !hdfs_files
	
	# Check hdfs files, if any
	if (any(hdfs_files)) {
		hdfs_file_names <- hdfs_path(file[hdfs_files])
		hdfs_res <- sapply(hdfs_file_names, rhdfs::hdfs.exists)
		names(hdfs_res) <- NULL
	} else hdfs_res <- FALSE
	
	# Check local files, if any
	if (any(local_files)) {
		local_file_names <- file[local_files]
		local_res <- base::file.exists(local_file_names)
	} else local_res <- FALSE
	
	# Return result
	res <- logical(length(file))
	res[hdfs_files] <- hdfs_res
	res[local_files] <- local_res
	return(res)
}

# This function works just like 'utils' function 'download.file', but it is
# vectorised. It uses only 'curl' as method. It handles dest files with path in
# the hdfs.
download_file <- function (url, destfile, quiet = FALSE, cacheOK = TRUE, 
			   extra = getOption("download.file.extra")) {
	
	# Validate parameters
	if (typeof(url) != "character") 
		stop("'url' must be a character vector")
	if (typeof(destfile) != "character") 
		stop("'destfile' must be a character vector")
	
	# Compose extras
	if (quiet) extra <- c(extra, "-s -S")
	if (!cacheOK) extra <- c(extra, "-H 'Pragma: no-cache'")
	extras <- paste(extra, collapse = " ")
	
	# Identify hdfs files
	hdfs_files <- is_in_hdfs(destfile)
	
	# Compose temporary names for hdfs dest files
	temp_dir <- tempdir()
	local_files <- path.expand(destfile)
	local_files[hdfs_files] %<>% 
		hdfs_path() %>%
		basename() %>%
		paste(temp_dir, ., sep = "/")
	
	# Compose system calls
	calls <- paste("curl", extras, shQuote(url), "-o", shQuote(local_files))
	
	# Make system calls and move temporary dest files to hdfs
	for (i in 1:length(local_files)) {
		status <- system(calls[i])
		if (status) {
			warning("download had nonzero exit status")
		} else {
			if (hdfs_files[i]) 
				rhdfs::hdfs.put(local_files[i], destfile[i])
		}
	}
	
	# Return status invisibly
	invisible(status)
}

# This function works like base R function 'dir.create', but it also works on
# the HDFS if the path to the folder starts with 'hdfs:'.
# NOTE: This function is vectorised.
dir_create <- function(paths) {
# 	rhdfs::hdfs.dircreate(hdfs_path(paths), 
# 			      ifelse(is_in_hdfs(paths), 
# 			             hdfs.defaults("fs"), 
# 			             hdfs.defaults("local")))
	
	fs <- rep(hdfs.defaults("local"), length(paths))
	fs[is_in_hdfs(paths)] <- hdfs.defaults("fs")
	rhdfs::hdfs.dircreate(hdfs_path(paths), fs)
}

# This function works almost like base R function 'list.files', but it also
# works on the HDFS if the global variable HDFS is set to TRUE.
list_files <- function(path= ".", pattern = NULL, full.names = FALSE, 
		       recursive=FALSE, ignore.case = FALSE) {
	if (is_in_hdfs(path)) {
		res <- rhdfs::hdfs.ls(hdfs_path(path), recursive)$file
		if (!full.names) 
			res <- basename(res)
		if (!is.null(pattern)) 
			res <- grep(pattern, res, ignore.case, value = TRUE)
		return(res)
	} else {
		base::list.files(path, pattern, FALSE, full.names, recursive, 
				 ignore.case)
	}
}

# This function works like base R function 'file.mtime', but it also works on
# the HDFS if the global variable HDFS is set to TRUE.
file_mtime <- function(path) {
	if (is_in_hdfs(path)) {
		as.POSIXct(rhdfs::hdfs.ls(hdfs_path(path))$modtime, 
			   format = "%Y-%m-%d %H:%M")
	} else {
		base::file.mtime(path)
	}
}

# This function works like base R function 'file.copy', but it also works on
# the HDFS if the global variable HDFS is set to TRUE.
file_copy <- function(from, to, overwrite=FALSE) {
	using_hdfs <- FALSE
	
	# Check if source file is in HDFS
	if (is_in_hdfs(from)) {
		from <- hdfs_path(from)
		srcFS <- hdfs.defaults("fs")
		using_hdfs <- TRUE
	} else {
		srcFS <- hdfs.defaults("local")
	}
	
	# Check if destination file is in HDFS
	if (is_in_hdfs(to)) {
		to <- hdfs_path(to)
		dstFS <- hdfs.defaults("fs")
		using_hdfs <- TRUE
	} else {
		dstFS <- hdfs.defaults("local")
	}
	
	# Copy file
	if (using_hdfs) {
		rhdfs::hdfs.copy(from, to, overwrite, srcFS, dstFS)	
	} else {
		base::file.copy(from, to, overwrite)
	}
}

# This function works similar to base R function 'readLines', but it also works
# on the HDFS if the global variable HDFS is set to TRUE.
read_lines <- function(path, collapse = FALSE) {
	# Initialise result variable
	res <- character(0)
	
	# Cycle through the files
	for (one_path in path) {
		if (is_in_hdfs(one_path)) {
			lines <- rhdfs::hdfs.read.text.file(hdfs_path(one_path))
		} else {
			lines <- base::readLines(one_path)
		}
		if (collapse) lines <- paste(lines, collapse = "\n")
		res <- c(res, lines)
	}
	
	# Return result
	return(res)
}

# This function works similar to base R function 'read.table', but it also works
# on the HDFS if the file name starts with 'hdfs:'.
# NOTE: This function is NOT vectorised
read_table <- function(file, ...) {
	if (is_in_hdfs(file)) {
		file_hdfs <- hdfs_path(file)
		file <- tempfile()
		rhdfs::hdfs.get(file_hdfs, file)
		data <- read.table(file, ...)
		file.remove(file)
	} else {
		data <- read.table(file, ...)
	}
	return(data)
}

# This function works similar to base R function 'read.csv', but it also works
# on the HDFS if the file name starts with 'hdfs:'.
# NOTE: This function is NOT vectorised
read_csv <- function(file, ...) {
	if (is_in_hdfs(file)) {
		file_hdfs <- hdfs_path(file)
		file <- tempfile()
		rhdfs::hdfs.get(file_hdfs, file)
		data <- read.csv(file, ...)
		file.remove(file)
	} else {
		data <- read.csv(file, ...)
	}
	return(data)
}

# This function works similar to base R function 'write.csv', but it also works
# on the HDFS if the file name starts with 'hdfs:'.
# NOTE: This function is NOT vectorised
write_csv <- function(x, file = "", ...) {
	if (is_in_hdfs(file)) {
		file_hdfs <- hdfs_path(file)
		file <- tempfile()
		write.csv(x, file, ...)
		status <- rhdfs::hdfs.put(file, file_hdfs)
		file.remove(file)
		
	} else {
		write.csv(x, file, ...)
	}
	
	# Return status invisibly
	invisible(status)
}

normalize <- function(art) {
	if (length(art) > 0) {
		norm <- url_decode(art)
		norm[norm != art] <- normalize(norm[norm != art])
		norm[norm == art] <- gsub("[ |'|/]", "_", norm[norm == art])
		return(norm)
	}
}

# This function reads the data file produced by the script 'filter_articles_langs.sh'.
# Optionally it appends it to an existing wikistats file. If 'append_file' does 
# not exist then it will just save the data frame on disk.
read_wikistats <- function(data_file = paste0("hdfs:/user/", Sys.info()[["user"]], "/many_lang_extraction/part-m-00000"), 
			   header_file = paste0("hdfs:/user/", Sys.info()[["user"]], "/many_lang_extraction/part-m-00001"), 
			   append_file = "") {
	# Compose header of the data frame
	header <- read_lines(header_file) %>%
		strsplit("[\t| ]") %>%
		unlist() %>%
		gsub(x = ., pattern = "'", replacement = "")
	header <- paste0("T", header)
	header[1:2] <- c("project", "article")
	
	# Read data
	data <- read_table(data_file, col.names = header, quote = "") %>%
		transform(article = normalize(as.character(article)),
			  lang = substr(project, 1, 2)) %>%
		select(-project) %>%
		melt(id.vars = c("lang", "article"), variable.name = "time") %>%
		group_by(lang, article, time) %>%
		summarise(value = sum(value))
	
	# Return result
	return(data)
}

# This function checks if the data folder exist, and if it does not then 
# creates it together with its subfolders structure.
check_data_folders <- function(data_folders) {
	# Vectorise function
	if (length(data_folders) > 1) {
		res <- sapply(data_folders, FUN=check_data_folders)
	} else {
		if (!file_exists(data_folders)) {
			dir_create(data_folders)
			loginfo(paste0("Data folder '", data_folders, "' created."), 
				logger="data.log")
		}
	}
}

list_archived_versions <- function(archive, file) {
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
	versions <- list_files(archive, pattern)
	
	# Extract dates from names of archived versions
	m <- regexec(pattern, versions)
	dates <- unlist(regmatches(versions, m))
	dates <- as.Date(dates, format = "%Y-%m-%d-%H-%M-%S")
	dates <- dates[!is.na(dates)]
	
	# Return dates of archived versions
	res <- paste(archive, versions, sep = "/")
	attr(res, "date") <- dates
	return(res)
}

# This function returns the name of the latest archived version of file at the
# date passed as parameter. If no date is passed then the currently latest
# version is returned.
get_from_archive <- function(archive, file, date) {
	# Check parameters
	if (missing(file)) stop ("file name is missing")
	if (missing(date)) date <- Sys.Date()
	
	# Make sure date is of class Date
	date <- as.Date(date)
	
	# Get list of archived versions
	versions <- list_archived_versions(archive, file)
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
copy_to_archive <- function(archive, file_name) {
	# Check if file exists
	if (!file_exists(file_name)) {
		msg <- paste0("file '", file_name, "' does not exist")
		logerror(paste0("Error when archiving: ", msg), logger = "data.log")
		stop(msg)
	}
	
	# Remove path
	base_name <- basename(file_name)
	
	# Remove extension
	library(tools)
	ext <- file_ext(base_name)
	sole_name <- file_path_sans_ext(base_name)
	
	# Get date of the file
	file_date <- strftime(file_mtime(file_name), format="%Y-%m-%d-%H-%M-%S")
	
	# Compose archive name
	arch_file_name <- paste0(archive, "/", 
				 sole_name, "_", file_date, ".", ext)
	
	# Check if archive file already exists
	if (file.exists(arch_file_name)) stop("file is already archived")
	
	# Copy file to archive
	file_copy(file_name, arch_file_name)
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

# This function creates text files with the titles of articles for each
# different language and also the config file to be passed to the bash script
# which will perform the extraction.
make_extract_config <- function(articles, languages, 
				out_dir = "./data/", 
				art_file_prefix = "articles_", 
				config_file = "multilang_extraction.cfg", 
				hdfs_temp_dir = paste0("/user/", Sys.info()[["user"]], "/temp/"), 
				hdfs_out_dir = paste0("/user/", Sys.info()[["user"]], "/many_lang_extraction/")) {
	
	# Encode names of articles
	articles <- gsub(" ", "_", articles)
	
	# Create initial lines of the config file
	lines <- c(paste0('outdir="', hdfs_out_dir, '"'),
		   paste0('tempdir="', hdfs_temp_dir, '"'))
	
	# Get list of unique languages
	unique_languages <- levels(languages)
	
	# For each unique language
	seq <- 1
	for (l in unique_languages) {
		
		# Select articles of language l
		language_articles <- articles[languages == l]

		# If there are any articles of language l
		if (length(language_articles) > 0) {
			
			# Write list of articles for language l in text file
			file_name <- paste0(out_dir, art_file_prefix, l, ".txt")
			writeLines(as.character(language_articles), file_name)
			
			# Add articles list file to conf
			line <- paste0('proj', seq, '="', l, '.z ', file_name,
				       ' /projects/wikistats/views_processed_2012-2013/articles_time-series_', 
				       l, ' /projects/wikistats/views_processed_2014-2015/articles_time-series_', 
				       l, '"')
			lines <- c(lines, line)
			seq <- seq + 1
		}
	}
	
	# Write config file
	file_name <- paste0(out_dir, config_file)
	writeLines(lines, file_name, sep = "\n")
	
	# Give instructions to user on how to use the extraction config file
	message(paste0("Config file and text files with lists of articles per ",
		     "language were saved in directory ", out_dir))
	message("In order to extract page views data for those articles run script")
	message("./scripts/bash/filter_articles_langs.sh -c <config_file> (-g <hour|day|week|month>)")
	message("For example:")
	message(paste0("./scripts/bash/filter_articles_langs.sh -c ", file_name, " -g month"))
	message(paste0("Extracted page views can then be found in the HDFS in directory ", hdfs_out_dir))
}
