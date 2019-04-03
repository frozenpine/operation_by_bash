HOST_FILE="${BASE_DIR}/hosts.ini"
APP_FILE="${BASE_DIR}/apps.ini"

function extract_ini_sec() {
    local _SEC_NAME
    local _INI_FILE
    _SEC_NAME="$1"
    _INI_FILE="$2"
    
    if [[ -z ${_INI_FILE} ]]; then
        error INI file arg missing.
        return 1
    elif [[ ! -f "${_INI_FILE}" ]]; then
        error Invalid INI file path: ${_INI_FILE}
        return 1
    fi

    if [[ -z ${_SEC_NAME} ]]; then
        error Section name arg missing.
        return 1
    else
        grep "^\[${_SEC_NAME}\]" "${_INI_FILE}" &>/dev/null
        if [[ $? -ne 0 ]]; then
            error "Invalid section name: ${_SEC_NAME}"
            return 1
        fi
    fi
    
    sed 's/#.*//g' "${_INI_FILE}" | sed -n '/^\['"${_SEC_NAME}"'\]/,/^\[/ p' | sed '/^\[/d; /^[ '"\t"']*$/d'
}

function parse_ssh() {
    local _SSH_PATTERN
    _SSH_PATTERN="ssh://([^:@]{0,})?(:[^@]*)?@?([^:]*)(:.*)?"
    local _SSH_ARGS

    if [[ ! "$1" =~ ${_SSH_PATTERN} ]]; then
        error Invalid ssh connection pattern: "$1"
        return 1
    fi

    local _IDX=0

    for _MATCH_IDX in {1..4}; do
        if [[ -n ${BASH_REMATCH[$_MATCH_IDX]} ]]; then
            _SSH_ARGS[${_IDX}]=${BASH_REMATCH[$_MATCH_IDX]}
            _IDX=$((_IDX+1))
        fi
    done
    
    case ${#_SSH_ARGS[@]} in
        1)
            SSH_USER=`whoami`
            SSH_PASS="*"
            SSH_HOST=${_SSH_ARGS[0]}
            SSH_PORT=22
        ;;
        2)
            SSH_PASS="*"
            if [[ ${_SSH_ARGS[1]} =~ :[0-9]* ]]; then
                SSH_USER=`whoami`
                SSH_HOST=${_SSH_ARGS[0]}
                SSH_PORT=${_SSH_ARGS[1]:1}
            else
                SSH_USER=${_SSH_ARGS[0]}
                SSH_HOST=${_SSH_ARGS[1]}
                SSH_PORT=22
            fi
        ;;
        3)
            if [[ ${_SSH_ARGS[2]} =~ :[0-9]* ]]; then
                SSH_USER=${_SSH_ARGS[0]}
                SSH_PASS="*"
                SSH_HOST=${_SSH_ARGS[1]}
                SSH_PORT=${_SSH_ARGS[2]:1}
            else
                SSH_USER=${_SSH_ARGS[0]}
                SSH_PASS=${_SSH_ARGS[1]:1}
                SSH_HOST=${_SSH_ARGS[2]}
                SSH_PORT=22
            fi
        ;;
        4)
            SSH_USER=${_SSH_ARGS[0]}
            SSH_PASS=${_SSH_ARGS[1]:1}
            SSH_HOST=${_SSH_ARGS[2]}
            SSH_PORT=${_SSH_ARGS[3]:1}
        ;;
    esac
}

function get_all_hosts() {
    sed 's/#.*$//g' /etc/hosts | grep -v -E "`uname -n`|localhost|^[ \t]*$" | awk '{printf("ssh://%s\n", $1)}'
}

function host_list() {
    if [[ -n ${GROUP_NAME} ]]; then
        extract_ini_sec ${GROUP_NAME} "${HOST_FILE}" || exit 1
    elif [[ -n ${REMOTE_HOST} ]]; then
        local _USER
        [[ -n ${REMOTE_USER} ]] && _USER="${REMOTE_USER}" || _USER=`whoami`
        echo "ssh://${_USER}@${REMOTE_HOST}:${REMOTE_PORT:=22}"
    else
        get_all_hosts
    fi
}
