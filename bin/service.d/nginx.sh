declare -A NGINX_LIST
NGINX_LIST["front001"]="172.31.11.1"
NGINX_LIST["front002"]="172.31.11.2"
NGINX_LIST["front003"]="172.31.11.7"

NGINX_SERVERS=
MYSQL_PORT=3306

for SVR_NAME in ${!NGINX_LIST[@]}; do
    IP=`grep "${SVR_NAME}" /etc/hosts | awk '{print $1}'`
    if [[ -z ${IP} || ${IP} != "${NGINX_LIST[$SVR_NAME]}" ]]; then
        sed -i '/'"${SVR_NAME}"'/d' /etc/hosts
        echo "${NGINX_LIST[$SVR_NAME]} ${SVR_NAME}" >> /etc/hosts
    fi
done
