VERSION=${TRADE_MATCH_VERSION}

if [[ -z ${VERSION} ]]; then
    error "match version missing."
    exit 1
fi

NAME=match
USER=${NAME}

JVM_OPTS=${TRADE_MATCH_JVM}

# SENTRY_DSN="http://ebd586b285bc4fd08c7026c36007a182:f8fae917d105440ca9301e597d5ff179@monitor:9000/5"
SENTRY_DSN=

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
    -v "${CONTAINER_BASE}/log":/var/log/trade \
    registry:5000/trade$1/${NAME}:${VERSION} ${JVM_OPTS} \
        -jar /${NAME}/trade$1-${NAME}-${VERSION}.jar \
        --server.port=${MATCH_PORT} \
        --logging.level.root=${LOG_LEVEL:=warning} \
        --logging.level.com.quantdo.trade=${LOG_LEVEL:=warning} \
        --com.quantdo.trade.match.consumer.bootstrap.servers=${KAFKA_SERVERS} \
        --com.quantdo.trade.match.producer.bootstrap.servers=${KAFKA_SERVERS} \
        --com.quantdo.trade.match.global.outputIndexTopic=${INDEX_TOPIC} \
        # --com.quantdo.trade.handle.manager.transaction-batch-size=1000 \
        # --com.quantdo.trade.match.consumer.receive.buffer.bytes=10240000 \
        # --com.quantdo.trade.match.consumer.fetch.max.bytes=10240000 \
        # --com.quantdo.trade.match.consumer.fetch.min.bytes=1024000 \
        # --com.quantdo.trade.match.consumer.fetch.max.wait.ms=10 \
        # --com.quantdo.trade.match.consumer.max.poll.records=1000 \
        # --com.quantdo.trade.match.consumer.heartbeat.interval.ms=10000 \
        # --com.quantdo.trade.match.consumer.session.timeout.ms=30000 \
        # --com.quantdo.trade.match.producer.acks=all \
        # --com.quantdo.trade.match.producer.max.in.flight.requests.per.connection=1 \
        # --com.quantdo.trade.match.producer.max.request.size=2147483647 \
        # --com.quantdo.trade.match.producer.transaction.timeout.ms=300000 \
        # --com.quantdo.trade.match.producer.buffer.memory=2147483647 \
        # --com.quantdo.trade.match.producer.batch.size=1024000 \
        # --com.quantdo.trade.match.producer.linger.ms=100 \
        # --com.quantdo.trade.match.producer.receive.buffer.bytes=10240000
