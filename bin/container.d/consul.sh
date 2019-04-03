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

make_dir -b"/opt/${NAME}" conf data || exit 1

get_id `uname -n`

FIRST_IP=${CONSUL_LIST[${NAME}001]}
SELF_IP=`ip address show ${BIND_INT} | grep inet | awk '{print $2}' | cut -d'/' -f1`

if [[ ${ID} -eq 1 ]]; then
    BOOTSTRAP="-bootstrap-expect 3 -ui"
    JOIN="-join=${FIRST_IP} -retry-join=${FIRST_IP}"
else
    BOOTSTRAP="-bootstrap-expect 3"
    JOIN="-join=${FIRST_IP} -retry-join=${FIRST_IP}"
fi

docker run -d \
    --name ${NAME} \
    --restart always \
    --network host \
    -v /opt/${NAME}/conf:/consul/config \
    -v /opt/${NAME}/data:/consul/data \
    registry:5000/${NAME}:${VERSION} \
        consul agent -server \
        -bind=${SELF_IP} \
        -client="0.0.0.0" \
        ${BOOTSTRAP} \
        ${JOIN} \
        -data-dir=/consul/data \
        -config-dir=/consul/config
