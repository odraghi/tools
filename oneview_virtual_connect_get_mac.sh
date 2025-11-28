#!/bin/bash
#set -x

THIS_PROGRAM=$0

LOGICAL_INTERCONNECT_URI="/rest/logical-interconnects/b22dc0aa-982d-4e7d-8a6a-b01b98734d40"

this_help()
{
   cat << EOF

    Usage: ${THIS_PROGRAM} [OPTIONS]

DESCRIPTION

   Query Oneview for All MAC info

      ${THIS_PROGRAM} --user administrator --domain local
      ${THIS_PROGRAM} --oneview abc0012ch.lab.local --user admin --domain lab.local
      ${THIS_PROGRAM} --user admin --domain lab.local

   Query Oneview to search info about a specific Mac Address
      ${THIS_PROGRAM} --user admin --domain lab.local --search-mac "00:50:56:01:44:16"
      ${THIS_PROGRAM} --session-id "xxxxxxxxx" --search-mac "00:50:56:01:44:16"

OPTIONS:

     --oneview     Oneview host name (default abc0012ch.lab.local).
     --domain      Domain (default lab.local).
     --user        Username (default administrator).
     --session-id  Already connected session id.
     --search-mac  Mac address to search (format "00:50:56:01:44:16" ).

     --help       This Help.

EOF
}

parse_args()
{
   POSITIONAL_ARGS=()

   while [[ $# -gt 0 ]]; do
      case $1 in
         # --my-argument)
         #    ARG_MY_ARGUMENT="$2"
         #    shift # past argument
         #    shift # past value
         #    ;;
         --oneview)
            ARG_ONEVIEW="$2"
            shift # past argument
            shift # past value
            ;;
         -d|--domain)
            ARG_DOMAIN="$2"
            shift # past argument
            shift # past value
            ;;
         -u|--user)
            ARG_USER="$2"
            shift # past argument
            shift # past value
            ;;
         -s|--session-id)
            ARG_SESSION_ID="$2"
            shift # past argument
            shift # past value
            ;;
         -m|--search-mac)
            ARG_SEARCH_MAC="$2"
            shift # past argument
            shift # past value
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

   # Set default values
   ARG_DOMAIN="${ARG_DOMAIN:-lab.local}"
   ARG_USER="${ARG_USER:-administrator}"
   ARG_ONEVIEW="${ARG_ONEVIEW:-abc0012ch.lab.local}"

}

log_info()
{
   echo -e "\nINFO: $*"
   sleep ${DELAY_SECOND:-0}
}

log_warn()
{
   echo -e "\nWARNING: $*"
   sleep ${DELAY_SECOND:-0}
}

fatal_error()
{
   echo -e "\nERROR: $*"
   exit 2
}

authenticate() {
   echo -e "User (${ARG_DOMAIN}): \c"
   [ -z ${ARG_USER} ]  && read ARG_USER || echo ${ARG_USER}
   echo -e "Password: \c" && read -s PASSWD && echo "xxxxx"

JSON_DATA=$(cat << EOF
{
   "authLoginDomain": "$ARG_DOMAIN",
   "userName": "$ARG_USER",
   "password": "$PASSWD"
}
EOF
)

   SESSION_ID=$(curl -sk -X POST https://${ARG_ONEVIEW}/rest/login-sessions \
      -H 'X-API-Version: 1000' \
      -H 'Accept: application/json' \
      -H 'Content-Type: application/json' \
      -d "${JSON_DATA}" \
      | jq -r '.sessionID')
   log_info "sessionID: ${SESSION_ID}"
}

get_logical_interconnects_group() {
   FILTER_OPTION=""
   # SEARCH_MAC=$1
   log_info "Fetching logical-interconnects .."
   # [ ! -z ${SEARCH_MAC} ] && FILTER_OPTION="-d filter=macAddress='${SEARCH_MAC}'"
   ARG_LOGICAL_INTERCO_GRP="FNX-LIG01-MONO3FR"
   FILTER_OPTION="-d filter=name='${ARG_LOGICAL_INTERCO_GRP}'"

   #curl -sk --get https://${ARG_ONEVIEW}/rest/logical-interconnects/b22dc0aa-982d-4e7d-8a6a-b01b98734d40/forwarding-information-base \
   curl -sk --get https://${ARG_ONEVIEW}/rest/index/resources \
      -H 'X-API-Version: 4400' \
      -H "auth: ${SESSION_ID}" \
      -H 'Accept: application/json' \
      -H 'Content-Type: application/json' \
      -d 'category=logical-interconnect-groups' \
      ${FILTER_OPTION} | jq
}

get_arp_table() {
   SEARCH_MAC=$1
   FILTER_OPTION=""
   log_info "Fetching MAC table .."
   [ ! -z ${SEARCH_MAC} ] && FILTER_OPTION="-d filter=macAddress='${SEARCH_MAC}'"

   #curl -sk --get https://${ARG_ONEVIEW}/rest/logical-interconnects/b22dc0aa-982d-4e7d-8a6a-b01b98734d40/forwarding-information-base \
   curl -sk --get https://${ARG_ONEVIEW}${LOGICAL_INTERCONNECT_URI}/forwarding-information-base \
      -H 'X-API-Version: 4400' \
      -H "auth: ${SESSION_ID}" \
      -H 'Accept: application/json' \
      -H 'Content-Type: application/json' \
      ${FILTER_OPTION} | jq
}


## Main
parse_args $*

[ -z ${ARG_SESSION_ID} ] && authenticate || SESSION_ID=${ARG_SESSION_ID}

get_arp_table ${ARG_SEARCH_MAC}

get_logical_interconnects_group
