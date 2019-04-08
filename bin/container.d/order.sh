VERSION="1.0.1-SNAPSHOT"
NAME=order
USER=${NAME}

JVM_OPTS=""

# SENTRY_DSN="http://73668afe8c674732904c6f7bc167395a:afa4c2ce16eb4352baed667d5675631b@monitor:9000/3"
SENTRY_DSN=

SERVICE_LIST="registry zookeeper kafka consul order"

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

docker run -d \
    --name ${NAME} \
    --restart no \
    --network host \
    -e SENTRY_DSN="${SENTRY_DSN}" \
    registry:5000/trade$1/${NAME}:${VERSION} \
        ${JVM_OPTS} \
        -jar /${NAME}/trade$1-${NAME}-${VERSION}.jar \
        --server.port=${ORDER_PORT} \
        --com.quantdo.trade.consul.host=${CONSUL_HOST} \
        --com.quantdo.trade.consul.port=${CONSUL_PORT} \
        --com.quantdo.trade.handle.manager.producer.acks=all \
        --com.quantdo.trade.handle.manager.producer.max.in.flight.requests.per.connection=1
