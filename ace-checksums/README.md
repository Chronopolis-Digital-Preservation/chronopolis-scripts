This set of scripts is used to retrieve checksum information from ACE AM in the
event that they were stored incorrectly in the database. The AM stores the
checksum which it saw in its EventLog which can be queried through a json 
interface. The events are then parsed and the checksum which was calculated is
extracted.

Example usage:
```
[ace-checksums] $ cat ace-report 
C:/src/httpd-2.0.54.tar
C:/src/jdk-1_5_0_08-linux-i586.bin
C:/src/DLS/SRB3.4.2rele.tar
C:/src/DLS/postgresql-8.0.3.tar
C:/src/DLS/SRB3.4.1rele.tar
C:/src/DLS/postgresql-8.1.4.tar
C:/DLS/DLsysBuildCollection/LOGS/20070728_load.log
[ace-checksums] $ sed -i -e 's/C://' siox/siox-report 
[ace-checksums] $ ./retrieve-seen.sh 
/src/httpd-2.0.54.tar
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   916  100   916    0     0   1768      0 --:--:-- --:--:-- --:--:--  1771
....
[ace-checksums] $ ./extract-hash.sh 
json/DLSDLsysBuildCollectionLOGS20070728_load.log
json/srcDLSpostgresql-8.0.3.tar
json/srcDLSpostgresql-8.1.4.tar
json/srcDLSSRB3.4.1rele.tar
json/srcDLSSRB3.4.2rele.tar
json/srchttpd-2.0.54.tar
jon/srcjdk-1_5_0_08-linux-i586.bin
[ace-checksums] $ cat generated_hashes
{"digest": "b3ff37db5a3d6d53c554e73a433d6843a12b260ff911054dd4aadd8103a75a75", "path": "/DLS/DLsysBuildCollection/LOGS/20070728_load.log"},
{"digest": "504dced2eb6c7e94112c54ab3aa3c09ab2cf680ccb5748990f4d8128c6d8c8df", "path": "/src/DLS/postgresql-8.0.3.tar"},
{"digest": "b6e12fafa326f0804dd7c25473b6961e4831987612380de743b84cd4071943ea", "path": "/src/DLS/postgresql-8.1.4.tar"},
{"digest": "26244fd3a05f2d65960624f444867f50ae2ccc5bdd373fef27ebe3ac9ee239c1", "path": "/src/DLS/SRB3.4.1rele.tar"},
{"digest": "89b04ee8da207e115b4890acadfc73b0cd8231b06e66943c296aafe64ea14d08", "path": "/src/DLS/SRB3.4.2rele.tar"},
{"digest": "68da577070e248e9b8ad0afc6ee46736554d60ad891fb4326738d1fac8d77f3c", "path": "/src/httpd-2.0.54.tar"},
{"digest": "fc0931cd5ca88112d8416c4e0b69e69db26715bb6f4466f51c0964b0bf575090", "path": "/src/jdk-1_5_0_08-linux-i586.bin"},

```
