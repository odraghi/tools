#!/bin/bash

cat << EOF

 Sample commands (after connected to the node):

OVN Database
------------
ovn-nbctl show


Logical Switch
--------------
# List
ovn-nbctl ls-list

# Show (see @ip and @mac)
ovn-nbctl show <SWITCH_NAME>

# Qos
ovn-nbctl qos-list <SWITCH_NAME>

# ACL (network policy)
ovn-nbctl acl-list <SWITCH_NAME>

# Loadbalancer (DNAT)
ovn-nbctl ls-lb-list <SWITCH_NAME>

# List Port
ovn-nbctl lsp-list <SWITCH_NAME>

# Get Port Security
ovn-nbctl lsp-get-port-security <SWITCH_PORT_NAME>

# Set Port Security (Only for Troubleshooting..)
ovn-nbctl lsp-set-port-security <SWITCH_PORT_NAME> "02:53:f1:b5:45:7f 192.168.0.2"


Logical Router
-----------------
# List
ovn-nbctl lr-list

# Show (see @ip and @mac)
ovn-nbctl show <ROUTER_NAME>

# List Ports
ovn-nbctl lrp-list <ROUTER_NAME>

# Router
ovn-nbctl lr-route-list <ROUTER_NAME>

# NAT (In general snat..)
ovn-nbctl lr-nat-list <ROUTER_NAME>

# Loadbalancer on Router (DNAT)
ovn-nbctl lr-lb-list <ROUTER_NAME>

# Router Policies
ovn-nbctl lr-policy-list <ROUTER_NAME>


OVN Trace (Traffic simulation, no real packet..)
------------------------------
# Query to get the port
ovn-nbctl find logical_switch_port name=<NAMESPACE>_<POD_NAME>

exemple:
ovn-nbctl find logical_switch_port name=vdc-saturne_virt-launcher-fortigate-gw-saturne-njhr4

# Ping Pod_A to Pod_B
ovn-trace --ct new --ovs <SWITCH_NAME> 'inport=="<SWITCH_PORT_NAME>" && eth.src==02:53:f1:b5:45:80 && ip4.src==192.168.100.2 && eth.dst==02:53:f1:b5:45:7f  && ip4.dst==192.168.100.1 && icmp && ip.ttl==64'

# Connection Pod to 192.168.100.1 (tcp:3128)
ovn-trace --ct new --ovs <SWITCH_NAME> 'inport=="<SWITCH_PORT_NAME>" && eth.src==02:53:f1:b5:45:80 && ip4.src==192.168.100.2 && ip4.dst==192.168.100.1 && tcp && tcp.dst==3128 && ip.ttl==64'

END OF SAMPLES...
-----------------


EOF

NODES=$(oc get node -o jsonpath="{range .items[*]} {.metadata.name}")


## Search a corresponding node
ARG_NODE=$1
if [ -n $ARG_NODE ]; then
  for NODE in $NODES; do
    echo "$NODE" | grep -q $ARG_NODE && SELECTED_NODE=$NODE
  done
fi

if [ -z $SELECTED_NODE ] ; then
  echo "Nodes:"
  for NODE in $NODES; do
    echo " $NODE"
  done
 echo
 read -p "  Connect in OVN North DB on node (ex: $NODE): " SELECTED_NODE
fi

echo -e "\nConnecting on $SELECTED_NODE ..\n"
POD_NAME=$(oc get pod -n openshift-ovn-kubernetes --field-selector spec.nodeName=$SELECTED_NODE -l app=ovnkube-node -o jsonpath='{.items[0].metadata.name}')
oc exec -it pod/$POD_NAME -n openshift-ovn-kubernetes -c nbdb -- /bin/bash
