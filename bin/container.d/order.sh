VERSION=${TRADE_ORDER_VERSION}

if [[ -z ${VERSION} ]]; then
    error "order version missing."
    exit 1
fi

NAME=order
USER=${NAME}

JVM_OPTS=${TRADE_ORDER_JVM}

SENTRY_DSN=`get_sentry_dsn ${NAME}`

SERVICE_LIST="registry zookeeper kafka consul redis order"

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

REDIS_HOST=
IDX=$((RANDOM % ${#REDIS_LIST[@]}))
COUNT=0
for SVR_NAME in ${!REDIS_LIST[@]}; do
    if [[ ${COUNT} -eq ${IDX} ]]; then
        REDIS_HOST=${REDIS_LIST[$SVR_NAME]}
        break
    fi

    COUNT=$((COUNT+1))
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
    --user `grep ^${USER} /etc/passwd | cut -d':' -f3` \
    -e SENTRY_DSN="${SENTRY_DSN}" \
    -e LOG_LEVEL_ROOT=${LOG_LEVEL:=info} \
    -v "${CONTAINER_BASE}/log":/${NAME}/logs \
    registry:5000/trade$1/${NAME}:${VERSION} \
        ${JVM_OPTS} \
        -jar /${NAME}/trade$1-${NAME}-${VERSION}.jar \
        --logging.level.com.js.trade=${LOG_LEVEL:=info} \
        --server.port=${ORDER_PORT} \
        --com.js.trade.consul.host=${CONSUL_HOST} \
        --com.js.trade.consul.port=${CONSUL_PORT} \
        --com.js.trade.order.kafka.producer.bootstrap.servers=${KAFKA_SERVERS} \
        --com.js.trade.web.signature.monitor.properties.bootstrap.servers=${KAFKA_SERVERS} \
        --spring.redis.host=${REDIS_HOST} \
        --spring.redis.port=${REDIS_PORT} \
        &>/dev/null
