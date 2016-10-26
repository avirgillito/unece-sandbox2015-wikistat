# GET TOURISM DATA FROM BARCELONA WEBSITE

# 1. install package rvest and call it
# 2. put in an object 'url' the url of the page where you have the data you want to download
# 3. go to that page, right click and then on 'inspect element'. Go until you find the part that concern the table, 
#    right click on it and then 'Copy' and 'Copy XPath'
# 4. return on RStudio and build an object of this kind (in the xpath you'll have to put the copyXPath that you got at point 3:
#     df <- url %>%
#           read_html() %>%
#           html_nodes(xpath = '__________') %>%
#           html_table()
# 5. check your object: it will be a list, so it will be sufficient to do:
#     df <- df[[1]]
#    to have a dataframe.
# 6. now you'll just have to work a little bit with rows and columns.

library(rvest)
library(dplyr)

### BARCELONA

# 2016

# January

url <- "http://www.bcn.cat/estadistica/angles/dades/economia/teoh/actual/r01.htm"

Barcelona_tourism_2016 <- url %>%
  read_html() %>%
  html_nodes(xpath = '/html/body/table') %>%
  html_table()

Barcelona_Jan_16 <- Barcelona_tourism_2016[[1]] %>%
  select(X4, X5) %>%
  mutate(Jan_2016 = X5) %>%
  select(-X5) 

Barcelona_Jan_16 <- Barcelona_Jan_16[8:73, ]

# February

url <- "http://www.bcn.cat/estadistica/angles/dades/economia/teoh/actual/r02.htm"

Barcelona_tourism_2016 <- url %>%
  read_html() %>%
  html_nodes(xpath = '/html/body/table') %>%
  html_table()

Barcelona_Feb_16 <- Barcelona_tourism_2016[[1]] %>%
  select(X4, X5) %>%
  mutate(Feb_2016 = X5) %>%
  select(-X5) 

Barcelona_Feb_16 <- Barcelona_Feb_16[8:73, ]

# March

url <- "http://www.bcn.cat/estadistica/angles/dades/economia/teoh/actual/r03.htm"

Barcelona_tourism_2016 <- url %>%
  read_html() %>%
  html_nodes(xpath = '/html/body/table') %>%
  html_table()

Barcelona_Mar_16 <- Barcelona_tourism_2016[[1]] %>%
  select(X4, X5) %>%
  mutate(Mar_2016 = X5) %>%
  select(-X5) 

Barcelona_Mar_16 <- Barcelona_Mar_16[8:73, ]

# April

url <- "http://www.bcn.cat/estadistica/angles/dades/economia/teoh/actual/r04.htm"

Barcelona_tourism_2016 <- url %>%
  read_html() %>%
  html_nodes(xpath = '/html/body/table') %>%
  html_table()

Barcelona_Apr_16 <- Barcelona_tourism_2016[[1]] %>%
  select(X4, X5) %>%
  mutate(Apr_2016 = X5) %>%
  select(-X5) 

Barcelona_Apr_16 <- Barcelona_Apr_16[8:73, ]

# May

url <- "http://www.bcn.cat/estadistica/angles/dades/economia/teoh/actual/r05.htm"

Barcelona_tourism_2016 <- url %>%
  read_html() %>%
  html_nodes(xpath = '/html/body/table') %>%
  html_table()

Barcelona_May_16 <- Barcelona_tourism_2016[[1]] %>%
  select(X4, X5) %>%
  mutate(May_2016 = X5) %>%
  select(-X5) 

Barcelona_May_16 <- Barcelona_May_16[8:73, ]

# June

url <- "http://www.bcn.cat/estadistica/angles/dades/economia/teoh/actual/r06.htm"

Barcelona_tourism_2016 <- url %>%
  read_html() %>%
  html_nodes(xpath = '/html/body/table') %>%
  html_table()

Barcelona_June_16 <- Barcelona_tourism_2016[[1]] %>%
  select(X4, X5) %>%
  mutate(June_2016 = X5) %>%
  select(-X5) 

Barcelona_June_16 <- Barcelona_June_16[8:73, ]

# July

url <- "http://www.bcn.cat/estadistica/angles/dades/economia/teoh/actual/r06.htm"

Barcelona_tourism_2016 <- url %>%
  read_html() %>%
  html_nodes(xpath = '/html/body/table') %>%
  html_table()

Barcelona_July_16 <- Barcelona_tourism_2016[[1]] %>%
  select(X4, X5) %>%
  mutate(July_2016 = X5) %>%
  select(-X5) 

Barcelona_July_16 <- Barcelona_July_16[8:73, ]

Barcelona_2016 <- cbind(Barcelona_Jan_16, Barcelona_Feb_16$Feb_2016, Barcelona_Mar_16$Mar_2016, Barcelona_Apr_16$Apr_2016, 
                        Barcelona_May_16$May_2016, Barcelona_June_16$June_2016, Barcelona_July_16$July_2016)

names(Barcelona_2016) <- c("variables", "Jan_2016", "Feb_2016", "Mar_2016", "Apr_2016", "May_2016", "Jun_2016", "Jul_2016")

write.csv(Barcelona_2016, "./tourism_data/Barcelona/Barcelona_2016.csv")

# 2015

url <- "http://www.bcn.cat/estadistica/angles/dades/economia/teoh/actual/r2015.htm"

Barcelona_tourism_2015 <- url %>%
  read_html() %>%
  html_nodes(xpath = '/html/body/table') %>%
  html_table()

Barcelona_Jan_15 <- Barcelona_tourism_2015[[1]] %>%
  select(X4, X5) %>%
  mutate(Jan_2015 = X5) %>%
  select(-X5) 

Barcelona_Jan_15 <- Barcelona_Jan_15[8:73, ]

Barcelona_Feb_15 <- Barcelona_tourism_2015[[2]] %>%
  select(X4, X5) %>%
  mutate(Feb_2015 = X5) %>%
  select(-X5) 

Barcelona_Feb_15 <- Barcelona_Feb_15[6:71, ]

Barcelona_Mar_15 <- Barcelona_tourism_2015[[3]] %>%
  select(X4, X5) %>%
  mutate(Mar_2015 = X5) %>%
  select(-X5) 

Barcelona_Mar_15 <- Barcelona_Mar_15[6:71, ]

