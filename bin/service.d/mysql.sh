declare -A MYSQL_LIST
MYSQL_LIST["mysql"]="172.31.24.112"
# MYSQL_LIST["mysql001"]="172.31.11.12"
# MYSQL_LIST["mysql002"]="172.31.11.13"

MYSQL_SERVERS=
MYSQL_PORT=3306

for SVR_NAME in ${!MYSQL_LIST[@]}; do
    IP=`grep "${SVR_NAME}" /etc/hosts | awk '{print $1}'`

    if [[ -z ${IP} || ${IP} != "${MYSQL_LIST[$SVR_NAME]}" ]]; then
        ${SUDO} sed -i 's/'"${SVR_NAME}"' //'  /etc/hosts

        grep "${MYSQL_LIST[$SVR_NAME]}" /etc/hosts >/dev/null
        if [[ $? -eq 0 ]]; then
            ${SUDO} sed -i '/'${MYSQL_LIST[${SVR_NAME}]}'/ s/\(.*\)/\1 '"${SVR_NAME}"'/' /etc/hosts
        else
            ${SUDO} sed -i '$a'"${MYSQL_LIST[$SVR_NAME]} ${SVR_NAME}" /etc/hosts
        fi
    fi
done
