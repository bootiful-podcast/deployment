#!/usr/bin/env bash

set -e
set -o pipefail

echo "Manually starting an instance of the backup-cronjob"
JOB_ID=backup-cronjob-initial-run-job
kubectl get jobs | grep $JOB_ID && kubectl delete  jobs/$JOB_ID
kubectl create job --from=cronjob/backup-cronjob $JOB_ID
