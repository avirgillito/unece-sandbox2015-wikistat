import datetime
import sys
import os
import inspect

sys.path.append(os.path.dirname(inspect.getframeinfo(inspect.currentframe()).filename))
import populate_initial

#populate_initial.populate_initial("C:\\Users\\kovacbo\\wikipedia\\data.sqlite", "C:\\Users\\kovacbo\\wikipedia\\sampled-2014-01", cur_date)
#populate_initial.populate_initial("d:\\db\\art.sqlite","d:\\db\\hits.sqlite", "C:\\Users\\kovacbo\\wikipedia\\sampled-2014-01", cur_date)
populate_initial.populate_initial("d:\\db\\2014-01\\all.sqlite","C:\\Users\\kovacbo\\wikipedia\\pagecounts-2014-01-views-ge-5.bz2", datetime.datetime(2014,1,1))

#populate_initial.populate_initial("C:\\Users\\kovacbo\\wikipedia\\bigdata.sqlite", "C:\\Users\\kovacbo\\wikipedia\\more-sampled-2014-01", cur_date)

#populate_initial.populate_initial("C:\\Users\\kovacbo\\wikipedia\\data.sqlite", "C:\\Users\\kovacbo\\wikipedia\\pagecounts-2014-01-views-ge-5.bz2", cur_date)