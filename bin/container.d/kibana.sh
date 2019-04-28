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

ES_SERVERS=
for SVR_NAME in ${!ELASTIC_LIST[@]}; do
    ES_SERVERS="${ES_SERVERS},\"http://${SVR_NAME}:${ELASTIC_PORT}\""
done
ES_SERVERS=${ES_SERVERS:1}

CONTAINER_BASE="${DATA_BASE:=/opt}/${NAME}"
make_dir -b "${CONTAINER_BASE}" conf || exit 1
${SUDO} cat<<EOF >"${CONTAINER_BASE}/conf/kibana.yml"
server.name: kibana
server.host: "0"
elasticsearch.hosts: [ ${ES_SERVERS} ]
xpack.monitoring.ui.container.elasticsearch.enabled: true
EOF
${SUDO} chown -R ${USER}:${USER} "/opt/${NAME}"

make_dir -b "/etc/${NAME}" || exit 1

docker run -d \
    --name ${NAME} \
    --restart always \
    --network host \
    --user `grep ${USER} /etc/passwd | cut -d':' -f3` \
    -v "${CONTAINER_BASE}/conf/kibana.yml":/usr/share/kibana/config/kibana.yml:ro \
    registry:5000/${NAME}:${VERSION}
