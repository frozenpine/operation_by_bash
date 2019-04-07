if [[ $# -lt 1 ]]; then
    error "Invalid args: $*"
    exit 1
fi

ERR=0

for CONTAINER in $*; do
    COUNT=`docker ps --filter=status=running | awk -vNAME=${CONTAINER} 'FNR!=1{ if($NF==NAME)print}' | wc -l`
    
    if [[ $COUNT -eq 1 ]]; then
        info "docker container[${CONTAINER}] is running."
    else
        docker ps -a | grep ${CONTAINER} &>/dev/null
        if [[ $? -ne 0 ]]; then
            error "docker container[${CONTAINER}] missing."
        else
            warning "docker container[${CONTAINER}] not running."
        fi
        ERR=$((ERR+1))
    fi
done

exit ${ERR}