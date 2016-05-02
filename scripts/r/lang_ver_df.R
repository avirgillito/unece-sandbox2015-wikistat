# This scripts reads the list of articles selected in the English Wikipedia,
# gets all the language versions of those articles and saves it as a data frame.

# Load required libraries
library(dplyr)
library(reshape2)

# Load auxiliar functions
source("./scripts/r/whs_data_man.R")
hdfs.init()

getLangVersion_df <- function(articles_df, lang_orig = "en") {
  # Get all other language versions of articles
  langVer <- getLangVersion(articles_df$article, lang_orig)
  
  ## Convert list to data frame
  for (i in 1:nrow(articles_df)) {
    id <- articles_df$id[i]
    
    # Add row for English article
    article_title <- as.character(articles_df$article[i])
    
    # If data frame doesn't exist then create it
    if (!exists("out_articles_df")) {
      out_articles_df <- data.frame(id = id, lang = lang_orig, 
                                 article = article_title)
      row.names(out_articles_df) <- NULL
      out_articles_df$id <- as.factor(out_articles_df$id)
      out_articles_df$lang <- as.factor(out_articles_df$lang)
      out_articles_df$article <- as.character(out_articles_df$article)
    } else {
      t <- data.frame(id = as.factor(id), lang = lang_orig, 
                      article = article_title)
      t$id <- as.factor(t$id)
      row.names(t) <- NULL
      out_articles_df <- rbind(out_articles_df, t)
    }
    
    # Add rows for languages other than English
    langList <- langVer[[i]]
    if (!is.null(langList)) {
      t <- cbind(id, lang = names(langList), article = langList)
      row.names(t) <- NULL
      out_articles_df <- rbind(out_articles_df, t)
    }
  }
  
  # Remove references to sections in names of articles
  out_articles_df$article <- remove_section_ref(out_articles_df$article)
  
  return(out_articles_df)
}

