VERSION="latest"
NAME=nexus3
USER=200

SERVICE_LIST="registry"

for SERVICE in ${SERVICE_LIST}; do
    source "${BASE_DIR}/service.d/${SERVICE}.sh" || {
        echo "service list file missing: ${SERVICE}.sh" >&2
        exit 1
    }
done

CONTAINER_BASE="${DATA_BASE:=/opt}/${NAME}"
make_dir -b "${CONTAINER_BASE}" oss || exit 1

${SUDO} chown -R ${USER} "${CONTAINER_BASE}"

docker run -d \
    --name ${NAME} \
    --restart always \
    --network host \
    -v "${CONTAINER_BASE}/oss":/nexus-data \
    registry:5000/${NAME}
