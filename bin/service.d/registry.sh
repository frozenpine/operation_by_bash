declare -A REGISTRY_LIST
REGISTRY_LIST["registry"]="172.31.11.0"

REGISTRY_SERVERS=
REGISTRY_PORT=5000

for SVR_NAME in ${!REGISTRY_LIST[@]}; do
    IP=`grep "${SVR_NAME}" /etc/hosts | awk '{print $1}'`
    if [[ -z ${IP} || ${IP} != "${REGISTRY_LIST[$SVR_NAME]}" ]]; then
        sed -i '/'"${SVR_NAME}"'/d' /etc/hosts
        echo "${REGISTRY_LIST[$SVR_NAME]} ${SVR_NAME}" >> /etc/hosts
    fi
done
