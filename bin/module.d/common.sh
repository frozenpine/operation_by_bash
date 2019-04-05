CONF_BASE="${BASE_DIR}/conf"
MODULE_BASE="${BASE_DIR}/module.d"

COMMON_ENV="${CONF_BASE}/common.env"

if [[ -f "${COMMON_ENV}" ]]; then
    source "${COMMON_ENV}"
fi

if [[ -n ${IDENTITY_FILE} ]]; then
    IDENTITY="-i ${IDENTITY_FILE}"
fi

# Bash Color start
# to display color with enhanced echo command: "echo -e"
# color only functioned properly under xterm terminal
# ${COLOR[color name]}something to be colorized${COLOR[nc]}
declare -A COLOR

COLOR=([black]='\033[0;30m' [red]='\033[0;31m' [green]='\033[0;32m' [orange]='\033[0;33m' [blue]='\033[0;34m' [purple]='\033[0;35m' [cyan]='\033[0;36m' [light_gray]='\033[0;37m' [dark_gray]='\033[1;30m' [light_red]='\033[1;31m' [light_green]='\033[1;32m' [yellow]='\033[1;33m' [light_blue]='\033[1;34m' [light_purple]='\033[1;35m' [light_cyan]='\033[1;36m' [white]='\033[1;37m' [nc]='\033[0m')
# Bash color end

# Bash log start
# logger function will retrive log message from stdin with prefix: [log level]
#   log level: info warni error
# file_logger is already registered.
declare -A LOGGERS

function _rotate_file_by_size() {
    [[ -z ${LOG_FILE} ]] && return

    echo >/dev/null
}

function _rotate_file_by_TIME() {
    [[ -z ${LOG_FILE} ]] && return

    echo >/dev/null
}

# rotate log file by all rotate variable: ROTATE_BY_SIZE, ROTATE_BY_TIME
function _rotate_log_file() {
    _rotate_file_by_TIME
    _rotate_file_by_size
}

# log message to file specified by variable LOG_FILE
# if LOG_FILE is null, will create "Syslog.log" under directory specified by variable LOG_DIR
# if both variable missing, nothing happen.
function file_logger() {
    _rotate_log_file

    sed '1s/\(.*\)/'"`date "+%Y-%m-%d %H:%M:%S"`"' \1/' >> "${LOG_FILE:=/dev/null}"
}

function _check_log() {
    if [[ -z ${LOG_FILE} && -z ${LOG_DIR} ]]; then
        return
    fi

    if [[ -n ${LOG_FILE} ]]; then
        if [[ ! -w "${LOG_FILE}" ]]; then
            echo "[error] log file[${LOG_FILE}] exists, but not writable." >&2
            return 1
        fi

        pushd `dirname "${LOG_FILE}"` >/dev/null
        LOG_DIR=`pwd`
        popd >/dev/null
    elif [[ -d "${LOG_DIR}" ]]; then
        if [[ ! -w "${LOG_DIR}" ]]; then
            echo "[error] log dir[${LOG_DIR}] exists, but not writable." >&2
            return 1
        fi

        LOG_FILE="${LOG_DIR}/Syslog.log"
    else
        echo "[error] path[${LOG_DIR}] is not a directory." >&2
        return 1
    fi
}

_check_log || exit 1
LOGGERS["file"]=file_logger

