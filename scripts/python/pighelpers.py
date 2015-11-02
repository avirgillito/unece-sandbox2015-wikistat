import datetime
import re
import sys
import socket
#import hashlib
import random

epoch = datetime.datetime(1970,1,1)

count = 0

@outputSchema("id:int")
def getId():
  #return int(hashlib.md5(str(proj) + str(art)).hexdigest(), 16)
  return random.randint(1,100000000000000000)
  #return random.randint(1,2)

@outputSchema("y:bag{t:tuple(id:chararray, hour:int, hits:int)}")
def convert_to_norm(id, hours):
  if not hours:
    return []

  return [(id, h[0], h[1]) for h in hours]
  #res = []
  #for h in hours:
  #  res += [(id, hours[0], hours[1])]
  #return res


@outputSchema("id:int")
def _getid(servers, server, localid):
 return servers[0]

@outputSchema("t:tuple(server:chararray, id:int)")
def _getid_per_server():
  global count
  host = socket.gethostname()
  count += 1
  return (host, count) 

@outputSchema("y:bag{t:tuple(hour:int, hits:int)}")
def parseHours(yearmonth, hrs):
  [year, month] = [int(t) for t in (re.split("-",yearmonth))]
  current_date = datetime.datetime(year, month, 1)
  offset_at_first_day = (current_date - epoch).days * 24
  res = convert_all(hrs, offset_at_first_day)
  return res

@outputSchema("y:chararray")
def remove_commas_and_braces(x):
    x = x.replace("[","")
    x = x.replace("]","")
    x = x.replace(",","")
    return x

@outputSchema("y:chararray")
def agglomerate_periods(proj, art, all):
    strings = [a[3] for a in all]
    arrays = []
    for s in strings:
        s = s[1:-1]
        arrays += [[int(t) for t in re.split(",",s)]]    
    res = str([sum([t[i] for t in arrays]) for i in range(0,len(arrays[0]))])
    return res

    strings = [a[3] for a in all]
    arrays = []
    for s in strings: 
        toexec="nextarray=" + s
        try:
            exec(toexec) 
        except:
            return str(sys.exc_info())
        arrays += [nextarray]

    res = str([sum([t[i] for t in arrays]) for i in range(0,len(arrays[0]))])
    # remove surrounding [ and ] and commas inbetween
    return res

    # first strip the surrounding [ and ]
    all = all[1:-1]
    opening_braces=[m.start() for m in re.finditer("\[",all)]  
    closing_braces=[m.start() for m in re.finditer("\]",all)]
    if len(opening_braces) != len(closing_braces):
        raise "Problem with" + str(proj) + " " + str(art) + " check for [ or ] in the article name."
    pairs = zip(openening_braces, closing_braces)
    # each element will be an array corresponding the full period where only one year is not (necesserily) zeroed out
    # expected is that the elements are equal in length
    arrays = []
    for p in pairs:
        toexec="nextarray="+all[p[0]:p[1]+1]
        exec(toexec) 
        arrays += [nextarray]
    return str([sum([t[i] for t in arrays]) for i in range(0,len(arrays[0]))])

@outputSchema("y:bag{t:tuple(hour:int, hits:int)}")
def combineBags(allbags):
  return sorted([t for bag in allbags for x in bag for t in x], key = lambda x: x[0])

@outputSchema("totalhits:int")
def getTotalHits(monthly_hits):
  try:
    return sum([int(x[0]) for x in monthly_hits])
  except TypeError, e:
    return 0

'''
  token is date and time visit string
  d is the beginning start date to offset against
'''
def convert_to_hourly_count(token, offset):
    # add the hours corresponding to the day count to the offset    
    offset = offset + char2offset(token[0]) * 24    
    res = []
    # If data are missing for a whole day an asterisk + question is showing for that day,
    if token[1] == '*':
        for i in range(0,23):
            return [(offset + i, -1)]
            
    noquest = re.sub("\?", "-1", token[1:])
    all = re.findall("\w\-*\d+", noquest)    
    return [(offset + char2offset(a[0]), int(a[1:])) for a in all]
'''
  gets a line with the codes for all the days in the month
  returns a list with tuples (day, count).
  offset is the offset in days since epoch
'''    
def convert_all(all_dates, offset):    
    toks = all_dates.split(",")
    # the last token is just empty
    res = []
    for t in toks[:-1]:
        res += convert_to_hourly_count(t, offset)
    return res
    
'''
    Assuming UTC. Don't use time.mktime as it assumes its input is in the localtime!
'''
def date2timestamp(d):
    return (mktime(d) - epoch)/3600    

def char2offset(c):
    return (ord(c) - ord('A'))
