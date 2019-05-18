VERSION="2.12-2.2.0"
NAME=kafka
USER=${NAME}

SERVICE_LIST="registry zookeeper kafka"

for SERVICE in ${SERVICE_LIST}; do
    source "${BASE_DIR}/service.d/${SERVICE}.sh" || {
        echo "service list file missing: ${SERVICE}.sh" >&2
        exit 1
    }
done

get_id `uname -n`
BROKER_ID=${ID}

for SVR_NAME in ${!ZOOKEEPER_LIST[@]}; do
    ZK_SERVERS="${ZK_SERVERS},${SVR_NAME}:${ZOOKEEPER_PORT}"
done
ZK_SERVERS=${ZK_SERVERS:1}

CONTAINER_BASE="${DATA_BASE:=/opt}/${NAME}"
find_user ${USER}
if [[ $? -ne 0 ]]; then
    ${SUDO} useradd --home-dir "${CONTAINER_BASE}" \
            --create-home \
            --shell /sbin/nologin \
            ${USER} || exit 1
fi

make_dir -b "${CONTAINER_BASE}" data config log || exit 1

LOG_TEMP=`mktemp`
cat <<EOF >"${LOG_TEMP}"
log4j.rootLogger=INFO, stdout

log4j.appender.stdout=org.apache.log4j.ConsoleAppender
log4j.appender.stdout.layout=org.apache.log4j.PatternLayout
log4j.appender.stdout.layout.ConversionPattern=[%d] %p %m (%c)%n

log4j.appender.kafkaAppender=org.apache.log4j.DailyRollingFileAppender
log4j.appender.kafkaAppender.DatePattern='.'yyyy-MM-dd-HH
log4j.appender.kafkaAppender.File=\${kafka.logs.dir}/server.log
log4j.appender.kafkaAppender.layout=org.apache.log4j.PatternLayout
log4j.appender.kafkaAppender.layout.ConversionPattern=[%d] %p %m (%c)%n

log4j.appender.stateChangeAppender=org.apache.log4j.DailyRollingFileAppender
log4j.appender.stateChangeAppender.DatePattern='.'yyyy-MM-dd-HH
log4j.appender.stateChangeAppender.File=\${kafka.logs.dir}/state-change.log
log4j.appender.stateChangeAppender.layout=org.apache.log4j.PatternLayout
log4j.appender.stateChangeAppender.layout.ConversionPattern=[%d] %p %m (%c)%n

log4j.appender.requestAppender=org.apache.log4j.DailyRollingFileAppender
log4j.appender.requestAppender.DatePattern='.'yyyy-MM-dd-HH
log4j.appender.requestAppender.File=\${kafka.logs.dir}/kafka-request.log
log4j.appender.requestAppender.layout=org.apache.log4j.PatternLayout
log4j.appender.requestAppender.layout.ConversionPattern=[%d] %p %m (%c)%n

log4j.appender.cleanerAppender=org.apache.log4j.DailyRollingFileAppender
log4j.appender.cleanerAppender.DatePattern='.'yyyy-MM-dd-HH
log4j.appender.cleanerAppender.File=\${kafka.logs.dir}/log-cleaner.log
log4j.appender.cleanerAppender.layout=org.apache.log4j.PatternLayout
log4j.appender.cleanerAppender.layout.ConversionPattern=[%d] %p %m (%c)%n

log4j.appender.controllerAppender=org.apache.log4j.DailyRollingFileAppender
log4j.appender.controllerAppender.DatePattern='.'yyyy-MM-dd-HH
log4j.appender.controllerAppender.File=\${kafka.logs.dir}/controller.log
log4j.appender.controllerAppender.layout=org.apache.log4j.PatternLayout
log4j.appender.controllerAppender.layout.ConversionPattern=[%d] %p %m (%c)%n

log4j.appender.authorizerAppender=org.apache.log4j.DailyRollingFileAppender
log4j.appender.authorizerAppender.DatePattern='.'yyyy-MM-dd-HH
log4j.appender.authorizerAppender.File=\${kafka.logs.dir}/kafka-authorizer.log
log4j.appender.authorizerAppender.layout=org.apache.log4j.PatternLayout
log4j.appender.authorizerAppender.layout.ConversionPattern=[%d] %p %m (%c)%n

# Change the two lines below to adjust ZK client logging
log4j.logger.org.I0Itec.zkclient.ZkClient=INFO
log4j.logger.org.apache.zookeeper=INFO

# Change the two lines below to adjust the general broker logging level (output to server.log and stdout)
log4j.logger.kafka=WARN
log4j.logger.org.apache.kafka=WARN

# Change to DEBUG or TRACE to enable request logging
log4j.logger.kafka.request.logger=WARN, requestAppender
log4j.additivity.kafka.request.logger=false

# Uncomment the lines below and change log4j.logger.kafka.network.RequestChannel$ to TRACE for additional output
# related to the handling of requests
#log4j.logger.kafka.network.Processor=TRACE, requestAppender
#log4j.logger.kafka.server.KafkaApis=TRACE, requestAppender
#log4j.additivity.kafka.server.KafkaApis=false
log4j.logger.kafka.network.RequestChannel$=WARN, requestAppender
log4j.additivity.kafka.network.RequestChannel$=false

