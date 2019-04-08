VERSION="1.0.3-SNAPSHOT"
NAME=rest
USER=${NAME}

JVM_OPTS="-Duser.timezone=GMT+08"

# SENTRY_DSN="http://654e52faff5144798b88dff78fa283b5:73a9028558844a5d88c14c50a106b9cc@monitor:9000/8"
SENTRY_DSN=

DB_NAME="sso"
DB_USER="trader"
DB_PASS="js2018"

SERVICE_LIST="registry zookeeper kafka mysql redis"

for SERVICE in ${SERVICE_LIST}; do
    source "${BASE_DIR}/service.d/${SERVICE}.sh" || {
        echo "service list file missing: ${SERVICE}.sh" >&2
        exit 1
    }
done

MYSQL_HOST=
IDX=$((RANDOM % ${#MYSQL_LIST[@]}))
COUNT=0
for NAME in ${!MYSQL_LIST[@]}; do
    if [[ ${COUNT} -eq ${IDX} ]]; then
        MYSQL_HOST=${MYSQL_LIST[$NAME]}
        break
    fi

    COUNT=$((COUNT+1))
done

REDIS_HOST=
IDX=$((RANDOM % ${#REDIS_LIST[@]}))
COUNT=0
for NAME in ${!REDIS_LIST[@]}; do
    if [[ ${COUNT} -eq ${IDX} ]]; then
        REDIS_HOST=${REDIS_LIST[$NAME]}
        break
    fi

    COUNT=$((COUNT+1))
done

ZK_SERVERS=
for SVR_NAME in ${!ZK_LIST[@]}; do
    ZK_SERVERS="${ZK_SERVERS},${SVR_NAME}:${ZK_PORT}"
done
ZK_SERVERS=${ZK_SERVERS:1}

docker run -d \
    --name ${NAME} \
    --restart no \
    --network host \
    -e SENTRY_DSN="${SENTRY_DSN}" \
    registry:5000/digital/${NAME}:${VERSION} \
        ${JVM_OPTS} \
        -jar /${NAME}/digital-${NAME}-${VERSION}.jar \
        --spring.redis.host=${REDIS_HOST} \
        --spring.datasource.url="jdbc:mysql://${MYSQL_HOST}:${MYSQL_PORT}/${DB_NAME}?characterEncoding=utf-8" \
        --spring.datasource.username="${DB_USER}" \
        --spring.datasource.password="${DB_PASS}" \
        --dubbo.provider.host=`uname -n` \
        --dubbo.registry.address=${ZK_SERVERS} \
        --dubbo.consumer.timeout=300000
