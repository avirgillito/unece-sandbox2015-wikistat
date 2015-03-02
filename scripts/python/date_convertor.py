import datetime
import re

'''
  token is date and time visit string
  d is the beginning start date to offset against
'''
def convert_to_day_count(token, d):
    offset = ord(token[0]) - ord('A')
    z = re.findall('\d+', token)
    zint = [ int(x) for x in z]
    return (d + datetime.timedelta(offset), sum(zint))
    

'''
  gets a line with the codes for all the days in the month
  returns a list with tuples (day, count)
'''    
def convert_all(all_dates, d):
    toks = all_dates.split(",")
    # the last token is just empty
    return [convert_to_day_count(t, d) for t in toks[:-1]]
    
'''
    converts a date to a column name for the big data database    
'''
def date2col(d):
    return "d" + d.strftime('%Y_%m_%d')