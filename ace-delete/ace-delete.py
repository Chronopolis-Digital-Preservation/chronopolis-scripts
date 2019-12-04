#!/usr/bin/env python

import requests
import json
import argparse
import sys

collection_rest = '/rest/collections/by-group/{}'
collection_remove = '/ManageCollection?remove=yes&collectionid={}'

def get_collections(am, auth, group):
    print(am, collection_rest.format(group))

    url = am + collection_rest.format(group)
    r = requests.get(url, auth=auth)
    return r.json()

def obliterate(ace, group, dry_run=True, verbose=False):
    am, user, password = ace
    auth = (user, password)
    collections = get_collections(am, auth, group)

    size = 0
    for c in collections['collection']:
        print(c['id'])
        url = am + collection_remove.format(c['id'])
        if dry_run or verbose:
            print('Removing', c['name'], 'using', url)

        # Not the prettiest... but w.e.
        if not dry_run:
            r = requests.get(url, auth=auth)

        size += 1
    print('Removed', size, 'collections')

def main():
    print(sys.version)
    parser = argparse.ArgumentParser()
    parser.add_argument('-a', '--ace')
    parser.add_argument('-u', '--user')
    parser.add_argument('-p', '--password')
    parser.add_argument('-g', '--group')
    parser.add_argument('-n', '--dry-run', action='store_true')
    parser.add_argument('-v', '--verbose', action='store_true')

    args = parser.parse_args()

    obliterate((args.ace, args.user, args.password), args.group, args.dry_run, args.verbose)

if __name__ == "__main__":
    main()
    
