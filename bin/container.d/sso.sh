VERSION="1.0.0-SNAPSHOT"
NAME=sso
USER=${NAME}

# SENTRY_DSN="http://a18befa43f4d4d38983934e7cf7ed441:6103657ae0634a7299fc70670e295c73@monitor:9000/6"
SENTRY_DSN=

JVM_OPTS="-Duser.timezone=GMT+08"

SERVICE_LIST="registry zookeeper kafka mysql redis tradebase"

DB_NAME="digital"
DB_USER="trader"
DB_PASS="js2018"

WALLET_URL="http://127.0.0.1:3000/api/BTC/testnet"

for SERVICE in ${SERVICE_LIST}; do
    source "${BASE_DIR}/service.d/${SERVICE}.sh" || {
        echo "service list file missing: ${SERVICE}.sh" >&2
        exit 1
    }
done

MYSQL_HOST=
IDX=$((RANDOM % ${#MYSQL_LIST[@]}))
COUNT=0
for SVR_NAME in ${!MYSQL_LIST[@]}; do
    if [[ ${COUNT} -eq ${IDX} ]]; then
        MYSQL_HOST=${MYSQL_LIST[$SVR_NAME]}
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

docker run -d \
    --name ${NAME} \
    --restart no \
    --network host \
    -e SENTRY_DSN="${SENTRY_DSN}" \
    registry:5000/tradebase/${NAME}:${VERSION} \
        ${JVM_OPTS} \
        -jar /${NAME}/tradebase-${NAME}-${VERSION}.jar \
        --server.port=${TRADEBASE_PORT} \
        --spring.datasource.url="jdbc:mysql://${MYSQL_HOST}:${MYSQL_PORT}/${DB_NAME}?characterEncoding=utf-8" \
        --spring.datasource.username="${DB_USER}" \
        --spring.datasource.password="${DB_PASS}" \
        --spring.redis.host="${REDIS_HOST}" \
        --url.wallet.sing="${WALLET_URL}" \
        --com.quantdo.trade.data-exchange.command.producer.bootstrap.servers="${KAFKA_SERVERS}" \
        --com.quantdo.trade.data-exchange.monitor.consumer.bootstrap.servers="${KAFKA_SERVERS}" \
        --verifyCode=false
