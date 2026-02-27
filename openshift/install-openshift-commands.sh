#!/bin/bash
install_tool()
{
  TOOL_URL=$1
  WGET_OPTION=$2
  TOOL_ARCHIVE=$(echo $TOOL_URL | sed "s/.*\///")
  TMP_ARCHIVE="/tmp/$(mktemp --dry-run tmp.XXXXXXXXXX_$TOOL_ARCHIVE)"
  echo "INFO: GET $TOOL_URL"
  wget -q --show-progress -O $TMP_ARCHIVE $WGET_OPTION $TOOL_URL
  [ $? -ne 0 ] && echo "ERROR: Failed to download $TOOL_ARCHIVE" && return
  FILES=$(tar tzf $TMP_ARCHIVE | grep -v README)
  echo "INFO: Installing command(s)"
  tar xzvf $TMP_ARCHIVE -C /usr/local/bin/ $FILES
  for FILE in $FILES; do
     chmod +x /usr/local/bin/$FILE
     [ $FILE == "helm-linux-amd64" ] && mv /usr/local/bin/{$FILE,helm} && echo "helm"
  done
  rm -f $TMP_ARCHIVE
}

## Cluster Installer
install_tool https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable/openshift-install-linux.tar.gz

## oc + kubectl 
install_tool https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable/openshift-client-linux.tar.gz

# Helm3
install_tool https://mirror.openshift.com/pub/openshift-v4/clients/helm/latest/helm-linux-amd64.tar.gz

# virtctl
echo "INFO: Need a cluster with Openshift Virtualization to get 'virtctl'"
echo -e "Cluster FQDN (dmo-ocp.sfr-sh.net): \c"
read CLUSTER_FQDN
CLUSTER_FQDN=${CLUSTER_FQDN:-dmo-ocp.sfr-sh.net}
install_tool https://hyperconverged-cluster-cli-download-openshift-cnv.apps.${CLUSTER_FQDN}/amd64/linux/virtctl.tar.gz --no-check-certificate

[ -f /etc/redhat-release ] && dnf install -y bash-completion
[ -f /etc/debian_version ] && apt install -y bash-completion

oc completion bash > /etc/bash_completion.d/openshift-oc
kubectl completion bash > /etc/bash_completion.d/openshift-kubectl
