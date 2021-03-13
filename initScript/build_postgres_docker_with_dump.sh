#!/usr/bin/env bash

pg_restore -d $POSTGRES_DB -U $POSTGRES_USER --clean --if-exists -Fc --no-owner /dump/dump