Barcelona_Apr_15 <- Barcelona_tourism_2015[[4]] %>%
  select(X4, X5) %>%
  mutate(Apr_2015 = X5) %>%
  select(-X5) 

Barcelona_Apr_15 <- Barcelona_Apr_15[6:71, ]

Barcelona_May_15 <- Barcelona_tourism_2015[[5]] %>%
  select(X4, X5) %>%
  mutate(May_2015 = X5) %>%
  select(-X5) 

Barcelona_May_15 <- Barcelona_May_15[6:71, ]

Barcelona_Jun_15 <- Barcelona_tourism_2015[[6]] %>%
  select(X4, X5) %>%
  mutate(Jun_2015 = X5) %>%
  select(-X5) 

Barcelona_Jun_15 <- Barcelona_Jun_15[6:71, ]

Barcelona_Jul_15 <- Barcelona_tourism_2015[[7]] %>%
  select(X4, X5) %>%
  mutate(Jul_2015 = X5) %>%
  select(-X5) 

Barcelona_Jul_15 <- Barcelona_Jul_15[6:71, ]

Barcelona_Aug_15 <- Barcelona_tourism_2015[[8]] %>%
  select(X4, X5) %>%
  mutate(Aug_2015 = X5) %>%
  select(-X5) 

Barcelona_Aug_15 <- Barcelona_Aug_15[6:71, ]

Barcelona_Sep_15 <- Barcelona_tourism_2015[[9]] %>%
  select(X4, X5) %>%
  mutate(Sep_2015 = X5) %>%
  select(-X5) 

Barcelona_Sep_15 <- Barcelona_Sep_15[6:71, ]

Barcelona_Oct_15 <- Barcelona_tourism_2015[[10]] %>%
  select(X4, X5) %>%
  mutate(Oct_2015 = X5) %>%
  select(-X5) 

Barcelona_Oct_15 <- Barcelona_Oct_15[6:71, ]

Barcelona_Nov_15 <- Barcelona_tourism_2015[[11]] %>%
  select(X4, X5) %>%
  mutate(Nov_2015 = X5) %>%
  select(-X5) 

Barcelona_Nov_15 <- Barcelona_Nov_15[6:71, ]

Barcelona_Dec_15 <- Barcelona_tourism_2015[[12]] %>%
  select(X4, X5) %>%
  mutate(Dec_2015 = X5) %>%
  select(-X5) 

Barcelona_Dec_15 <- Barcelona_Dec_15[6:71, ]

Barcelona_2015 <- cbind(Barcelona_Jan_15, Barcelona_Feb_15$Feb_2015, Barcelona_Mar_15$Mar_2015, Barcelona_Apr_15$Apr_2015, 
                        Barcelona_May_15$May_2015, Barcelona_Jun_15$Jun_2015, Barcelona_Jul_15$Jul_2015, Barcelona_Aug_15$Aug_2015, 
                        Barcelona_Sep_15$Sep_2015, Barcelona_Oct_15$Oct_2015, Barcelona_Nov_15$Nov_2015, Barcelona_Dec_15$Dec_2015)

names(Barcelona_2015) <- c("variables", "Jan_2015", "Feb_2015", "Mar_2015", "Apr_2015", "May_2015", "Jun_2015",
                           "Jul_2015", "Aug_2015", "Sep_2015", "Oct_2015", "Nov_2015", "Dec_2015")

write.csv(Barcelona_2015, "./tourism_data/Barcelona/Barcelona_2015.csv")

# 2014

url <- "http://www.bcn.cat/estadistica/angles/dades/economia/teoh/actual/r2014.htm"

Barcelona_tourism_2014 <- url %>%
  read_html() %>%
  html_nodes(xpath = '/html/body/table') %>%
  html_table()

Barcelona_Jan_14 <- Barcelona_tourism_2014[[1]] %>%
  select(X4, X5) %>%
  mutate(Jan_2014 = X5) %>%
  select(-X5) 

Barcelona_Jan_14 <- Barcelona_Jan_14[8:73, ]

Barcelona_Feb_14 <- Barcelona_tourism_2014[[1]] %>%
  select(X4, X5) %>%
  mutate(Feb_2014 = X5) %>%
  select(-X5) 

Barcelona_Feb_14 <- Barcelona_Feb_14[81:146, ]

Barcelona_Mar_14 <- Barcelona_tourism_2014[[1]] %>%
  select(X4, X5) %>%
  mutate(Mar_2014 = X5) %>%
  select(-X5) 

Barcelona_Mar_14 <- Barcelona_Mar_14[154:219, ]

Barcelona_Apr_14 <- Barcelona_tourism_2014[[1]] %>%
  select(X4, X5) %>%
  mutate(Apr_2014 = X5) %>%
  select(-X5) 

Barcelona_Apr_14 <- Barcelona_Apr_14[227:292, ]

Barcelona_May_14 <- Barcelona_tourism_2014[[1]] %>%
  select(X4, X5) %>%
  mutate(May_2014 = X5) %>%
  select(-X5) 

Barcelona_May_14 <- Barcelona_May_14[300:365, ]

Barcelona_Jun_14 <- Barcelona_tourism_2014[[1]] %>%
  select(X4, X5) %>%
  mutate(Jun_2014 = X5) %>%
  select(-X5) 

Barcelona_Jun_14 <- Barcelona_Jun_14[373:438, ]

Barcelona_Jul_14 <- Barcelona_tourism_2014[[1]] %>%
  select(X4, X5) %>%
  mutate(Jul_2014 = X5) %>%
  select(-X5) 

Barcelona_Jul_14 <- Barcelona_Jul_14[446:511, ]

Barcelona_Aug_14 <- Barcelona_tourism_2014[[1]] %>%
  select(X4, X5) %>%
  mutate(Aug_2014 = X5) %>%
  select(-X5) 

Barcelona_Aug_14 <- Barcelona_Aug_14[519:584, ]

Barcelona_Sep_14 <- Barcelona_tourism_2014[[1]] %>%
  select(X4, X5) %>%
  mutate(Sep_2014 = X5) %>%
  select(-X5) 

Barcelona_Sep_14 <- Barcelona_Sep_14[592:657, ]

Barcelona_Oct_14 <- Barcelona_tourism_2014[[1]] %>%
  select(X4, X5) %>%
  mutate(Oct_2014 = X5) %>%
  select(-X5) 

