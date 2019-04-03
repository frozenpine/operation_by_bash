VERSION="1.0.3-SNAPSHOT"
NAME=rest
USER=${NAME}

JVM_OPTS="-Duser.timezone=GMT+08"

SENTRY_DSN="http://654e52faff5144798b88dff78fa283b5:73a9028558844a5d88c14c50a106b9cc@monitor:9000/8"

SERVICE_LIST="registry zookeeper kafka mysql redis"

for SERVICE in ${SERVICE_LIST}; do
    source "${BASE_DIR}/service.d/${SERVICE}.sh" || {
        echo "service list file missing: ${SERVICE}.sh" >&2
        exit 1
    }
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
        --spring.redis.host=redis001 \
        --spring.datasource.url=jdbc:mysql://mysql002:3306/sso?characterEncoding=utf-8 \
        --spring.datasource.username=trader \
        --spring.datasource.password=js2018 \
        --dubbo.provider.host=`uname -n` \
        --dubbo.registry.address=${ZK_SERVERS} \
        --dubbo.consumer.timeout=300000
