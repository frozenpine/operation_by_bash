VERSION=${TRADE_TMES_VERSION}

if [[ -z ${VERSION} ]]; then
    error "tmes version missing."
    exit 1
fi

NAME=tmes
USER=${NAME}

JVM_OPTS=${TRADE_TMES_JVM}

SENTRY_DSN=`get_sentry_dsn ${NAME}`

DB_NAME="clear"

SERVICE_LIST="registry zookeeper kafka elastic tmes"
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

ELASTIC_SERVERS=
for SVR_NAME in ${!ELASTIC_LIST[@]}; do
    ELASTIC_SERVERS="${ELASTIC_SERVERS},${SVR_NAME}:$((ELASTIC_PORT+100))"
done
ELASTIC_SERVERS=${ELASTIC_SERVERS:1}

SELF_IP=`ip address show eth0 | grep inet | grep -v inet6 | awk '{print $2}' | cut -d'/' -f1`

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
        --logging.level.com.quantdo.trade=${LOG_LEVEL:=info} \
        --server.address=${SELF_IP} \
        --server.port=${TMES_PORT} \
        --spring.data.elasticsearch.cluster-nodes=${ELASTIC_SERVERS} \
        --com.quantdo.trade.sink.properties.bootstrap.servers=${KAFKA_SERVERS} \
        --com.quantdo.trade.sink.source-topic=${SINK_TOPIC:=DBTOPIC} \
        --com.quantdo.trade.sink.properties.fetch.max.wait.ms=10 \
        --com.quantdo.trade.sink.properties.heartbeat.interval.ms=10000 \
        --com.quantdo.trade.sink.properties.session.timeout.ms=30000 \
        --com.quantdo.trade.sink.properties.max.poll.records=1000 \
        --com.quantdo.trade.sink.properties.max.poll.interval.ms=300000 \
