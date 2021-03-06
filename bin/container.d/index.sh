VERSION=${SERVICE_INDEX_VERSION}

if [[ -z ${VERSION} ]]; then
    error "index version missing."
    exit 1
fi

NAME=index
USER=${NAME}

SENTRY_DSN=`get_sentry_dsn ${NAME}`

JVM_OPTS=""

DB_NAME="management"

WALLET_URL="${WALLET_HOST}/api/BTC/testnet"

SERVICE_LIST="registry zookeeper kafka mysql redis consul index front"
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

MYSQL_HOST=
# IDX=$((RANDOM % ${#MYSQL_LIST[@]}))
IDX=0
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

FRONT_HOST=
IDX=$((RANDOM % ${#FRONT_LIST[@]}))
COUNT=0
for SVR_NAME in ${!FRONT_LIST[@]}; do
    if [[ ${COUNT} -eq ${IDX} ]]; then
        FRONT_HOST=${FRONT_LIST[$SVR_NAME]}
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
    -e LOG_LEVEL_ROOT=${LOG_LEVEL:=info} \
    -v "${CONTAINER_BASE}/log":/${NAME}/logs \
    registry:5000/service/${NAME}:${VERSION} \
        ${JVM_OPTS} \
        -jar /${NAME}/service-${NAME}-${VERSION}.jar \
        --server.port=${INDEX_PORT} \
        --spring.cloud.consul.host=${CONSUL_HOST} \
        --spring.cloud.consul.port=${CONSUL_PORT} \
        --spring.datasource.url="jdbc:mysql://${MYSQL_HOST}:${MYSQL_PORT}/${DB_NAME}?characterEncoding=utf-8" \
        --spring.datasource.username="${DB_USER:=$DEFAULT_DB_USER}" \
        --spring.datasource.password="${DB_PASS:=$DEFAULT_DB_PASS}" \
        --elaticjob.zookeeper.server-lists=${ZK_SERVERS} \
        --jedis.pool.host="${REDIS_HOST}" \
        --jedis.pool.port="${REDIS_PORT}" \
        --com.js.trade.support.consume.bootstrap.servers="${KAFKA_SERVERS}" \
        --com.js.trade.support.produce.bootstrap.servers="${KAFKA_SERVERS}" \
        --rest.kline.url="http://${FRONT_HOST}:${FRONT_PORT}/statistics?symbol=" \
        --cache.type=0 \
        &>/dev/null
