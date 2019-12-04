These scripts contain work for migrating data for a depositor to a new node. 
The reasoning for this could be anything, but previously has happened when
decomissioning a node.

The `replicator.py` should be run first, and when all replications are complete
the `history-create.sh` can be run if events need to be created for the
duracloud-bridge.

## Dependencies

* python3
* requests (installed via pip)

example
```
[node-migration] $ source ~/.venv/py3/bin/activate
(py36) [node-migration] $ pip install requests
Requirement already satisfied: requests in /narahomes/shake/.venv/py3/lib/python3.6/site-packages (2.22.0)
Requirement already satisfied: idna<2.9,>=2.5 in /narahomes/shake/.venv/py3/lib/python3.6/site-packages (from requests) (2.8)
Requirement already satisfied: chardet<3.1.0,>=3.0.2 in /narahomes/shake/.venv/py3/lib/python3.6/site-packages (from requests) (3.0.4)
Requirement already satisfied: certifi>=2017.4.17 in /narahomes/shake/.venv/py3/lib/python3.6/site-packages (from requests) (2019.6.16)
Requirement already satisfied: urllib3!=1.25.0,!=1.25.1,<1.26,>=1.21.1 in /narahomes/shake/.venv/py3/lib/python3.6/site-packages (from requests) (1.25.3)
WARNING: You are using pip version 19.2.2, however version 19.3.1 is available.
You should consider upgrading via the 'pip install --upgrade pip' command.
(py36) [node-migration] $ ./replicator.py
Checking staging for 17527
Creating replication for 17527
...
(py36) [node-migration] $ ./replicator.py
(py36) [node-migration] $ cat successful-bags
ncdcr_126_lib-gen-chronopolis_2019-02-13-13-35-22
ncdcr_126_lib-statepubs-chronopolis_2019-02-12-13-28-56
ncdcr_126_lib-statepubs-chronopolis_2019-01-30-17-37-36
ncdcr_126_lib-statepubs-chronopolis_2019-01-18-19-55-12
ncdcr_126_lib-gen-chronopolis_2018-10-16-12-24-30
ncdcr_126_lib-statepubs-chronopolis_2018-10-09-16-39-27
ncdcr_126_lib-gen-chronopolis_2018-06-15-13-08-23
ncdcr_126_lib-nao-chronopolis_2018-05-09-19-14-25
ncdcr_126_lib-statepubs-chronopolis_2018-04-18-16-14-57
ncdcr_126_lib-statepubs-chronopolis_2018-02-21-20-19-25
ncdcr_126_lib-statepubs-chronopolis_2018-02-14-16-14-59
ncdcr_126_lib-statepubs-chronopolis_2018-01-23-14-11-36
ncdcr_126_lib-nao-chronopolis_2017-12-04-13-40-33
ncdcr_126_lib-ncpedia_2017-11-13-14-02-43
ncdcr_126_lib-nao-chronopolis_2017-11-08-15-06-31
figshare_1074_productionfiles_2018-10-10-14-01-05
figshare_1074_productionfiles_2019-05-22-10-53-00
figshare_1074_snproductionfiles_2018-10-09-08-32-34
figshare_1074_snproductionmetadata_2018-10-08-10-50-45
figshare_1074_productionmetadata_2018-10-08-10-50-08
(py36) [node-migration] $ ./history-create.sh
...

```


