VERSION="3.4.13"
NAME=zookeeper
USER=${NAME}

CLIENT_PORT=2181
SVR_PORT1=2888
SVR_PORT2=3888

SERVICE_LIST="registry zookeeper"

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

make_dir -b"${CONTAINER_BASE}" conf data datalog || exit 1
${SUDO} chown -R ${USER}:${USER} "${CONTAINER_BASE}"

get_id `uname -n`
ZID=${ID}

ZSERVERS=

if [[ ${#ZK_LIST[@]} -gt 1 ]]; then
    for SVR_NAME in ${!ZK_LIST[@]}; do
        get_id ${SVR_NAME}
        ZSERVERS="${ZSERVERS} server.${ID}=${ZK_LIST[$SVR_NAME]}:${SVR_PORT1}:${SVR_PORT2}"
    done

    docker run -d \
        --name ${NAME} \
        --restart always \
        --network host \
        --user `grep ${USER} /etc/passwd | cut -d':' -f3` \
        -v "${CONTAINER_BASE}/conf:/conf" \
        -v "${CONTAINER_BASE}/data:/data" \
        -v "${CONTAINER_BASE}/datalog:/datalog" \
        -e ZOO_MY_ID=${ZID} \
        -e ZOO_SERVERS="${ZSERVERS}" \
        -e JMXPORT=1099 \
        registry:5000/${NAME}:${VERSION}
else
    docker run -d \
        --name ${NAME} \
        --restart always \
        --network host \
        --user `grep ${USER} /etc/passwd | cut -d':' -f3` \
        -v "${CONTAINER_BASE}/conf:/conf" \
        -v "${CONTAINER_BASE}/data:/data" \
        -v "${CONTAINER_BASE}/datalog:/datalog" \
        -e ZOO_STANDALONE_ENABLED="true" \
        -e JMXPORT=1099 \
        registry:5000/${NAME}:${VERSION}
fi
