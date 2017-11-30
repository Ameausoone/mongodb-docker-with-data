#!/usr/bin/env bash

set -ex

echo "****************************"
echo "***  Init indexes ***"
echo "****************************"
mongo --host localhost < /scripts/create-indexes.js

for database in /seed/*/
do
  database=${database%*/}
  database=${database##*/}
  echo "~> import database $database"
  mongo $database --eval "db.createUser({ user: 'user', pwd: 'pass', roles: [ 'read'] })"
  collections=/seed/$database/*.json
  for collection in $collections
  do
    mongoimport --db $database --file $collection
  done
done