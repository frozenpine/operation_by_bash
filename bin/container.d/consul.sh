VERSION="1.4.3"
NAME=consul
USER=${NAME}

BIND_INT="eth0"

SERVICE_LIST="registry consul"

for SERVICE in ${SERVICE_LIST}; do
    source "${BASE_DIR}/service.d/${SERVICE}.sh" || {
        echo "service list file missing: ${SERVICE}.sh" >&2
        exit 1
    }
done

CONTAINER_BASE="${DATA_BASE:=/opt}/${NAME}"
make_dir -b"${CONTAINER_BASE}" conf data || exit 1

get_id `uname -n`

SELF_IP=`ip address show ${BIND_INT} | grep inet | grep -v inet6 | awk '{print $2}' | cut -d'/' -f1`

if [[ ${#CONSUL_LIST[@]} -ge 3 ]]; then
    FIRST_IP=${CONSUL_LIST[${NAME}01]}
    
    if [[ ${ID} -eq 1 ]]; then
        BOOTSTRAP="-bootstrap-expect 3 -ui"
        JOIN="-join=${FIRST_IP} -retry-join=${FIRST_IP}"
    else
        BOOTSTRAP="-bootstrap-expect 3"
        JOIN="-join=${FIRST_IP} -retry-join=${FIRST_IP}"
    fi
else
    BOOTSTRAP="-bootstrap"
fi
    
docker run -d \
    --name ${NAME} \
    --restart always \
    --network host \
    -v "${CONTAINER_BASE}/conf:/consul/config" \
    -v "${CONTAINER_BASE}/data:/consul/data" \
    registry:5000/${NAME}:${VERSION} \
        consul agent -server \
        -bind=${SELF_IP} \
        -client="0.0.0.0" \
        ${BOOTSTRAP} \
        ${JOIN} \
        -data-dir=/consul/data \
        -config-dir=/consul/config
