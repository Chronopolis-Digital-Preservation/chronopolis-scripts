This is a collection of scripts for monitoring and summarizing replication.

## Summarizing Replication
```
./bytesec.sh -d ucsd-lib /var/log/chronopolis/replication.log{,.2019-1[01]*}
```

## Monitoring Replication Progress
```
./rsync-progress.sh
```

## Monitoring Network Performance
From Bern Schloer, this creates a new log of transfer rates,
computed by watching overall network byte counts.
```
./simple_network_monitor&

[root@chron ~]# ls /var/log/chronopolis/transfer_rates
/var/log/chronopolis/transfer_rates
[root@chron ~]# tail !$
tail /var/log/chronopolis/transfer_rates
Wed Dec  4 10:15:25 PST 2019: 4072241   3976    3
Wed Dec  4 11:04:22 PST 2019: 12488615  12195   11
Wed Dec  4 11:04:23 PST 2019: 3609904   3525    3
Wed Dec  4 15:04:23 PST 2019: 3412761   3332    3
Thu Dec  5 11:42:57 PST 2019: 16100176  15722   15
Thu Dec  5 11:43:09 PST 2019: 48148069  47019   45
Sat Dec  7 03:42:58 PST 2019: 16105614  15728   15
Sat Dec  7 14:10:56 PST 2019: 3412320   3332    3
Sun Dec  8 06:10:55 PST 2019: 16103592  15726   15
```

## Replication Speed from Splunk
splunk search
bytes/sec host="chron.ucsd.edu" sourcetype="chronopolis-replication-rsync"
assume only one host in the csv
ORDERED FROM LAST TO FIRST!!!!
export csv

```
./summary.sh /tmp/ucsd-splunk.csv
bb1 8.5T
bb2 6.7T
bb3 6.4T
bb4 6.2T
bb5 5.9T
bb6 5.8T
bb7 6.6T
bb8 6.9T
bb9 12.1T
bb0 8.4T
total = 73.5T
avg = 99.5MB/s
min = 64.7MB/s
max = 144.8MB/s
overall = 196.1MB/s
overall time = 109.2 hours
```
