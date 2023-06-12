#!/bin/bash

JENKINSIP=$(terraform output -raw jenkins-master-ip)

curl    --request PATCH \
        --url https://api.cloudflare.com/client/v4/zones/d373d918a348f2db0746a85dfda61c4d/dns_records/712b87fab7711bce9c225849f871ba4e \
        --header 'Content-Type: application/json' \
        --header "Authorization: Bearer $CLOUDFLARE_TOKEN" \
        --data "{\"name\": \"jenkins\", \"type\": \"A\", \"content\": \"$JENKINSIP\"}"
