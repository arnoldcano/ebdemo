#!/bin/sh

MARATHON_TEMPLATE='marathon.template.json'
MARATHON_FILE='marathon.json'

setup_environment() {
  if [ -z $DOCKER_HUB_USERNAME ]; then
    echo 'DOCKER_HUB_USERNAME is not set'
    exit 1
  fi
  if [ -z $DOCKER_HUB_PASSWORD ]; then
    echo 'DOCKER_HUB_PASSWORD is not set'
    exit 1
  fi
  if [ -z $JOB_NAME ]; then
    echo 'JOB_NAME is not set'
    exit 1
  fi
  if [ -z $GIT_COMMIT ]; then
    echo 'GIT_COMMIT is not set'
    exit 1
  fi
  if [ -z $RDS_USERNAME ]; then
    echo 'RDS_USERNAME is not set'
    exit 1
  fi
  if [ -z $RDS_PASSWORD ]; then
    echo 'RDS_PASSWORD is not set'
    exit 1
  fi
  if [ -z $SECRET_KEY_BASE ]; then
    echo 'SECRET_KEY_BASE is not set'
    exit 1
  fi
  IMAGE="${DOCKER_HUB_USERNAME}/${JOB_NAME}:${GIT_COMMIT}"
}

write_marathon_file() {
  cat $MARATHON_TEMPLATE \
    | sed "s|<IMAGE>|$IMAGE|g" \
    | sed "s|<RDS_USERNAME>|$RDS_USERNAME|g" \
    | sed "s|<RDS_PASSWORD>|$RDS_PASSWORD|g" \
    | sed "s|<SECRET_KEY_BASE>|$SECRET_KEY_BASE|g" \
    > $MARATHON_FILE
}

setup_environment
docker build -t ${IMAGE} .
docker run -e RAILS_ENV=test ${IMAGE} bundle exec rake
docker login -u ${DOCKER_HUB_USERNAME} -p ${DOCKER_HUB_PASSWORD}
docker push ${IMAGE}
write_marathon_file
