VERSION="2.7.1"
NAME=registry

docker run -d \
    --name registry \
    --restart always \
    --network host \
    -v /etc/${NAME}:/etc/docker/registry \
    -v ${DATA_BASE:=/opt}/${NAME}:/var/lib/registry \
    ${NAME}:${VERSION}