Barcelona_Oct_14 <- Barcelona_Oct_14[665:730, ]

Barcelona_Nov_14 <- Barcelona_tourism_2014[[1]] %>%
  select(X4, X5) %>%
  mutate(Nov_2014 = X5) %>%
  select(-X5) 

Barcelona_Nov_14 <- Barcelona_Nov_14[738:803, ]

Barcelona_Dec_14 <- Barcelona_tourism_2014[[1]] %>%
  select(X4, X5) %>%
  mutate(Dec_2014 = X5) %>%
  select(-X5) 

Barcelona_Dec_14 <- Barcelona_Dec_14[811:876, ]

Barcelona_2014 <- cbind(Barcelona_Jan_14, Barcelona_Feb_14$Feb_2014, Barcelona_Mar_14$Mar_2014, Barcelona_Apr_14$Apr_2014, 
                        Barcelona_May_14$May_2014, Barcelona_Jun_14$Jun_2014, Barcelona_Jul_14$Jul_2014, Barcelona_Aug_14$Aug_2014, 
                        Barcelona_Sep_14$Sep_2014, Barcelona_Oct_14$Oct_2014, Barcelona_Nov_14$Nov_2014, Barcelona_Dec_14$Dec_2014)

names(Barcelona_2014) <- c("variables", "Jan_2014", "Feb_2014", "Mar_2014", "Apr_2014", "May_2014", "Jun_2014",
                           "Jul_2014", "Aug_2014", "Sep_2014", "Oct_2014", "Nov_2014", "Dec_2014")

write.csv(Barcelona_2014, "./tourism_data/Barcelona/Barcelona_2014.csv")

# 2013

url <- "http://www.bcn.cat/estadistica/angles/dades/economia/teoh/actual/r2013.htm"

Barcelona_tourism_2013 <- url %>%
  read_html() %>%
  html_nodes(xpath = '/html/body/table') %>%
  html_table()

Barcelona_Jan_13 <- Barcelona_tourism_2013[[1]] %>%
  select(X4, X5) %>%
  mutate(Jan_2013 = X5) %>%
  select(-X5) 

Barcelona_Jan_13 <- Barcelona_Jan_13[8:73, ]

Barcelona_Feb_13 <- Barcelona_tourism_2013[[1]] %>%
  select(X4, X5) %>%
  mutate(Feb_2013 = X5) %>%
  select(-X5) 

Barcelona_Feb_13 <- Barcelona_Feb_13[81:146, ]

Barcelona_Mar_13 <- Barcelona_tourism_2013[[1]] %>%
  select(X4, X5) %>%
  mutate(Mar_2013 = X5) %>%
  select(-X5) 

Barcelona_Mar_13 <- Barcelona_Mar_13[154:219, ]

Barcelona_Apr_13 <- Barcelona_tourism_2013[[1]] %>%
  select(X4, X5) %>%
  mutate(Apr_2013 = X5) %>%
  select(-X5) 

Barcelona_Apr_13 <- Barcelona_Apr_13[227:292, ]

Barcelona_May_13 <- Barcelona_tourism_2013[[1]] %>%
  select(X4, X5) %>%
  mutate(May_2013 = X5) %>%
  select(-X5) 

Barcelona_May_13 <- Barcelona_May_13[300:365, ]

Barcelona_Jun_13 <- Barcelona_tourism_2013[[1]] %>%
  select(X4, X5) %>%
  mutate(Jun_2013 = X5) %>%
  select(-X5) 

Barcelona_Jun_13 <- Barcelona_Jun_13[373:438, ]

Barcelona_Jul_13 <- Barcelona_tourism_2013[[1]] %>%
  select(X4, X5) %>%
  mutate(Jul_2013 = X5) %>%
  select(-X5) 

Barcelona_Jul_13 <- Barcelona_Jul_13[446:511, ]

Barcelona_Aug_13 <- Barcelona_tourism_2013[[1]] %>%
  select(X4, X5) %>%
  mutate(Aug_2013 = X5) %>%
  select(-X5) 

Barcelona_Aug_13 <- Barcelona_Aug_13[519:584, ]

Barcelona_Sep_13 <- Barcelona_tourism_2013[[1]] %>%
  select(X4, X5) %>%
  mutate(Sep_2013 = X5) %>%
  select(-X5) 

Barcelona_Sep_13 <- Barcelona_Sep_13[592:657, ]

Barcelona_Oct_13 <- Barcelona_tourism_2013[[1]] %>%
  select(X4, X5) %>%
  mutate(Oct_2013 = X5) %>%
  select(-X5) 

Barcelona_Oct_13 <- Barcelona_Oct_13[665:730, ]

Barcelona_Nov_13 <- Barcelona_tourism_2013[[1]] %>%
  select(X4, X5) %>%
  mutate(Nov_2013 = X5) %>%
  select(-X5) 

Barcelona_Nov_13 <- Barcelona_Nov_13[738:803, ]

Barcelona_Dec_13 <- Barcelona_tourism_2013[[1]] %>%
  select(X4, X5) %>%
  mutate(Dec_2013 = X5) %>%
  select(-X5) 

Barcelona_Dec_13 <- Barcelona_Dec_13[811:876, ]

Barcelona_2013 <- cbind(Barcelona_Jan_13, Barcelona_Feb_13$Feb_2013, Barcelona_Mar_13$Mar_2013, Barcelona_Apr_13$Apr_2013, 
                        Barcelona_May_13$May_2013, Barcelona_Jun_13$Jun_2013, Barcelona_Jul_13$Jul_2013, Barcelona_Aug_13$Aug_2013, 
                        Barcelona_Sep_13$Sep_2013, Barcelona_Oct_13$Oct_2013, Barcelona_Nov_13$Nov_2013, Barcelona_Dec_13$Dec_2013)

names(Barcelona_2013) <- c("variables", "Jan_2013", "Feb_2013", "Mar_2013", "Apr_2013", "May_2013", "Jun_2013",
                           "Jul_2013", "Aug_2013", "Sep_2013", "Oct_2013", "Nov_2013", "Dec_2013")

write.csv(Barcelona_2013, "./tourism_data/Barcelona/Barcelona_2013.csv")

# 2012

url <- "http://www.bcn.cat/estadistica/angles/dades/economia/teoh/actual/r2012.htm"

