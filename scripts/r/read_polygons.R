library(rgdal)


read_polygonns <- function(datafile, layername) {
    
itwhs <- readOGR(datafile, layername);
return(itwhs);

}