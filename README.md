# Deployment

This repository handles all the deployment concerns beyond each individual service (MQ, DB, etc.)

## RabbitMQ 

The RabbitMQ service supports the functioning of the whole system. 
It connects the various applications. Run `deploy_bp_rabbitmq.sh` to get 
an application that's running on Kubernetes. You can talk to it on your 
local developer machine by doing some port forwarding.  

```bash 
rmq_id=$( k get pods | grep bp-rabbitmq | cut -f1 -d\ )
kubectl port-forward $rmq_id 15672 5672
```

The following services depend on the RabbitMQ instance:

* `api`
* `processor` 
* `site-generator`

## PostgreSQL 

The PostgresSQl service stores working state for the system.
Run `deploy_bp_postgresql.sh` to get an application that's 
running on Kubernetes. You can talk to it on your local developer 
machine by doing some port forwarding. 

```bash 
pg_id=$( k get pods | grep bp-postgresql | cut -f1 -d\ )
kubectl port-forward $pg_id 5432
```

The following services depend on the RabbitMQ instance:

* `api`
* `processor` 
* `site-generator`


