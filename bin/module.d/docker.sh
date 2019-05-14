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

    local _CONTAINER_NAME=$1

    COUNT=`docker ps --filter=status=running | \
        awk -vNAME=${_CONTAINER_NAME} 'FNR!=1{ if($NF==NAME)print}' | \
        wc -l`
    
    if [[ $COUNT -eq 1 ]]; then
        info "container[${_CONTAINER_NAME}] is running."
        return
    fi

    docker ps -a | grep ${_CONTAINER_NAME} &>/dev/null
    if [[ $? -ne 0 ]]; then
        error "container[${_CONTAINER_NAME}] missing."
        return 255
    else
        warning "container[${_CONTAINER_NAME}] not running."
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

    local _WAIT=1
    local OPTIND FLAG
    while getopts :w: FLAG; do
        case $FLAG in
            w)
                _WAIT=${OPTARG}

                if [[ ! ${_WAIT} =~ [0-9]+ ]]; then
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

    local _CONTAINER_NAME=$1
    
    check_container ${_CONTAINER_NAME} &>/dev/null
    case $? in
        0)
            warning "container[${_CONTAINER_NAME}] is already started."
            return 1
        ;;
        1)
            info "starting container[${_CONTAINER_NAME}]..."
            
            docker start ${_CONTAINER_NAME}
            
            if [[ $? -ne 0 ]]; then
                error "starting container[${_CONTAINER_NAME}] failed."
                return 2
            fi
        ;;
        255)
            local _start_script=`find "${CONTAINER_BASE}" -type f -name "${_CONTAINER_NAME}.sh"`
            
            if [[ ! -f "${_start_script}" ]]; then
                error "no start script found for ${_container}"
                return 255
            fi

            info "creating container[${_CONTAINER_NAME}]..."

            # shift container name
            shift
            source "${_start_script}" $*

            if [[ $? -ne 0 ]]; then
                error "creating container[${_CONTAINER_NAME}] failed."
                return 2
            fi
        ;;
        *)
            error ""
        ;;
    esac

    sleep ${_WAIT}
    check_container ${_CONTAINER_NAME} || return 2
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

    local _REMOVE_CONTAINER=0
    local _KILL=0
    local _CLEAN_VOLUME=0
    local _skip_back=0

    local OPTIND FLAG
    while getopts :frcs FLAG; do
        case $FLAG in
            r)
                _REMOVE_CONTAINER=1
            ;;
            f)
                _KILL=1
            ;;
            c)
                _CLEAN_VOLUME=1
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

    local _CONTAINER_NAME=$1

    check_container ${_CONTAINER_NAME} >/dev/null
    case $? in
        1)
            if [[ ${_REMOVE_CONTAINER} -ne 1 ]]; then
                return 1
            fi
        ;;
        255)
            if [[ ${_CLEAN_VOLUME} -ne 1 ]]; then
                return 1
            fi
        ;;
    esac

    case "${_KILL}${_REMOVE_CONTAINER}" in
        "11")
            docker rm -vf ${_CONTAINER_NAME}

            if [[ $? -ne 0 ]]; then
                error "failed to kill & remove container[${_CONTAINER_NAME}]"
                return 1
            fi
        ;;
        "01")
            docker stop ${_CONTAINER_NAME}
            if [[ $? -ne 0 ]]; then
                error "failed to stop container[${_CONTAINER_NAME}]"
                return 1
            fi
            docker rm -v ${_CONTAINER_NAME}
            if [[ $? -ne 0 ]]; then
                error "failed to remove container[${_CONTAINER_NAME}]"
                return 1
            fi
        ;;
        "10")
            docker kill ${_CONTAINER_NAME}
            if [[ $? -ne 0 ]]; then
                error "failed to kill container[${_CONTAINER_NAME}]"
                return 1
            fi
        ;;
        "00")
            docker stop ${_CONTAINER_NAME}
            if [[ $? -ne 0 ]]; then
                error "failed to stop container[${_CONTAINER_NAME}]"
                return 1
            fi
        ;;
        *)
            error "invalid stop | remove args."
            exit 1
        ;;
    esac

    if [[ ${_CLEAN_VOLUME} -eq 1 ]]; then
        local _DATA_DIR="${DATA_BASE:=/opt}/${_CONTAINER_NAME}"
        local _BACK_BASE="${DATA_BASE:=/opt}/backup"
        local _BACK_FILE="${_BACK_BASE}/${_CONTAINER_NAME}_`date '+%Y%m%d%H%M%S'`.tar.gz"

        if [[ ! -d "${_DATA_DIR}" ]]; then
            warning "no data dir found."
            return
        fi

        if [[ ${_skip_back} -ne 1 ]]; then
            info "backing up container[$_CONTAINER_NAME] data dir: ${_DATA_DIR}"
            if [[ ! -d "${_BACK_BASE}" ]]; then
                ${SUDO} mkdir -p "${_BACK_BASE}"
            fi
            if [[ ! -d "${_DATA_DIR}" ]]; then
                warning "data dir not exist for container[${_CONTAINER_NAME}]."
            else
                pushd "${_DATA_DIR}" >/dev/null
                    ${SUDO} tar -czvf "${_BACK_FILE}" ./
                    ${SUDO} ls -l "${_BACK_FILE}"
                popd >/dev/null
            fi
        fi

        if [[ -d "${_DATA_DIR}" ]]; then
            info "cleaning container[${_CONTAINER_NAME}] data dir: ${_DATA_DIR}"
            ${SUDO} rm -rf "${_DATA_DIR}"
        fi
    fi
}

