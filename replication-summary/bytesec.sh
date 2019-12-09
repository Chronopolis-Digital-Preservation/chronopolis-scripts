#!/bin/sh

depositor=''
if [ "$1" = "-d" ]; then
  shift
  if [ $# -eq 0 ]; then
    echo "usage: $0 -d <depositor> <logs>"
    exit 1
  fi
  depositor=$1
  shift
fi

LOG=${*:-/var/log/chronopolis/replication.log}

ls -rt $LOG |\
while read f; do
  if expr $f : '.*gz'; then
    zcat < $f
  else
    cat < $f
  fi
done |\
tr -d ',' |\
awk -v depositor="$depositor" '
{split($9,d,"/")}
depositor && d[1] != depositor {next}
/rsync-log .* File list size/ && starttime[$9] == 0 {
  split($1,a,"-")
  split($2,b,":")
  starttime[$9]=mktime(a[1] " " a[2] " " a[3] " " b[1] " " b[2] " " b[3])
  if (starttime["Overall"]=="") {starttime["Overall"]=starttime[$9]}
}
/rsync-log .*bytes\/sec/ && $14 > 100000000 {
  curdate[$9]=$1
  curdate["Overall"]=$1
  curtime[$9]=$2
  curtime["Overall"]=$2
  date=$1
  time=substr($2,0,5)
  size=$14
  speed=$16/1024^2
  cumsize[$9]+=size
  cumsize["Overall"]+=size
  printf "%s %s-%s  %s  %.1fG  %.1f MB/s\n",$9,date,time,bag,size/1024^3,speed
}
END {
  print "====================="
  for (bag in cumsize) {
    if (bag == "Overall") {continue}
    split(curdate[bag],a,"-")
    split(curtime[bag],b,":")
    endtime[bag]=mktime(a[1] " " a[2] " " a[3] " " b[1] " " b[2] " " b[3])
    printf "Bag %s  %.1fT  %.1f MB/s\n", bag,cumsize[bag]/1024^4,cumsize[bag]/1024^2/(endtime[bag]-starttime[bag])
  }
  print "====================="
  split(curdate["Overall"],a,"-")
  split(curtime["Overall"],b,":")
  endtime["Overall"]=mktime(a[1] " " a[2] " " a[3] " " b[1] " " b[2] " " b[3])
  printf "Overall %.1fT  %.1f MB/s\n", cumsize["Overall"]/1024^4,cumsize["Overall"]/1024^2/(endtime["Overall"]-starttime["Overall"])
}'


#/var/log/chronopolis/replication.log.2019-02-21.0.gz:2019-02-21 10:59:59.446  INFO 2841 --- [pool-2-thread-2] rsync-log                                : rontest/bulk12 File list size: 145

#/var/log/chronopolis/replication.log.2019-02-11.0.gz:2019-02-11 12:33:01.177  INFO 11445 --- [pool-2-thread-1] rsync-log                                : rontest/test2 sent 30 bytes  received 1935 bytes  1310.00 bytes/sec
