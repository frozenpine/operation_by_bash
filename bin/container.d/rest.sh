VERSION=${DIGITAL_REST_VERSION}

if [[ -z ${VERSION} ]]; then
    error "rest version missing."
    exit 1
fi

NAME=rest
USER=${NAME}

JVM_OPTS=""

# SENTRY_DSN="http://654e52faff5144798b88dff78fa283b5:73a9028558844a5d88c14c50a106b9cc@monitor:9000/8"
SENTRY_DSN=

DB_NAME="sso"
DB_USER=${DB_USER:="trader"}
DB_PASS=${DB_PASS:="js2018"}

SERVICE_LIST="registry zookeeper kafka mysql redis digital"

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
        --server.port="${DIGITAL_PORT}" \
        --spring.redis.host="${REDIS_HOST}" \
        --spring.datasource.url="jdbc:mysql://${MYSQL_HOST}:${MYSQL_PORT}/${DB_NAME}?characterEncoding=utf-8" \
        --spring.datasource.username="${DB_USER}" \
        --spring.datasource.password="${DB_PASS}" \
        --dubbo.registry.address="${ZK_SERVERS}" \
        --dubbo.protocol.host="${SELF_IP}" \
        --dubbo.consumer.timeout=300000
