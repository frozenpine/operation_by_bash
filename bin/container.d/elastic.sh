VERSION="6.6.0"
NAME=elasticsearch
SHORT_NAME=elastic
USER=${SHORT_NAME}

CLUSTER_NAME=Js

SERVICE_LIST="registry elastic"

for SERVICE in ${SERVICE_LIST}; do
    source "${BASE_DIR}/service.d/${SERVICE}.sh" || {
        echo "service list file missing: ${SERVICE}.sh" >&2
        exit 1
    }
done

get_id `uname -n`
BROKER_ID=${ID}
CLIENT_PORT=9200

ES_SERVERS=
FIRST_IP=
for SVR_NAME in ${!ELASTIC_LIST[@]}; do
    if [[ x"${FIRST_IP}" == "x" ]]; then
        FIRST_IP=${ELASTIC_LIST[$SVR_NAME]}
    fi
    ES_SERVERS="${ES_SERVERS},${SVR_NAME}:${ELASTIC_PORT}"
done
ES_SERVERS=${ES_SERVERS:1}

CONTAINER_BASE="${DATA_BASE:=/opt}/${SHORT_NAME}"
find_user ${USER}
if [[ $? -ne 0 ]]; then
    ${SUDO} useradd --home-dir "${CONTAINER_BASE}" \
            --create-home \
            --shell /sbin/nologin \
            ${USER} || exit 1
fi

make_dir -b "${CONTAINER_BASE}" data config log || exit 1

${SUDO} chown -R ${USER}:${USER} "${CONTAINER_BASE}"

if [[ ${#ELASTIC_LIST[@]} -ge 3 ]]; then
    docker run -d \
        --name ${SHORT_NAME} \
        --restart always \
        --network host \
        --user `grep ${USER} /etc/passwd | cut -d':' -f3` \
        -v "${CONTAINER_BASE}/data:/usr/share/elasticsearch/data" \
        -e "cluster.name=${CLUSTER_NAME}" \
        -e "discovery.zen.ping.unicast.hosts=${FIRST_IP}" \
        registry:5000/${NAME}:${VERSION}
else
    docker run -d \
        --name ${SHORT_NAME} \
        --restart always \
        --network host \
        --user `grep ${USER} /etc/passwd | cut -d':' -f3` \
        -v "${CONTAINER_BASE}/data:/usr/share/elasticsearch/data" \
        -e "cluster.name=${CLUSTER_NAME}" \
        -e "discovery.type=single-node" \
        registry:5000/${NAME}:${VERSION}
fi
