declare -A ES_LIST
ES_LIST["es"]="172.31.24.114"
# ES_LIST["es001"]="172.31.11.14"
# ES_LIST["es002"]="172.31.11.15"
# ES_LIST["es003"]="172.31.11.16"

ES_SERVERS=
ES_PORT=9300

for SVR_NAME in ${!ES_LIST[@]}; do
    IP=`grep "${SVR_NAME}" /etc/hosts | awk '{print $1}'`

    if [[ -z ${IP} || ${IP} != "${ES_LIST[$SVR_NAME]}" ]]; then
        ${SUDO} sed -i 's/'"${SVR_NAME}"' //'  /etc/hosts

        grep "${ES_LIST[$SVR_NAME]}" /etc/hosts >/dev/null
        if [[ $? -eq 0 ]]; then
            ${SUDO} sed -i '/'${ES_LIST[${SVR_NAME}]}'/ s/\(.*\)/\1 '"${SVR_NAME}"'/' /etc/hosts
        else
            ${SUDO} sed -i '$a'"${ES_LIST[$SVR_NAME]} ${SVR_NAME}" /etc/hosts
        fi
    fi
done
