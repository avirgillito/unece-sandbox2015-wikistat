### Functions to use:

## get_wikidata:   returns a list with all the data that are available in the wikidata_url
##                (function similar to the one that gets the wikimarkup)

## add_wikidata_sitelinks   adds to the df with items and coordinates the articles and languages that are 
##                          are available in the wikidata item files(that it gets through get_wikidata)
##                          NOTE: it is based on languages with TWO CHARACTERS and WIKIPEDIA only articles,
##                          possible generalization to the whole wikidata universe.

## wikidata_sitelinks_df  gets the wikidata items and create a df with artices, language and items 

## NOTE: all functions work from the df 'items' that has item, lat and long

library(dplyr)
library(jsonlite)
source("./scripts/r/data_man.R")

# Set the url to get the single item files

wikidata_url <- 'https://www.wikidata.org/wiki/Special:EntityData/'
  
# This function gets the items of Wikidata, saves them in a folder and extract from them 'wikidata content' in
# the form of a list
get_wikidata <- function(items, refresh = F) {
  items_list <- items$item
  for (i in 1:length(items_list)) {
    file_name <- paste0('/ichec/home/users/signose/wikistats/wikidata_items/item_', items_list[i], '.txt')
    # Find out which files need to be downloaded
    to_download <- !file_exists(file_name) | refresh
    print(paste0("Files to download:", sum(to_download)))
    # Download files not in the cache
    if (any(to_download)) {
      url <- paste0(wikidata_url, items_list[i], '.json')
      download.file(url[to_download], file_name[to_download])
    }
  }  
    # Read json files and extract wikidata
    res <- vector("list", length = length(items_list))
    counter <- 0
    file_list <- paste0("/ichec/home/users/signose/wikistats/wikidata_items/item_", items_list, ".txt")
    for (one_file in file_list) {
      text <- readLines(one_file)
      if (jsonlite::validate(text)) {
        json <- jsonlite::fromJSON(text)
        wikidata <- json$entities[[1]]
        trans <- wikidata$`*`
        names(trans) <- wikidata$lang
        if (is.null(wikidata)) {
          wikidata <- "ERROR: wikidata is null"
          warning(paste("null wikidata in "), substr(one_file, 57, regexpr(".", one_file)-1))
        }
      }
      counter <- counter + 1
      res[[counter]] <- wikidata
    }
    # Return wiki markup of articles
    return(res)
}

# This function adds the articles and languages found in wikidata files to the original items df.
# It is set to work considering TWO CHARACTERS languages and WIKIPEDIA only articles. 
add_wikidata_sitelinks <- function(items) {
  # get wikidata
  wikidata <- get_wikidata(items)
  # transform wikidata list
  wikidata <- do.call(cbind, wikidata)
  # transpose wikidata list
  wikidata <- t(wikidata)
  # create dataframe and filter considering only wikipedia items
  wikidata <- as.data.frame(wikidata)%>%
    select(-pageid, -ns, -title, -lastrevid, -modified, -type, -labels, -descriptions, -aliases, -claims) %>%
    filter(grepl("wikipedia", sitelinks))
  # split column sitelinks
  wikidata <- splitstackshape::concat.split.multiple(wikidata, "sitelinks", seps=",", "long") 
  # consider only rows with title and url 
  wikidata <- wikidata %>%
    filter(grepl("title =", sitelinks) | grepl("url =", sitelinks)) %>%
    tidyr::separate(sitelinks, sep = "=", c('delete', 'keep')) 
  # prepare datasets with articles and urls
  title <- wikidata %>%
    filter(delete == "title ") %>%
    mutate(article = gsub("[[:punct:]]", "", keep)) %>%
    select(-delete, -keep)
  url <- wikidata %>%
    filter(delete == "url ") %>%
    filter(nchar(substr(keep, 11, regexpr("wiki", keep)-2)) == 2) %>%
    mutate(lang = substr(keep, 11, 12)) %>%
    select(-delete, -keep)
  # unify datasets
  wikidata <- cbind(title,url) %>%
    mutate(id = as.character(id)) %>%
    select(-id) %>%
    mutate(item = id) %>%
    select(-id)
  wikidata <- as.data.frame(wikidata)
  # join datasets
  wikidata <- wikidata %>%
    left_join(items, by = 'item')
  #return output
  return(wikidata)
}

# This function gets the wikidata items and creates a separate df with articles, languages and items

wikidata_sitelinks_df <- function(items) {
  # get wikidata
  wikidata <- get_wikidata(items)
  # transform wikidata list
  wikidata <- do.call(cbind, wikidata)
  # transpose wikidata list
  wikidata <- t(wikidata)
  # create dataframe and filter considering only wikipedia items
  wikidata <- as.data.frame(wikidata)%>%
    select(-pageid, -ns, -title, -lastrevid, -modified, -type, -labels, -descriptions, -aliases, -claims) %>%
    filter(grepl("wikipedia", sitelinks))
  # split column sitelinks
  wikidata <- splitstackshape::concat.split.multiple(wikidata, "sitelinks", seps=",", "long") 
  # consider only rows with title and url 
  wikidata <- wikidata %>%
    filter(grepl("title =", sitelinks) | grepl("url =", sitelinks)) %>%
    tidyr::separate(sitelinks, sep = "=", c('delete', 'keep')) 
  # prepare datasets with articles and urls
  title <- wikidata %>%
    filter(delete == "title ") %>%
    mutate(article = gsub("[[:punct:]]", "", keep)) %>%
    select(-delete, -keep)
  url <- wikidata %>%
    filter(delete == "url ") %>%
    filter(nchar(substr(keep, 11, regexpr("wiki", keep)-2)) == 2) %>%
    mutate(lang = substr(keep, 11, 12)) %>%
    select(-delete, -keep)
  # unify datasets
  wikidata <- cbind(title,url) %>%
    mutate(id = as.character(id)) %>%
    select(-id) %>%
    mutate(item = id) %>%
    select(-id)
  wikidata <- as.data.frame(wikidata)
  #return output
  return(wikidata)
}
