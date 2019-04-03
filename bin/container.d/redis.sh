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

find_user ${USER}
if [[ $? -ne 0 ]]; then
    useradd --home-dir "/opt/${NAME}" \
            --create-home \
            --shell /sbin/nologin \
            ${USER} || exit 1
fi

make_dir -b "/opt/${NAME}" data conf || exit 1
chown -R ${USER}:${USER} "/opt/${NAME}"

docker run -d \
    --name ${NAME} \
    --restart always \
    --network host \
    --user `grep ${USER} /etc/passwd | cut -d':' -f3` \
    -v /opt/${NAME}/data:/data \
    -v /opt/${NAME}/conf:/usr/local/etc/${NAME} \
    registry:5000/${NAME}:${VERSION} redis-server --appendonly yes
