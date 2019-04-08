declare -A DIGITAL_LIST
DIGITAL_LIST["mgmt"]="172.31.24.112"
# DIGITAL_LIST["zk001"]="172.31.11.14"
# DIGITAL_LIST["zk002"]="172.31.11.15"
# DIGITAL_LIST["zk003"]="172.31.11.16"

REST_PORT=9089

for SVR_NAME in ${!DIGITAL_LIST[@]}; do
    IP=`grep "${SVR_NAME}" /etc/hosts | awk '{print $1}'`
    
    if [[ -z ${IP} || ${IP} != "${DIGITAL_LIST[$SVR_NAME]}" ]]; then
        ${SUDO} sed -i 's/'"${SVR_NAME}"' //'  /etc/hosts

        grep "${DIGITAL_LIST[$SVR_NAME]}" /etc/hosts >/dev/null
        if [[ $? -eq 0 ]]; then
            ${SUDO} sed -i '/'${DIGITAL_LIST[${SVR_NAME}]}'/ s/\(.*\)/\1 '"${SVR_NAME}"'/' /etc/hosts
        else
            ${SUDO} sed -i '$a'"${DIGITAL_LIST[$SVR_NAME]} ${SVR_NAME}" /etc/hosts
        fi
    fi
done
