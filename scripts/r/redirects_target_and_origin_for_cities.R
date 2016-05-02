
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
    mutate(id = 1L, 
           target = get_redirect_target(wm),
           article = target,
           target = "",
           wm = getWikiMarkup(article, lang))
  
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
           target = article,
           article = as.character(origin),
           wm = getWikiMarkup(article, lang),
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
