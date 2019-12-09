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
