#!/bin/sh

header_message="NuvlaBox Network Manager
\n\n
This microservice is responsible for setting up the necessary network
configurations for the NuvlaBox to function properly.
\n\n
This includes setting up a VPN client in case the respective NuvlaBox
resource in Nuvla mandates so.
\n\n
Arguments:\n
  No arguments are expected.\n
  This message will be shown whenever -h, --help or help is provided and a
  command to the Docker container.\n
"


SOME_ARG="$1"

help_info() {
    echo "COMMAND: ${1}. You have asked for help:"
    echo -e ${header_message}
    exit 0
}


if [[ ! -z ${SOME_ARG} ]]
then
    if [[ "${SOME_ARG}" = "-h" ]] || [[ "${SOME_ARG}" = "--help" ]] || [[ "${SOME_ARG}" = "help" ]]
    then
        help_info ${SOME_ARG}
    else
        echo "WARNING: this container does not expect any arguments, thus they'll be ignored"
    fi
fi

SHARED="/srv/nuvlabox/shared"
VPN_SYNC="${SHARED}/vpn"
VPN_IS="${VPN_SYNC}/vpn-is"
VPN_CONF="${VPN_SYNC}/nuvlabox.conf"
NUVLABOX_ID=$(echo ${NUVLABOX_UUID} | awk -F'/' '{print $NF}')

mkdir -p ${VPN_SYNC}

write_vpn_conf() {

    cat>${VPN_CONF} <<EOF
## TODO

EOF

}


##----- FOR NOW, THE NETWORK MANAGER ONLY SETS UP THE VPN CLIENT -----##

# wait for the VPN IS to be written by the agent
while true
do
    echo 'INFO: waiting for the NuvlaBox agent to mandate which VPN Infrastructure to use in '${VPN_IS}
    until [[ ! -f ${VPN_IS} ]]
    do
        continue
    done

    openssl req -batch -nodes -newkey ec -pkeyopt ec_paramgen_curve:secp521r1 \
        -keyout ${VPN_SYNC}/nuvlabox-vpn.key -out ${VPN_SYNC}/nuvlabox-vpn.csr \
        -subj "/CN=${NUVLABOX_ID}"

    vpn_credential = $(curl -XPOST -k http://agent:5000/api/commission -H content-type:application/json \
        -d '''{"vpn-csr": "'''$(cat ${VPN_SYNC}/nuvlabox-vpn.csr | sed ':a;N;$!ba;s/\n/\\n/g')'''"}''')

    vpn_certificate = $(echo ${vpn_credential} | jq '.["vpn-certificate"]')
    vpn_intermediate_ca = $(echo ${vpn_credential} | jq '.["vpn-intermediate-ca"]')

    write_vpn_conf

    # deletes the file so that it wait until there's an update
    rm -f ${VPN_IS}
done





