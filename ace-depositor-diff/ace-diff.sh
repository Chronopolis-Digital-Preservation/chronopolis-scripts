#!/bin/sh

local_ace='https://localhost/ace-am'
local_user='local-user'
local_pass='local-password'
remote_ace='https://not-localhost.ucsd.edu/ace-am'
remote_user='remote-user'
remote_pass='remote-user'
group=''

curl --user "${local_user}:${local_pass}" "${local_ace}/Status?status_group=${group}&json=true&count=400" | python -m json.tool > local.json
curl --user "${remote_user}:${remote_pass}" "${remote_ace}/Status?status_group=${group}&json=true&count=400" | python -m json.tool > local.json

grep -E 'name|totalFiles' local.json > local.count
grep -E 'name|totalFiles' remote.json > remote.count

diff -y local.count remote.count | less
