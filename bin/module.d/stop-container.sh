STATUS_COMMAND="${MODULE_BASE}/check-container.sh"

if [[ $# -lt 1 ]]; then
    error "Invalid args: $*"
    exit 1
fi

REMOVE=0
FORCE=0
SKIP_BACK=0

while getopts :frcs FLAG; do
    case $FLAG in
        r)
            REMOVE=1
        ;;
        f)
            FORCE=1
        ;;
        c)
            CLEAN=1
        ;;
        s)
            SKIP_BACK=1
        ;;
        *)
        ;;
    esac
done
shift $((OPTIND-1))

function stop_container() {
    case "${FORCE}${REMOVE}" in
        "11")
            docker rm -vf $1
            if [[ $? -ne 0 ]]; then
                error "failed to kill & remove container[$1]"
                return 1
            fi
        ;;
        "01")
            docker stop $1
            if [[ $? -ne 0 ]]; then
                error "failed to stop container[$1]"
                return 1
            fi
            docker rm -v $1
            if [[ $? -ne 0 ]]; then
                error "failed to remove container[$1]"
                return 1
            fi
        ;;
        "10")
            docker kill $1
            if [[ $? -ne 0 ]]; then
                error "failed to kill container[$1]"
                return 1
            fi
        ;;
        "00")
            docker stop $1
            if [[ $? -ne 0 ]]; then
                error "failed to stop container[$1]"
                return 1
            fi
        ;;
        *)
            error "invalid stop | remove args."
            return 1
        ;;
    esac

    if [[ ${CLEAN} -eq 1 ]]; then
        local _DATA_DIR="${DATA_BASE:=/opt}/$1"
        local _BACK_BASE="${DATA_BASE:=/opt}/backup"
        local _BACK_FILE="${_BACK_BASE}/$1_`date '+%Y%m%d%H%M%S'`.tar.gz"

        if [[ ${SKIP_BACK} -ne 1 ]]; then
            info "backing up container[$1] data dir: ${_DATA_DIR}"
            if [[ ! -d "${_BACK_BASE}" ]]; then
                ${SUDO} mkdir -p "${_BACK_BASE}"
            fi
            pushd "${_DATA_DIR}" >/dev/null
                ${SUDO} tar -czvf "${_BACK_FILE}" ./
                ${SUDO} ls -l "${_BACK_FILE}"
            popd >/dev/null
        fi

        info "cleaning container[$1] data dir: ${_DATA_DIR}"
        ${SUDO} rm -rf "${_DATA_DIR}"
    fi
}

ERR=0

for CONTAINER in $*; do
    "${STATUS_COMMAND}" ${CONTAINER} &>/dev/null
    if [[ $? -ne 0 && ${REMOVE} -ne 1 ]]; then
        warning "docker container[${CONTAINER}] already stopped."
        ERR=$((ERR+1))
        continue
    fi
    info "stopping ${CONTAINER}..."
    stop_container ${CONTAINER}
    if [[ $? -ne 0 ]]; then
        ERR=$((ERR+1))
        continue
    fi
done

exit ${ERR}
