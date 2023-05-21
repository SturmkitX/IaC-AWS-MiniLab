#!/bin/bash

ELBDNS=$(terraform output -raw kube-elb-01-dns)

curl    --request PATCH \
        --url https://api.cloudflare.com/client/v4/zones/d373d918a348f2db0746a85dfda61c4d/dns_records/61c730743a7985812954a48bd27b6c00 \
        --header 'Content-Type: application/json' \
        --header "Authorization: Bearer $CLOUDFLARE_TOKEN" \
        --data "{\"name\": \"*\", \"type\": \"CNAME\", \"content\": \"$ELBDNS\"}"
