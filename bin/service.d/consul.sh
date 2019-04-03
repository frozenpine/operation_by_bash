declare -A CONSUL_LIST
CONSUL_LIST["consul"]="172.31.24.114"
# CONSUL_LIST["consul001"]="172.31.11.14"
# CONSUL_LIST["consul002"]="172.31.11.15"
# CONSUL_LIST["consul003"]="172.31.11.16"

CONSUL_SERVERS=
CONSUL_PORT=8500

for SVR_NAME in ${!CONSUL_LIST[@]}; do
    IP=`grep "${SVR_NAME}" /etc/hosts | awk '{print $1}'`

    if [[ -z ${IP} || ${IP} != "${CONSUL_LIST[$SVR_NAME]}" ]]; then
        ${SUDO} sed -i 's/'"${SVR_NAME}"' //'  /etc/hosts

        grep "${CONSUL_LIST[$SVR_NAME]}" /etc/hosts >/dev/null
        if [[ $? -eq 0 ]]; then
            ${SUDO} sed -i '/'${CONSUL_LIST[${SVR_NAME}]}'/ s/\(.*\)/\1 '"${SVR_NAME}"'/' /etc/hosts
        else
            ${SUDO} sed -i '$a'"${CONSUL_LIST[$SVR_NAME]} ${SVR_NAME}" /etc/hosts
        fi
    fi
done
