#!/usr/bin/env bash
set -e


APP_NAME=backup-cronjob
CONFIG_MAP_NAME=${APP_NAME}-configmap
cd $ROOT_DIR/backup_cronjob/

kubectl delete cronjobs backup-cronjob || echo "could not delete backup-cronjob"
kubectl delete configmaps/$CONFIG_MAP_NAME || echo "could not delete configmaps/$CONFIG_MAP_NAME "

echo "Creating ConfigMap for $CONFIG_MAP_NAME"

kubectl get configmaps/${CONFIG_MAP_NAME} | grep $CONFIG_MAP_NAME || \
  kubectl create configmap $CONFIG_MAP_NAME --from-file ./bin/

echo "did the configmap create?"
kubectl get configmaps/${CONFIG_MAP_NAME}

kubectl apply -f  backup_cronjob.yaml

##
echo "Going to run the cronjob (backup-cronjob) one time upfront before waiting for the scheduled to run."

BACKUP_JOB_NAME=backup-cronjob-initial-run-job
kubectl get job $BACKUP_JOB_NAME && kubectl delete job $BACKUP_JOB_NAME
kubectl create job --from=cronjob/backup-cronjob $BACKUP_JOB_NAME
