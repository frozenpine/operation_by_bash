CONF_BASE="${BASE_DIR}/conf"
MODULE_BASE="${BASE_DIR}/module.d"
CONTAINER_BASE="${BASE_DIR}/container.d"
SERVICE_BASE="${BASE_DIR}/service.d"
TEMPLATE_BASE="${BASE_DIR}/templates"
SQL_BASE="${BASE_DIR}/sql"

COMMON_ENV="${CONF_BASE}/common.env"

if [[ -f "${COMMON_ENV}" ]]; then
    source "${COMMON_ENV}"
else
    echo "[error] common.env missing." >&2
    exit 1
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
    # _rotate_log_file

    sed '1s/\(.*\)/'"`date "+%Y-%m-%d %H:%M:%S"`"' \1/' >> "${LOG_FILE:=/dev/null}"
}

function _check_log() {
    if [[ -z ${LOG_FILE} && -z ${LOG_DIR} ]]; then
        return
    fi

    if [[ -n ${LOG_FILE} ]]; then
        if [[ -f "${LOG_FILE}" && ! -w "${LOG_FILE}" ]]; then
            echo "[error] log file[${LOG_FILE}] exists, but not writable." >&2
            return 1
        fi

        pushd `dirname "${LOG_FILE}"` >/dev/null
        LOG_DIR=`pwd`
        popd >/dev/null
    fi

    if [[ -d "${LOG_DIR}" ]]; then
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

    if [[ x"${_BASE_DIR}" == "x" ]]; then
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

# help message for position args
declare -a HELP_POSITION_ARGS

function _trim_line() {
    local _LINE_MAX
    local _START
    local _END
    local _LAST_SEP
    local _HEAD_LEN
    local _LINE
    local _BREAK
    local _TRIM_LINE
    local _SPACE
    local _COLOR
    local _FIRST_LINE

    _LINE_MAX=79

    _FIRST_LINE=$1
    shift
    _HEAD_LEN=$1
    shift
    _SPACE=$1
    shift
    _COLOR=$1
    shift
    _LINE=$*

    if [[ ${#_LINE} -le $((_LINE_MAX-_HEAD_LEN)) ]]; then
        if [[ ${_FIRST_LINE} -eq 1 ]]; then
            printf "%${_SPACE}s${_COLOR}%s${COLOR["nc"]}\n" " " "${_LINE}"
        else
            printf "%${_HEAD_LEN}s%${_SPACE}s${_COLOR}%s${COLOR["nc"]}\n" " " " " "${_LINE}"
        fi
        return
    fi

    _END=0
    while [[ ${_END} -lt ${#_LINE} ]]; do
        _START=${_END}
        _LAST_SEP=${_END}
        
        while true; do
            if [[ ${_LINE:$_END:1} =~ (\'|\") ]]; then
                if [[ ${_BREAK} == ${_LINE:$_END:1} ]]; then
                    _BREAK=
                else
                    _BREAK=${_LINE:$_END:1}
                fi
            fi

            case ${_LINE:$_END:1} in
                "[")
                    if [[ -z ${_BREAK} ]]; then
                        _BREAK="["
                    fi
                ;;
                "]")
                    if [[ ${_BREAK} == "[" ]]; then
                        _BREAK=
                    fi
                ;;
            esac

            if [[ -z ${_BREAK} && ${_LINE:$_END:1} =~ ( |,|/|\\|\.|;) ]]; then
                _LAST_SEP=$((_END+1))
            fi

            _END=$((_END+1))

            if [[ ${_END} -ge ${#_LINE} ]]; then
                _END=${#_LINE}
                break
            fi

            if [[ $((_END-_START)) -gt $((_LINE_MAX-_HEAD_LEN)) ]]; then
                _END=${_LAST_SEP}
                break
            fi
        done

        if [[ ${_FIRST_LINE} -eq 1 && ${_START} -eq 0 ]]; then
            printf "%${_SPACE}s${_COLOR}%s${COLOR["nc"]}\n" " " "${_LINE:$_START:$((_END-_START))}"
        else
            _TRIM_LINE="${_LINE:$_START:$((_END-_START))}"
            printf "%${_HEAD_LEN}s%${_SPACE}s${_COLOR}%s${COLOR["nc"]}\n" " " " " "${_TRIM_LINE## }"
        fi
    done
}

function help_message() {
    local _CMD
    local _ARG_LIST
    local _POSITION_ARG_LIST
    local _OPTIONAL
    local _COMMAND_LIST
    local _MAX_CMD
    local _HEAD_LEN
    local _LINE_MAX

    _CMD=`basename $0`
    _HEAD_LEN=7
    _MAX_CMD=0
    _LINE_MAX=89

    # if [[ "x${HELP_ARGS["D"]}" == "x" ]]; then
    #     HELP_ARGS["D"]="optional,Dry-run command for test."
    # fi

    if [[ "x${HELP_ARGS["h"]}" == "x" ]]; then
        HELP_ARGS["h"]="optional,Show this help message."
    fi

    for ARG in ${!HELP_ARGS[@]}; do
        DESCRIPTION=${HELP_ARGS[$ARG]}

        if [[ ${DESCRIPTION} == "-" ]]; then
            continue
        fi

        if [[ $ARG =~ ":" ]]; then
            ARG_PATTERN="-${ARG:0:1} {${ARG:2}}"
        else
            ARG_PATTERN="-${ARG:0:1}"
        fi

        if [[ ${DESCRIPTION} =~ optional, ]]; then
            _ARG_LIST="${_ARG_LIST} [${ARG_PATTERN}]"
        else
            _ARG_LIST="${_ARG_LIST} ${ARG_PATTERN}"
        fi
    done

    _OPTIONAL=
    for POS in ${!HELP_POSITION_ARGS[@]}; do
        POS_ARG="${HELP_POSITION_ARGS[$POS]}"

        if [[ ${POS_ARG} =~ optional, ]]; then
            _OPTIONAL=1
        fi

        if [[ ${_OPTIONAL} -eq 1 ]]; then
            _POSITION_ARG_LIST="${_POSITION_ARG_LIST} [${POS_ARG#optional,}]"
        else
            _POSITION_ARG_LIST="${_POSITION_ARG_LIST} ${POS_ARG#optional,}"
        fi
    done

    if [[ ${#HELP_COMMANDS[@]} -ge 1 ]]; then
        for NAME in ${!HELP_COMMANDS[@]}; do
            _COMMAND_LIST="${_COMMAND_LIST} | ${NAME}"
            
            if [[ ${#NAME} -gt ${_MAX_CMD} ]]; then
                _MAX_CMD=${#NAME}
            fi
        done
        _COMMAND_LIST="{ ${_COMMAND_LIST# | } }"

        if [[ ${_HEAD_LEN} -le ${_MAX_CMD} ]]; then
            _HEAD_LEN=$((${_MAX_CMD}+2))
        fi
    fi

    printf "Usage: ${COLOR["cyan"]}%s${COLOR["nc"]}" "${_CMD}"
    if [[ ${#HELP_COMMANDS[@]} -ge 1 ]]; then
        _trim_line 1 $((7+${#_CMD})) 1 ${COLOR["dark_gray"]} ${_ARG_LIST## }
        _trim_line 0 $((7+${#_CMD})) 1 ${COLOR["blue"]} ${_COMMAND_LIST}
    else
        _trim_line 1 $((7+${#_CMD})) 1 ${COLOR["dark_gray"]} "${_ARG_LIST## }"
    fi
    if [[ ${#HELP_POSITION_ARGS[@]} -ge 1 ]]; then
        _trim_line 0 $((7+${#_CMD})) 1 ${COLOR["yellow"]} "${_POSITION_ARG_LIST## }"
    fi

    printf "${COLOR["dark_gray"]}%s${COLOR["nc"]}\n" "Args:"
    for ARG in ${!HELP_ARGS[@]}; do
        DESCRIPTION=${HELP_ARGS[$ARG]}

        if [[ ${DESCRIPTION} == "-" ]]; then
            continue
        fi

        printf "${COLOR["dark_gray"]}%${_HEAD_LEN}s${COLOR["nc"]}" "-${ARG:0:1}"
        _trim_line 1 ${_HEAD_LEN} 4 ${COLOR["dark_gray"]} ${DESCRIPTION#optional,}
    done
    
    if [[ ${#HELP_COMMANDS[@]} -lt 1 ]]; then
        return
    fi
    
    printf "${COLOR[light_blue]}%s${COLOR["nc"]}\n" "Commands:"
    for NAME in ${!HELP_COMMANDS[@]}; do
        printf "${COLOR["blue"]}%${_HEAD_LEN}s${COLOR["nc"]}" "${NAME}"

        DESCRIPTION=${HELP_COMMANDS[$NAME]}

        _trim_line 1 ${_HEAD_LEN} 4 ${COLOR["light_blue"]} ${DESCRIPTION}
    done
}

function gen_md5() {
    if [[ $# -lt 1 ]]; then
        error "source file missing in gen md5: $*"
        exit 1
    fi

    local _src_file
    local _check_sum_file
    local _print_tag

    if [[ $1 == "-p" ]]; then
        _print_tag=1
        shift
    fi

    _src_file="$1"

    if [[ ${_print_tag} -eq 1 ]]; then
        _check_sum_file=/dev/null
    else
        if [[ $# -gt 1 ]]; then
            _check_sum_file="$2"
        else
            _check_sum_file="${_src_file}.md5"
        fi
    fi

    openssl md5 "${_src_file}" | cut -d' ' -f2 | tee "${_check_sum_file}"
}

function check_md5() {
    if [[ $# -lt 1 ]]; then
        error "invalid args in gen md5: $*"
        exit 1
    fi

    local _src_file
    local _check_sum_file
    local _src_file_md5

    _src_file="$1"
    if [[ $# -gt 1 ]]; then
        _check_sum_file="$2"
    else
        _check_sum_file="${_src_file}.md5"
    fi

    if [[ ! -f "${_check_sum_file}" ]]; then
        error "check sum file missing."
        exit 1
    fi

    _src_file_md5=$(gen_md5 -p "${_src_file}")
    if [[ "${_src_file_md5}" != `cat "${_check_sum_file}"` ]]; then
        return 1
    fi
}

function check_env_true() {
    if [[ $# -ne 1 ]]; then
        error "env name missing in check_true."
        exit 1
    fi

    typeset -u ENV_NAME
    ENV_NAME=$1

    local _env_value=$(eval echo "\$`echo ${ENV_NAME}`")

    if [[ ${_env_value} -eq 1 ]]; then
        return
    fi

    if [[ ${_env_value} =~ ([Tt]([Rr][Uu][Ee])?|[Yy]([Ee][Ss])?) ]]; then
        return
    fi

    return 1
}

function list_dir() {
    if [[ $# -ne 1 ]]; then
        error "base dir missing in list dir."
        exit 1
    fi
    
    local _idx=1
    local _base_dir=$1

    if [[ ! -d "${_base_dir}" ]]; then
        error "path[${_base_dir}] is not a directory."
        exit 1
    fi
    
    echo
    echo "Available {dir_name}: "

    find "${_base_dir}" -maxdepth 1 -type d -not -name "`basename ${_base_dir}`" -exec basename {} \; | \
        while read _dir_name; do
            if [[ ${_idx} -lt 100 ]]; then
                _space_width=4
            else
                _space_width=$((6-${#_idx}))
            fi

            printf "%${_space_width}s%02d. %s\n" " " "${_idx}" "${_dir_name}"
            _idx=$((_idx+1))
        done
}
