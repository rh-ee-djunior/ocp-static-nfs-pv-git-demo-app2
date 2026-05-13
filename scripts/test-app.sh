#!/usr/bin/env bash
set -euo pipefail

NS="${NS:-nfs-static-pv-demo-app2}"
ROUTE="$(oc get route nfs-pv-writer-app2 -n "$NS" -o jsonpath='{.spec.host}')"

curl -sk "https://$ROUTE/" | jq
curl -sk "https://$ROUTE/write?msg=app2-antes-migracao" | jq
curl -sk "https://$ROUTE/generate?files=5&size_kb=64" | jq
curl -sk "https://$ROUTE/list" | jq
