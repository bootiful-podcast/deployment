#!/usr/bin/env bash

function deploy_system_app(){
  APP_NAME=$1
  RESULT=$( curl \
    -X POST \
    -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization: token $GH_PERSONAL_ACCESS_TOKEN" \
    https://api.github.com/repos/bootiful-podcast/${APP_NAME}/dispatches \
    -d '{"event_type":"deploy-event"}'
  )
  echo $RESULT
}

