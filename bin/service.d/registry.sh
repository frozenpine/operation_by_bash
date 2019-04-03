declare -A REGISTRY_LIST
REGISTRY_LIST["registry"]="172.31.24.114"

REGISTRY_SERVERS=
REGISTRY_PORT=5000

for SVR_NAME in ${!REGISTRY_LIST[@]}; do
    IP=`grep "${SVR_NAME}" /etc/hosts | awk '{print $1}'`

    if [[ -z ${IP} || ${IP} != "${REGISTRY_LIST[$SVR_NAME]}" ]]; then
        ${SUDO} sed -i 's/'"${SVR_NAME}"' //'  /etc/hosts

        grep "${REGISTRY_LIST[$SVR_NAME]}" /etc/hosts >/dev/null
        if [[ $? -eq 0 ]]; then
            ${SUDO} sed -i '/'${REGISTRY_LIST[${SVR_NAME}]}'/ s/\(.*\)/\1 '"${SVR_NAME}"'/' /etc/hosts
        else
            ${SUDO} sed -i '$a'"${REGISTRY_LIST[$SVR_NAME]} ${SVR_NAME}" /etc/hosts
        fi
    fi
done
