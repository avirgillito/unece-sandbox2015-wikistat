# CatScan code

# Constants
CATSCAN_URL <- "http://tools.wmflabs.org/catscan2/catscan2.php"

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
        query <- paste0(CATSCAN_URL, "?",
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
