declare -A SSO_LIST
SSO_LIST["sso"]="172.31.24.111"
# SSO_LIST["zk001"]="172.31.11.14"
# SSO_LIST["zk002"]="172.31.11.15"
# SSO_LIST["zk003"]="172.31.11.16"

SSO_PORT=9091

for SVR_NAME in ${!SSO_LIST[@]}; do
    IP=`grep "${SVR_NAME}" /etc/hosts | awk '{print $1}'`
    
    if [[ -z ${IP} || ${IP} != "${SSO_LIST[$SVR_NAME]}" ]]; then
        ${SUDO} sed -i 's/'"${SVR_NAME}"' //'  /etc/hosts

        grep "${SSO_LIST[$SVR_NAME]}" /etc/hosts >/dev/null
        if [[ $? -eq 0 ]]; then
            ${SUDO} sed -i '/'${SSO_LIST[${SVR_NAME}]}'/ s/\(.*\)/\1 '"${SVR_NAME}"'/' /etc/hosts
        else
            ${SUDO} sed -i '$a'"${SSO_LIST[$SVR_NAME]} ${SVR_NAME}" /etc/hosts
        fi
    fi
done
