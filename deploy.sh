#!/bin/sh

NAME='ebdemo'
TEMPLATE='deploy.template.json'
TAG=`git rev-parse --short HEAD`
DCOS_CLI_URL='https://downloads.dcos.io/binaries/cli/linux/x86-64/dcos-1.8/dcos'

check_environment() {
  echo 'Checking environment...'
  if [ -z $DCOS_URL ]; then
    echo 'DCOS_URL is not set'
    exit 1
  fi
  if [ -z $DCOS_ACS_TOKEN ]; then
    echo 'DCOS_ACS_TOKEN is not set'
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
}

setup_dcos_cli() {
  echo 'Setup DCOS CLI...'
  if ! which dcos > /dev/null; then
    curl -fLsS --retry 20 -Y 100000 -y 60 $DCOS_CLI_URL -o dcos
    sudo mv dcos /usr/local/bin
    sudo chmod +x /usr/local/bin/dcos
  fi
  dcos config set core.dcos_url $DCOS_URL
  dcos config set core.dcos_acs_token $DCOS_ACS_TOKEN
  dcos config show
}

prepare_deploy() {
  echo 'Preparing deploy...'
  if [ ! -f $TEMPLATE ]; then
    echo "$TEMPLATE not found"
    exit 1
  fi
  cat $TEMPLATE \
    | sed "s|<TAG>|$TAG|g" \
    | sed "s|<RDS_USERNAME>|$RDS_USERNAME|g" \
    | sed "s|<RDS_PASSWORD>|$RDS_PASSWORD|g" \
    | sed "s|<SECRET_KEY_BASE>|$SECRET_KEY_BASE|g" \
    > $TAG.json
}

deploy_to_dcos() {
  prepare_deploy
  echo 'Deploying to DCOS...'
  if dcos marathon app list | grep -q $NAME; then
    if ! dcos marathon app update $NAME < $TAG.json; then FAILED=1; fi
  else
    if ! dcos marathon app add < $TAG.json; then FAILED=1; fi
  fi
  cleanup_deploy
  if [ $FAILED -eq 1 ]; then
    echo "$NAME deploy failed"
    exit 1
  fi
}

cleanup_deploy() {
  echo 'Cleanup deploy...'
  if [ -f "$TAG.json" ]; then rm $TAG.json; fi
}

check_environment
setup_dcos_cli
deploy_to_dcos
