### GUIDE TO QUERY WIKIDATA FOR CLASSES

## This is another step further of the script 'guide_to_query_wikidata_for_categories.R'.
## Following these instructions you'll be able to get the classes related to the items
## that you got from the first query location script.

## The procedure is a little bit different than before, because in this case we will go through these steps:

## 1. We will read the file that we got from the query_location_property functions. In this case the output will be a dataframe 
##    with the identifier of the property and the name of the property.

## 2. We will query for the property class. In this case we have to take the properties' identifier one by one and query for the
##    class/es it belongs to. 

## 3. Then, we will read the result of the previous query (one by one) and we'll get as output a dataframe with the name of the
##    property and the name of the class it belongs to.

## 4. Finally, we'll have to link the output that came out from different functions: list of Wikidata properties id 
##    (from read_property_identifier), list of classes (from read_property_class) and list of properties (from read_property_list).
##    We will obtain a dataframe woth three variables: Wikidata (location) item identifier, property and class.

## For each property, the query that we are going to perform is this:

SELECT ?classLabel
WHERE {
  wd:Q1002697 wdt:P279 ?class
  SERVICE wikibase:label { bd:serviceParam wikibase:language "en" }
}

## where Q1002697 represents the property Wikidata identifier. 

## The functions that you have to use are the following:

## 1. read_property_identifier, that only has as a parameter the Wikidata identifier of the target location (Q______)

## 2. query_property_class, in this case the parameter is the dataframe that comes out from function at point 1

## 3. read_property_class, that has the same parameter as point 2

## 4. link_property_class, that has three parameters:
##      a. the dataframe that comes out from point 1
##      b. the dataframe that comes out from point 3
##      c. the dataframe that comes out from function read_property_list (last function in guide on property)

