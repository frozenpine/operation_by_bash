# checking container's running status.
# position args: $1  container name
# return code:   0   running
#                1   stopped
#                255 container missing
function check_container() {
    if [[ $# -lt 1 ]]; then
        error "container name missing in check."
        exit 1
    fi

    local _name=$1

    COUNT=`docker ps --filter=status=running | awk -vNAME=${_name} 'FNR!=1{ if($NF==NAME)print}' | wc -l`
    
    if [[ $COUNT -eq 1 ]]; then
        info "container[${_name}] is running."
        return
    fi

    docker ps -a | grep ${CONTAINER} &>/dev/null
    if [[ $? -ne 0 ]]; then
        error "container[${CONTAINER}] missing."
        return 255
    else
        warning "container[${CONTAINER}] not running."
        return 1
    fi
}

# start/create container
# args:   -w {pos-integer}  waiting {pos-integer}(default: 1) seconds & check container status again
# position args: $1         container name
#                $*         extra args for start script
# return code:   0          started
#                1          already started
#                2          start failed
#                255        start script missing
function start_container() {
    if [[ $# -lt 1 ]]; then
        error "container name missing in start."
        exit 1
    fi

    local _wait=1

    local OPTIND FLAG
    while getopts :w: FLAG; do
        case $FLAG in
            w)
                _wait=${OPTARG}

                if [[ ! ${_wait} =~ [0-9]+ ]]; then
                    error "wait args must be a positive integer."
                    exit 1
                fi
            ;;
            *)
                error "invalid start container args: $*"
                exit 1
            ;;
        esac
    done
    shift $((OPTIND-1))

    local _name=$1
    local _result
    
    check_container ${_name}
    _result=$?

    case ${_status} in
        0)
            warning "container[${_name}] is already started."
            return 1
        ;;
        1)
            info "starting container[${_name}]..."
            
            docker start ${_name}
            
            if [[ $? -ne 0 ]]; then
                error "starting container[${_name}] failed."
                return 2
            fi
        ;;
        255)
            local _start_script=`find "${CONTAINER_BASE}" -type f -name "${_name}.sh"`
            
            if [[ ! -f "${_start_script}" ]]; then
                error "no start script found for ${_container}"
                return 255
            fi

            info "creating container[${_name}]..."

            # shift container name
            shift
            source "${_start_script}" $*

            if [[ $? -ne 0 ]]; then
                error "creating container[${_name}] failed."
                return 2
            fi
        ;;
        *)
            error ""
        ;;
    esac

    sleep ${_wait}
    check_container ${_name} || return 2
}

# stop, remove container & clean it's data volumes
# args:   -f        stop forcely
#         -r        remove container
#         -c        clean data volume
#         -s        skip backup while cleanning data volume
# position args: $1 container name
# return code:   0  stopped
#                1  failed while stopping, removeing or cleanning
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

    local _name=$1

    case "${_force}${_remove}" in
        "11")
            docker rm -vf $1

            if [[ $? -ne 0 ]]; then
                error "failed to kill & remove container[${_name}]"
                return 1
            fi
        ;;
        "01")
            docker stop $1
            if [[ $? -ne 0 ]]; then
                error "failed to stop container[${_name}]"
                return 1
            fi
            docker rm -v $1
            if [[ $? -ne 0 ]]; then
                error "failed to remove container[${_name}]"
                return 1
            fi
        ;;
        "10")
            docker kill $1
            if [[ $? -ne 0 ]]; then
                error "failed to kill container[${_name}]"
                return 1
            fi
        ;;
        "00")
            docker stop $1
            if [[ $? -ne 0 ]]; then
                error "failed to stop container[${_name}]"
                return 1
            fi
        ;;
        *)
            error "invalid stop | remove args."
            exit 1
        ;;
    esac

    if [[ ${_clean} -eq 1 ]]; then
        local _data_dir="${DATA_BASE:=/opt}/$1"
        local _back_base="${DATA_BASE:=/opt}/backup"
        local _back_file="${_back_base}/$1_`date '+%Y%m%d%H%M%S'`.tar.gz"

        if [[ ${_skip_back} -ne 1 ]]; then
            info "backing up container[$1] data dir: ${_data_dir}"
            if [[ ! -d "${_back_base}" ]]; then
                ${SUDO} mkdir -p "${_back_base}"
            fi
            if [[ ! -d "${_data_dir}" ]]; then
                warning "data dir not exist for container[${_name}]."
            else
                pushd "${_data_dir}" >/dev/null
                    ${SUDO} tar -czvf "${_back_file}" ./
                    ${SUDO} ls -l "${_back_file}"
                popd >/dev/null
            fi
        fi

        if [[ -d "${_data_dir}" ]]; then
            info "cleaning container[${_name}] data dir: ${_data_dir}"
            ${SUDO} rm -rf "${_data_dir}"
        fi
    fi
}
