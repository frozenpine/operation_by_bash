VERSION="0.11.0"
NAME=jmx-prometheus-exporter
USER=jmx
SERVICE_PORT=5556
JVM_OPTS=
CONFIG_DIR="/opt/jmx_exporter/config"

SERVICE_LIST="registry"

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

if [[ $# -gt 0 ]]; then
    CONFIG_YML="${CONFIG_DIR}/${1}.yml"
fi

docker run -d \
    --name ${NAME} \
    --restart always \
    --network host \
    --user `grep ${USER} /etc/passwd | cut -d':' -f3` \
    -v /opt/${NAME}/config:${CONFIG_DIR} \
    -e SERVICE_PORT=${SERVICE_PORT} \
    -e JVM_OPT="${JVM_OPT}" \
    -e CONFIG_YML="${CONFIG_YML}" \
    registry:5000/${NAME}:${VERSION}
