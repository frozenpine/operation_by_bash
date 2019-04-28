VERSION="7.0.0"
NAME=kibana
USER=${NAME}

SERVICE_LIST="registry elastic"
for SERVICE in ${SERVICE_LIST}; do
    source "${BASE_DIR}/service.d/${SERVICE}.sh" || {
        echo "service list file missing: ${SERVICE}.sh" >&2
        exit 1
    }
done

find_user ${USER}
if [[ $? -ne 0 ]]; then
    useradd --home-dir "/opt/${NAME}" \
            --create-home \
            --shell /sbin/nologin \
            ${USER} || exit 1
fi

# make_dir -b "${DATA_BASE:=/opt}/${NAME}" || exit 1
# chown -R ${USER}:${USER} "/opt/${NAME}"
# 
# make_dir -b "/etc/${NAME}" || exit 1

ES_SERVERS=
for SVR_NAME in ${!ELASTIC_LIST[@]}; do
    ES_SERVERS="${ES_SERVERS},http://${SVR_NAME}:${ELASTIC_PORT}"
done
ES_SERVERS=${ES_SERVERS:1}

docker run -d \
    --name ${NAME} \
    --restart always \
    --network host \
    --user `grep ${USER} /etc/passwd | cut -d':' -f3` \
    -e ELASTICSEARCH_HOSTS=${ES_SERVERS} \
    registry:5000/${NAME}:${VERSION}
