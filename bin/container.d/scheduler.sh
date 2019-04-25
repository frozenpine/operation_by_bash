VERSION=${SERVICE_SCHEDULER_VERSION}

if [[ -z ${VERSION} ]]; then
    error "clear version missing."
    exit 1
fi

NAME=scheduler
USER=${NAME}

SENTRY_DSN=`get_sentry_dsn ${NAME}`

JVM_OPTS=""

DB_NAME="clear"
PRIM_DB_NAME="digital"

SERVICE_LIST="registry zookeeper kafka mysql consul scheduler"

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
PRIM_DB_USER=
PRIM_DB_PASS=
for CONF in `extract_ini_sec ${PRIM_DB_NAME} "${CONF_BASE}/dbs.ini"`; do
    if [[ $CONF =~ .*[Uu][Ss][Ee][Rr] ]]; then
        PRIM_DB_USER=`echo ${CONF} | cut -d'=' -f2`
        PRIM_DB_USER=${PRIM_DB_USER## }
        PRIM_DB_USER=${PRIM_DB_USER%% }
    fi
    if [[ $CONF =~ .*[Pp][Aa][Ss][Ss]([Ww][Oo][Rr][Dd])? ]]; then
        PRIM_DB_PASS=`echo ${CONF} | cut -d'=' -f2`
        PRIM_DB_PASS=${PRIM_DB_PASS## }
        PRIM_DB_PASS=${PRIM_DB_PASS%% }
    fi
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
    --user `grep ${USER} /etc/passwd | cut -d':' -f3` \
    -e SENTRY_DSN="${SENTRY_DSN}" \
    -v "${CONTAINER_BASE}/log":/${NAME}/logs \
    registry:5000/service/${NAME}:${VERSION} \
        ${JVM_OPTS} \
        -jar /${NAME}/service-${NAME}-${VERSION}.jar \
        --log.level.root=${LOG_LEVEL:=info} \
        --server.port=${SCHEDULER_PORT} \
        --spring.cloud.consul.host="${CONSUL_HOST}" \
        --spring.cloud.consul.port="${CONSUL_PORT}" \
        --spring.datasource.primary.url="jdbc:mysql://${MYSQL_HOST}:${MYSQL_PORT}/${PRIM_DB_NAME}?characterEncoding=utf-8" \
        --spring.datasource.primary.username="${PRIM_DB_USER:=$DEFAULT_DB_USER}" \
        --spring.datasource.primary.password="${PRIM_DB_PASS:=$DEFAULT_DB_PASS}" \
        --spring.datasource.secondary.url="jdbc:mysql://${MYSQL_HOST}:${MYSQL_PORT}/${DB_NAME}?characterEncoding=utf-8" \
        --spring.datasource.secondary.username="${DB_USER:=$DEFAULT_DB_USER}" \
        --spring.datasource.secondary.password="${DB_PASS:=$DEFAULT_DB_PASS}" \
        --elaticjob.zookeeper.server-lists="${ZK_SERVERS}" \
        --com.quantdo.trade.data-exchange.command.producer.bootstrap.servers="${KAFKA_SERVERS}" \
        --com.quantdo.trade.data-exchange.monitor.consumer.bootstrap.servers="${KAFKA_SERVERS}" \
        --spring.datasource.primary.max-idle=10 \
        --spring.datasource.primary.max-wait=10000 \
        --spring.datasource.primary.min-idle=5 \
        --spring.datasource.primary.initial-size=5 \
        --spring.datasource.primary.validation-query="SELECT 1" \
        --spring.datasource.primary.test-on-borrow=false \
        --spring.datasource.primary.test-while-idle=true \
        --spring.datasource.primary.time-between-eviction-runs-millis=18800 \
        --spring.datasource.secondary.max-idle=10 \
        --spring.datasource.secondary.max-wait=10000 \
        --spring.datasource.secondary.min-idle=5 \
        --spring.datasource.secondary.initial-size=5 \
        --spring.datasource.secondary.validation-query="SELECT 1" \
        --spring.datasource.secondary.test-on-borrow=false \
        --spring.datasource.secondary.test-while-idle=true \
        --spring.datasource.secondary.time-between-eviction-runs-millis=18800 \
