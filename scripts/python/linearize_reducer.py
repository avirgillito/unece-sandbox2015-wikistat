#!/usr/bin/python

from operator import itemgetter
import datetime
import sys
import os
import re

def combineBags(allbags):
  return sorted([t for bag in allbags for x in bag for t in x], key = lambda x: x[0])

def getTotalHits(monthly_hits):
  try:
    return sum([int(x[0]) for x in monthly_hits])
  except TypeError, e:
    return 0

# It is assumed that lines have the format
# (proj,(art)) {(month1, proj, (art), count1,{(hour11,count11),(hour12, count12),..}), (month2, proj, (art), count2,{(hour21,count21),(hour22, count22,...)}), ...}
#

for line in sys.stdin:
  line = line.strip()
  toks = line.split()
  projart = toks[0]
  proj = projart[1:projart.index(",")]  
  art = projart[projart.index(",")+2:-2]
  rest = toks[1]
  tot = 0
  hours = []

  #print str(art)
  #continue

  # strip { and } from the sides
  #tempstr = rest[1:-1]
  rest = rest[1:-1]

  # the following parsing breaks if the article name contains {
  
  #print str(projart) + str(art) + "\n"
  #print line
  test = ""
  try:
    while True:
      if art not in rest:
        break
      
      i = rest.index(art)
      j = i + len(art) 
      chunk = rest[j+2:] # j+2 to remove the closing brace and the separating comma
      first_brace = chunk.index("{")
      last_brace = chunk.index("}")
      
      rest = chunk[last_brace:] 
      monthly_count = int(chunk[0:chunk.index(",")])
      #monthly_count = chunk[0:chunk.index(",")]
      
      #test += "|" + chunk[0:chunk.index(",") + "|"
      #test += "|" + chunk[0:chunk.index(",")] + "|"
      
      tot += monthly_count
      #continue
    
      hrs = "[" + chunk[first_brace + 1: last_brace] + "]"
      to_exec = "bag = " + hrs
      exec(to_exec)
      hours += bag
      rest = chunk[last_brace:] 
  except Exception:
      continue

  #print str(proj) + str(art) + ["(" + int(d), int] 
  #output =  str(proj) + " " +str(art) + " " + str(tot) + "{" + str(hours) + "}"
  print proj + "\t" + art + "\t" +str(tot) + "\t{" + ''.join(str(hours)[1:-1].split()) + "}"
