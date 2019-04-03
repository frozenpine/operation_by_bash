VERSION="latest"
NAME=kafka-exporter
SERVICE_PORT=9308

SERVICE_LIST="registry kafka"

for SERVICE in ${SERVICE_LIST}; do
    source "${BASE_DIR}/service.d/${SERVICE}.sh" || {
        echo "service list file missing: ${SERVICE}.sh" >&2
        exit 1
    }
done

for SVR_NAME in ${!KAFKA_LIST[@]}; do
    KAFKA_SERVERS=" --kafka.server=${SVR_NAME}:${KAFKA_PORT}"
done

docker run -d \
    --name ${NAME} \
    --restart always \
    --network host \
    registry:5000/${NAME}:${VERSION} ${KAFKA_SERVERS}
