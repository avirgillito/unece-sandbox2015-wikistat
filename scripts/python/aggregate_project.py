import sys
import re
import getopt

#
#  Expects input from stdin - lines of the form <hour> <count>. Outputs to stdout. The g argument specifies the aggregation level
#

optlist, args = getopt.getopt(sys.argv[1:], "g:")

aggr=[x[1] for x in optlist if x[0] == "-g"][0]
buckets={}

for line in sys.stdin:
  line = line.strip()
  toks = re.split(" ", line)
  if len(toks) < 2:
    continue
  hour = toks[0]
  if (len(hour) < 8):
    sys.exit(2)
  if aggr == "month":
    buckets.setdefault(hour[:7],[]).append(long(toks[1]))
  if aggr == "day":
    buckets.setdefault(hour[:10],[]).append(long(toks[1]))
  if aggr == "hour":
    buckets.setdefault(hour[:13],[]).append(long(toks[1]))

for k in sorted(buckets.keys()):
  print k, sum(buckets[k])
