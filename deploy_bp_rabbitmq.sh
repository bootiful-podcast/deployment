#!/usr/bin/env bash

APP_NAME=bp-rabbitmq

# kill the existing container
cid=$( docker ps -a | grep $APP_NAME | cut -f1 -d\ )
docker rm -f $cid

# https://codeburst.io/get-started-with-rabbitmq-on-docker-4428d7f6e46b
#docker run --rm -it --hostname ${APP_NAME}-leader-node -p 15672:15672 -p 5672:5672 rabbitmq:3.8.9-management

# you should be able to visit the management plugin like so:
# http://localhost:15672

kubectl apply -f <(echo "
---
apiVersion: v1
kind: Secret
metadata:
  name: ${APP_NAME}-secrets
type: Opaque
stringData:
  RABBITMQ_DEFAULT_USER: ${BP_RABBITMQ_MANAGEMENT_USERNAME}
  RABBITMQ_DEFAULT_PASS: ${BP_RABBITMQ_MANAGEMENT_PASSWORD}
")

  RABBITMQ_DEFAULT_USER and RABBITMQ_DEFAULT_PASS environmental variables:






kubectl apply -f bp-rabbitmq.yaml
