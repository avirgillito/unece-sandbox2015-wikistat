
# Source dependencies
source("./scripts/r/data_man.R")
source("./scripts/r/wiki_tools.R")

# Constants
WHS_UNESCO_URL <- "http://whc.unesco.org/en/list/xml/"
WHS_RAW_FILE <- "whc-sites.xml"
WHS_FILE <- "whs.csv"

# This function downloads the raw XML file with the official list of world 
# heritage sites published by UNESCO and produces a clean CSV data file. If the 
# clean file does not exist then it will create it even if no new file was 
# downloaded. If 'overwrite' parameter is TRUE then it overwrites the raw XML 
# file in case it exists in the data folder. Otherwise, it does not download the 
# file. If 'archive' parameter is TRUE then it will backup the existing raw XML 
# file before a new one is, in case the files are different.
check_whs_updates <- function(overwrite = FALSE, archive = TRUE) {
	whsRawFileName <- paste(RAW_DATA_FOLDER, WHS_RAW_FILE, sep="/")
	whsFileName <- paste(DATA_FOLDER, WHS_FILE, sep="/")
	
	# Check if data folders exist and create them in case they don't
	CheckDataFolderExists()
	
	# If raw file does not exist or is to be overwritten then download it
	rawFileExists <- file.exists(whsRawFileName)
	if (!rawFileExists || overwrite) {
		# If to be overwritten file is to be archived then do it
		if (rawFileExists && archive) {
			
		}
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

get_whs <- function(version_date) {
	# If file doesn't exist then download it
	whsFileName <- paste(DATA_FOLDER, WHS_FILE, sep="/")
	if (!file.exists(whsFileName)) check_whs_updates()
	
	# If no version date passed as parameter then return latest one
	if (!missing(version_date)) {
		whs <- read.csv(whsFileName, fileEncoding="UTF-8")
		whs$id_number <- as.numeric(as.character(whs$id_number))
		return(whs)
	}
	
	# Otherwise return the latest version at the version date
	
	# If all archived files more recent than version date then raise warning
	
	# Return whs list 
}
