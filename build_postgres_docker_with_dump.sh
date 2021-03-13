#!/usr/bin/env bash

POSTGRES_DB=$1
POSTGRES_USER=$2
POSTGRES_PASSWORD=$3
FILE_NAME=$4
IMAGE_NAME=$5

set -e

echo "Run container"
docker run -d --name postgres_with_db \
            -e PGDATA=/data \
            -e POSTGRES_DB="$POSTGRES_DB" \
            -e POSTGRES_USER="$POSTGRES_USER" \
            -e POSTGRES_PASSWORD="$POSTGRES_PASSWORD" \
            -v "$FILE_NAME":/dump/dump \
            -p 5438:5432 \
            postgres:latest
sleep 5

echo "Restore dump"
docker exec postgres_with_db pg_restore -d "$POSTGRES_DB" -U "$POSTGRES_USER" --clean --if-exists -Fc --no-owner /dump/dump

echo "Database restored successfully"
echo "Building new image $IMAGE_NAME with restored db"

docker commit "$(docker ps -aqf "name=postgres_with_db")" "$IMAGE_NAME"


docker stop postgres_with_db
docker rm "$(docker ps -aqf "name=postgres_with_db")"
