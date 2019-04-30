VERSION="7.0.0"
NAME=filebeat
USER=

SERVICE_LIST="registry"

for SERVICE in ${SERVICE_LIST}; do
    source "${BASE_DIR}/service.d/${SERVICE}.sh" || {
        echo "service list file missing: ${SERVICE}.sh" >&2
        exit 1
    }
done

CONTAINER_BASE="${DATA_BASE:=/opt}/${NAME}"
make_dir -b "${CONTAINER_BASE}" conf || exit 1
cat <<EOF > "${CONTAINER_BASE}/conf/filebeat.yml"
filebeat.config:
  modules:
    path: \${path.config}/modules.d/*.yml
    reload.enabled: false

processors:
- add_cloud_metadata: ~

filebeat.inputs:
- type: log
  paths:
  - /opt/*/log/*.log
  - /opt/*/logs/*.log
  multiline:
    pattern: '^[0-9]{4}-[0-9]{2}-[0-9]{2}'
    negate: true
    match: after

output.elasticsearch:
  hosts: [${ELASTIC_SERVERS}]
  index: "filebeat-%{[agent.version]}-%{+yyyy.MM.dd}"
EOF

docker run -d \
    --name ${NAME} \
    --restart always \
    --net="host" \
    -v "${CONTAINER_BASE}/conf/filebeat.yml:/usr/share/filebeat/filebeat.yml:ro" \
    -v "${DATA_BASE:=/opt}:/opt:ro" \
    registry:5000/${NAME}:${VERSION}
