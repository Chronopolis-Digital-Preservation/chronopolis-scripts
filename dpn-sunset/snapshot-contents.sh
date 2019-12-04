#!/bin/sh -e

WORKING_DIR=${PWD}

STAGING=/staging_root
PRESERVATION=/preservation_root

# MEMBER_FOR="washington tufts ksudpn caltech ukansas"
MEMBER_FOR="ucsd"
DURA_USER="bridge_user"
DURA_PASS="bridge_pass"
SNAPSHOTS_FILE="snapshots.json"

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
        echo "Getting snapshot details for ${snapshot}"
        curl -f -s -o "${member}/${snapshot}-details.json" --user ${DURA_USER}:${DURA_PASS} "https://dpn-bridge.ucsd.edu/bridge/snapshot/${snapshot}"

        snapshot_dir="${STAGING}/${member}/${snapshot}"
        mkdir -p ${snapshot_dir}

        alternates=`grep -h 'alternate' ${member}/${snapshot}-details.json | sed -e 's/.*\[\(.*\)\]/\1/' -e 's/\s//g' -e 's/"//g' -e 's/,/ /g'`
        echo "Captured alternate ids ${alternates}"

        for alternate in ${alternates}; do
            dpn_bag="${PRESERVATION}/${member}/${alternate}"
            echo "Copying metadata for snapshot part ${alternate}"

            mkdir -p ${snapshot_dir}/dpn/${alternate}/dpn-tags
            # Tags
            cp ${dpn_bag}/bagit.txt ${snapshot_dir}/dpn/${alternate}/bagit.txt
            cp ${dpn_bag}/bag-info.txt ${snapshot_dir}/dpn/${alternate}/bag-info.txt
            cp ${dpn_bag}/dpn-tags/dpn-info.txt ${snapshot_dir}/dpn/${alternate}/dpn-tags/dpn-info.txt

            # Manifests
            cp ${dpn_bag}/manifest-md5.txt ${snapshot_dir}/dpn/${alternate}/manifest-md5.txt
            cp ${dpn_bag}/manifest-sha256.txt ${snapshot_dir}/dpn/${alternate}/manifest-sha256.txt
            cp ${dpn_bag}/tagmanifest-sha256.txt ${snapshot_dir}/dpn/${alternate}/tagmanifest-sha256.txt

            # Preserve the content-properties and .collection-snapshot.properties in a similar manner as before
            # Also store the old .collection-snapshot.properties in the dpn subdir
            cp ${dpn_bag}/content-properties.json ${snapshot_dir}/content-properties.json
            cp ${dpn_bag}/.collection-snapshot.properties ${snapshot_dir}/dpn/.collection-snapshot.properties

            cat ${dpn_bag}/manifest-md5.txt >> ${snapshot_dir}/manifest-md5.txt
            cat ${dpn_bag}/manifest-sha256.txt >> ${snapshot_dir}/manifest-sha256.txt

            rsync -av ${dpn_bag}/data/ ${snapshot_dir}/data/
        done

        echo "Updating .collection-snapshot.properties"
        updated=$(updated_name ${member})
        sed "
          s/member-id=.*/member-id=${updated}/g
          s/owner-id=${member}/owner-id=${updated}/g
          s/duracloud-host=${member}\(.*\)/duracloud-host=${updated}\1/g
        " ${snapshot_dir}/dpn/.collection-snapshot.properties > ${snapshot_dir}/.collection-snapshot.properties

        echo "Creating new BagIt metadata for ${snapshot}"
        echo -e "BagIt-Version: 0.97\nTag-File-Character-Encoding: UTF-8" > ${snapshot_dir}/bagit.txt

        # BagInfo
        ## PayloadOxum (du -bs + find)
        ## Bag-Size (du -hc)
        ## Bagging-Date
        ## Source-Organization (depositor? ucsd?)
        human_size=`du -hs ${snapshot_dir}/data | awk '{print $1}'`
        oxum_size=`du -s --block-size=1 ${snapshot_dir}/data | awk '{print $1}'`
        oxum_files=`find ${snapshot_dir}/data -type f | wc -l`
        now=`date +%Y-%m-%d`
        sed "
          s/BAG_SIZE/${human_size}/g
          s/PAYLOAD_OXUM/${oxum_size}.${oxum_files}/g
          s/BAG_DATE/${now}/g
        " bag-info.template > ${snapshot_dir}/bag-info.txt

        # Create the tagmanifest
        ## Touch the file first so that it can be listed and pruned from find
        echo "Creating new tagmanifest-sha256.txt for ${snapshot}"
        cd ${snapshot_dir}
        touch tagmanifest-sha256.txt
        find . \( -path ./data -o -path ./tagmanifest-sha256.txt \) -prune -o -type f -print0 | xargs -0 sha256sum | sed -e 's/\.\///' > ${snapshot_dir}/tagmanifest-sha256.txt
        cd ${WORKING_DIR}
    done
done

