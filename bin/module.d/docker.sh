function check_container() {
    if [[ $# -lt 1 ]]; then
        error "container name missing in check."
        exit 1
    fi

    local _err=0

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
            _err=$((_err+1))
        fi
    done

    return ${_err}
}

function start_container() {
    if [[ $# -lt 1 ]]; then
        error "container name missing in start."
        exit 1
    fi

    local _container=$1
    local _count=`docker ps --all --filter=name=${_container} --quiet | wc -l`
    local _start_script=`find "${CONTAINER_BASE}" -type f -name "${_container}.sh"`

    if [[ ${_count} -eq 1 ]]; then
        docker start ${_container}
        return $?
    else
        if [[ -f "${_start_script}" ]]; then
            shift
            source "${_start_script}" $*
            return $?
        else
            error "no start script found for ${_container}"
            return 1
        fi
    fi
}

function stop_container() {
    if [[ $# -lt 1 ]]; then
        error "container name missing in stop."
        exit 1
    fi

    local _remove=0
    local _force=0
    local _clean=0
    local _skip_back=0

    local OPTIND FLAG
    while getopts :frcs FLAG; do
        case $FLAG in
            r)
                _remove=1
            ;;
            f)
                _force=1
            ;;
            c)
                _clean=1
            ;;
            s)
                _skip_back=1
            ;;
            *)
                error "invalid args in stop container: $*"
                exit 1
            ;;
        esac
    done
    shift $((OPTIND-1))

    case "${_force}${_remove}" in
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

    if [[ ${_clean} -eq 1 ]]; then
        local _data_dir="${DATA_BASE:=/opt}/$1"
        local _back_base="${DATA_BASE:=/opt}/backup"
        local _back_file="${_back_base}/$1_`date '+%Y%m%d%H%M%S'`.tar.gz"

        if [[ ${SKIP_BACK} -ne 1 ]]; then
            info "backing up container[$1] data dir: ${_data_dir}"
            if [[ ! -d "${_back_base}" ]]; then
                ${SUDO} mkdir -p "${_back_base}"
            fi
            if [[ ! -d "${_data_dir}" ]]; then
                warning "data dir not exist for container[$1]."
            else
                pushd "${_data_dir}" >/dev/null
                    ${SUDO} tar -czvf "${_back_file}" ./
                    ${SUDO} ls -l "${_back_file}"
                popd >/dev/null
            fi
        fi

        if [[ -d "${_data_dir}" ]]; then
            info "cleaning container[$1] data dir: ${_data_dir}"
            ${SUDO} rm -rf "${_data_dir}"
        fi
    fi
}
