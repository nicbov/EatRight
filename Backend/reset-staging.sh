#!/usr/bin/bash

set -eux

docker build -t eatright-backend .

docker stop eatright-backend-staging || true

mysql --defaults-extra-file=~/.mysql.defaults -B -e 'DROP DATABASE recipedb' || true
mysql --defaults-extra-file=~/.mysql.defaults -B -e 'CREATE DATABASE recipedb;'

docker run --rm --name eatright-backend-staging -d --network host --env-file ~/.docker.env eatright-backend
