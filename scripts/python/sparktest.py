from pyspark import SparkContext

logFile = "/home/bogomil/temp/sparklog"

sc = SparkContext("")

#f = sc.textFile("hdfs://namenode.ib.sandbox.ichec.ie:8020/user/bogomil/tiny_wiki_italian/it_2012-01_tiny")
f = sc.textFile("hdfs://namenode.ib.sandbox.ichec.ie:8020/user/bogomil/tiny_wiki_italian/")
pagini = f.filter(lambda line: "Pagina" in line)
pagini.saveAsTextFile("hdfs://namenode.ib.sandbox.ichec.ie:8020/user/bogomil/test_spark")

p = pagini.count()
print p
