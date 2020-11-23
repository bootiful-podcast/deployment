#!/usr/bin/env bash
set -e
set -o pipefail
 
function wait_for_config_server_external_ip() {

  SVC_NAME=configuration
  IP_OF_CONFIG_SERVER=""
  
  while [ true ]; do
    kubectl get  deployments/configuration  && IP_OF_CONFIG_SERVER="$(kubectl get svc "$SVC_NAME" --template="{{range .status.loadBalancer.ingress}}{{.ip}}{{end}}")" && break   \
      || sleep 10
  done

  while true; do
      successCond="$(kubectl get svc "$SVC_NAME"  --template="{{range .status.loadBalancer.ingress}}{{.ip}}{{end}}")"
      if [[ -z "$successCond" ]]; then
          echo "Waiting for endpoint readiness..."
          sleep 10
      else
          sleep 2
          export IP_OF_CONFIG_SERVER=${successCond}
          echo "The external IP is up! ${successCond}"
          break
    fi
  done
 
}
