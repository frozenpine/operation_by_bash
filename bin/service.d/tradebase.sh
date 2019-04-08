declare -A TRADEBASE_LIST
TRADEBASE_LIST["sso"]="172.31.24.111"
# TRADEBASE_LIST["zk001"]="172.31.11.14"
# TRADEBASE_LIST["zk002"]="172.31.11.15"
# TRADEBASE_LIST["zk003"]="172.31.11.16"

ZK_SERVERS=
SSO_PORT=9091

for SVR_NAME in ${!TRADEBASE_LIST[@]}; do
    IP=`grep "${SVR_NAME}" /etc/hosts | awk '{print $1}'`
    
    if [[ -z ${IP} || ${IP} != "${TRADEBASE_LIST[$SVR_NAME]}" ]]; then
        ${SUDO} sed -i 's/'"${SVR_NAME}"' //'  /etc/hosts

        grep "${TRADEBASE_LIST[$SVR_NAME]}" /etc/hosts >/dev/null
        if [[ $? -eq 0 ]]; then
            ${SUDO} sed -i '/'${TRADEBASE_LIST[${SVR_NAME}]}'/ s/\(.*\)/\1 '"${SVR_NAME}"'/' /etc/hosts
        else
            ${SUDO} sed -i '$a'"${TRADEBASE_LIST[$SVR_NAME]} ${SVR_NAME}" /etc/hosts
        fi
    fi
done