Barcelona_tourism_2012 <- url %>%
  read_html() %>%
  html_nodes(xpath = '/html/body/table') %>%
  html_table()

Barcelona_Jan_12 <- Barcelona_tourism_2012[[1]] %>%
  select(X4, X5) %>%
  mutate(Jan_2012 = X5) %>%
  select(-X5) 

Barcelona_Jan_12 <- Barcelona_Jan_12[8:73, ]

Barcelona_Feb_12 <- Barcelona_tourism_2012[[2]] %>%
  select(X4, X5) %>%
  mutate(Feb_2012 = X5) %>%
  select(-X5) 

Barcelona_Feb_12 <- Barcelona_Feb_12[6:71, ]

Barcelona_Mar_12 <- Barcelona_tourism_2012[[3]] %>%
  select(X4, X5) %>%
  mutate(Mar_2012 = X5) %>%
  select(-X5) 

Barcelona_Mar_12 <- Barcelona_Mar_12[6:71, ]

Barcelona_Apr_12 <- Barcelona_tourism_2012[[4]] %>%
  select(X4, X5) %>%
  mutate(Apr_2012 = X5) %>%
  select(-X5) 

Barcelona_Apr_12 <- Barcelona_Apr_12[6:71, ]

Barcelona_May_12 <- Barcelona_tourism_2012[[5]] %>%
  select(X4, X5) %>%
  mutate(May_2012 = X5) %>%
  select(-X5) 

Barcelona_May_12 <- Barcelona_May_12[6:71, ]

Barcelona_Jun_12 <- Barcelona_tourism_2012[[6]] %>%
  select(X4, X5) %>%
  mutate(Jun_2012 = X5) %>%
  select(-X5) 

Barcelona_Jun_12 <- Barcelona_Jun_12[6:71, ]

Barcelona_Jul_12 <- Barcelona_tourism_2012[[7]] %>%
  select(X4, X5) %>%
  mutate(Jul_2012 = X5) %>%
  select(-X5) 

Barcelona_Jul_12 <- Barcelona_Jul_12[6:71, ]

Barcelona_Aug_12 <- Barcelona_tourism_2012[[8]] %>%
  select(X4, X5) %>%
  mutate(Aug_2012 = X5) %>%
  select(-X5) 

Barcelona_Aug_12 <- Barcelona_Aug_12[6:71, ]

Barcelona_Sep_12 <- Barcelona_tourism_2012[[9]] %>%
  select(X4, X5) %>%
  mutate(Sep_2012 = X5) %>%
  select(-X5) 

Barcelona_Sep_12 <- Barcelona_Sep_12[6:71, ]

Barcelona_Oct_12 <- Barcelona_tourism_2012[[10]] %>%
  select(X4, X5) %>%
  mutate(Oct_2012 = X5) %>%
  select(-X5) 

Barcelona_Oct_12 <- Barcelona_Oct_12[6:71, ]

Barcelona_Nov_12 <- Barcelona_tourism_2012[[11]] %>%
  select(X4, X5) %>%
  mutate(Nov_2012 = X5) %>%
  select(-X5) 

Barcelona_Nov_12 <- Barcelona_Nov_12[6:71, ]

Barcelona_Dec_12 <- Barcelona_tourism_2012[[12]] %>%
  select(X4, X5) %>%
  mutate(Dec_2012 = X5) %>%
  select(-X5) 

Barcelona_Dec_12 <- Barcelona_Dec_12[6:71, ]

Barcelona_2012 <- cbind(Barcelona_Jan_12, Barcelona_Feb_12$Feb_2012, Barcelona_Mar_12$Mar_2012, Barcelona_Apr_12$Apr_2012, 
                        Barcelona_May_12$May_2012, Barcelona_Jun_12$Jun_2012, Barcelona_Jul_12$Jul_2012, Barcelona_Aug_12$Aug_2012, 
                        Barcelona_Sep_12$Sep_2012, Barcelona_Oct_12$Oct_2012, Barcelona_Nov_12$Nov_2012, Barcelona_Dec_12$Dec_2012)

names(Barcelona_2012) <- c("variables", "Jan_2012", "Feb_2012", "Mar_2012", "Apr_2012", "May_2012", "Jun_2012",
                           "Jul_2012", "Aug_2012", "Sep_2012", "Oct_2012", "Nov_2012", "Dec_2012")

write.csv(Barcelona_2012, "./tourism_data/Barcelona/Barcelona_2012.csv")

# Arrivals

Barcelona_arrivals <- Barcelona_2012 %>%
  mutate(country_of_origin = variables)%>%
  select(country_of_origin, Jan_2012, Feb_2012, Mar_2012, Apr_2012, May_2012, Jun_2012, 
         Jul_2012, Aug_2012, Sep_2012, Oct_2012, Nov_2012, Dec_2012) %>%
  cbind(Barcelona_2013) %>%
  select(-variables)%>%
  cbind(Barcelona_2014) %>%
  select(-variables)%>%
  cbind(Barcelona_2015) %>%
  select(-variables)%>%
  cbind(Barcelona_2016)%>%
  select(-variables)

Barcelona_arrivals <- Barcelona_arrivals[8:36,]

write.csv(Barcelona_arrivals, "./tourism_data/Barcelona/Barcelona_arrivals.csv")

# Overnight_stays

Barcelona_overnight_stays <- Barcelona_2012 %>%
  mutate(country_of_origin = variables)%>%
  select(country_of_origin, Jan_2012, Feb_2012, Mar_2012, Apr_2012, May_2012, Jun_2012, 
         Jul_2012, Aug_2012, Sep_2012, Oct_2012, Nov_2012, Dec_2012) %>%
  cbind(Barcelona_2013) %>%
  select(-variables)%>%
  cbind(Barcelona_2014) %>%
  select(-variables)%>%
  cbind(Barcelona_2015) %>%
  select(-variables)%>%
  cbind(Barcelona_2016)%>%
  select(-variables)

Barcelona_overnight_stays <- Barcelona_overnight_stays[38:66,]

write.csv(Barcelona_overnight_stays, "./tourism_data/Barcelona/Barcelona_overnight_stays.csv")


### VIENNA

library(readxl)

