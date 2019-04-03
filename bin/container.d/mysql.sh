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

find_user ${USER}
if [[ $? -ne 0 ]]; then
    useradd --home-dir "/opt/${NAME}" \
            --create-home \
            --shell /sbin/nologin \
            ${USER} || exit 1
fi

make_dir -b "/opt/${NAME}" data run log || exit 1
chown -R ${USER}:${USER} "/opt/${NAME}"

docker run -d \
    --name ${NAME} \
    --restart always \
    --network host \
    --user `grep ${USER} /etc/passwd | cut -d':' -f3` \
    -v /opt/${NAME}/data:/var/lib/${NAME} \
    -v /opt/${NAME}/run:/var/run/${NAME}d \
    -v /opt/${NAME}/log:/var/log/${NAME} \
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
