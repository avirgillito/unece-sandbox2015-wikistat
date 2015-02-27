import bz2
import datetime

def test(file):
    bin = bz2.BZ2File(file , 'r')
    print(datetime.datetime.now())
    withcolon = 0
    total = 0
    while True:
        line = bin.readline()
        if line =="":
          break
        parts = line.split()
        if parts[0].startswith("#"):
          continue
        total += 1
        if ":" in parts[1]:
          withcolon +=1

    bin.close()	  
    print(datetime.datetime.now())
    return (total, withcolon)