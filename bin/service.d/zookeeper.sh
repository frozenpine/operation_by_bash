declare -A ZK_LIST
ZK_LIST["zk001"]="172.31.11.14"
ZK_LIST["zk002"]="172.31.11.15"
ZK_LIST["zk003"]="172.31.11.16"

ZK_SERVERS=
ZK_PORT=2181

for SVR_NAME in ${!ZK_LIST[@]}; do
    IP=`grep "${SVR_NAME}" /etc/hosts | awk '{print $1}'`
    if [[ -z ${IP} || ${IP} != "${ZK_LIST[$SVR_NAME]}" ]]; then
        sed -i '/'"${SVR_NAME}"'/d' /etc/hosts
        echo "${ZK_LIST[$SVR_NAME]} ${SVR_NAME}" >> /etc/hosts
    fi
done
