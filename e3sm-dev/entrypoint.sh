#!/bin/bash -f

git config --global user.email "e3smuser@dev.null"
git config --global user.name "e3smuser"

exec "$@"