function _build() {
    cat | sed '/^[ '"\t"']*$/d' | (\
        while read _FILE_NAME; do
            [[ ${_FILE_NAME} =~ ${BUILD_NAME}-([a-zA-Z-]+)-([SNAPSHOT0-9.-]+).jar ]] || {
                error "invalid jar file name: ${_FILE_NAME}"
                continue
            }

            local _MODULE=${BASH_REMATCH[1]}
            local _VERSION=${BASH_REMATCH[2]}
            
            SIG_FILE="${BUILD_DIR}/${_FILE_NAME}.md5"

            NEW_SIG=`gen_md5 -p "${BUILD_DIR}/${_FILE_NAME}"`
            if [[ ${FORCE} -eq 0 && -f "${SIG_FILE}" && `cat "${SIG_FILE}"` == ${NEW_SIG} ]]; then
                warning "module[${_MODULE}] with version[${_VERSION}] not modified, skip building."
                continue
            fi

            echo -n ${NEW_SIG} >"${SIG_FILE}"
            
            [[ ! -d build ]] && ${SUDO} mkdir build
            pushd build >/dev/null
                TEMP_DOCKERFILE=`mktemp`
                template "${BUILD_DIR}/dockerfile.template" "${TEMP_DOCKERFILE}"
                $SUDO mv "${TEMP_DOCKERFILE}" ./dockerfile

                if [[ -d "../${_MODULE}_conf" ]]; then
                    ${SUDO} rm -rf ./config
                    ${SUDO} cp -r "../${_MODULE}_conf" ./config
                fi

                ${SUDO} rm -f *.jar &>/dev/null
                ${SUDO} cp "${BUILD_DIR}/${_FILE_NAME}" ./ &>/dev/null
                find "${BUILD_DIR}" -type f -name "*.sh" -exec ${SUDO} cp {} . \; &>/dev/null
                ${SUDO} chmod u+x *.sh &>/dev/null

                _IMAGE_NAME="registry:5000/${BUILD_NAME}/${_MODULE}:${_VERSION}"
                eval "${DRY_RUN} docker build . -t ${_IMAGE_NAME}"

                if [[ $? -eq 0 && ${PUSH_REGISTRY} -eq 1 ]]; then
                    eval "${DRY_RUN} docker push ${_IMAGE_NAME}"
                    [[ ${CLEAN_LOCAL} -eq 1 ]] && eval "${DRY_RUN} docker rmi ${_IMAGE_NAME}"
                fi
            popd >/dev/null

            "${BASE_DIR}/allssh" "echo \"docker rmi -f ${_IMAGE_NAME}\" | tee >(eval \`cat\`)"
        done
    )
}

# build & push docker image to registry
# args:   -b project_name   project name
#         -c                whether to clean local temp image
#         -p                whether to push image to registry
#         -f                build image forcely, w/o checking jar md5
function build_image() {
    if [[ $# -lt 1 ]]; then
        error "module name missing in build image."
        exit 1
    fi

    which template &>/dev/null
    if [[ $? -ne 0 ]]; then
        FUNC_FILE_TEMPLATE="${MODULE_BASE}/template.sh"
        import_functions
    fi

    BUILD_BASE="${DATA_BASE:=/opt}/docker-hub"
    BUILD_DIR=
    BUILD_NAME=

    local OPTIND FLAG
    while getopts :b:cpfh FLAG; do
        case $FLAG in
            c)
                CLEAN_LOCAL=1
            ;;
            p)
                PUSH_REGISTRY=1
            ;;
            f)
                FORCE=1
            ;;
            b)
                BUILD_NAME=${OPTARG}
                BUILD_DIR="${BUILD_BASE}/${BUILD_NAME}"
            ;;
            *)
                error "invalid args: $*"
                exit 1
            ;;
        esac
    done
    shift $((OPTIND-1))

    if [[ -z ${BUILD_NAME} ]]; then
        error "missing module name."
        exit 1
    fi

    if [[ $# -ne 1 ]]; then
        error "invalid args: $*"
        exit 1
    fi

    if [[ $1 == "all" ]]; then
        PATTERN="${BUILD_NAME}-*.jar"
    else
        PATTERN="${BUILD_NAME}-$1-*.jar"
    fi

    if [[ ! -d "${BUILD_DIR}" ]]; then
        error "invalid BUILD_NAME"
        exit 1
    fi

    cd "${BUILD_DIR}"

    ORIGIN_TEMPLATE_FILE="${TEMPLATE_BASE}/dockerfile/${BUILD_NAME}.template"
    if [[ ! -f "${ORIGIN_TEMPLATE_FILE}" ]]; then
        error "dockerfile template missing."
        exit 1
    fi

    $SUDO cp -f "${ORIGIN_TEMPLATE_FILE}" ./dockerfile.template

    TEMPLATE_CONF_DIR="${TEMPLATE_BASE}/${BUILD_NAME}"
    if [[ -d "${TEMPLATE_CONF_DIR}" ]]; then
        ${SUDO} cp -r "${TEMPLATE_CONF_DIR}"/* ./
    fi

    ls ${PATTERN} &>/dev/null
    if [[ $? -ne 0 ]]; then
        error "invalid module name: $1"
        exit 1
    fi
    find . -maxdepth 1 -type f -name "${PATTERN}" -exec basename {} \; | _build
}