Vienna_Jan_15 <- read_excel("./tourism_data/Vienna/arrivals_and_overnight_stays_by_country_of_origin_in_january_2015_by_laend.xlsx", sheet = "Vienna")
Vienna_Jan_15 <- Vienna_Jan_15[5:80, ] 
names(Vienna_Jan_15) <- c("country_of_origin", "arrivals", "a", "b", "c", "overnight_stays", "d", "e", "f", "g")
Vienna_Jan_15 <- Vienna_Jan_15 %>%
  select(-a, -b, -c, -d, -e, -f, -g)

Vienna_Feb_15 <- read_excel("./tourism_data/Vienna/arrivals_and_overnight_stays_by_country_of_origin_in_february_2015_by_laen.xlsx", sheet = "Vienna")
Vienna_Feb_15 <- Vienna_Feb_15[5:80, ] 
names(Vienna_Feb_15) <- c("country_of_origin", "arrivals", "a", "b", "c", "overnight_stays", "d", "e", "f", "g")
Vienna_Feb_15 <- Vienna_Feb_15 %>%
  select(-a, -b, -c, -d, -e, -f, -g)

Vienna_Mar_15 <- read_excel("./tourism_data/Vienna/arrivals_and_overnight_stays_by_country_of_origin_in_march_2015_by_laender.xlsx", sheet = "Vienna")
Vienna_Mar_15 <- Vienna_Mar_15[5:80, ] 
names(Vienna_Mar_15) <- c("country_of_origin", "arrivals", "a", "b", "c", "overnight_stays", "d", "e", "f", "g")
Vienna_Mar_15 <- Vienna_Mar_15 %>%
  select(-a, -b, -c, -d, -e, -f, -g)

Vienna_Apr_15 <- read_excel("./tourism_data/Vienna/arrivals_and_overnight_stays_by_country_of_origin_in_april_2015_by_laender.xlsx", sheet = "Vienna")
Vienna_Apr_15 <- Vienna_Apr_15[5:80, ] 
names(Vienna_Apr_15) <- c("country_of_origin", "arrivals", "a", "b", "c", "overnight_stays", "d", "e", "f", "g")
Vienna_Apr_15 <- Vienna_Apr_15 %>%
  select(-a, -b, -c, -d, -e, -f, -g)

Vienna_May_15 <- read_excel("./tourism_data/Vienna/arrivals_and_overnight_stays_by_country_of_origin_in_may_2015_by_laender.xlsx", sheet = "Vienna")
Vienna_May_15 <- Vienna_May_15[5:80, ] 
names(Vienna_May_15) <- c("country_of_origin", "arrivals", "a", "b", "c", "overnight_stays", "d", "e", "f", "g")
Vienna_May_15 <- Vienna_May_15 %>%
  select(-a, -b, -c, -d, -e, -f, -g)

Vienna_Jun_15 <- read_excel("./tourism_data/Vienna/arrivals_and_overnight_stays_by_country_of_origin_in_june_2015_by_laender.xlsx", sheet = "Vienna")
Vienna_Jun_15 <- Vienna_Jun_15[5:80, ] 
names(Vienna_Jun_15) <- c("country_of_origin", "arrivals", "a", "b", "c", "overnight_stays", "d", "e", "f", "g")
Vienna_Jun_15 <- Vienna_Jun_15 %>%
  select(-a, -b, -c, -d, -e, -f, -g)

Vienna_Jul_15 <- read_excel("./tourism_data/Vienna/arrivals_and_overnight_stays_by_country_of_origin_in_july_2015_by_laender.xlsx", sheet = "Vienna")
Vienna_Jul_15 <- Vienna_Jul_15[5:80, ] 
names(Vienna_Jul_15) <- c("country_of_origin", "arrivals", "a", "b", "c", "overnight_stays", "d", "e", "f", "g")
Vienna_Jul_15 <- Vienna_Jul_15 %>%
  select(-a, -b, -c, -d, -e, -f, -g)

Vienna_Aug_15 <- read_excel("./tourism_data/Vienna/arrivals_and_overnight_stays_by_country_of_origin_in_august_2015_by_laende.xlsx", sheet = "Vienna")
Vienna_Aug_15 <- Vienna_Aug_15[5:80, ] 
names(Vienna_Aug_15) <- c("country_of_origin", "arrivals", "a", "b", "c", "overnight_stays", "d", "e", "f", "g")
Vienna_Aug_15 <- Vienna_Aug_15 %>%
  select(-a, -b, -c, -d, -e, -f, -g)

Vienna_Sep_15 <- read_excel("./tourism_data/Vienna/arrivals_and_overnight_stays_by_country_of_origin_in_september_2015_by_lae.xlsx", sheet = "Vienna")
Vienna_Sep_15 <- Vienna_Sep_15[5:80, ] 
names(Vienna_Sep_15) <- c("country_of_origin", "arrivals", "a", "b", "c", "overnight_stays", "d", "e", "f", "g")
Vienna_Sep_15 <- Vienna_Sep_15 %>%
  select(-a, -b, -c, -d, -e, -f, -g)

Vienna_Oct_15 <- read_excel("./tourism_data/Vienna/arrivals_and_overnight_stays_by_country_of_origin_in_october_2015_by_laend.xlsx", sheet = "Vienna")
Vienna_Oct_15 <- Vienna_Oct_15[5:80, ] 
names(Vienna_Oct_15) <- c("country_of_origin", "arrivals", "a", "b", "c", "overnight_stays", "d", "e", "f", "g")
Vienna_Oct_15 <- Vienna_Oct_15 %>%
  select(-a, -b, -c, -d, -e, -f, -g)

Vienna_Nov_15 <- read_excel("./tourism_data/Vienna/arrivals_and_overnight_stays_by_country_of_origin_in_november_2015_by_laen.xlsx", sheet = "Vienna")
Vienna_Nov_15 <- Vienna_Nov_15[5:80, ] 
names(Vienna_Nov_15) <- c("country_of_origin", "arrivals", "a", "b", "c", "overnight_stays", "d", "e", "f", "g")
Vienna_Nov_15 <- Vienna_Nov_15 %>%
  select(-a, -b, -c, -d, -e, -f, -g)

Vienna_Dec_15 <- read_excel("./tourism_data/Vienna/arrivals_and_overnight_stays_by_country_of_origin_in_december_2015_by_laen.xlsx", sheet = "Vienna")
Vienna_Dec_15 <- Vienna_Dec_15[5:80, ] 
names(Vienna_Dec_15) <- c("country_of_origin", "arrivals", "a", "b", "c", "overnight_stays", "d", "e", "f", "g")
Vienna_Dec_15 <- Vienna_Dec_15 %>%
  select(-a, -b, -c, -d, -e, -f, -g)

