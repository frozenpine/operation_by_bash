VERSION=${TRADE_QUERY_VERSION}

if [[ -z ${VERSION} ]]; then
    error "query version missing."
    exit 1
fi

NAME=query
USER=${NAME}

JVM_OPTS=${TRADE_QUERY_JVM}

# SENTRY_DSN="http://73668afe8c674732904c6f7bc167395a:afa4c2ce16eb4352baed667d5675631b@monitor:9000/3"
SENTRY_DSN=

DB_NAME="clear"

SERVICE_LIST="registry zookeeper kafka mysql elastic consul query"
for SERVICE in ${SERVICE_LIST}; do
    source "${BASE_DIR}/service.d/${SERVICE}.sh" || {
        echo "service list file missing: ${SERVICE}.sh" >&2
        exit 1
    }
done

DB_USER=
DB_PASS=
for CONF in `extract_ini_sec ${DB_NAME} "${CONF_BASE}/dbs.ini"`; do
    if [[ $CONF =~ .*[Uu][Ss][Ee][Rr] ]]; then
        DB_USER=`echo ${CONF} | cut -d'=' -f2`
        DB_USER=${DB_USER## }
        DB_USER=${DB_USER%% }
    fi
    if [[ $CONF =~ .*[Pp][Aa][Ss][Ss]([Ww][Oo][Rr][Dd])? ]]; then
        DB_PASS=`echo ${CONF} | cut -d'=' -f2`
        DB_PASS=${DB_PASS## }
        DB_PASS=${DB_PASS%% }
    fi
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

ELASTIC_SERVERS=
for SVR_NAME in ${!ELASTIC_LIST[@]}; do
    ELASTIC_SERVERS="${ELASTIC_SERVERS},http://${SVR_NAME}:${ELASTIC_PORT}"
done
ELASTIC_SERVERS=${ELASTIC_SERVERS:1}

docker run -d \
    --name ${NAME} \
    --restart no \
    --network host \
    -e SENTRY_DSN="${SENTRY_DSN}" \
    registry:5000/trade$1/${NAME}:${VERSION} \
        ${JVM_OPTS} \
        -jar /${NAME}/trade$1-${NAME}-${VERSION}.jar \
        --logging.level.com.quantdo.trade=${LOG_LEVEL:=info} \
        --server.port=${QUERY_PORT} \
        --com.quantdo.trade.data-exchange.command.producer.bootstrap.servers=${KAFKA_SERVERS} \
        --com.quantdo.trade.data-exchange.monitor.consumer.bootstrap.servers=${KAFKA_SERVERS} \
        --com.quantdo.trade.handle.manager.producer.acks=all \
        --com.quantdo.trade.handle.manager.producer.max.in.flight.requests.per.connection=1 \
        --com.quantdo.trade.consul.host=${CONSUL_HOST} \
        --com.quantdo.trade.consul.port=${CONSUL_PORT} \
        --spring.elasticsearch.jest.uris=${ELASTIC_SERVERS} \
        --spring.datasource.url="jdbc:mysql://${MYSQL_HOST}:${MYSQL_PORT}/${DB_NAME}?useUnicode=true&characterEncoding=utf-8&connectionCollation=utf8_general_ci&useSSL=false&serverTimezone=Asia/Shanghai" \
        --spring.datasource.username=${DB_USER:=$DEFAULT_DB_USER} \
        --spring.datasource.password=${DB_PASS:=$DEFAULT_DB_PASS}
