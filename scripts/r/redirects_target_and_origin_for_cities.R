
# Load required libraries
library(dplyr)
library(reshape2)

# Load auxiliar functions
source("./scripts/r/whs_data_man.R")

# This function adds redirect targets to a list of articles.
# It uses the fields: wm, target, lang
add_redirect_targets <- function(articles) {
  # Check if there are redirect articles
  if (all(!is_redirect(articles$wm) | articles$target != "")) return (articles)
  
  # Get targets
  targets <- articles %>%
    filter(is_redirect(wm), target == "") %>%
    select(article, lang, wm) %>%
    mutate(id = 1L, 
           target = get_redirect_target(wm),
           article = as.character(target),
           target = "",
           wm = as.character(getWikiMarkup(article, lang)))
  
  # If targets are also redirects then recursively resolve redirects
  if (any(is_redirect(targets$wm))) {
    targets <- add_redirect_targets(targets)
  }
  
  # Add targets to the list of articles and eliminate duplicates
  res <- articles %>%
    union(targets) %>%
    distinct()
  
  # Return result
  return(res)
  
}

# This function returns the name of the article to which the wikiMarkup directs.
get_redirect_target <- function(wikiMarkup) {
  # Vectorised function
  if (length(wikiMarkup) > 1) {
    res <- sapply(wikiMarkup, FUN = get_redirect_target)
    names(res) <- NULL
  } else {
    # Make sure wikiMarket is not a list of 1 element
    wikiMarkup <- unlist(wikiMarkup)
    
    # Split text in lines
    wikiMarkup <- strsplit(wikiMarkup, "\\n")[[1]]
    
    # Get line with redirect text
    redir_regex <- REDIR_WIKIMARKUP %>%
      paste(collapse = "|") %>%
      paste0("^(", ., ") *\\[\\[.+\\]\\]")
    redirectLine <- grep(redir_regex, wikiMarkup, 
                         ignore.case = TRUE, perl = TRUE, 
                         value = TRUE)
    
    # gsub does not escape properly the square brakets, so replace them
    redirectLine <- gsub("\\[", "<", redirectLine)
    redirectLine <- gsub("\\]", ">", redirectLine)
    
    # Get article to which it redirects
    m <- gregexpr("<<[^>]+>>", redirectLine)
    article <- regmatches(redirectLine, m)
    article <- gsub("<<([^>]+)>>", "\\1", article)
    
    # Remove possible references to sections in the articles
    article <- remove_section_ref(article)
    
    # Return article name
    res <- article
  }
  
  # Return result
  return(res)
}

# This function adds redirect origins to a list of articles.
add_redirect_origins <- function(articles) {
  # Check if there are articles to be checked for redirect origins
  if (all(articles$origins_checked)) return (articles)
  
  # Flag articles as checked for redirect origins
  to_check <- !articles$origins_checked
  articles$origins_checked <- TRUE
  
  # Get redirect origins
  origins <- get_redirect_origins(articles[to_check, "article"], articles[to_check, "lang"]) %>%
    plyr::ldply(.fun = as.data.frame.attr, .id = "article")
  
  # Check if there are redirect origins
  if (all(is.na(origins$origin))) return (articles)
  
  # Process origins found
  origins <- origins%>%
    filter(!is.na(origin)) %>%
    left_join(articles, by = c("article", "lang")) %>%
    select(lang, article, origin) %>%
    mutate(id = 1L, 
           target = as.character(article),
           article = as.character(origin),
           wm = as.character(getWikiMarkup(article, lang)),
           origins_checked = FALSE) %>%
    select(-origin)
  
  # Add origins to the list of articles that are not already there
  res <- origins %>%
    anti_join(articles, by = c("lang", "article")) %>%
    union(articles)
  
  # If there are any new articles in the list then recursively get their origins
  if (any(!res$origins_checked)) {
    res <- add_redirect_origins(res)
  }
  
  # Return result
  return(res)
  
}

