#!/usr/bin/env bash


echo "Deploying the GKE Cluster itself..."
./deploy_bp_gke_cluster.sh

echo "Deploying PostgreSQL"
./deploy_bp_postgresql.sh

echo "Deploying RabbitMQ"
./deploy_bp_rabbitmq.sh