Vienna_Jan_16 <- read_excel("./tourism_data/Vienna/arrivals_and_overnight_stays_by_country_of_origin_in_january_2016_by_laend.xlsx", sheet = "Vienna")
Vienna_Jan_16 <- Vienna_Jan_16[5:80, ] 
names(Vienna_Jan_16) <- c("country_of_origin", "arrivals", "a", "b", "c", "overnight_stays", "d", "e", "f", "g")
Vienna_Jan_16 <- Vienna_Jan_16 %>%
  select(-a, -b, -c, -d, -e, -f, -g)

Vienna_Feb_16 <- read_excel("./tourism_data/Vienna/arrivals_and_overnight_stays_by_country_of_origin_in_february_2016_by_laen.xlsx", sheet = "Vienna")
Vienna_Feb_16 <- Vienna_Feb_16[5:80, ] 
names(Vienna_Feb_16) <- c("country_of_origin", "arrivals", "a", "b", "c", "overnight_stays", "d", "e", "f", "g")
Vienna_Feb_16 <- Vienna_Feb_16 %>%
  select(-a, -b, -c, -d, -e, -f, -g)

Vienna_Mar_16 <- read_excel("./tourism_data/Vienna/arrivals_and_overnight_stays_by_country_of_origin_in_march_2016_by_laender.xlsx", sheet = "Vienna")
Vienna_Mar_16 <- Vienna_Mar_16[5:80, ] 
names(Vienna_Mar_16) <- c("country_of_origin", "arrivals", "a", "b", "c", "overnight_stays", "d", "e", "f", "g")
Vienna_Mar_16 <- Vienna_Mar_16 %>%
  select(-a, -b, -c, -d, -e, -f, -g)

Vienna_Apr_16 <- read_excel("./tourism_data/Vienna/arrivals_and_overnight_stays_by_country_of_origin_in_april_2016_by_laender (1).xlsx", sheet = "Vienna")
Vienna_Apr_16 <- Vienna_Apr_16[5:80, ] 
names(Vienna_Apr_16) <- c("country_of_origin", "arrivals", "a", "b", "c", "overnight_stays", "d", "e", "f", "g")
Vienna_Apr_16 <- Vienna_Apr_16 %>%
  select(-a, -b, -c, -d, -e, -f, -g)

# Arrivals

Vienna_arrivals <- cbind(Vienna_Jan_15$country_of_origin,  Vienna_Jan_15$arrivals, Vienna_Feb_15$arrivals, Vienna_Mar_15$arrivals, Vienna_Apr_15$arrivals,
                         Vienna_May_15$arrivals, Vienna_Jun_15$arrivals, Vienna_Jul_15$arrivals, Vienna_Aug_15$arrivals,
                         Vienna_Sep_15$arrivals, Vienna_Oct_15$arrivals, Vienna_Nov_15$arrivals, Vienna_Dec_15$arrivals,
                         Vienna_Jan_16$arrivals, Vienna_Feb_16$arrivals, Vienna_Mar_16$arrivals, Vienna_Apr_16$arrivals)

names(Vienna_arrivals) <- c("country_of origin", "Jan_2015", "Feb_2015", "Mar_2015", "Apr_2015", "May_2015", "Jun_2015",
                            "Jul_2015", "Aug_2015", "Sep_2015", "Oct_2015", "Nov_2015", "Dec_2015",  "Jan_2016", "Feb_2016", 
                            "Mar_2016", "Apr_2016")

write.csv(Vienna_arrivals, "./tourism_data/Vienna/Vienna_arrivals.csv")

# Overnight stays

Vienna_overnight_stays <- cbind(Vienna_Jan_15$country_of_origin, Vienna_Jan_15$overnight_stays, Vienna_Feb_15$overnight_stays, Vienna_Mar_15$overnight_stays, Vienna_Apr_15$overnight_stays,
                         Vienna_May_15$overnight_stays, Vienna_Jun_15$overnight_stays, Vienna_Jul_15$overnight_stays, Vienna_Aug_15$overnight_stays,
                         Vienna_Sep_15$overnight_stays, Vienna_Oct_15$overnight_stays, Vienna_Nov_15$overnight_stays, Vienna_Dec_15$overnight_stays,
                         Vienna_Jan_16$overnight_stays, Vienna_Feb_16$overnight_stays, Vienna_Mar_16$overnight_stays, Vienna_Apr_16$overnight_stays)

names(Vienna_overnight_stays) <- c("country_of origin", "Jan_2015", "Feb_2015", "Mar_2015", "Apr_2015", "May_2015", "Jun_2015",
                            "Jul_2015", "Aug_2015", "Sep_2015", "Oct_2015", "Nov_2015", "Dec_2015",  "Jan_2016", "Feb_2016", 
                            "Mar_2016", "Apr_2016")

write.csv(Vienna_overnight_stays, "./tourism_data/Vienna/Vienna_overnight_stays.csv")

### BRUGES (CITY)

# Arrivals

Bruges_arrivals_2012 <- read_excel("./tourism_data/Bruges/Bruges_arrivals_month_2012.xlsx", sheet = "brug")

Bruges_arrivals_2012 <- Bruges_arrivals_2012[6:39,]

names(Bruges_arrivals_2012) <- c("country_of_origin", "Jan_2012", "Feb_2012", "Mar_2012", "Apr_2012", "May_2012", "Jun_2012",
                                   "Jul_2012", "Aug_2012", "Sep_2012", "Oct_2012", "Nov_2012", "Dec_2012", "total", "empty")

Bruges_arrivals_2012 <- Bruges_arrivals_2012 %>%
  select(-total, -empty)

Bruges_arrivals_2013 <- read_excel("./tourism_data/Bruges/Bruges_arrivals_month_2013.xlsx", sheet = "brug")

Bruges_arrivals_2013 <- Bruges_arrivals_2013[6:39,]

names(Bruges_arrivals_2013) <- c("variables", "Jan_2013", "Feb_2013", "Mar_2013", "Apr_2013", "May_2013", "Jun_2013",
                                 "Jul_2013", "Aug_2013", "Sep_2013", "Oct_2013", "Nov_2013", "Dec_2013", "total", "empty", "a", "b", "c", "d", "e", "f", "g")

