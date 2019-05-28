VERSION=${TRADE_CLEAR_VERSION}

if [[ -z ${VERSION} ]]; then
    error "clear version missing."
    exit 1
fi

NAME=clear
USER=${NAME}

JVM_OPTS=${TRADE_CLEAR_JVM}

SENTRY_DSN=`get_sentry_dsn ${NAME}`

SERVICE_LIST="registry zookeeper kafka consul clear"

for SERVICE in ${SERVICE_LIST}; do
    source "${BASE_DIR}/service.d/${SERVICE}.sh" || {
        echo "service list file missing: ${SERVICE}.sh" >&2
        exit 1
    }
done

CONSUL_HOST=
IDX=$((RANDOM % ${#CONSUL_LIST[@]}))
COUNT=0
for SVR_NAME in ${!CONSUL_LIST[@]}; do
    if [[ ${COUNT} -eq ${IDX} ]]; then
        CONSUL_HOST=${CONSUL_LIST[$SVR_NAME]}
        break
    fi

    COUNT=$((COUNT+1))
done

KAFKA_SERVERS=
for SVR_NAME in ${!KAFKA_LIST[@]}; do
    KAFKA_SERVERS="${KAFKA_SERVERS},${SVR_NAME}:${KAFKA_PORT}"
done
KAFKA_SERVERS=${KAFKA_SERVERS:1}

SELF_IP=`ip address show eth0 | grep inet | grep -v inet6 | awk '{print $2}' | cut -d'/' -f1`

CONTAINER_BASE="${DATA_BASE:=/opt}/${NAME}"
find_user ${USER}
if [[ $? -ne 0 ]]; then
    ${SUDO} useradd --home-dir "${CONTAINER_BASE}" \
            --create-home \
            --shell /sbin/nologin \
            ${USER} || exit 1
fi
make_dir -b "${CONTAINER_BASE}" log data || exit 1
${SUDO} chown -R ${USER}:${USER} "${CONTAINER_BASE}"

docker run -d \
    --name ${NAME} \
    --restart no \
    --network host \
    --user `grep ${USER} /etc/passwd | cut -d':' -f3` \
    -e SENTRY_DSN="${SENTRY_DSN}" \
    -e LOG_LEVEL_ROOT=${LOG_LEVEL:=info} \
    -v "${CONTAINER_BASE}/log":/${NAME}/logs \
    -v "${CONTAINER_BASE}/log":/${NAME}/data \
    registry:5000/trade$1/${NAME}:${VERSION} \
        ${JVM_OPTS} \
        -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/${NAME}/data/heapdump.hprof \
        -jar /${NAME}/trade$1-${NAME}-${VERSION}.jar \
        --logging.level.com.quantdo.trade=${LOG_LEVEL:=info} \
        --server.address=${SELF_IP} \
        --server.port=${CLEAR_PORT} \
        --com.quantdo.trade.consul.host=${CONSUL_HOST} \
        --com.quantdo.trade.consul.port=${CONSUL_PORT} \
        --com.quantdo.trade.handle.producer.properties.bootstrap.servers=${KAFKA_SERVERS} \
        --com.quantdo.trade.handle.producer.properties.max.request.size=100000000 \
        --com.quantdo.trade.handle.producer.properties.request.timeout.ms=450000 \
        --com.quantdo.trade.handle.producer.properties.buffer.memory=100000000 \
        --com.quantdo.trade.handle.consumer.properties.bootstrap.servers=${KAFKA_SERVERS} \
        --com.quantdo.trade.handle.snapshot-topic=${CLEAR_SNAPSHOT_TOPIC} \
        --com.quantdo.trade.handle.checkpoint-topic=${CLEAR_CHECKPOINT_TOPIC} \
        --com.quantdo.trade.handle.consumer.properties.fetch.max.wait.ms=10 \
        --com.quantdo.trade.handle.consumer.properties.heartbeat.interval.ms=10000 \
        --com.quantdo.trade.handle.consumer.properties.session.timeout.ms=30000 \
        --com.quantdo.trade.handle.consumer.properties.max.poll.records=1000 \
        --com.quantdo.trade.handle.consumer.properties.max.poll.interval.ms=300000 \
        --com.quantdo.trade.handle.consumer.properties.request.timeout.ms=300000 \
