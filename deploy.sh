#!/usr/bin/env bash

echo "Deploying PostgreSQL"
./deploy_bp_postgresql.sh

echo "Deploying RabbitMQ"
./deploy_bp_rabbitmq.sh