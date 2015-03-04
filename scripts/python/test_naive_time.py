import datetime
import time
import sys
import os
import inspect

#
# Warning - you need to have the pytz library installed to do the CET part of the test.
#


sys.path.append(os.path.dirname(inspect.getframeinfo(inspect.currentframe()).filename))
#import populate_initial
from pytz import timezone
import pytz

def test_naive():
    day = 0
    month = 0
    year = 2010
    for i in range(1,13):
        month = i
        for j in range(1,31):       
            day = j        
            try:
                d1 = datetime.datetime(year, month, day)
                d2 = datetime.datetime(year, month, day + 1)
            except ValueError, e:                            
                continue
            diff = d2 - d1
            seconds = diff.days * 86400 + diff.seconds
            if seconds != 86400:            
                print "AA"
                print day, month

def test_cet():
    day = 0
    month = 0
    year = 2010

    cet = timezone("CET")

    for i in range(1,13):
        month = i        
        for j in range(1,31):            
            day = j        
            try:
                d1 = cet.localize(datetime.datetime(year, month, day))
                d2 = cet.localize(datetime.datetime(year, month, day + 1))
            except ValueError, e:            
                continue
            diff = d2 - d1
            seconds = diff.days * 86400 + diff.seconds
            if seconds != 86400:            
                print "AA"
                print day, month
    