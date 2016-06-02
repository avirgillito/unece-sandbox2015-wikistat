### HOW TO HANDLE DATA IN ArcGIS

# The software to use is ArcMAP. Inside this, on the right corner, you'll find ArcCatalog, which will also be used. 

# 1. Load the data that you have (items with geo coordinates) with 'add data' in an .xls format. 

# 2. Once you've loaded the file, you'll find that table on the left, in the 'Table of contents'. 
#    Right click on it and then on 'data' -> 'export' 
#    Choose to export the table in the geodatabase (gdb) on which you are working. 

# 3. Go to the ArcCatalog, find the table that you just imported into the gdb.
#    Right click on it and on 'create feature class' -> 'from XY table'.
#    Choose latitude as X field and longitude as Y field.
#    Click on 'coordinate system of input coordinates' -> 'Select' and choose the most appropriate
#    (for the city pilot I used Geographic Coordinate System -> World -> WGS 1984)
#    Specify as output the gdb which you are working on.

#    Alternative way: right click on the table on the left and then 'Display XY data', the procedure is the same.

# 4. Then you have to 'add data' again to add the feature class just created

# This procedure simply plot the points that you have on the map.

# If you want to filter your points according to levels that are on the map, 
# then follow this procedure (after the previous one):

# 5. Click on 'ArcToolbox' -> 'Analysis tools' -> 'Overlay' -> 'Intersect'

# 6. In 'input feature' you just have to drop the two database that have to be joined,
#    in the form of feature classes (in the city pilot these are: urau_RG_100k_2011_2014 
#    and the feature class that I've just created at point 4, 'XY <city>'). Choose POINTS as
#    output type. 

# 7. The previous point will create another feature class (find it on the left as <city>_intersect). 
#    Right click on it and on 'Open attribute table'. Here you can filter considering the map. 
#    Click on 'Table options' -> 'Select by attributes'. Now you have to set your filter (for city pilot: 
#    URAU_NAME = <city> AND URAU_CATG = <catg>). Click 'Apply'

# 8. Now you have to save the filtered table. Click on 'Table options' -> 'Export'. Check that 
#    'selected records' is selected, and choose to export the table in the gdb.

# 9. Now create another feature class starting from this new table [instructions at point 3 and 4]

# After that, just flag/unflag the feature classes that you need on the left (you should display only the 
# one that we just created). 
