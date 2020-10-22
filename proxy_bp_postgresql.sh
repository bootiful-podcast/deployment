#!/usr/bin/env zsh
pg_id=$( kubectl get pods | grep bp-postgresql | cut -f1 -d\ )
kubectl port-forward $pg_id 5432
