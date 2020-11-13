#!/usr/bin/env bash
set -e

echo "Loaded repository utils"

function deploy_system_app() {
  APP_NAME=$1
  if [ -z "${GH_PERSONAL_ACCESS_TOKEN}" ]
  then
    echo "the token is empty..."
  else
    echo  "the token is not empty"
  fi

  echo "Trying to invoke the deployment for ${APP_NAME}."

  PAYLOAD='{"event_type":"deploy-development-event"}'

  if [ "$BP_MODE_LOWERCASE" = "production" ]; then
    PAYLOAD='{"event_type":"deploy-production-event"}'

  fi


  RESULT=$(curl -X POST -H "Accept: application/vnd.github.v3+json" \
      -H "Authorization: token ${GH_PERSONAL_ACCESS_TOKEN}" https://api.github.com/repos/bootiful-podcast/${APP_NAME}/dispatches -d $PAYLOAD )
  echo $RESULT
}

