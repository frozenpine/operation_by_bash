VERSION="v2.7.0"
NAME=prometheus
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

make_dir -b "/opt/${NAME}" || exit 1
chown -R ${USER}:${USER} "/opt/${NAME}"

make_dir -b "/etc/${NAME}" || exit 1

docker run -d \
    --name ${NAME} \
    --restart always \
    --network host \
    --user `grep ${USER} /etc/passwd | cut -d':' -f3` \
    -v /etc/${NAME}:/etc/${NAME}:ro \
    -v /opt/${NAME}:/${NAME} \
    registry:5000/${NAME}:${VERSION}
