VERSION=${TRADE_MATCH_VERSION}

if [[ -z ${VERSION} ]]; then
    error "match version missing."
fi

NAME=match
USER=${NAME}

JVM_OPTS="-Xms8G -Xmx8G"

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

docker run -d \
    --name ${NAME} \
    --restart no \
    --network host \
    -e SENTRY_DSN="${SENTRY_DSN}" \
    registry:5000/trade$1/${NAME}:${VERSION} ${JVM_OPTS} \
        -jar /${NAME}/trade$1-${NAME}-${VERSION}.jar \
        --server.port=${MATCH_PORT} \
        --logging.level.root=info \
        --logging.level.com.quantdo.trade=info \
        --com.quantdo.trade.match.producer.bootstrap.servers=${KAFKA_SERVERS} \
        --com.quantdo.trade.handle.manager.transaction-batch-size=1000 \
        --com.quantdo.trade.match.consumer.receive.buffer.bytes=10240000 \
        --com.quantdo.trade.match.consumer.fetch.max.bytes=10240000 \
        --com.quantdo.trade.match.consumer.fetch.min.bytes=1024000 \
        --com.quantdo.trade.match.consumer.fetch.max.wait.ms=10 \
        --com.quantdo.trade.match.consumer.max.poll.records=10000 \
        --com.quantdo.trade.match.producer.acks=all \
        --com.quantdo.trade.match.producer.max.in.flight.requests.per.connection=1 \
        --com.quantdo.trade.match.producer.max.request.size=2147483647 \
        --com.quantdo.trade.match.producer.transaction.timeout.ms=300000 \
        --com.quantdo.trade.match.producer.buffer.memory=2147483647 \
        --com.quantdo.trade.match.producer.batch.size=1024000 \
        --com.quantdo.trade.match.producer.linger.ms=100 \
        --com.quantdo.trade.match.producer.receive.buffer.bytes=10240000
