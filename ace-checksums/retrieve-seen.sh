#!/bin/sh
# 
# Retrieve the "seen" checksum from the EventLog of an ACE AM. This requires 
# the Report to be downloaded from the ACE AM in order to query on each path
# which is marked as corrupt.
#
# todo: edit out the C: or M: from the report here rather than performing it 
# manually
#
# Usage: edit the coll, user, pass, and server variables
#  coll - the collection report which is read in
#  user - the user to authenticate as
#  pass - the password to authenticate with
#  server - the ACE AM to connect to

coll=collection
user=portaluser
pass=<password>
server="https://localhost/ace-am"
report=${coll}-report

while IFS= read -r path
do
    path=${path%$'\r'}
    output=${path//\//}
    mkdir json
    # mkdir -p "json${path}"
    # touch "json${path}"
    echo ${path}
    curl -o "json/${output}" -u ${user}:${pass} "${server}/EventLog?logpath=${path}&json=true"
done < ${report}
