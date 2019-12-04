#!/bin/sh -e

WORKING_DIR=${PWD}

STAGING=/staging_root
PRESERVATION=/preservation_root

# MEMBER_FOR="washington tufts ksudpn caltech ukansas"
MEMBER_FOR="caltech"
DURA_PASS="bridge-user"
DURA_PASS="bridge-password"
SNAPSHOTS_FILE="snapshots.json"
HISTORY_EVENT="{\"history\": \"[{'snapshot-action': 'DPN_TO_CHRONOPOLIS_TRANSITION'},{'dpn-bag-ids': [alternates]}]\", \"alternate\": \"false\"}"

function updated_name {
    if [ "$1" = "ksudpn" ]; then
        echo "ksulib"
    else
        echo $1
    fi
}

# Create directories to hold content, keep our top level clean
for member in ${MEMBER_FOR}; do
    # echo "Creating work directory ${pwd}/${member}"
    mkdir -p ${member}

    GREPEX="snapshotId.*"${member}
    # Pull snapshot information for each depositor
    ### awk removes quotes and commas from the lines
    for snapshot in `grep -E ${GREPEX} ${SNAPSHOTS_FILE} | awk '{gsub("[\",]", "", $3); print $3}'`; do
        curlo="${member}/${snapshot}-update.out"
        filename="${member}/${snapshot}-transition.json"
        alternates=`grep -h 'alternate' ${member}/${snapshot}-details.json | sed -e 's/.*\[\(.*\)\]/\1/' -e 's/\s//g' -e 's/,/ /g' -e "s/\"/'/g"` #-e 's/"//g' 
        JSON=${HISTORY_EVENT/alternates/${alternates/ /, }}
        echo "${snapshot} POSTing ${JSON}"
        echo $JSON > ${filename}

        curl -o ${curlo} -f -H "Content-Type: application/json" -X POST --data @${filename} --user ${DURA_USER}:${DURA_PASS} "https://duracloud-bridge.ucsd.edu/bridge/snapshot/${snapshot}/history"
    done
done