Bruges_arrivals_2013 <- Bruges_arrivals_2013 %>%
  select(-total, -empty, -a, -b, -c, -d, -e, -f, -g)

Bruges_arrivals_2014 <- read_excel("./tourism_data/Bruges/Bruges_arrivals_month_2014.xlsx", sheet = "brug")

Bruges_arrivals_2014 <- Bruges_arrivals_2014[6:39,]

names(Bruges_arrivals_2014) <- c("variables", "Jan_2014", "Feb_2014", "Mar_2014", "Apr_2014", "May_2014", "Jun_2014",
                                 "Jul_2014", "Aug_2014", "Sep_2014", "Oct_2014", "Nov_2014", "Dec_2014", "total", "empty", "a", "b", "c", "d", "e", "f", "g")

Bruges_arrivals_2014 <- Bruges_arrivals_2014 %>%
  select(-total, -empty, -a, -b, -c, -d, -e, -f, -g)

Bruges_arrivals_2015 <- read_excel("./tourism_data/Bruges/Bruges_arrivals_month_2015.xlsx", sheet = "brug")

Bruges_arrivals_2015 <- Bruges_arrivals_2015[6:39,]

names(Bruges_arrivals_2015) <- c("variables", "Jan_2015", "Feb_2015", "Mar_2015", "Apr_2015", "May_2015", "Jun_2015",
                                 "Jul_2015", "Aug_2015", "Sep_2015", "Oct_2015", "Nov_2015", "Dec_2015", "empty")

Bruges_arrivals_2015 <- Bruges_arrivals_2015 %>%
  select(-empty)

Bruges_arrivals <- cbind(Bruges_arrivals_2012, Bruges_arrivals_2013) %>%
  select(-variables) %>%
  cbind(Bruges_arrivals_2014) %>%
  select(-variables) %>%
  cbind(Bruges_arrivals_2015) %>%
  select(-variables)
  
write.csv(Bruges_arrivals, "./tourism_data/Bruges/Bruges_arrivals.csv")

# Overnight stays

Bruges_overnight_stays_2012 <- read_excel("./tourism_data/Bruges/Bruges_overnight_stays_month_2012.xlsx", sheet = "brug")

Bruges_overnight_stays_2012 <- Bruges_overnight_stays_2012[6:39,]

names(Bruges_overnight_stays_2012) <- c("country_of_origin", "Jan_2012", "Feb_2012", "Mar_2012", "Apr_2012", "May_2012", "Jun_2012",
                                 "Jul_2012", "Aug_2012", "Sep_2012", "Oct_2012", "Nov_2012", "Dec_2012", "total", "empty")

Bruges_overnight_stays_2012 <- Bruges_overnight_stays_2012 %>%
  select(-total, -empty)

Bruges_overnight_stays_2013 <- read_excel("./tourism_data/Bruges/Bruges_overnight_stays_month_2013.xlsx", sheet = "brug")

Bruges_overnight_stays_2013 <- Bruges_overnight_stays_2013[6:39,]

names(Bruges_overnight_stays_2013) <- c("variables", "Jan_2013", "Feb_2013", "Mar_2013", "Apr_2013", "May_2013", "Jun_2013",
                                 "Jul_2013", "Aug_2013", "Sep_2013", "Oct_2013", "Nov_2013", "Dec_2013", "total", "empty", "a", "b", "c", "d", "e", "f")

Bruges_overnight_stays_2013 <- Bruges_overnight_stays_2013 %>%
  select(-total, -empty, -a, -b, -c, -d, -e, -f)

Bruges_overnight_stays_2014 <- read_excel("./tourism_data/Bruges/Bruges_overnight_stays_month_2014.xlsx", sheet = "brug")

Bruges_overnight_stays_2014 <- Bruges_overnight_stays_2014[6:39,]

names(Bruges_overnight_stays_2014) <- c("variables", "Jan_2014", "Feb_2014", "Mar_2014", "Apr_2014", "May_2014", "Jun_2014",
                                 "Jul_2014", "Aug_2014", "Sep_2014", "Oct_2014", "Nov_2014", "Dec_2014", "total", "empty", "a", "b", "c", "d", "e", "f")

Bruges_overnight_stays_2014 <- Bruges_overnight_stays_2014 %>%
  select(-total, -empty, -a, -b, -c, -d, -e, -f)

Bruges_overnight_stays_2015 <- read_excel("./tourism_data/Bruges/Bruges_overnight_stays_month_2015.xlsx", sheet = "brug")

Bruges_overnight_stays_2015 <- Bruges_overnight_stays_2015[6:39,]

names(Bruges_overnight_stays_2015) <- c("variables", "Jan_2015", "Feb_2015", "Mar_2015", "Apr_2015", "May_2015", "Jun_2015",
                                        "Jul_2015", "Aug_2015", "Sep_2015", "Oct_2015", "Nov_2015", "Dec_2015", "empty")

Bruges_overnight_stays_2015 <- Bruges_overnight_stays_2015 %>%
  select(-empty)

Bruges_overnight_stays <- cbind(Bruges_overnight_stays_2012, Bruges_overnight_stays_2013) %>%
  select(-variables) %>%
  cbind(Bruges_overnight_stays_2014) %>%
  select(-variables)%>%
  cbind(Bruges_overnight_stays_2015) %>%
  select(-variables)

write.csv(Bruges_overnight_stays, "./tourism_data/Bruges/Bruges_overnight_stays.csv")

### BRUGES (REGION)

Bruges_region_arrivals_2012 <- read_excel("./tourism_data/Bruges/Bruges_arrivals_month_2012.xlsx", sheet = "Brugse Ommeland")

Bruges_region_arrivals_2012 <- Bruges_region_arrivals_2012[6:39,]

names(Bruges_region_arrivals_2012) <- c("country_of_origin", "Jan_2012", "Feb_2012", "Mar_2012", "Apr_2012", "May_2012", "Jun_2012",
                                 "Jul_2012", "Aug_2012", "Sep_2012", "Oct_2012", "Nov_2012", "Dec_2012", "total", "empty")

Bruges_region_arrivals_2012 <- Bruges_region_arrivals_2012 %>%
  select(-total, -empty)

