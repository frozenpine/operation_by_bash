STATUS_COMMAND="${MODULE_BASE}/check-container.sh"

if [[ $# -lt 1 ]]; then
    error "Invalid args: $*"
    exit 1
fi

function start_container() {
    local _COUNT
    local _START_FILE
    _COUNT=`docker ps --all --filter=name=$1 --quiet | wc -l`
    if [[ ${_COUNT} -eq 1 ]]; then
        docker start $1
    else
        _START_FILE=`find "${CONTAINER_BASE}" -type f -name "$1.sh"`
        if [[ -n ${_START_FILE} ]]; then
            shift
            source "${_START_FILE}" ${ARG} $*
            return $?
        else
            error "no start script found for $1"
            return 1
        fi
    fi
}

if [[ $1 =~ ^-.* ]]; then
    ARG=$1
    shift
fi

for CONTAINER in $*; do
    "${STATUS_COMMAND}" ${CONTAINER} &>/dev/null
    if [[ $? -eq 0 ]]; then
        warning "docker container[$CONTAINER] already started."
        exit
    else
        info "starting ${CONTAINER}..."
        start_container ${CONTAINER}
        if [[ $? -ne 0 ]]; then
            exit 1
        fi
    fi
done
