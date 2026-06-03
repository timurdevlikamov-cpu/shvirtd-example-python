#!/bin/bash

export $(grep -v '^#' .env | xargs)
mkdir /opt/backup

docker run --rm  --network "backend" -e MYSQL_ROOT_PASSWORD="$MYSQL_ROOT_PASSWORD" -e MYSQL_DATABASE="$MYSQL_DATABASE" schnitzler/mysqldump mysqldump -h db-mysql -u root -p"$MYSQL_ROOT_PASSWORD" "$MYSQL_DATABASE" > "$BACKUP_FILE"
