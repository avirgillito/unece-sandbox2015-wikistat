import subprocess
import re
import sys
import urllib
import tempfile
import os

arts_ids="/projects/wikistats/applications_data/whs/04_whs_redirects_targets_origins_europe.csv"
#arts_ids="/user/bogomil/many_lang_extraction/tst_arts.csv"
arts_counted="/user/bogomil/many_lang_extraction/part-m-00000"
#arts_counted="/user/bogomil/many_lang_extraction/test_arts_cntd"
arts_final="/user/bogomil/many_lang_extraction/articles_ids_counted"

def normalize(art):
  norm = urllib.unquote(art)
  #  norm = re.sub(" ", "_", norm)
  #  norm = re.sub("'", "_", norm)
  #return norm
  if norm == art:
    norm = re.sub(" ", "_", norm)
    norm = re.sub("'", "_", norm)
    norm = re.sub("/", "_", norm)
    return norm
  else:
    return normalize(norm)    

# Gets a file from hdfs to the local file system
def get_file(hdfs_path):
    cat = subprocess.Popen(["hadoop", "fs", "-cat", hdfs_path], stdout=subprocess.PIPE)
    return cat.stdout

# Puts a file from the local file system to the hdfs
def put_file(local_path, hdfs_path):
    put = subprocess.Popen(["hadoop", "fs", "-put", local_path, hdfs_path], stdin=subprocess.PIPE)
    put.stdin.close()
    put.wait()

#(id,fname) = tempfile.mkstemp()
#f = open(fname,"w")
#f.write("aa")
#f.close()
#put_file(fname, "/user/bogomil/test/"+"f")
#os.remove(fname)
#sys.exit(2)

arts_by_name_and_lang={}
articles = get_file(arts_ids)
counts = get_file(arts_counted)

n=0
# example line 
# "7",1009,"de","Kathedrale in Tournai","",TRUE
for a in articles:
  # skip header
  if n == 0:
    n = 1
    continue
  toks = re.split("\"", a)
  whs_id = toks[2][1:-1]
  lang = toks[3]
  art = normalize(toks[5])
  key=lang+"#"+art
  arts_by_name_and_lang[key] = whs_id
  #if lang[0] != "\"" or lang[-1] != "\"" or art[0] != "\"" or art[-1] != "\"":
  #  print "Error ",n, art
  #  sys.exit(2)
  n = n+1

#print arts_by_name_and_lang
#sys.exit(2)

(id,fname) = tempfile.mkstemp()
f = open(fname,"w")
for l in counts:
  toks = l.split()
  # bg.z -> bg etc.
  lang = toks[0][0:2]
  art = normalize(toks[1])
  key = lang + "#" + art
  # some articles we set manually
  if toks[1] == "%D0%A5%D1%80%D0%B0%D0%BC_%22%D0%A1%D0%B2%D0%B5%D1%82%D0%B8_%D0%92%D0%B0%D1%81%D0%B8%D0%BB%D0%B8%D0%B9_%D0%91%D0%BB%D0%B0%D0%B6%D0%B5%D0%BD%D0%B8%22":
    whs_id = "545"  
  elif toks[1] == "%D0%93%D0%BE%D1%81%D1%83%D0%B4%D0%B0%D1%80%D1%81%D1%82%D0%B2%D0%B5%D0%BD%D0%BD%D1%8B%D0%B9_%D0%B8%D1%81%D1%82%D0%BE%D1%80%D0%B8%D0%BA%D0%BE-%D1%8D%D1%82%D0%BD%D0%BE%D0%B3%D1%80%D0%B0%D1%84%D0%B8%D1%87%D0%B5%D1%81%D0%BA%D0%B8%D0%B9_%D0%B7%D0%B0%D0%BF%D0%BE%D0%B2%D0%B5%D0%B4%D0%BD%D0%B8%D0%BA_%22%D0%93%D0%BE%D0%B1%D1%83%D1%81%D1%82%D0%B0%D0%BD%22":
    whs_id = "1076"  
  elif toks[1] == "Park_Narodowy_%22Po%C5%82oniny%22":
    whs_id = "1133"  
  elif toks[1] == "%d0%a6%d1%80%d0%ba%d0%b2%d0%b0_%22%d0%a1%d0%b2._%d0%92%d0%b0%d1%81%d0%b8%d0%bb%d0%b8%d1%98%22_-_%d0%9c%d0%be%d1%81%d0%ba%d0%b2%d0%b0":
    whs_id = "545"  
  elif toks[1] == "%22Triumphal_Arch%22_of_Orange":
    whs_id = "163"  
  elif toks[1] == "Musterhaus_%22Am_Horn%22":
    whs_id = "729"  
  elif  key not in arts_by_name_and_lang:
    print key
    print l
    continue
  #  key = lang + "#" + urllib.unquote(art)
  else:
    whs_id = arts_by_name_and_lang[key]
  nl = whs_id + " " + l + "\n"
  f.write(whs_id + " " +l)
f.close() 
put_file(fname, arts_final)
os.remove(fname)
