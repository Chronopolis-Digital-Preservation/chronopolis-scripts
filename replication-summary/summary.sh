#!/bin/bash

# splunk search
# bytes/sec host="chron.ucsd.edu" sourcetype="chronopolis-replication-rsync"
# assume only one host in the csv
# ORDERED FROM LAST TO FIRST!!!!
# export csv

if [ $# -ne 1 ]; then
  echo "usage: %0 <splunk export csv>"
  exit 1
fi
csv=$1
if [ ! -f $csv ]; then
  echo "MISSING CSV $csv"
  exit 1
fi

tr -d ',' </ad/rstanonik/ucsd-splunk.csv |\
awk '
  BEGIN {
    min=1e9
    max=0
    begin=0
    end=0
  }
  /bb/ && $9 > 1000000000 {
    split($4,a,"_")
    x=a[2]
#    print x,$9,$11
    sum+=$11
    cnt++
    if ($11 < min) {
      min=$11
    }
    if ($11 > max) {
      max=$11
    }
    total+=$9
    bag[x]+=$9
    if (end == 0) {
      s=substr($1, 2)
      split(s, a, "/")
      split($2, b, ":")
      s2=a[1] " " a[2] " " a[3] " " b[1] " " b[2] " " b[3]
      end=mktime(s2)
    }
    s=substr($1, 2)
    split(s, a, "/")
    split($2, b, ":")
    s2=a[1] " " a[2] " " a[3] " " b[1] " " b[2] " " b[3]
    begin=mktime(s2)
  }
  END {
    for (x in bag) {
      printf "%s %.1fT\n", x, bag[x]/1024^4
    }
    printf "total = %.1fT\n", total/1024^4
    printf "avg = %.1fMB/s\n", sum/cnt/1024^2
    printf "min = %.1fMB/s\n", min/1024^2
    printf "max = %.1fMB/s\n", max/1024^2
    printf "overall = %.1fMB/s\n", total/(end-begin)/1024^2
    printf "overall time = %.1f hours\n", (end-begin)/(3600)
  }
'

# 2021/09/07 14:37:58
# "2021/09/07 01:06:36 - ucsd-lib/ucsd-lib_bb9_2021-08-24-09-50-56 sent 119,804 bytes  received 950,839,404,487 bytes  126,483,475.13 bytes/sec","2021-09-07T01:06:36.000-0700",1,7,6,september,36,tuesday,2021,local,,"chron.ucsd.edu",main,1,"//_::_-_-/------__,____,,,___,,._/","/var/log/chronopolis/replication-rsync.log","chronopolis-replication-rsync","chron-log.ucsd.edu",,20,0
