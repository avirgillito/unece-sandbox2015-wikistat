import datetime
import re


epoch = datetime.datetime(1970,1,1)



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
