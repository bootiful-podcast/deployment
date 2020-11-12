#!/usr/bin/env bash

set -e
set -o pipefail

pg_id=$( kubectl get pods | grep postgresql | cut -f1 -d\ )
kubectl port-forward $pg_id 5432
