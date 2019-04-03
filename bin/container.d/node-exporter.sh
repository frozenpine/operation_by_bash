VERSION="v0.17.0"

SERVICE_LIST="registry"

for SERVICE in ${SERVICE_LIST}; do
    source "${BASE_DIR}/service.d/${SERVICE}.sh" || {
        echo "service list file missing: ${SERVICE}.sh" >&2
        exit 1
    }
done

docker run -d \
    --name node-exporter \
    -p 9100:9100 \
    --restart always \
    --net="host" \
    --pid="host" \
    -v "/:/host:ro,rslave" \
    registry:5000/node-exporter:${VERSION} \
    --path.rootfs /host \
    --collector.interrupts \
    --collector.systemd \
    --log.level="warn"
