library(sp)
library(rgdal)

setwd("./Urban_audit_2011_2014_SH")

c.area = readOGR(dsn = ".", layer = "URAU_RG_100K_2011_2014")
c.area <- spTransform(c.area, "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")

# choose a city code
cc <- "DE021C1"

city <- c.area[c.area$URAU_CODE == cc,]

# generates n random points uniformly distributed in the rectangle around the chosen city

x.min <- min(city@polygons[[1]]@Polygons[[1]]@coords[,1])
x.max <- max(city@polygons[[1]]@Polygons[[1]]@coords[,1])

y.min <- min(city@polygons[[1]]@Polygons[[1]]@coords[,2])
y.max <- max(city@polygons[[1]]@Polygons[[1]]@coords[,2])

n <- 50

points <- SpatialPoints(cbind(runif(n, min = x.min, max = x.max), runif(n, min = y.min, max = y.max)))

# imposes the projection of the points to be equal to that of the city
proj4string(points) = proj4string(c.area)

# checks which points fall within the city boundary
a <- over(x = points, y = city)

output <- !is.na(a[,1])

plot(city)
plot(points, add = TRUE)
plot(points[output,], col = "red", add = TRUE)