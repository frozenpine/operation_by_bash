VERSION="1.15.8"
NAME=openresty
USER=nginx

SERVICE_LIST="registry"

for SERVICE in ${SERVICE_LIST}; do
    source "${BASE_DIR}/service.d/${SERVICE}.sh" || {
        echo "service list file missing: ${SERVICE}.sh" >&2
        exit 1
    }
done

make_dir -b "${DATA_BASE:=/opt}/${NAME}" data conf/conf.d log cache || exit 1

if [[ ! -f "${DATA_BASE:=/opt}/${NAME}/conf/nginx.conf" ]]; then
    warning "nginx.conf missing, copy from template."
    ${SUDO} cp "${TEMPLATE_BASE}/nginx/nginx.conf" "${DATA_BASE:=/opt}/${NAME}/conf/nginx.conf"

    [[ $? -ne 0 ]] && {
        error "make nginx.conf failed."
        exit 1
    }
fi

docker run -d \
    --name nginx \
    --restart always \
    --network host \
    -v ${DATA_BASE:=/opt}/nginx/data:/var/lib/nginx \
    -v ${DATA_BASE:=/opt}/nginx/conf/nginx.conf:/etc/nginx/nginx.conf:ro \
    -v ${DATA_BASE:=/opt}/nginx/conf/conf.d:/etc/nginx/conf.d:ro \
    -v ${DATA_BASE:=/opt}/nginx/log:/var/log/nginx \
    -v ${DATA_BASE:=/opt}/nginx/cache:/var/cache/nginx \
    registry:5000/${NAME}:${VERSION}
