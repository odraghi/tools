#!/bin/bash

THIS_PROGRAM=$(basename $0)

this_help()
{
   cat << EOF

    Usage: ${THIS_PROGRAM} [OPTIONS]

DESCRIPTION

   This program install client command tools to work with Openshift.
     - openshift-install
     - oc, kubectl
     - butane
     - helm
     - virtctl
     - nmstate (Package only on Redhat os)

      ${THIS_PROGRAM} --ocp-version 4.20.17
      ${THIS_PROGRAM} --ocp-version 4.20.17 --butane-version v0.27.0
      ${THIS_PROGRAM} --skip-virtcl
      ${THIS_PROGRAM} --virtcl-ocp-cluster my-ocp-cluster.my-domain

OPTIONS:

     --ocp-version <VERSION>                Openshift version (default: latest)
     --butane-version <VERSION>             Butane version (default: v0.26.0)
     --virtcl-ocp-cluster <OCP_CLUSTER>     Openshift Cluster to get virtctl
     --skip-virtcl                          Don't install virtctl

EOF
}


parse_args()
{
   POSITIONAL_ARGS=()

   while [[ $# -gt 0 ]]; do
      case $1 in
         --ocp-version)
            ARG_OCP_VERSION="$2"
            shift # past argument
            shift # past value
            ;;
         --butane-version)
            ARG_BUTANE_VERSION="$2"
            shift # past argument
            shift # past value
            ;;
         --virtcl-ocp-cluster)
            ARG_VIRTCTL_OCP_CLUSTER="$2"
            shift # past argument
            shift # past value
            ;;
         --skip-virtcl)
            ARG_SKIP_VIRTCTL="yes"
            shift # past argument
            ;;
         -h|--help)
            this_help
            exit
            ;;
         -*|--*)
            echo "Unknown option $1"
            exit 1
            ;;
         *)
            POSITIONAL_ARGS+=("$1") # save positional arg
            shift # past argument
            [ ${#POSITIONAL_ARGS[@]} -gt 1 ] && fatal_error "Unexpected positional args : ${POSITIONAL_ARGS[0]}"
            ;;
      esac
   done
   
   ARG_SKIP_VIRTCTL=${ARG_SKIP_VIRTCTL:-no}
   ARG_OCP_VERSION=${ARG_OCP_VERSION:-latest}
   ARG_BUTANE_VERSION=${ARG_BUTANE_VERSION:-v0.26.0}
   ARG_VIRTCTL_OCP_CLUSTER=${ARG_VIRTCTL_OCP_CLUSTER:-dmo-ocp.sfr-sh.net}
}


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

install_butane()
{
  TOOL_URL=https://github.com/coreos/butane/releases/download/${ARG_BUTANE_VERSION}/butane-x86_64-unknown-linux-gnu
  wget -q --show-progress -O /usr/local/bin/butane $TOOL_URL
  [ $? -ne 0 ] && echo "ERROR: Failed to download $TOOL_URL" && return
  chmod 755 /usr/local/bin/butane 
}



tools_version()
{
   cat << EOF

Tools Version on this machine:
---------------
INFO: openshift-install version
$(openshift-install version)
---------------
INFO: oc version --client=true
$(oc version --client=true)
---------------
INFO: kubectl version --client=true
$(kubectl version --client=true)
---------------
INFO: helm version
$(helm version)
---------------
INFO: butane --version
$(butane --version)
---------------
INFO: virtctl version --client
$(virtctl version --client)

EOF
}

### Main
parse_args $*


if [ "$ARG_OCP_VERSION" = "latest" ]; then
  ## Cluster Installer
  install_tool https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable/openshift-install-linux.tar.gz

  ## oc + kubectl 
  install_tool https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable/openshift-client-linux.tar.gz
else
  ## Cluster Installer
  install_tool https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/${ARG_OCP_VERSION}/openshift-install-linux-${ARG_OCP_VERSION}.tar.gz

  ## oc + kubectl 
  install_tool https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/${ARG_OCP_VERSION}/openshift-client-linux-${ARG_OCP_VERSION}.tar.gz
fi


# Helm3
install_tool https://mirror.openshift.com/pub/openshift-v4/clients/helm/latest/helm-linux-amd64.tar.gz

# Butane
install_butane

# Virtctl
if [ "${ARG_SKIP_VIRTCTL}" = "no" ] ; then
  echo "INFO: Using ${ARG_VIRTCTL_OCP_CLUSTER} to get Openshift Virtualization virtctl' tool" 
  install_tool https://hyperconverged-cluster-cli-download-openshift-cnv.apps.${ARG_VIRTCTL_OCP_CLUSTER}/amd64/linux/virtctl.tar.gz --no-check-certificate
fi

[ -f /etc/redhat-release ] && dnf install -y bash-completion nmstate
[ -f /etc/debian_version ] && apt install -y bash-completion

oc completion bash > /etc/bash_completion.d/openshift-oc
kubectl completion bash > /etc/bash_completion.d/openshift-kubectl

tools_version
