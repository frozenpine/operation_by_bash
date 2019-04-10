VERSION=${DIGITAL_SERVICEIMPL_VERSION}

if [[ -z ${VERSION} ]]; then
    error "serviceimpl version missing."
    exit 1
fi

NAME=serviceimpl
USER=${NAME}

JVM_OPTS=""

# SENTRY_DSN="http://032c281ab84f4c0798e6f3482a4d2e2e:d44ee127559b4d7e921d212a7b03fd81@monitor:9000/7"
SENTRY_DSN=

DB_NAME="digital"
DB_USER=${DB_USER:="trader"}
DB_PASS=${DB_PASS:="js2018"}

SERVICE_LIST="registry zookeeper kafka mysql"

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

KAFKA_SERVERS=
for SVR_NAME in ${!KAFKA_LIST[@]}; do
    KAFKA_SERVERS="${KAFKA_SERVERS},${SVR_NAME}:${KAFKA_PORT}"
done
KAFKA_SERVERS=${KAFKA_SERVERS:1}

ZK_SERVERS=
for SVR_NAME in ${!ZOOKEEPER_LIST[@]}; do
    ZK_SERVERS="${ZK_SERVERS},${SVR_NAME}:${ZOOKEEPER_PORT}"
done
ZK_SERVERS=${ZK_SERVERS:1}

SELF_IP=`ip address show ${BIND_INT:=eth0} | grep inet | grep -v inet6 | awk '{print $2}' | cut -d'/' -f1`

docker run -d \
    --name ${NAME} \
    --restart no \
    --network host \
    -e SENTRY_DSN="${SENTRY_DSN}" \
    registry:5000/digital/${NAME}:${VERSION} \
        ${JVM_OPTS} \
        -jar /${NAME}/digital-${NAME}-${VERSION}.jar \
        --com.quantdo.trade.data-exchange.command.producer.bootstrap.servers="${KAFKA_SERVERS}" \
        --com.quantdo.trade.data-exchange.monitor.comsumer.bootstrap.servers="${KAFKA_SERVERS}" \
        --spring.datasource.url="jdbc:mysql://${MYSQL_HOST}:${MYSQL_PORT}/${DB_NAME}?characterEncoding=utf-8" \
        --spring.datasource.username="${DB_USER}" \
        --spring.datasource.password="${DB_PASS}" \
        --spring.datasource.list[0].url="jdbc:mysql://${MYSQL_HOST}:${MYSQL_PORT}/clear?characterEncoding=utf-8" \
        --spring.datasource.list[0].name="front" \
        --spring.datasource.list[0].master-dataSource="true" \
        --spring.datasource.list[0].username="${DB_USER}" \
        --spring.datasource.list[0].password="${DB_PASS}" \
        --dubbo.registry.address="${ZK_SERVERS}" \
        --dubbo.provider.host="${SELF_IP}" \
        --dubbo.provider.timeout=180000
