VERSION=${TRADE_CLEAR_VERSION}

if [[ -z ${VERSION} ]]; then
    error "clear version missing."
    exit 1
fi

NAME=clear
USER=${NAME}

JVM_OPTS=${TRADE_CLEAR_JVM}

# SENTRY_DSN="http://68634f3a3c434dd7904b9383ea9f47a4:f71cf64ccf1a4972a4c6b421f5a37769@monitor:9000/4"
SENTRY_DSN=

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

make_dir -b "${DATA_BASE:=/opt}/${NAME}" log|| exit 1

SELF_IP=`ip address show eth0 | grep inet | grep -v inet6 | awk '{print $2}' | cut -d'/' -f1`

docker run -d \
    --name ${NAME} \
    --restart no \
    --network host \
    -e SENTRY_DSN="${SENTRY_DSN}" \
    -e CLASSPATH=/docker-java-home/jre/lib \
    -v "${DATA_BASE:=/opt}/${NAME}/log":/var/log/trade \
    registry:5000/trade$1/${NAME}:${VERSION} \
        ${JVM_OPTS} \
        -jar /${NAME}/trade$1-${NAME}-${VERSION}.jar \
        --logging.level.com.quantdo.trade=${LOG_LEVEL:=warning} \
        --server.address=${SELF_IP} \
        --server.port=${CLEAR_PORT} \
        --com.quantdo.trade.consul.host=${CONSUL_HOST} \
        --com.quantdo.trade.consul.port=${CONSUL_PORT} \
        --com.quantdo.trade.handle.manager.mode=memory \
        --com.quantdo.trade.handle.manager.producer.bootstrap.servers=${KAFKA_SERVERS} \
        --com.quantdo.trade.handle.manager.consumer.bootstrap.servers=${KAFKA_SERVERS} \
        --com.quantdo.trade.handle.manager.snapshot-topic=${CLEAR_SNAPSHOT_TOPIC} \
        --com.quantdo.trade.handle.manager.checkpoint-topic=${CLEAR_CHECKPOINT_TOPIC} \
        --com.quantdo.trade.handle.manager.consumer.receive.buffer.bytes=10240000 \
        --com.quantdo.trade.handle.manager.consumer.fetch.max.bytes=10240000 \
        --com.quantdo.trade.handle.manager.consumer.fetch.min.bytes=1024000 \
        --com.quantdo.trade.handle.manager.consumer.fetch.max.wait.ms=10 \
        --com.quantdo.trade.handle.manager.consumer.max.poll.records=10000 \
        --com.quantdo.trade.handle.manager.transaction-batch-size=1000 \
        --com.quantdo.trade.handle.manager.producer.acks=all \
        --com.quantdo.trade.handle.manager.producer.max.in.flight.requests.per.connection=1 \
        --com.quantdo.trade.handle.manager.producer.batch.size=1024000 \
        --com.quantdo.trade.handle.manager.producer.linger.ms=100 \
        --com.quantdo.trade.handle.manager.producer.receive.buffer.bytes=10240000
