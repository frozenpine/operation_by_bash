declare -A REDIS_LIST
REDIS_LIST["redis001"]="172.31.11.9"

REDIS_SERVERS=
REDIS_PORT=6379

for SVR_NAME in ${!REDIS_LIST[@]}; do
    IP=`grep "${SVR_NAME}" /etc/hosts | awk '{print $1}'`
    if [[ -z ${IP} || ${IP} != "${REDIS_LIST[$SVR_NAME]}" ]]; then
        sed -i '/'"${SVR_NAME}"'/d' /etc/hosts
        echo "${REDIS_LIST[$SVR_NAME]} ${SVR_NAME}" >> /etc/hosts
    fi
done
