#!/usr/bin/env bash

set -e
set -o pipefail

rmq_id=$( kubectl get pods | grep rabbitmq | cut -f1 -d\ )
kubectl port-forward $rmq_id 5672 15672 