VERSION="5.0.3"
NAME=redis
USER=${NAME}

SERVICE_LIST="registry"

for SERVICE in ${SERVICE_LIST}; do
    source "${BASE_DIR}/service.d/${SERVICE}.sh" || {
        echo "service list file missing: ${SERVICE}.sh" >&2
        exit 1
    }
done

CONTAINER_BASE="${DATA_BASE:=/opt}/${NAME}"

find_user ${USER}
if [[ $? -ne 0 ]]; then
    ${SUDO} useradd --home-dir "${CONTAINER_BASE}" \
            --create-home \
            --shell /sbin/nologin \
            ${USER} || exit 1
fi

make_dir -b "${CONTAINER_BASE}" data conf || exit 1
${SUDO} chown -R ${USER}:${USER} "${CONTAINER_BASE}"

docker run -d \
    --name ${NAME} \
    --restart always \
    --network host \
    --user `grep ${USER} /etc/passwd | cut -d':' -f3` \
    -v "${CONTAINER_BASE}/data:/data" \
    -v "${CONTAINER_BASE}/conf:/usr/local/etc/${NAME}" \
    registry:5000/${NAME}:${VERSION} redis-server --appendonly yes
