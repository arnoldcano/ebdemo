#!/bin/sh

IMAGE="${DOCKER_HUB_USERNAME:?}/${JOB_NAME:?}:${GIT_COMMIT:?}"
MARATHON_TEMPLATE='marathon.template.json'
MARATHON_FILE='marathon.json'

docker build -t "${IMAGE:?}" .
docker run -e RAILS_ENV=test "${IMAGE:?}" bundle exec rake
docker login -u "${DOCKER_HUB_USERNAME:?}" -p "${DOCKER_HUB_PASSWORD:?}"
docker push "${IMAGE:?}"

sed \
  -e "s|<IMAGE>|${IMAGE:?}|g" \
  -e "s|<RDS_USERNAME>|${RDS_USERNAME:?}|g" \
  -e "s|<RDS_PASSWORD>|${RDS_PASSWORD:?}|g" \
  -e "s|<SECRET_KEY_BASE>|${SECRET_KEY_BASE:?}|g" \
  $MARATHON_TEMPLATE > $MARATHON_FILE
