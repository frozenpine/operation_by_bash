VERSION=${TRADE_MATCH_VERSION}

if [[ -z ${VERSION} ]]; then
    error "match version missing."
    exit 1
fi

NAME=match
USER=${NAME}

JVM_OPTS=${TRADE_MATCH_JVM}

SENTRY_DSN=`get_sentry_dsn ${NAME}`

SERVICE_LIST="registry zookeeper kafka match"

for SERVICE in ${SERVICE_LIST}; do
    source "${BASE_DIR}/service.d/${SERVICE}.sh" || {
        echo "service list file missing: ${SERVICE}.sh" >&2
        exit 1
    }
done

KAFKA_SERVERS=
for SVR_NAME in ${!KAFKA_LIST[@]}; do
    KAFKA_SERVERS="${KAFKA_SERVERS},${SVR_NAME}:${KAFKA_PORT}"
done
KAFKA_SERVERS=${KAFKA_SERVERS:1}

CONTAINER_BASE="${DATA_BASE:=/opt}/${NAME}"
find_user ${USER}
if [[ $? -ne 0 ]]; then
    ${SUDO} useradd --home-dir "${CONTAINER_BASE}" \
            --create-home \
            --shell /sbin/nologin \
            ${USER} || exit 1
fi
make_dir -b "${CONTAINER_BASE}" log || exit 1
${SUDO} chown -R ${USER}:${USER} "${CONTAINER_BASE}"

docker run -d \
    --name ${NAME} \
    --restart no \
    --network host \
    --user `grep ${USER} /etc/passwd | cut -d':' -f3` \
    -e SENTRY_DSN="${SENTRY_DSN}" \
    -e LOG_LEVEL_ROOT=${LOG_LEVEL:=info} \
    -v "${CONTAINER_BASE}/log":/${NAME}/logs \
    registry:5000/trade$1/${NAME}:${VERSION} \
        ${JVM_OPTS} \
        -jar /${NAME}/trade$1-${NAME}-${VERSION}.jar \
        --server.port=${MATCH_PORT} \
        --logging.level.com.js.trade=${LOG_LEVEL:=info} \
        --com.js.trade.handle.producer.properties.bootstrap.servers=${KAFKA_SERVERS} \
        --com.js.trade.handle.producer.max.request.size=52428800 \
        --com.js.trade.handle.consumer.properties.bootstrap.servers=${KAFKA_SERVERS} \
        --com.js.trade.handle.consumer.properties.fetch.max.bytes=52428800 \
        &>/dev/null
