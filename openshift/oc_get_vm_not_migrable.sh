oc get vmi -A -o json | jq -r '.items[] | select(any(.status.conditions[]; .type == "LiveMigratable" and .status == "False")) | "\(.metadata.namespace)\t\(.metadata.name)"'