get_redirect_origins <- function(article, lang="en", refresh=FALSE) {
  # Get rid of mount fuji character
  if (any(article == "\U0001f5fb")) {
    article[article == "\U0001f5fb"] <- "Unicode Character MOUNT FUJI"
  }
  
  # Get rid of parenthesized latin capital letter character
  if (any(article == "\U0001f110" | article == "\U0001f111" | article == "\U0001f112" | article == "\U0001f113" | article == "\U0001f114" | article == "\U0001f115" | article == "\U0001f116" | article == "\U0001f117" | article == "\U0001f118" | article == "\U0001f119" | article == "\U0001f120" | article == "\U0001f121" | article == "\U0001f122" | article == "\U0001f123" | article == "\U0001f124" | article == "\U0001f125" | article == "\U0001f126" | article == "\U0001f127" | article == "\U0001f128" | article == "\U0001f129")) {
    article[article == "\U0001f110" | article == "\U0001f111" | article == "\U0001f112" | article == "\U0001f113" | article == "\U0001f114" | article == "\U0001f115" | article == "\U0001f116" | article == "\U0001f117" | article == "\U0001f118" | article == "\U0001f119" | article == "\U0001f120" | article == "\U0001f121" | article == "\U0001f122" | article == "\U0001f123" | article == "\U0001f124" | article == "\U0001f125" | article == "\U0001f126" | article == "\U0001f127" | article == "\U0001f128" | article == "\U0001f129"] <- "Unicode Character PARENTHESIZED LATIN CAPITAL LETTER"
  }
  
  # Get rid of squared latin capital letter character 
  if (any(article == "\U0001f130" | article == "\U0001f131" | article == "\U0001f132" | article == "\U0001f133" | article == "\U0001f134" | article == "\U0001f135" | article == "\U0001f136" | article == "\U0001f137" | article == "\U0001f138" | article == "\U0001f139" | article == "\U0001f140" | article == "\U0001f141" | article == "\U0001f142" | article == "\U0001f143" | article == "\U0001f144" | article == "\U0001f145" | article == "\U0001f146" | article == "\U0001f147" | article == "\U0001f148" | article == "\U0001f149")) {
    article[article == "\U0001f130" | article == "\U0001f131" | article == "\U0001f132" | article == "\U0001f133" | article == "\U0001f134" | article == "\U0001f135" | article == "\U0001f136" | article == "\U0001f137" | article == "\U0001f138" | article == "\U0001f139" | article == "\U0001f140" | article == "\U0001f141" | article == "\U0001f142" | article == "\U0001f143" | article == "\U0001f144" | article == "\U0001f145" | article == "\U0001f146" | article == "\U0001f147" | article == "\U0001f148" | article == "\U0001f149"] <- "Unicode Character SQUARED LATIN CAPITAL LETTER"
  }
  
  # Get rid of negative circled capital letter character 
  if (any(article == "\U0001f150" | article == "\U0001f151" | article == "\U0001f152" | article == "\U0001f153" | article == "\U0001f154" | article == "\U0001f155" | article == "\U0001f156" | article == "\U0001f157" | article == "\U0001f158" | article == "\U0001f159" | article == "\U0001f160" | article == "\U0001f161" | article == "\U0001f162" | article == "\U0001f163" | article == "\U0001f164" | article == "\U0001f165" | article == "\U0001f166" | article == "\U0001f167" | article == "\U0001f168" | article == "\U0001f169")) {
    article[article == "\U0001f150" | article == "\U0001f151" | article == "\U0001f152" | article == "\U0001f153" | article == "\U0001f154" | article == "\U0001f155" | article == "\U0001f156" | article == "\U0001f157" | article == "\U0001f158" | article == "\U0001f159" | article == "\U0001f160" | article == "\U0001f161" | article == "\U0001f162" | article == "\U0001f163" | article == "\U0001f164" | article == "\U0001f165" | article == "\U0001f166" | article == "\U0001f167" | article == "\U0001f168" | article == "\U0001f169"] <- "Unicode Character NEGATIVE CIRCLED LATIN CAPITAL LETTER"
  }
  
  # Get rid of train character 
  if (any(article == "\U0001f686")) {
    article[article == "\U0001f686"] <- "Unicode Character TRAIN"
  }
  
  # Get rid of metro character 
  if (any(article == "\U0001f687")) {
    article[article == "\U0001f687"] <- "Unicode Character METRO"
  }
  
  # Get rid of bus character 
  if (any(article == "\U0001f68c")) {
    article[article == "\U0001f68c"] <- "Unicode Character BUS"
  }
  
  # Create data folders if they don't exit
  check_data_folders(DATA_DIR_STR)
  
  # Make article and lang vectors of same length
  lang <- rep(lang, len = length(article))
  
  # Remove possible references to sections in the articles
  article <- remove_section_ref(article)
  
  # Replace spaces for underscores
  article_name <- gsub(" ", "_", article)
  
  # Compose file name of stored json file with API reply
  valid_article_name <- gsub("[:*?<>|/\"]", "_", article_name)
  file_name <- paste0(REDIRECTS_DIR, "/", lang, "_",  
                      valid_article_name, "_redir.json")
  
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
                         "&prop=redirects")
    }
    
    # Download json files with API replies
    download_file(url[to_download], file_name[to_download])
  }	
  
  # Read json files and extract wiki markup
  res <- vector("list", length = length(article))
  counter <- 0
  for (one_file in file_name) {
    text <- read_lines(one_file, collapse = TRUE)
    if (jsonlite::validate(text)) {
      json <- jsonlite::fromJSON(text)
      if ("missing" %in% names(json$query$pages[[1]])) {
        redirects <- "ERROR: redirect origins missing"
        warning(paste("redirect origins missing in "), one_file)
      } else {
        redirects <- json$query$pages[[1]]$redirects$title
      }
    } else {
      redirects <- "ERROR: not valid json text"
      warning(paste("json text not valid in "), one_file)
    }
    if (is.null(redirects)) {
      redirects <- NA
    }
    counter <- counter + 1
    attr(redirects, "lang") <- lang[counter]
    res[[counter]] <- redirects
  }
  names(res) <- article
  #attr(res, "lang") <- lang
  
  # Return wiki markup of articles
  return(res)
}

# This function converts a vector to data frame including its attributes as fields
as.data.frame.attr <- function(v) {
  return(data.frame(origin = as.character(v), lang = attr(v, "lang")))
}
