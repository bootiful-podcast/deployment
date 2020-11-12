#!/usr/bin/env bash
set -e
set -o pipefail

function install_config_client_cli() {
  mkdir -p $GITHUB_WORKSPACE/bin
  export PATH=$PATH:$GITHUB_WORKSPACE/bin

  ORGANIZATION=joshlong
  REPO=config-client-cli
  LOCATION=$(
    curl -s https://api.github.com/repos/$ORGANIZATION/$REPO/releases/latest |
      jq '.assets[0].browser_download_url' -r
  )

  wget $LOCATION
  chmod a+x config-client
  mv config-client $GITHUB_WORKSPACE/bin/config-client
}

function hydrate_environment_from_config_server() {

  SVC_NAME=configuration
  IP_OF_CONFIG_SERVER=""

  while [ true ]; do
    kubectl get  deployments/configuration  && IP_OF_CONFIG_SERVER="$(kubectl get svc "$SVC_NAME" --template="{{range .status.loadBalancer.ingress}}{{.ip}}{{end}}")" && break   \
      || sleep 10
  done

  echo "------"
  echo $IP_OF_CONFIG_SERVER
  config-client $CONFIGURATION_SERVER_USERNAME $CONFIGURATION_SERVER_PASSWORD deployment \
    $BP_MODE_LOWERCASE http://${IP_OF_CONFIG_SERVER} $GITHUB_ENV
  echo "------"
}
