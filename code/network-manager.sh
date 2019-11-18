#!/bin/sh

header_message="NuvlaBox Network Manager
\n\n
This microservice is responsible for setting up the necessary network
configurations for the NuvlaBox to function properly.
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
#
#
#     $1: vpn_ca_certificate
#     $2: vpn_intermediate_ca_is
#     $3: vpn_intermediate_ca
#     $4: vpn_certificate
#     $5: path to nuvlabox-vpn.key
#     $6: vpn_shared_key
#     $7: vpn_common_name_prefix
#     $8: vpn_endpoints_mapped

    cat>${VPN_CONF} <<EOF
client

dev vpn
dev-type tun

# Certificate Configuration
# CA certificate
<ca>
${1}
${2}
${3}
</ca>

# Client Certificate
<cert>
${4}
</cert>

# Client Key
<key>
$(cat $5)
</key>

# Shared key
<tls-crypt>
${6}
</tls-crypt>

remote-cert-tls server

verify-x509-name "${7}" name-prefix

script-security 2
up /opt/nuvlabox/scripts/get_ip.sh

auth-nocache

ping 60
ping-restart 120
compress lz4

${8}

EOF

}


##----- FOR NOW, THE NETWORK MANAGER ONLY SETS UP THE VPN CLIENT -----##

# wait for the VPN IS to be written by the agent
while true
do
    echo 'INFO: waiting for the NuvlaBox agent to mandate which VPN Infrastructure to use in '${VPN_IS}
    until [[ -f ${VPN_IS} ]]
    do
        continue
    done

    openssl req -batch -nodes -newkey ec -pkeyopt ec_paramgen_curve:secp521r1 \
        -keyout ${VPN_SYNC}/nuvlabox-vpn.key -out ${VPN_SYNC}/nuvlabox-vpn.csr \
        -subj "/CN=${NUVLABOX_ID}"

    flatten_csr=$(cat ${VPN_SYNC}/nuvlabox-vpn.csr | sed ':a;N;$!ba;s/\n/\\n/g')

    vpn_conf_fields=$(curl -XPOST -k http://agent:5000/api/commission -H content-type:application/json \
        -d "{\"vpn-csr\": \"${flatten_csr}\"}")

    echo "${vpn_conf_fields}" | jq -e

    if [[ $? -ne 0 ]]
    then
        echo "ERR: Cannot commission with VPN credential...check NuvlaBox Agent logs for more info"
        sleep 20
    else
        vpn_certificate=$(echo ${vpn_conf_fields} | jq -r '.["vpn-certificate"]')
        vpn_intermediate_ca=$(echo ${vpn_conf_fields} | jq -r '.["vpn-intermediate-ca"]')
        vpn_ca_certificate=$(echo ${vpn_conf_fields} | jq -r '.["vpn-ca-certificate"]')
        vpn_intermediate_ca_is=$(echo ${vpn_conf_fields} | jq -r '.["vpn-intermediate-ca-is"]')
        vpn_shared_key=$(echo ${vpn_conf_fields} | jq -r '.["vpn-shared-key"]')
        vpn_common_name_prefix=$(echo ${vpn_conf_fields} | jq -r '.["vpn-common-name-prefix"]')
        vpn_endpoints_mapped=$(echo ${vpn_conf_fields} | jq -r '.["vpn-endpoints-mapped"]')

        write_vpn_conf "${vpn_ca_certificate}" "${vpn_intermediate_ca_is}" "${vpn_intermediate_ca}" \
                        "${vpn_certificate}" "${VPN_SYNC}/nuvlabox-vpn.key" "${vpn_shared_key}" \
                        "${vpn_common_name_prefix}" "${vpn_endpoints_mapped}"

        # deletes the file so that it wait until there's an update
        rm -f ${VPN_IS}
    fi
done





