#!/bin/sh

pgrep rsync |\
while read pid; do
  #echo $pid
  ls -l /proc/$pid/fd |\
  egrep '/export|/scratch' |\
  sed ' s;.* /;/;'
done
