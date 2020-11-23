#!/usr/bin/env bash
set -e



CONFIG_MAP_NAME=backup-cronjob-configmap
cd $ROOT_DIR/backup_cronjob/

kubectl delete cronjobs backup-cronjob || echo "could not delete backup-cronjob"
kubectl delete configmaps/$CONFIG_MAP_NAME || echo "could not delete configmaps/$CONFIG_MAP_NAME "



kubectl get configmaps/${CONFIG_MAP_NAME} | grep $CONFIG_MAP_NAME ||  kubectl create configmap $CONFIG_MAP_NAME --from-file ./bin/


kubectl apply -f backup_cronjob.yaml

echo "Going to run the cronjob (backup-cronjob) one time upfront before waiting for the scheduled to run."

$ROOT_DIR/postgresql/backup.sh