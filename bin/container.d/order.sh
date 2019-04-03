VERSION="1.0.1-SNAPSHOT"
NAME=order
USER=${NAME}

JVM_OPTS=""

SERVICE_LIST="registry zookeeper kafka mysql redis"

for SERVICE in ${SERVICE_LIST}; do
    source "${BASE_DIR}/service.d/${SERVICE}.sh" || {
        echo "service list file missing: ${SERVICE}.sh" >&2
        exit 1
    }
done

docker run -d \
    --name ${NAME} \
    --restart no \
    --network host \
    -e SENTRY_DSN="http://73668afe8c674732904c6f7bc167395a:afa4c2ce16eb4352baed667d5675631b@monitor:9000/3" \
    registry:5000/trade$1/${NAME}:${VERSION} \
        ${JVM_OPTS} \
        -jar /${NAME}/trade$1-${NAME}-${VERSION}.jar \
        --com.quantdo.trade.consul.host=consul001 \
        --com.quantdo.trade.consul.port=8500 \
        --com.quantdo.trade.handle.manager.producer.acks=all \
        --com.quantdo.trade.handle.manager.producer.max.in.flight.requests.per.connection=1
