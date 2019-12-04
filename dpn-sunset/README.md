Ok so this is a readme of some type... for now a combination of preliminary 
data collecting and steps for sunsetting.

## Usage

Sorry this isn't as well documented, it's mostly here for documentation of the
process that was used to migrate DPN content into Chronopolis.

Each script requires a `snapshots.json` which can be retrieved from the 
duracloud bridge application's list snapshots. An example of the format is
provided.

* snapshot-contents.sh - create chronopolis-ified bags for dpn snapshots
* create-history.sh - create history events in a duracloud-bridge noting the migration of data

## Prelimination

What we(I) want: information about depositors and their snapshots
* How many snapshots a depositor has
* How many bags a depositor has
* How many multipart bags a depositor has
* a mapping of snapshots to bags
  * should include size information for bags + snapshot
* Example json ```
{  "depostiors": [{ 
        "depositor": "ucsd",
        "totalSnapshots": 18,
        "singleBagSnapshots": 15,
        "multipartBagSnapshots": 3,
        "totalBags": 20,
        "totalBytes": 1024,
        "snapshots": {
          "id": "ucsd-blah-blah-blah",
          "totalFiles": 3,
          "totalBytes": 20,
          "bags": [{"name": "bag", "totalFiles": 1, totalBytes: 7}]
        }
    },...
]}
```

## Reconstitution of Bags
### Or: How I got stuck doing shit I knew I would have to do
### At least I don't have to deal with the TDL bags... yet

1. Grab a snapshot - Done
2. Create a new root folder using the snapashot_id - Done
3. Create a metadata directory "dpn/" - Done
4. For each bag in the snapshot
   a. create a folder underneath "dpn/${bag}/" - Done
   b. Copy the bag-info.txt - Done
   c. Copy the manifest-md5.txt - Done
   d. Copy the manifest-sha256.txt - Done
   e. Copy the tagmanifest-sha256.txt - Done
   f. Copy the dpn-tags directory - Talk to Sibyl/Bill
   g. Copy the content-properties.json to "dpn/" - Talk to Sibyl/Bill
   h. Copy the .collection-snapshot.properties to "dpn/" - Talk to Sibyl/Bill
   i. Copy files into "data/" - Done
5. Concatenate all manifest-sha256.txt files together (md5 as well?) - Done
6. Validate files? after? - Talk
7. Generate new BagIt metadata
   a. bagit.txt - can copy old one tbh - Done
   b. bag-info.txt - TBD
     1. replace Bagging-Date
     2. replace Payload-Oxum
     3. replace Bag-Size
     4. remove empty fields
     5. create a tempalte and fill in w/ information?
       i. include member contact info? or just omit?
8. Update Duracloud metadata - ???
   a. content-properties.json
   b. .collection-snapshot.properties
9. Generate a new tagmanifest-sha256.txt - Done

## Reingestion

1. Iterate over snapshots
2. Register - ron scripts
3. Tokenize - handled by ingest
4. Replicate
5. Done

