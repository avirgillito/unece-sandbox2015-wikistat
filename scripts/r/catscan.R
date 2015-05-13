# CatScan code

# Constants
CATSCAN_URL <- "http://tools.wmflabs.org/catscan2/catscan2.php"

"language=en&project=wikipedia&depth=0&categories=World+Heritage+Sites+in+Algeria&negcats=&comb%5Bsubset%5D=1&atleast_count=0&ns%5B0%5D=1&show_redirects=both&templates_yes=&templates_any=&templates_no=&outlinks_yes=&outlinks_any=&outlinks_no=&edits%5Bbots%5D=both&edits%5Banons%5D=both&edits%5Bflagged%5D=both&before=&after=&max_age=&larger=&smaller=&minlinks=&maxlinks=&min_redlink_count=1&min_topcat_count=1&sortby=none&sortorder=ascending&format=csv&ext_image_data=1&file_usage_data=1&doit=Do+it%21&interface_language=en"

catScan <- function(categories, language="en", project="wikipedia", depth=0, 
                    namespaces="article") {
        # Validate parameters
        ns <- ""
        if ("article" %in% namespaces) ns <- paste0(ns, "&ns[0]=1")
        if ("category" %in% namespaces) ns <- paste0(ns, "&ns[14]=1")
        if (ns == "") print("Invalid namespaces specified. Possible namespaces: 'article', 'category'.")
        
        # Compose query url
        categories <- gsub(" ", "+", categories)
        query <- paste0(CATSCAN_URL, "?",
                        "language=", language,
                        "&project=", project,
                        "&depth=", depth,
                        "&categories=", categories,
                        ns,
                        "&format=csv&doit=1")
        
        # Download to temporary file
        temp_file <- tempfile("catscan_", fileext = ".csv")
        download.file(query, temp_file, quiet = TRUE)
        
        # Load temporary file
        data <- read.csv(temp_file, skip=1, encoding="UTF-8")
        
        # Delete temporary file
        file.remove(temp_file)
        
        # Return data
        data
}

catScan("World Heritage Sites in Asia", namespaces=c("article", "category"))