log4j.logger.kafka.controller=TRACE, controllerAppender
log4j.additivity.kafka.controller=false

log4j.logger.kafka.log.LogCleaner=INFO, cleanerAppender
log4j.additivity.kafka.log.LogCleaner=false

log4j.logger.state.change.logger=TRACE, stateChangeAppender
log4j.additivity.state.change.logger=false

# Access denials are logged at INFO level, change to DEBUG to also log allowed accesses
log4j.logger.kafka.authorizer.logger=INFO, authorizerAppender
log4j.additivity.kafka.authorizer.logger=false
EOF
${SUDO} mv "${LOG_TEMP}" "${CONTAINER_BASE}/config/log4j.properties"
    
${SUDO} chown -R ${USER}:${USER} "${CONTAINER_BASE}"

SELF_IP=`ip address show eth0 | grep inet | grep -v inet6 | awk '{print $2}' | cut -d'/' -f1`

SELF_NAME=
for SVR_NAME in ${!KAFKA_LIST[@]}; do
    if [[ ${SELF_IP} == ${KAFKA_LIST[$SVR_NAME]} ]]; then
        SELF_NAME=${SVR_NAME}
        break
    fi
done

if [[ x"${SELF_NAME}" == "x" ]]; then
    error "kafka alias name not found."
    exit 1
fi
 
LISTENERS="PLAINTEXT://${SELF_NAME}:${KAFKA_PORT}"

if [[ ${#KAFKA_LIST[@]} -ge 3 ]]; then
    docker run -d \
        --name ${NAME} \
        --restart always \
        --network host \
        --user `grep ${USER} /etc/passwd | cut -d':' -f3` \
        -v "${CONTAINER_BASE}/data:/${NAME}" \
        -v "${CONTAINER_BASE}/config:/opt/kafka/config" \
        -v "${CONTAINER_BASE}/log:/opt/kafka/logs" \
        -e JMX_PORT=1199 \
        -e KAFKA_HOST_NAME="${SELF_NAME}" \
        -e KAFKA_ZOOKEEPER_CONNECT=${ZK_SERVERS} \
        -e KAFKA_ADVERTISED_LISTENERS=${LISTENERS} \
        -e KAFKA_LISTENERS=${LISTENERS} \
        -e KAFKA_BROKER_ID=${BROKER_ID} \
        -e KAFKA_DELETE_TOPIC_ENABLE="true" \
        -e KAFKA_AUTO_CREATE_TOPICS_ENABLE="false" \
        -e KAFKA_NUM_PARTITIONS=3 \
        -e KAFKA_DEFAULT_REPLICATION_FACTOR=3 \
        -e KAFKA_MIN_INSYNC_REPLICAS=2 \
        -e KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=3 \
        -e KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR=3 \
        -e KAFKA_TRANSACTION_STATE_LOG_MIN_ISR=2 \
        -e KAFKA_MAX_TRANSACTION_TIMEOUT_MS=300000 \
        -e KAFKA_SESSION_TIMEOUT_MS=300000 \
        -e KAFKA_GROUP_MAX_SESSION_TIMEOUT_MS=300000 \
        -e KAFKA_MESSAGE_MAX_BYTES=2147483647 \
        registry:5000/${NAME}:${VERSION}
else
    docker run -d \
        --name ${NAME} \
        --restart always \
        --network host \
        --user `grep ${USER} /etc/passwd | cut -d':' -f3` \
        -v "${CONTAINER_BASE}/data:/${NAME}" \
        -v "${CONTAINER_BASE}/config:/opt/kafka/config" \
        -v "${CONTAINER_BASE}/log:/opt/kafka/logs" \
        -e JMX_PORT=1199 \
        -e KAFKA_HOST_NAME=${SELF_NAME} \
        -e KAFKA_ZOOKEEPER_CONNECT=${ZK_SERVERS} \
        -e KAFKA_ADVERTISED_LISTENERS=${LISTENERS} \
        -e KAFKA_LISTENERS=${LISTENERS} \
        -e KAFKA_BROKER_ID=${BROKER_ID} \
        -e KAFKA_DELETE_TOPIC_ENABLE="true" \
        -e KAFKA_AUTO_CREATE_TOPICS_ENABLE="false" \
        -e KAFKA_NUM_PARTITIONS=3 \
        -e KAFKA_DEFAULT_REPLICATION_FACTOR=1 \
        -e KAFKA_MIN_INSYNC_REPLICAS=1 \
        -e KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1 \
        -e KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR=1 \
        -e KAFKA_TRANSACTION_STATE_LOG_MIN_ISR=1 \
        -e KAFKA_MAX_TRANSACTION_TIMEOUT_MS=300000 \
        -e KAFKA_SESSION_TIMEOUT_MS=300000 \
        -e KAFKA_GROUP_MAX_SESSION_TIMEOUT_MS=300000 \
        -e KAFKA_MESSAGE_MAX_BYTES=100000000 \
        -e KAFKA_REPLICA_FETCH_MAX_BYES=100000000 \
        registry:5000/${NAME}:${VERSION}
fi
