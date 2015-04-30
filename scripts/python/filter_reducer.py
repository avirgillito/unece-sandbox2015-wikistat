#!/usr/bin/python

from operator import itemgetter
import datetime
import sys
import os

current_word = None
current_count = 0
word = None

aggr=str(os.environ["WIKI_AGGR"]).strip()
#wiki=str(os.environ["WIKI_PROJ"]).strip()

epoch = datetime.datetime(1970,1,1)
first_hour = datetime.datetime(2012,1,1,0)
first_day = first_hour.date()
last_hour = datetime.datetime(2013,12,31,23)

offset_at_first_hour = (first_hour - epoch).days * 24
offset_at_last_hour = (last_hour - epoch).days * 24 + (last_hour - epoch).seconds/3600
total_hours = offset_at_last_hour - offset_at_first_hour + 1
total_days = total_hours/24
all_dates = [first_day + datetime.timedelta(t) for t in range(total_days)]
all_months = sorted(list(set([datetime.datetime(d.year, d.month, 1) for d in all_dates]))) 


formatted_dates = [d.strftime("%Y-%m-%d") for d in all_dates]
formatted_months = [d.strftime("%Y-%m") for d in all_months]
printed_header = False


def convert_hour_to_date(hr):
  hour = hr%24;
  day = hr/24;
  date = epoc + datetime.timedelta(day, hours = hour); 
  return date

def days_to_months(full_counts_days):
  res = [0 for m in all_months]
  for j,m in enumerate(all_months):
    for i,x in enumerate(all_dates):
      if x.year == m.year and x.month == m.month:
        res[j] += full_counts_days[i]
  return res   

for line in sys.stdin:
  line = line.strip()
  toks = line.split()
  id = toks[0]
  proj = toks[1]
  art = toks[2]
  total = toks[3]
  counts = toks[4]

  full_counts_hours = [-1 for t in range(total_hours)]
  
  cmd = "normalized=["+counts[1:-1] + "]"
  exec(cmd) 
  for n in normalized:
    absolute_offset = n[0]
    cnt = n[1]
    full_counts_hours[absolute_offset - offset_at_first_hour] = cnt
  #print '%s\t%s' % (str(len(full_counts)), str(absolute_offset - offset_at_first_hour))
 

  if aggr == "hour":
    print '%s\t%s\t%s\t%s' % (id,proj, art, str(full_counts_hours))
    continue
  
  # substitute -1 with 0 to perform correct aggregation
  x = [(abs(t) + t)/2 for t in full_counts_hours]
  # the following assumes that the nubmer of hours is divisible by 24
  full_counts_days = [sum(x[t:t+24]) for t in [t*24 for t in range(len(x)/24)]]
  
  if aggr == "day": 
    # first print the header - the computed dates
    if not printed_header:
      print '%s\t%s\t%s\t%s' % ("day","day", "day", str(formatted_dates))
      printed_header = True
 
    print '%s\t%s\t%s\t%s' % (id,proj, art, str(full_counts_days))

  if aggr == "month":
    if not printed_header:
      print '%s\t%s\t%s\t%s' % ("month","month", "month", str(formatted_months))
      printed_header = True
    print '%s\t%s\t%s\t%s' % (id,proj, art, str(days_to_months(full_counts_days)))
 


  #print line

  #word, count = line.split('\t', 1)
  #line = line[:-1]
  #line = line.strip()
#  try:
#    count = int(count)
#  except ValueError:
#    coninue
#  if current_word == word:
#    current_count += count
#  else:
#    if current_word:
#      print '%s\t%s' % (current_word, current_count)
#    current_count = count
#    current_word = word
#
#if current_word == word:
#    print '%s\t%s' % (current_word, current_count)
