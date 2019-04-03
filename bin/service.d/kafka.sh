declare -A KAFKA_LIST
KAFKA_LIST["kafka002"]="172.31.11.10"
KAFKA_LIST["kafka003"]="172.31.11.11"
KAFKA_LIST["kafka004"]="172.31.11.17"

KAFKA_SERVERS=
KAFKA_PORT=9092

for SVR_NAME in ${!KAFKA_LIST[@]}; do
    IP=`grep "${SVR_NAME}" /etc/hosts | awk '{print $1}'`
    if [[ -z ${IP} || ${IP} != "${KAFKA_LIST[$SVR_NAME]}" ]]; then
        sed -i '/'"${SVR_NAME}"'/d' /etc/hosts
        echo "${KAFKA_LIST[$SVR_NAME]} ${SVR_NAME}" >> /etc/hosts
    fi
done
