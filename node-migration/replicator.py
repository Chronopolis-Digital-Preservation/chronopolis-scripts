#!/bin/python 
# 
# This handles the creation of replications to a Chronopolis Node for a given
# depositor. It will first check for the BAG staging storage to be active, and
# if not it will create a new staging object. Then it will iterate each 
# collection which a Depositor owns and create a Replication for the given Node.
# 
# todo: only use the node_namespace
# 
# Dependencies: requests
#
# Usage:
#   set the node_id to the id of the Chronopolis Node
#   set the node_namespace to the namspace of the Chronopolis Node
#   add your credentials to the auth tuple
#   set the depositor equal to the Depositor namespace

import sys
import json
import requests

page=0
node_id=-1
node_namespace=''
seen=set()
auth=('', '')
depositor=''

# api endpoints
bag_api='https://chron-ingest.ucsd.edu/api/bags'
bag_id_api='https://chron-ingest.ucsd.edu/api/bags/%d'
bag_storage_api='https://chron-ingest.ucsd.edu/api/bags/%d/storage/BAG'
token_storage_api='https://chron-ingest.ucsd.edu/api/bags/%d/storage/TOKEN_STORE'
replication_api='https://chron-ingest.ucsd.edu/api/replications'

# files
success_file = open('successful-bags', 'w')
fail_file = open('failed-bags', 'w')

def exit():
    success_file.close()
    fail_file.close()
    sys.exit()

def check_staging(collection):
    bag_id = collection['id']

    name = collection['name']
    size = collection['size']
    files = collection['totalFiles']

    print("Checking staging for ", bag_id)
    bag_storage = requests.get(bag_storage_api % (bag_id), auth=auth)

    if bag_storage.status_code == 404:
        storage_create = {
                'location': depositor + '/' + name, 
                'validationFile': '/tagmanifest-sha256.txt',
                'storageRegion': 1, 
                'totalFiles': files, 
                'size': size, 
                'storageUnit': 'B'
        }
        print("Creating bag_storage: ", json.dumps(storage_create))
        request = requests.put(bag_storage_api % (bag_id), auth=auth, json=storage_create)
        if request.status_code != 201:
            print('[FAILURE] Could not create bag_staging for', bag_id, request.status_code)
            exit()


def create_replication(collection):
    print("Checking for replication")
    bag_id = collection['id']
    name = collection['name']
    replication = requests.get(replication_api, params = {'node': node_namespace, 'bag': name}, auth=auth)
    if replication.status_code == 200:
        js = replication.json()
        if len(js['content']) == 0:
            print("Creating replication for", bag_id)
            replicate = {'bagId': bag_id, 'nodeId': node_id}
            p = requests.post(replication_api, json=replicate, auth=auth)
            if p.status_code == 201:
                success_file.write(name)
                success_file.write('\n')
            else:
                print('[FAILURE] Could not create a replication for', bag_id, p.status_code)
                fail_file.write(name)
                fail_file.write('\n')


# first get all the bags to replicate
bags = requests.get(bag_api, params = {'depositor': depositor, 'page': page}, auth=auth)

# make sure the request succeeded
while bags.status_code == 200:
    page = page + 1
    bags_json = bags.json()
    content = bags_json['content']

    # if we're out of content, break (probably a better way to do this)
    if len(content) == 0:
        break

    for collection in content:
        bag_id = collection['id']
        if bag_id not in seen:
            check_staging(collection)
            create_replication(collection)
            seen.add(bag_id)
    bags = requests.get(bag_api, params = {'depositor': depositor, 'page': page}, auth=auth)

success_file.close()
fail_file.close()
