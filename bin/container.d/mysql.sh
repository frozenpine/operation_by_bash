VERSION="5.7.25"
NAME=mysql
USER=${NAME}

ADMIN_PASSWD="quantdo123456"

SERVICE_LIST="registry"

for SERVICE in ${SERVICE_LIST}; do
    source "${BASE_DIR}/service.d/${SERVICE}.sh" || {
        echo "service list file missing: ${SERVICE}.sh" >&2
        exit 1
    }
done

get_id `uname -n`
SERVER_ID=${ID}

CONTAINER_BASE="${DATA_BASE:=/opt}/${NAME}"
find_user ${USER}
if [[ $? -ne 0 ]]; then
    ${SUDO} useradd --home-dir "${CONTAINER_BASE}" \
            --create-home \
            --shell /sbin/nologin \
            ${USER} || exit 1
fi

make_dir -b "${CONTAINER_BASE}" data run log || exit 1
${SUDO} chown -R ${USER}:${USER} "${CONTAINER_BASE}"

docker run -d \
    --name ${NAME} \
    --restart always \
    --network host \
    --user `grep ${USER} /etc/passwd | cut -d':' -f3` \
    -v "${CONTAINER_BASE}/data:/var/lib/${NAME}" \
    -v "${CONTAINER_BASE}/run:/var/run/${NAME}" \
    -v "${CONTAINER_BASE}/log:/var/log/${NAME}" \
    -e MYSQL_ROOT_PASSWORD="${ADMIN_PASSWD}" \
    registry:5000/${NAME}:${VERSION} \
        --character-set-server=utf8mb4 \
        --collation-server=utf8mb4_unicode_ci \
        --server-id=${SERVER_ID} \
        --log-bin=mysql-bin \
        --back-log=7 \
        --binlog-format=row \
        --max-binlog-size=1G \
        --auto-increment-increment=2 \
        --auto-increment-offset=${SERVER_ID} \
        --relay-log=mysql-relay-bin \
        --sync-binlog=1
