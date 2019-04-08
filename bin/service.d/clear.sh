declare -A CLEAR_LIST
CLEAR_LIST["clear"]="172.31.24.114"
# CLEAR_LIST["zk001"]="172.31.11.14"
# CLEAR_LIST["zk002"]="172.31.11.15"
# CLEAR_LIST["zk003"]="172.31.11.16"

CLEAR_PORT=9291

for SVR_NAME in ${!CLEAR_LIST[@]}; do
    IP=`grep "${SVR_NAME}" /etc/hosts | awk '{print $1}'`
    
    if [[ -z ${IP} || ${IP} != "${CLEAR_LIST[$SVR_NAME]}" ]]; then
        ${SUDO} sed -i 's/'"${SVR_NAME}"' //'  /etc/hosts

        grep "${CLEAR_LIST[$SVR_NAME]}" /etc/hosts >/dev/null
        if [[ $? -eq 0 ]]; then
            ${SUDO} sed -i '/'${CLEAR_LIST[${SVR_NAME}]}'/ s/\(.*\)/\1 '"${SVR_NAME}"'/' /etc/hosts
        else
            ${SUDO} sed -i '$a'"${CLEAR_LIST[$SVR_NAME]} ${SVR_NAME}" /etc/hosts
        fi
    fi
done
