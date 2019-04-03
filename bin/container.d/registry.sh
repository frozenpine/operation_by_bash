VERSION="2.7.1"
NAME=registry

docker run -d \
    --name registry \
    --restart always \
    --network host \
    -v /etc/${NAME}:/etc/docker/registry \
    -v /data/${NAME}:/var/lib/registry \
    -e REGISTRY_AUTH=htpasswd \
    -e REGISTRY_AUTH_HTPASSWD_REALM="Registry Realm" \
    -e REGISTRY_AUTH_HTPASSWD_PATH=/etc/docker/registry/htpasswd \
    ${NAME}:${VERSION}
