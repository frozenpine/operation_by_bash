VERSION=${TRADE_TMDB_VERSION}

if [[ -z ${VERSION} ]]; then
    error "tmdb version missing."
    exit 1
fi

NAME=tmdb
USER=${NAME}

JVM_OPTS=${TRADE_TMDB_JVM}

SENTRY_DSN=`get_sentry_dsn ${NAME}`

DB_NAME="clear"

SERVICE_LIST="registry zookeeper kafka mysql tmdb"
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

KAFKA_SERVERS=
for SVR_NAME in ${!KAFKA_LIST[@]}; do
    KAFKA_SERVERS="${KAFKA_SERVERS},${SVR_NAME}:${KAFKA_PORT}"
done
KAFKA_SERVERS=${KAFKA_SERVERS:1}

SELF_IP=`ip address show eth0 | grep inet | grep -v inet6 | awk '{print $2}' | cut -d'/' -f1`

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
    registry:5000/trade$1/${NAME}:${VERSION} \
        ${JVM_OPTS} \
        -jar /${NAME}/trade$1-${NAME}-${VERSION}.jar \
        --logging.level.com.js.trade=${LOG_LEVEL:=info} \
        --server.address=${SELF_IP} \
        --server.port=${TMDB_PORT} \
        --spring.datasource.url="jdbc:mysql://${MYSQL_HOST}:${MYSQL_PORT}/${DB_NAME}?autoReconnect=true&useUnicode=true&characterEncoding=utf-8&connectionCollation=utf8_general_ci&useSSL=false&serverTimezone=Asia/Shanghai" \
        --spring.datasource.username=${DB_USER:=$DEFAULT_DB_USER} \
        --spring.datasource.password=${DB_PASS:=$DEFAULT_DB_PASS} \
        --com.js.trade.sink.properties.bootstrap.servers=${KAFKA_SERVERS} \
        &>/dev/null
