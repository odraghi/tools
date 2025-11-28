#!/bin/bash

# Config
TIMEOUT=1

# Const
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Functions
check_flow()
{
 DEST=$1
 PORT=$2

 IP=$(host ${DEST} | grep "has address" | tail -1 | cut -d " " -f4)
 [ "x$IP" = "x" ] && IP="host not found"
 [ "x$IP" = "x" ] && IP="host not found"
 echo "$(timeout ${TIMEOUT}s   curl -v --silent telnet://${DEST}:${PORT} 2>&1 | grep 'Connected to' )" | grep -q Connected
 RET=$?
 [ $RET -eq 0 ] && INFO="${GREEN}Connected to" || INFO="${RED}Can't connect to"
 echo -e "${INFO}${NC} ${DEST} (${IP}) port ${PORT}"
}

# Main
echo "Checking firewall rules destinations.."

echo -e "\nNTP"
check_flow      fnx9051vu.jmsp.prod     123
check_flow      fnx9052vu.jmsp.prod     123

echo -e "\nSMTP"
check_flow      fnx9051vu.jmsp.prod     25
check_flow      fnx9052vu.jmsp.prod     25

echo -e "\nDatabase SQL Server"
check_flow      fnx9060vi.fnx.local     1433
check_flow      fnx9060vi.fnx.local     1488
check_flow      fnx9060vi.fnx.local     3389

echo -e "\nESXi MGMT"
check_flow      fnx0035sh.fnx.local     902
check_flow      fnx0036sh.fnx.local     902

check_flow      vcsa-prod.fnx.local     443
check_flow      nsx-man.fnx.local       443
check_flow      infoblox.jmsp.prod      443
check_flow      rdn.jmsp.prod           80
check_flow      pps.jmsp.prod           443
check_flow      salt-tags.jmsp.prod     80
check_flow      10.11.248.98            80
check_flow      fnx9102vm.fnx.local     443
