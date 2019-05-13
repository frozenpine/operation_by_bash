VERSION="7.0.0"
NAME=filebeat
USER=

SERVICE_LIST="registry elastic"
for SERVICE in ${SERVICE_LIST}; do
    source "${BASE_DIR}/service.d/${SERVICE}.sh" || {
        echo "service list file missing: ${SERVICE}.sh" >&2
        exit 1
    }
done

if [[ x"LOG_ES" == "x" ]]; then
    ELASTIC_SERVERS=
    for SVR_NAME in ${!ELASTIC_LIST[@]}; do
        ELASTIC_SERVERS="${ELASTIC_SERVERS},\"http://${SVR_NAME}:${ELASTIC_PORT}\""
    done
    ELASTIC_SERVERS=${ELASTIC_SERVERS:1}
else
    ELASTIC_SERVERS="${LOG_ES}"
fi

CONTAINER_BASE="${DATA_BASE:=/opt}/${NAME}"
make_dir -b "${CONTAINER_BASE}" conf || exit 1
cat <<EOF > "${CONTAINER_BASE}/conf/filebeat.yml"
filebeat.config:
  modules:
    path: \${path.config}/modules.d/*.yml
    reload.enabled: true

processors:
- add_cloud_metadata: ~

filebeat.inputs:
- type: log
  paths:
  - ${DATA_BASE:=/opt}/rest/log/*.log
  - ${DATA_BASE:=/opt}/serviceimpl/log/*.log
  - ${DATA_BASE:=/opt}/index/log*/*.log
  - ${DATA_BASE:=/opt}/sms/log*/*.log
  - ${DATA_BASE:=/opt}/scheduler/log*/*.log
  - ${DATA_BASE:=/opt}/tradebase/log*/*.log
  - ${DATA_BASE:=/opt}/order/log*/*.log
  - ${DATA_BASE:=/opt}/query/log*/*.log
  - ${DATA_BASE:=/opt}/clear/log*/*.log
  - ${DATA_BASE:=/opt}/tmdb/log*/*.log
  - ${DATA_BASE:=/opt}/match/log*/*.log
  multiline:
    pattern: '^[0-9]{4}-[0-9]{2}-[0-9]{2}'
    negate: true
    match: after

output.elasticsearch:
  hosts: [${ELASTIC_SERVERS}]
EOF

docker run -d \
    --name ${NAME} \
    --restart always \
    --net="host" \
    -v "${CONTAINER_BASE}/conf/filebeat.yml:/usr/share/filebeat/filebeat.yml:ro" \
    -v "${DATA_BASE:=/opt}:/opt:ro" \
    registry:5000/${NAME}:${VERSION}
