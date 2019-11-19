#!/bin/sh
#
# Extract the "seen" hashes from the log events
# 
# Usage: run this script after retrieve_seen.sh
#   currently this will output for the Compare API 
#   if you want something similar to a manifest, 
#   invert the comments on line 24 and 25

dir=json
output=generated_hashes

# todo: hold buffer for printing json (init with {"comparisons": [) for start of json object
# at beginning of loop, print buffer to file
# after loop, trim 1 character off end of buffer
# then print end json
for file in ${dir}/*; do
    echo ${file}
    saw=$(grep -Eo 'Saw: \w*\"' ${file} | tail -1) # last instance of
    saw=${saw/#Saw: /}
    saw=${saw/\"/}
    path=$(grep -Eo '\"path\":\"[\/[:alnum:]\.\_\-]+' ${file} | head -1) # first instance of
    path=${path/#\"path\":\"/}
    # echo ${saw}  ${path} >> ${output}
    echo "{\"digest\": \"${saw}\", \"path\": \"${path}\"}," >> ${output}
done
