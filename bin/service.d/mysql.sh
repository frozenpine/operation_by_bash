declare -A MYSQL_LIST
MYSQL_LIST["mysql001"]="172.31.11.12"
MYSQL_LIST["mysql002"]="172.31.11.13"

MYSQL_SERVERS=
MYSQL_PORT=3306

for SVR_NAME in ${!MYSQL_LIST[@]}; do
    IP=`grep "${SVR_NAME}" /etc/hosts | awk '{print $1}'`
    if [[ -z ${IP} || ${IP} != "${MYSQL_LIST[$SVR_NAME]}" ]]; then
        sed -i '/'"${SVR_NAME}"'/d' /etc/hosts
        echo "${MYSQL_LIST[$SVR_NAME]} ${SVR_NAME}" >> /etc/hosts
    fi
done
