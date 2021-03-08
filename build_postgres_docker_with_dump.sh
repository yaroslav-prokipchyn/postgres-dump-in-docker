#!/usr/bin/env bash

POSTGRES_DB=$1
POSTGRES_USER=$2
POSTGRES_PASSWORD=$3
FILE_NAME=$4
IMAGE_NAME=$5

set -e
echo "Putting dump into docker"

docker build -t postgres_wit_init_sql:latest . --build-arg DUMP_FILE="$FILE_NAME"

echo "Run container"
docker run -d --name clean_postgres -e POSTGRES_DB="$POSTGRES_DB" -e POSTGRES_USER="$POSTGRES_USER"  -e POSTGRES_PASSWORD="$POSTGRES_PASSWORD" -p 5432:5432 postgres_wit_init_sql:latest
sleep 5

echo "Restore dump"
docker exec clean_postgres pg_restore -d "$POSTGRES_DB" -U "$POSTGRES_USER" --clean --if-exists -Fc --no-owner /tmp/dump.dump

echo "Database restored successfully"
echo "Building new with restored db $IMAGE_NAME"
docker commit "$(docker ps -aqf "name=clean_postgres")" "$IMAGE_NAME"


docker stop clean_postgres
docker rm "$(docker ps -aqf "name=clean_postgres")"
