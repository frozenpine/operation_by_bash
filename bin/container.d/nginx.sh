VERSION="1.14.2"
NAME=nginx
USER=${NAME}

SERVICE_LIST="registry"

for SERVICE in ${SERVICE_LIST}; do
    source "${BASE_DIR}/service.d/${SERVICE}.sh" || {
        echo "service list file missing: ${SERVICE}.sh" >&2
        exit 1
    }
done

make_dir -b "${DATA_BASE:=/opt}/${NAME}" data conf/conf.d log cache || exit 1

docker run -d \
    --name ${NAME} \
    --restart always \
    --network host \
    -v ${DATA_BASE:=/opt}/${NAME}/data:/var/lib/${NAME} \
    -v ${DATA_BASE:=/opt}/${NAME}/conf/nginx.conf:/etc/${NAME}/nginx.conf:ro \
    -v ${DATA_BASE:=/opt}/${NAME}/conf/conf.d:/etc/${NAME}/conf.d:ro \
    -v ${DATA_BASE:=/opt}/${NAME}/log:/var/log/${NAME} \
    -v ${DATA_BASE:=/opt}/${NAME}/cache:/var/cache/${NAME} \
    registry:5000/${NAME}:${VERSION}
