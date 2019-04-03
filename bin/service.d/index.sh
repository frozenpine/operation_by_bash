declare -A INDEX_LIST
INDEX_LIST["index"]="172.31.24.111"
# INDEX_LIST["zk001"]="172.31.11.14"
# INDEX_LIST["zk002"]="172.31.11.15"
# INDEX_LIST["zk003"]="172.31.11.16"

ZK_SERVERS=
ZK_PORT=2181

for SVR_NAME in ${!INDEX_LIST[@]}; do
    IP=`grep "${SVR_NAME}" /etc/hosts | awk '{print $1}'`
    
    if [[ -z ${IP} || ${IP} != "${INDEX_LIST[$SVR_NAME]}" ]]; then
        ${SUDO} sed -i 's/'"${SVR_NAME}"' //'  /etc/hosts

        grep "${INDEX_LIST[$SVR_NAME]}" /etc/hosts >/dev/null
        if [[ $? -eq 0 ]]; then
            ${SUDO} sed -i '/'${INDEX_LIST[${SVR_NAME}]}'/ s/\(.*\)/\1 '"${SVR_NAME}"'/' /etc/hosts
        else
            ${SUDO} sed -i '$a'"${INDEX_LIST[$SVR_NAME]} ${SVR_NAME}" /etc/hosts
        fi
    fi
done
