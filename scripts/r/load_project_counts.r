frequencies <- c("hour", "day", "month")
usage <- function(args.raw) {
    # extracts the script name from the script invocation parameters
    scriptparam <- args.raw[unlist(lapply(args.raw,function(x) {return (substr(x,1,7) == "--file=")}))]
    scriptname <- substring(scriptparam, 8)
    stop(paste0("\nUsage: Rscript ", scriptname, " -h <path_to_hourly_files_dir> -h <path_to_daily_files_dir> -m <path_to_month_files_dir>\
Files are expected to be named <lang>.txt or <lang>.m.txt with the second stran representing the mobile site.
"))
}

# extract the relevant parameters from the script's argument list
getargs <- function(args.raw, args) {
  flag_index_h <- match("-h", args.raw)
  flag_index_d <- match("-d", args.raw)
  flag_index_m <- match("-m", args.raw)
  
  return (c(hours=args.raw[flag_index_h + 1], days=args.raw[flag_index_d + 1], months=args.raw[flag_index_m + 1]))
}

read.proj.count.in.frame <- function (filename, freq, trim_first_and_last = FALSE) {
  if ( is.na(match(freq, frequencies))) {stop(Reduce(paste, frequencies, "Frequency must be one of "))}
  dfr = read.table(filename, header=FALSE)
  if (trim_first_and_last) { dfr <- head(dfr,-1); dfr <- tail(dfr,-1)}
  names(dfr) <- c(freq,"count")
  switch(freq,
    "hour" = {dfr$hour = as.POSIXct(dfr$hour, format="%Y-%m-%d:%H")},
    "day" = {dfr$day = as.POSIXct(dfr$day, format="%Y-%m-%d")},
    "month" = {dfr$month = as.POSIXct(sapply(dfr$month, function(x) {return (paste0(x,"-01"))}) , format="%Y-%m-%d")} 
  )
 return (dfr)
}

# Reads all files from a directory. Returns a list with first element the list of dataframes for the static wikis and a second element the list of mobile wikis.
read.all.proj.counts <- function (dirname, freq, trim_first_and_last = FALSE) {
  if ( is.na(match(freq, frequencies))) {stop(Reduce(paste, frequencies, "Frequency must be one of "))}
  static_wiki_frames <- c()
  static_wiki_names <- c() 
  mobile_wiki_frames <- c()
  mobile_wiki_names <- c() 
  
  files <- list.files(dirname)
  for (f in files) {
    split <- strsplit(f,"\\.")[[1]]
    fullpath <- paste0(dirname,"/",f)
    lang <- ""
    # mobile format is lang.m.txt static format is lang.txt
    switch (as.character(length(split)),
      "2" = {lang <- split[1]; 
               df <- read.proj.count.in.frame(fullpath, freq, trim_first_and_last);
               static_wiki_frames[[lang]] <- df;
               #static_wiki_frames <- c(static_wiki_frames, df);
               #static_wiki_names <- c(static_wiki_names, lang)
            },
      "3" = {lang <- split[1]; 
               df <- read.proj.count.in.frame(fullpath, freq, trim_first_and_last);
               mobile_wiki_frames[[lang]] <- df;
               #mobile_wiki_frames <- c(static_wiki_frames, df);
               #mobile_wiki_names <- c(static_wiki_names, lang)
            },
      {stop(paste0(f, " is an invalid file name. "))}
    ) 
  }
  #names(static_wiki_frames) <- static_wiki_names
  #names(mobile_wiki_frames) <- mobile_wiki_names
  res = list(static_wiki_frames, mobile_wiki_frames)
  return (res) 
}

# sums the series for all languages. Expects a list of dataframes - one per language.
combine.all.proj.counts <- function(df_list) {
  total_counts <- c(0)
  for (df in df_list) {  total_counts <- df$count + total_counts; }
  res <- data.frame(df_list[[1]][1], total_counts)
  names(res) <- names(df_list[[1]]) 
  return (res)
} 

# plots the static and mobile sites of a language
plot.static.vs.mobile <- function(df_static, df_mobile) {
  plot(df_static, ylim = c(0, max(df_static$count)*1.5))
  lines(df_static)
  lines(df_mobile)
}


main <- function(args.raw, args) {
  dirs <- getargs(args.raw, args)
  d_hours <- dirs["hours"]
  d_days <- dirs["days"]
  d_months <- dirs["months"]
  
  if((is.na(d_hours) & is.na(d_days) & is.na(d_months))) usage(args.raw)

}
if (! interactive()) {
  args <- commandArgs(trailingOnly = TRUE)
  args.raw <- commandArgs(trailingOnly = FALSE)
  main(args.raw, args)
} 

# d<-as.POSIXct("2017-01-01:23:00:00", format="%Y-%m-%d:%H")

