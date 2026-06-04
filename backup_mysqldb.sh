#!/bin/bash

export $(grep -v '^#' .env | xargs)
mkdir /opt/backup
sudo chown $USER:$USER /opt/backup

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

docker run --rm --entrypoint "" \
  --network shvirtd-example-python_backend \
  -e MYSQL_ROOT_PASSWORD="$MYSQL_ROOT_PASSWORD" \
  -e MYSQL_DATABASE="$MYSQL_DATABASE" \
  schnitzler/mysqldump mysqldump \
  -h db-mysql \
  -u root \
  -p"$MYSQL_ROOT_PASSWORD" \
  "$MYSQL_DATABASE" > "/opt/backup/mysql_backup_$TIMESTAMP.sql"
