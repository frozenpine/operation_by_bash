declare -A CONSUL_LIST
CONSUL_LIST["consul001"]="172.31.11.14"
CONSUL_LIST["consul002"]="172.31.11.15"
CONSUL_LIST["consul003"]="172.31.11.16"

CONSUL_SERVERS=
CONSUL_PORT=8500

for SVR_NAME in ${!CONSUL_LIST[@]}; do
    HOST_IP=`grep "${SVR_NAME}" /etc/hosts | awk '{print $1}'`

    if [[ -n ${HOST_IP} && ${HOST_IP} != "${CONSUL_LIST[$SVR_NAME]}" ]]; then
        sed -i 's/\(.*\)'"${SVR_NAME}"'\(.*\)/\1\2/g' /etc/hosts
    fi

    if [[ -z ${HOST_IP} ]]; then
        echo "${CONSUL_LIST[$SVR_NAME]} ${SVR_NAME}" >> /etc/hosts
    fi
done
