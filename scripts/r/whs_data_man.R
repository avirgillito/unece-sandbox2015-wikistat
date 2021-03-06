
# Source dependencies
source("./scripts/r/data_man.R")
source("./scripts/r/wiki_tools.R")

# Constants
WHS_UNESCO_URL <- "http://whc.unesco.org/en/list/xml/"
WHS_RAW_FILE <- "whc-sites.xml"
WHS_FILE <- "whs.csv"
if (HDFS) {
	WHS_DIR <- paste(DATA_DIR, "applications_data/whs", sep="/")
} else {
	WHS_DIR <- DATA_DIR
}
ARCHIVE_DATA_DIR <- paste(WHS_DIR, "archive", sep="/")

DATA_DIR_STR <- append(DATA_DIR_STR, ARCHIVE_DATA_DIR)

# This function downloads the raw XML file with the official list of world 
# heritage sites published by UNESCO and produces a clean CSV data file. If the 
# clean file does not exist then it will create it even if no new file was 
# downloaded. If 'overwrite' parameter is TRUE then it overwrites the raw XML 
# file in case it exists in the data folder. Otherwise, it does not download the 
# file. If 'archive' parameter is TRUE then it will backup the existing raw XML 
# file before a new one is, in case the files are different.
update_whs <- function() {
	loginfo("Checking for updates to WHS file in UNESCO website...", 
		logger="data.log")
	
	# Check if data folders exist and create them in case they don't
	check_data_folders(DATA_DIR_STR)
	
	# Download XML file from UNESCO website
	temp_xml_file <- paste(tempdir(), WHS_RAW_FILE, sep = "/")
	download.file(WHS_UNESCO_URL, temp_xml_file, mode = "wb")
	new_whs <- read_whs_xml(temp_xml_file)
	
	# Check if new file is different than latest one in archive
	updates <- TRUE
	archived_file_name <- get_from_archive(ARCHIVE_DATA_DIR, WHS_RAW_FILE)
	if (length(archived_file_name) != 0) {
		xml <- read_lines(archived_file_name)
		arch_whs <- read_whs_xml(xml)
		if (identical(new_whs, arch_whs)) {
			loginfo("no updates found.", logger="data.log")
			updates <- FALSE
		}
	}
	
	# Archive new XML file downloaded
	if (updates) {
		copy_to_archive(ARCHIVE_DATA_DIR, temp_xml_file)
		loginfo("updates found and archived.", logger="data.log")
	}
	
	# Save data as CSV
	csv_file_name <- paste(DATA_DIR, WHS_FILE, sep="/")
	if (updates || !file.exists(csv_file_name)) {
		write.csv(new_whs, file=csv_file_name, row.names=FALSE, 
			  fileEncoding="UTF-8")
		loginfo("WHS data saved as CSV.", logger="data.log")
	}
}

# This function reads the UNESCO xml file of WHS and converts it to a data frame
read_whs_xml <- function(xml) {
	# Convert raw file to data frame
	whs <- xmlToDataFrame(xml)
	
	# Remove html tags
	whs$historical_description <- getPlainText(whs$historical_description)
	whs$justification <- getPlainText(whs$justification)
	whs$long_description <- getPlainText(whs$long_description)
	whs$short_description <- getPlainText(whs$short_description)
	
	return(whs)
}

get_whs <- function(version_date) {
	# If version date passed as parameter then get data from archive
	if (!missing(version_date)) {
		xml_file_name <- get_from_archive(ARCHIVE_DATA_DIR, WHS_RAW_FILE, version_date)
		if (length(xml_file_name) != 0) {
			xml_file_name <- paste(ARCHIVE_DATA_DIR, xml_file_name, sep="/")
			return(read_whs_xml(xml_file_name))
		}
	}
	
	# Compose CSV file name
	csv_file_name <- paste(DATA_DIR, WHS_FILE, sep="/")
	
	# If CSV file doesn't exist then update WHS data
	if (!file.exists(csv_file_name)) {
		update_whs()
	}
	
	# Return data in CSV file 
	whs <- read.csv(csv_file_name, fileEncoding="UTF-8")
	whs$id_number <- as.numeric(as.character(whs$id_number)) 
	return(whs)
}

# This function extracts European WHS sites based on region and latitude and longitude
# then it saves the result as a new csv in the specified path. 
filter_european_sites <- function (whs_csv_full, target_path) {
  whs_full <- read_csv(whs_csv_full)
  europe_na <- whs_full[whs_full$region=="Europe and North America",]
  europe <- europe_na[europe_na$longitude>-49.6,]
  europe <- europe[europe$latitude > 0,]
  write_csv(europe, target_path)  
}

# This function extracts wiki articles pertaining to European sites.
filter_european_articles <- function(all_articles_path, whs_europe_path, target_path) {
  articles <- read_csv(all_articles_path)
  europe <- read_csv(whs_europe_path)
  euro_articles <- articles[articles$whs_id %in% europe$id_number,]
  write_csv(euro_articles, target_path) 
}