Bruges_region_arrivals_2013 <- read_excel("./tourism_data/Bruges/Bruges_arrivals_month_2013.xlsx", sheet = "Brugse Ommeland")

Bruges_region_arrivals_2013 <- Bruges_region_arrivals_2013[6:39,]

names(Bruges_region_arrivals_2013) <- c("variables", "Jan_2013", "Feb_2013", "Mar_2013", "Apr_2013", "May_2013", "Jun_2013",
                                 "Jul_2013", "Aug_2013", "Sep_2013", "Oct_2013", "Nov_2013", "Dec_2013", "total", "empty", "a", "b", "c", "d", "e", "f")

Bruges_region_arrivals_2013 <- Bruges_region_arrivals_2013 %>%
  select(-total, -empty, -a, -b, -c, -d, -e, -f)

Bruges_region_arrivals_2014 <- read_excel("./tourism_data/Bruges/Bruges_arrivals_month_2014.xlsx", sheet = "Brugse Ommeland")

Bruges_region_arrivals_2014 <- Bruges_region_arrivals_2014[6:39,]

names(Bruges_region_arrivals_2014) <- c("variables", "Jan_2014", "Feb_2014", "Mar_2014", "Apr_2014", "May_2014", "Jun_2014",
                                 "Jul_2014", "Aug_2014", "Sep_2014", "Oct_2014", "Nov_2014", "Dec_2014", "total", "empty", "a", "b", "c", "d", "e", "f")

Bruges_region_arrivals_2014 <- Bruges_region_arrivals_2014 %>%
  select(-total, -empty, -a, -b, -c, -d, -e, -f)

Bruges_region_arrivals_2015 <- read_excel("./tourism_data/Bruges/Bruges_arrivals_month_2015.xlsx", sheet = "Brugse Ommeland")

Bruges_region_arrivals_2015 <- Bruges_region_arrivals_2015[6:39,]

names(Bruges_region_arrivals_2015) <- c("variables", "Jan_2015", "Feb_2015", "Mar_2015", "Apr_2015", "May_2015", "Jun_2015",
                                        "Jul_2015", "Aug_2015", "Sep_2015", "Oct_2015", "Nov_2015", "Dec_2015", "empty")

Bruges_region_arrivals_2015 <- Bruges_region_arrivals_2015 %>%
  select(-empty)


Bruges_region_arrivals <- cbind(Bruges_region_arrivals_2012, Bruges_region_arrivals_2013) %>%
  select(-variables) %>%
  cbind(Bruges_region_arrivals_2014) %>%
  select(-variables) %>%
  cbind(Bruges_region_arrivals_2015) %>%
  select(-variables)

write.csv(Bruges_region_arrivals, "./tourism_data/Bruges/Bruges_region_arrivals.csv")

# Overnight stays

Bruges_region_overnight_stays_2012 <- read_excel("./tourism_data/Bruges/Bruges_overnight_stays_month_2012.xlsx", sheet = "Brugse Ommeland")

Bruges_region_overnight_stays_2012 <- Bruges_region_overnight_stays_2012[6:39,]

names(Bruges_region_overnight_stays_2012) <- c("country_of_origin", "Jan_2012", "Feb_2012", "Mar_2012", "Apr_2012", "May_2012", "Jun_2012",
                                 "Jul_2012", "Aug_2012", "Sep_2012", "Oct_2012", "Nov_2012", "Dec_2012", "total", "empty")

Bruges_region_overnight_stays_2012 <- Bruges_region_overnight_stays_2012 %>%
  select(-total, -empty)

Bruges_region_overnight_stays_2013 <- read_excel("./tourism_data/Bruges/Bruges_overnight_stays_month_2013.xlsx", sheet = "Brugse Ommeland")

Bruges_region_overnight_stays_2013 <- Bruges_region_overnight_stays_2013[6:39,]

names(Bruges_region_overnight_stays_2013) <- c("variables", "Jan_2013", "Feb_2013", "Mar_2013", "Apr_2013", "May_2013", "Jun_2013",
                                 "Jul_2013", "Aug_2013", "Sep_2013", "Oct_2013", "Nov_2013", "Dec_2013", "total", "empty", "a", "b", "c", "d", "e")

Bruges_region_overnight_stays_2013 <- Bruges_region_overnight_stays_2013 %>%
  select(-total, -empty, -a, -b, -c, -d, -e)

Bruges_region_overnight_stays_2014 <- read_excel("./tourism_data/Bruges/Bruges_overnight_stays_month_2014.xlsx", sheet = "Brugse Ommeland")

Bruges_region_overnight_stays_2014 <- Bruges_region_overnight_stays_2014[6:39,]

names(Bruges_region_overnight_stays_2014) <- c("variables", "Jan_2014", "Feb_2014", "Mar_2014", "Apr_2014", "May_2014", "Jun_2014",
                                 "Jul_2014", "Aug_2014", "Sep_2014", "Oct_2014", "Nov_2014", "Dec_2014", "total", "empty", "a", "b", "c", "d", "e")

Bruges_region_overnight_stays_2014 <- Bruges_region_overnight_stays_2014 %>%
  select(-total, -empty, -a, -b, -c, -d, -e)

Bruges_region_overnight_stays_2015 <- read_excel("./tourism_data/Bruges/Bruges_overnight_stays_month_2015.xlsx", sheet = "Brugse Ommeland")

Bruges_region_overnight_stays_2015 <- Bruges_region_overnight_stays_2015[6:39,]

names(Bruges_region_overnight_stays_2015) <- c("variables", "Jan_2015", "Feb_2015", "Mar_2015", "Apr_2015", "May_2015", "Jun_2015",
                                               "Jul_2015", "Aug_2015", "Sep_2015", "Oct_2015", "Nov_2015", "Dec_2015", "empty")

Bruges_region_overnight_stays_2015 <- Bruges_region_overnight_stays_2015 %>%
  select(-empty)


Bruges_region_overnight_stays <- cbind(Bruges_region_overnight_stays_2012, Bruges_region_overnight_stays_2013) %>%
  select(-variables) %>%
  cbind(Bruges_region_overnight_stays_2014) %>%
  select(-variables) %>%
  cbind(Bruges_region_overnight_stays_2015) %>%
  select(-variables)

write.csv(Bruges_region_overnight_stays, "./tourism_data/Bruges/Bruges_region_overnight_stays.csv")
