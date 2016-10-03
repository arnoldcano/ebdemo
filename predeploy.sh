#!/bin/sh

NAME="ebdemo"
TAG=`git rev-parse --short HEAD`

cat Dockerrun.aws.json.template \
  | sed 's|<NAME>|'$NAME'|g' \
  | sed 's|<TAG>|'$TAG'|g' \
  > Dockerrun.aws.json
