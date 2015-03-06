import bz2
import datetime
import os.path
import gzip

def filter(infile, outfile, proj_list = []):
    zo = gzip.open(outfile, 'ab')

    bin = bz2.BZ2File(infile , 'r')
    
    while True:        
        try:
            line = bin.readline()
            line = line.decode("utf-8")
        except UnicodeDecodeError, e:            
            continue
        if line =="":
          break
        parts = line.split()
        if len(parts) <  1:
            continue
        proj = parts[0]
        # if we have a non-empty project list, respect it
        if proj_list and len(proj_list) > 0 and proj not in proj_list:
            continue    
        zo.writeln(line)
    bin.close()	 
    zo.close()