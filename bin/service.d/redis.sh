declare -A REDIS_LIST
REDIS_LIST["redis"]="172.31.24.111"

REDIS_SERVERS=
REDIS_PORT=6379

for SVR_NAME in ${!REDIS_LIST[@]}; do
    IP=`grep "${SVR_NAME}" /etc/hosts | awk '{print $1}'`

    if [[ -z ${IP} || ${IP} != "${REDIS_LIST[$SVR_NAME]}" ]]; then
        ${SUDO} sed -i 's/'"${SVR_NAME}"' //'  /etc/hosts

        grep "${REDIS_LIST[$SVR_NAME]}" /etc/hosts >/dev/null
        if [[ $? -eq 0 ]]; then
            ${SUDO} sed -i '/'${REDIS_LIST[${SVR_NAME}]}'/ s/\(.*\)/\1 '"${SVR_NAME}"'/' /etc/hosts
        else
            ${SUDO} sed -i '$a'"${REDIS_LIST[$SVR_NAME]} ${SVR_NAME}" /etc/hosts
        fi
    fi
done
