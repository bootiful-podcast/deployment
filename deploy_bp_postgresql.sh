#!/usr/bin/env bash

APP_NAME=bp-postgresql
CONTAINER_NAME=postgres

# docker run -p 5432:5432 --name $DB_NAME -e POSTGRES_USER=bp -e POSTGRES_PASSWORD=bp -d postgres

# kubectl run $APP_NAME \
#   --image=${CONTAINER_NAME} \
#   --replicas=1 \
#   --port=5432 

#kubectl create deployment --image=${CONTAINER_NAME} ${APP_NAME}
#kubectl set env deployment/${APP_NAME}  POSTGRES_PASSWORD=bp
#kubectl set env deployment/${APP_NAME}  POSTGRES_USER=bp
#kubectl expose deployment ${APP_NAME} --port=5432 --name=postgres-exposed -o yaml
#kubectl get deployment -l app=$APP_NAME -o yaml > ${APP_NAME}.yaml

## todo move these to separate config
export POSTGRES_USER="bp"
export POSTGRES_PASSWORD="sd@s32s1234s2329sdgfiuesn"
echo "the PostgreSQL password is ${POSTGRES_PASSWORD} and the PostgreSQL user is ${POSTGRES_USER}"

kubectl apply -f <(echo "
---
apiVersion: v1
kind: Secret
metadata:
  name: ${APP_NAME}-secrets
type: Opaque
stringData:
  POSTGRES_USER: ${POSTGRES_USER}
  POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
")

kubectl apply -f bp-postgresql.yaml

