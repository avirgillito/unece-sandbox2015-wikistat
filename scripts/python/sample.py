import bz2
import datetime
import os.path
from random import randint

step = 100
   
def sample(infile, outfile):
    # so that we don't overwrite something
    if os.path.isfile(outfile):
       raise Exception("Output file exists.")

    o = file(outfile, 'w')

    bin = bz2.BZ2File(infile , 'r')
    r = randint(0,99)    
    count = 0
    # get to the first line to output
    while True:
        count += 1
        line = bin.readline()
        if count >= r:
          o.write(line)
          break
    
    count = 0
    while True:
        count += 1
        line = bin.readline()
        if line =="":
          break
        if count >= step:
          count = 0
          o.write(line)

    bin.close()	 
    o.close() 
    print(datetime.datetime.now()