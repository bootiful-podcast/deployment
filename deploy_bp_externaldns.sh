#!/usr/bin/env bash

ROOT_DOMAIN=bootifulpodcast.online
ROOT_SUB_DOMAIN=admin.${ROOT_DOMAIN}
ZONE_NAME=admin-bootifulpodcast-online

gcloud dns managed-zones list | grep $ZONE_NAME || gcloud dns managed-zones create "${ZONE_NAME}" \
    --dns-name "${ROOT_SUB_DOMAIN}." \
    --description "Automatically managed zone by kubernetes.io/external-dns"


echo "Here are the DNS servers for your Google Cloud managed DNS zone. Update your ISP with NS records with as tiny a TTL value as possible"
echo "I ended up creating 4 NS records in Gandi.net or Godaddy.com for 'ns-cloud-{vowel}{1-4}.googledomains.com.' Be sure to include the period after '.com'"

gcloud dns record-sets list \
    --zone "${ZONE_NAME}" \
    --name "${ROOT_SUB_DOMAIN}." \
    --type NS

kubectl apply -f bp-externaldns.yaml
