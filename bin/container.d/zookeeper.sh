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

find_user ${USER}
if [[ $? -ne 0 ]]; then
    useradd --home-dir "/opt/${NAME}" \
            --create-home \
            --shell /sbin/nologin \
            ${USER} || exit 1
fi

make_dir -b"/opt/${NAME}" conf data datalog || exit 1
chown -R ${USER}:${USER} "/opt/${NAME}"

get_id `uname -n`
ZID=${ID}

ZSERVERS=

for SVR_NAME in ${!ZK_LIST[@]}; do
    get_id ${SVR_NAME}
    ZSERVERS="${ZSERVERS} server.${ID}=${ZK_LIST[$SVR_NAME]}:${SVR_PORT1}:${SVR_PORT2}"
done

docker run -d \
    --name ${NAME} \
    --restart always \
    --network host \
    --user `grep ${USER} /etc/passwd | cut -d':' -f3` \
    -v /opt/${NAME}/conf:/conf \
    -v /opt/${NAME}/data:/data \
    -v /opt/${NAME}/datalog:/datalog \
    -e ZOO_MY_ID=${ZID} \
    -e ZOO_SERVERS="${ZSERVERS}" \
    -e JMXPORT=1099 \
    registry:5000/${NAME}:${VERSION}
