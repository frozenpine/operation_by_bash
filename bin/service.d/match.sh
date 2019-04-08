declare -A MATCH_LIST
MATCH_LIST["match"]="172.31.24.111"
# MATCH_LIST["zk001"]="172.31.11.14"
# MATCH_LIST["zk002"]="172.31.11.15"
# MATCH_LIST["zk003"]="172.31.11.16"

MATCH_PORT=9391

for SVR_NAME in ${!MATCH_LIST[@]}; do
    IP=`grep "${SVR_NAME}" /etc/hosts | awk '{print $1}'`
    
    if [[ -z ${IP} || ${IP} != "${MATCH_LIST[$SVR_NAME]}" ]]; then
        ${SUDO} sed -i 's/'"${SVR_NAME}"' //'  /etc/hosts

        grep "${MATCH_LIST[$SVR_NAME]}" /etc/hosts >/dev/null
        if [[ $? -eq 0 ]]; then
            ${SUDO} sed -i '/'${MATCH_LIST[${SVR_NAME}]}'/ s/\(.*\)/\1 '"${SVR_NAME}"'/' /etc/hosts
        else
            ${SUDO} sed -i '$a'"${MATCH_LIST[$SVR_NAME]} ${SVR_NAME}" /etc/hosts
        fi
    fi
done
