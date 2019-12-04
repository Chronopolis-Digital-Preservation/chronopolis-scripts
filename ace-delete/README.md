The `ace-delete.py` script will remove all collections for a given group in the
ACE Audit Manager. This script is a bit older but should still be able to run
without issue.

## Dependencies

* python3
* requests (installed via pip)

## Usage

The script expects certain parameters to be passed in:

* -a: The endpoint of your ace audit manager
* -u: The user to authenticate as
* -p: The password to authenticate with
* -g: The group to remove collections for
* -n: Perform a dry-run
* -v: Verbose output

## Example Usage

```
[ace-delete] $ ls
ace-delete.py
[ace-delete] $ virtualenv -p /path/to/Python3/bin/python3 env
    Running virtualenv with interpreter /opt/local/stow/Python3-3.3.2/bin/python3
    Using base prefix '/opt/local/stow/Python3-3.3.2'
    New python executable in env/bin/python3
    Also creating executable in env/bin/python
    Installing Setuptools.........................done.
    Installing Pip................................done.
[ace-delete] $ source env/bin/activate
(env)[ace-delete] $ pip install requests
    Downloading/unpacking requests
     Downloading requests-2.7.0.tar.gz (451kB): 451kB downloaded
    Running setup.py egg_info for package requests
     
    Installing collected packages: requests
      Running setup.py install for requests
     
    Successfully installed requests
    Cleaning up...
(env)[ace-delete] $ ./ace-delete.py -h                                                                             
3.3.2 (default, Sep 12 2013, 22:14:17)
[GCC 4.4.7 20120313 (Red Hat 4.4.7-3)]
usage: ace-delete.py [-h] [-a ACE] [-u USER] [-p PASSWORD] [-g GROUP] [-n]
                     [-v]
optional arguments:
  -h, --help            show this help message and exit
  -a ACE, --ace ACE
  -u USER, --user USER
  -p PASSWORD, --password PASSWORD
  -g GROUP, --group GROUP
  -n, --dry-run
  -v, --verbose
(env)[ace-delete] $ ./ace-delete.py -a https://chron-monitor.umiacs.umd.edu/ace-am -u admin -p <my-secret-password> -g <depositor-to-remove> -n
...
Removed 43 collections
(env)[ace-delete] $ deactivate
```

## TODO

This script could be updated to help facilitate the deprecation process by 
reading in a list of collection names which are to be removed.
