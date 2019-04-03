declare -A NGINX_LIST
NGINX_LIST["nginx"]="172.31.24.114"
# NGINX_LIST["front001"]="172.31.11.1"
# NGINX_LIST["front002"]="172.31.11.2"
# NGINX_LIST["front003"]="172.31.11.7"

NGINX_SERVERS=
MYSQL_PORT=3306

for SVR_NAME in ${!NGINX_LIST[@]}; do
    IP=`grep "${SVR_NAME}" /etc/hosts | awk '{print $1}'`

    if [[ -z ${IP} || ${IP} != "${NGINX_LIST[$SVR_NAME]}" ]]; then
        ${SUDO} sed -i 's/'"${SVR_NAME}"' //'  /etc/hosts

        grep "${NGINX_LIST[$SVR_NAME]}" /etc/hosts >/dev/null
        if [[ $? -eq 0 ]]; then
            ${SUDO} sed -i '/'${NGINX_LIST[${SVR_NAME}]}'/ s/\(.*\)/\1 '"${SVR_NAME}"'/' /etc/hosts
        else
            ${SUDO} sed -i '$a'"${NGINX_LIST[$SVR_NAME]} ${SVR_NAME}" /etc/hosts
        fi
    fi
done
