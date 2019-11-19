#!/bin/sh
# This reads from a list of snapshots and creates two history events for each
# One marking that tdlprod has replicated a collection
# The other noting that the ncar replication has been deprecated
 
FILE=successful-bags
REPLICATED_TEMPLATE=replicated.template
DEPRECATED_TEMPLATE=deprecated.template
 
BRIDGE=<bridge-url>
PASSWORD=<password>
 
while IFS= read -r snapshot
do
    echo ${snapshot}
    R_JSON=$(sed -e s/SNAPSHOT_ID/${snapshot}/ ${REPLICATED_TEMPLATE})
    D_JSON=$(sed -e s/SNAPSHOT_ID/${snapshot}/ ${DEPRECATED_TEMPLATE})
 
    curl -v -X POST "$BRIDGE/${snapshot}/history" \
        -H "Content-Type: application/json" \
        -u root:${PASSWORD} \
        --data-binary "$(echo ${R_JSON})"
 
    curl -v -X POST "$BRIDGE/${snapshot}/history" \
        -H "Content-Type: application/json" \
        -u root:${PASSWORD} \
        --data-binary "$(echo ${D_JSON})"
    sleep 2
done < ${FILE}