function _message() {
    local _LEVEL
    local _COLOR_CODE
    local _DST
    case $1 in
        INFO|info)
            _COLOR_CODE=${COLOR[green]}
        ;;
        WARNI|WARNING|warni|warning)
            _COLOR_CODE=${COLOR[orange]}
        ;;
        ERROR|error)
            _COLOR_CODE=${COLOR[red]}
        ;;
    esac
    _LEVEL="[${_COLOR_CODE}`printf "% 5s" $1`${COLOR[nc]}]"
    shift

    for LOGGER in ${LOGGERS[@]}; do
        _DST="${_DST} >(${LOGGER})"
    done

    if [[ $# -gt 0 ]]; then
        eval $(echo -e "echo \"${_LEVEL} $*\" | tee ${_DST}")
    else
        eval $(echo -e "sed -e 's/\(.*\)/    \1/g' -e '1i ${_LEVEL} >>>' | tee ${_DST}")
    fi
}

function info() {
    if [[ $# -gt 0 ]]; then
        _message "INFO" $*
    else
        cat | _message "INFO"
    fi
}

function warning() {
    if [[ $# -gt 0 ]]; then
        _message "WARNI" $* >&2
    else
        cat | _message "WARNI" >&2
    fi
}

function error() {
    if [[ $# -gt 0 ]]; then
        _message "ERROR" $* >&2
    else
        cat | _message "ERROR" >&2
    fi
}
# Bash log end

# Bash dialog start
function confirm() {
    local _MESSAGE
    local _DELAY
    local _ANS

    while getopts :t: FLAG; do
        case $FLAG in
            t)
                _DELAY=${OPTARG}
            ;;
            *)
                error "invalid confirm args: $*"
                exit 1
            ;;
        esac
    done
    shift $((OPTIND-1))

    [[ $# -gt 0 ]] && _MESSAGE="$* (y|N) " || _MESSAGE="Confirmed? (y|N) "
    while true; do
        echo -ne "${_MESSAGE}"
        read -n1 -t ${_DELAY:=10} _ANS
        echo
        [[ -z ${_ANS} ]] && {
            echo -e "Timeout[${_DELAY:=10} s], default ${COLOR[cyan]}N${COLOR[nc]} answer selected."
            _ANS='n'
        }
        case ${_ANS} in
            Y|y)
                return 0
            ;;
            N|n)
                return 1
            ;;
            *)
                echo; echo "Invalid input, please answer y or n."
                continue
            ;;
        esac
    done
}
# Bash dialog end

# Bash func import start
# import bash functions from file specified by variables with prefix "FUNC_FILE_"
function import_functions() {
    for FUNC_FILE in ${!FUNC_FILE_@}; do
        FUNC_FILE_PATH=$(eval echo \$$FUNC_FILE)
        if [[ -f "${FUNC_FILE_PATH}" ]]; then
            source "${FUNC_FILE_PATH}"
        else
            echo "${FUNC_FILE_PATH} not found." >&2
            exit 1
        fi
    done
}
# Bash func import end

# Bash path start
function is_relative_path() {
    if [[ $1 =~ ^/.* ]]; then
        return 1
    fi
}
# Bash path end

function get_id() {
    if [[ $# -ne 1 || ! $1 =~ [a-zA-Z_-]+0*([0-9]+) ]]; then
        echo "invalid hostname: $1" >&2
        exit 1
    fi
    ID=`echo ${BASH_REMATCH[1]}`
}

function find_user() {
    if [[ $# -ne 1 ]]; then
        error "missing user name."
        exit 1
    fi

    grep $1 /etc/passwd >/dev/null || return 1
}

function make_dir() {
    local _BASE_DIR

    while getopts :b: FLAG; do
        case $FLAG in
            b)
                _BASE_DIR="${OPTARG}"
            ;;
            *)
                error "invalid args: $*"
                exit 1
            ;;
        esac
    done
    shift $((OPTIND-1))

    if [[ -z "${_BASE_DIR}" ]]; then
        error "base dir missing."
        exit 1
    else
        ${SUDO} mkdir -p "${_BASE_DIR}" || return 1
    fi

    for DIR in $*; do
        ${SUDO} mkdir -p "${_BASE_DIR}/${DIR}" || return 1
    done

    ${SUDO} chmod go+rx "${_BASE_DIR}"
}

# help message for command
# HELP_COMMANDS["command name"]="command description"
declare -A HELP_COMMANDS

# help message for args
# HELP_ARGS["arg name"]="optional,arg description"
# arg name without prefix "-"
# if arg is optional, make sure arg description is start with "optional,"
# if arg has arg value, make sure join arg name and value name with ":"
# HELP_ARGS has two default args: -D for dry-run, -h for help message
# if no need to use this two default args, please set arg description with "-"
declare -A HELP_ARGS

function _help() {
    local _CMD
    local _ARG_LIST
    local _COMMAND_LIST
    local _MAX_CMD
    local _HEAD_LEN
    local _DES_MAX

    _CMD=`basename $0`
    _HEAD_LEN=$((7+${#_CMD}))
    _MAX_CMD=0
    _DES_MAX=100

    if [[ ${#HELP_COMMANDS[@]} -ge 1 ]]; then
        for NAME in ${!HELP_COMMANDS[@]}; do
            _COMMAND_LIST="${_COMMAND_LIST}|${NAME}"
            
            if [[ ${#NAME} -gt ${_MAX_CMD} ]]; then
                _MAX_CMD=${#NAME}
            fi
        done
        _COMMAND_LIST="{${_COMMAND_LIST:1}}"
    fi

    if [[ "x${HELP_ARGS["D"]}" == "x" ]]; then
        HELP_ARGS["D"]="optional,Dry-run command for test."
    fi

    if [[ "x${HELP_ARGS["h"]}" == "x" ]]; then
        HELP_ARGS["h"]="optional,Show this help message."
    fi

    for ARG in ${!HELP_ARGS[@]}; do
        DESCRIPTION=${HELP_ARGS[$ARG]}

        if [[ ${DESCRIPTION} == "-" ]]; then
            continue
        fi

        if [[ $ARG =~ : ]]; then
            ARG_PATTERN="-${ARG:0:1} ${ARG:2}"
        else
            ARG_PATTERN="-${ARG:0:1}"
        fi

        if [[ ${DESCRIPTION} =~ optional, ]]; then
            _ARG_LIST="${_ARG_LIST} [${ARG_PATTERN}]"
        else
            _ARG_LIST="${_ARG_LIST} ${ARG_PATTERN}"
        fi
    done

    printf "Usage: %s %s %s\n" "${_CMD}" "${_ARG_LIST}" "${_COMMAND_LIST}"
    
    if [[ ${#_HEAD_LEN} -lt ${#_MAX_CMD} ]]; then
        _HEAD_LEN=${#_MAX_CMD}
    fi

    printf "%s\n" "Args:"
    for ARG in ${!HELP_ARGS[@]}; do
        DESCRIPTION=${HELP_ARGS[$ARG]}

        if [[ ${DESCRIPTION} == "-" ]]; then
            continue
        fi

        printf "%${_HEAD_LEN}s    %s\n" "-${ARG:0:1}" "${DESCRIPTION#optional,}"
    done
    
    if [[ ${#HELP_COMMANDS[@]} -lt 1 ]]; then
        return
    fi
    
    printf "%s\n" "Commands:"
    for NAME in ${!HELP_COMMANDS[@]}; do
        printf "%${_HEAD_LEN}s" "${NAME}"

        DESCRIPTION=${HELP_COMMANDS[$NAME]}

        if [[ ${#DESCRIPTION} -le ${_DES_LEN} ]]; then
            printf "    %s\n" "${HELP_COMMANDS[$NAME]}"
        else
            _END=0
            while [[ ${_END} -lt ${#DESCRIPTION} ]]; do
                _START=${_END}
                _LAST_SEP=${_END}
                
                while true; do
                    if [[ ${DESCRIPTION:$_END:1} =~ ( |,|/|\\|\.|;|\"|\') ]]; then
                        _LAST_SEP=$((_END+1))
                    fi

                    _END=$((_END+1))

                    if [[ ${_END} -ge ${#DESCRIPTION} ]]; then
                        _END=${#DESCRIPTION}
                        break
                    fi

                    if [[ $((_END-_START)) -gt ${_DES_MAX} ]]; then
                        _END=${_LAST_SEP}
                        break
                    fi
                done

                if [[ ${_START} -eq 0 ]]; then
                    printf "    %s\n" "${DESCRIPTION:$_START:$((_END-_START))}"
                else
                    printf "%${_HEAD_LEN}s    %s\n" " " "${DESCRIPTION:$_START:$((_END-_START))}"
                fi
            done
        fi
    done
}
