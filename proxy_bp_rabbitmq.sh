#!/usr/bin/env zsh

rmq_id=$( kubectl get pods | grep bp-rabbitmq | cut -f1 -d\ )
kubectl port-forward $rmq_id 5672 15672 