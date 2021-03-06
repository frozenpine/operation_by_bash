HOST_FILE="${CONF_BASE}/hosts.ini"

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

_ini_item_pattern='([a-zA-Z0-9_-]+) *= *([a-zA-Z0-9@\#?:/_-]+)'

function get_ini_key() {
    if [[ ! $1 =~ $_ini_item_pattern ]]; then
        error "invalid ini item: $1"
        exit 1
    fi

    echo -n "${BASH_REMATCH[1]}"
}

function get_ini_value() {
    if [[ ! $1 =~ $_ini_item_pattern ]]; then
        error "invalid ini item: $1"
        exit 1
    fi

    echo -n "${BASH_REMATCH[2]}"
}

function list_sections() {
    if [[ $# -gt 0 ]]; then
        SEC_FILE="$1"
    else
        SEC_FILE="${HOST_FILE}"
    fi

    sed -n 's/^\[\(.*\)\]/\1/p' "${SEC_FILE}"
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
    # sed 's/#.*$//g' /etc/hosts | grep -v -E "localhost|^[ \t]*$" | awk '{printf("ssh://%s\n", $1)}'
    for ALIAS_SEC_NAME in `list_sections ${CONF_BASE}/alias.ini`; do
        HOST_IP=`echo ${ALIAS_SEC_NAME} | cut -d':' -f2`
        HOST_NAME=`echo ${ALIAS_SEC_NAME} | cut -d':' -f1`
        echo "ssh://${HOST_IP}"
    done
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

function alias_address() {
    for ALIAS_SEC_NAME in `list_sections ${CONF_BASE}/alias.ini`; do
        HOST_IP=`echo ${ALIAS_SEC_NAME} | cut -d':' -f2`
        HOST_NAME=`echo ${ALIAS_SEC_NAME} | cut -d':' -f1`

        IP=`grep "${HOST_NAME}" /etc/hosts | awk '{print $1}'`

        if [[ -z ${IP} || ${IP} != "${HOST_IP}" ]]; then
            ${SUDO} sed -i 's/'"${HOST_NAME}"' //'  /etc/hosts

            # can not delete space after HOST_IP
            grep "${HOST_IP}[[:space:]]" /etc/hosts >/dev/null
            if [[ $? -eq 0 ]]; then
                ${SUDO} sed -i '/'${HOST_IP}'/ s/\(.*\)/\1 '"${HOST_NAME}"'/' /etc/hosts
            else
                ${SUDO} sed -i '$a'"${HOST_IP} ${HOST_NAME}" /etc/hosts
            fi
        fi
        
        for ALIAS_NAME in `extract_ini_sec ${ALIAS_SEC_NAME} "${CONF_BASE}/alias.ini"`; do
            HOST_ALIAS["$ALIAS_NAME"]="${HOST_IP}"
        done || {
            error "parse alias.ini failed."
            exit 1
        }
    done

    # for NAME in ${!HOST_ALIAS[@]}; do
    #     echo $NAME=${HOST_ALIAS[$NAME]}
    # done
}

function app_ports() {
    if [[ ! -f "${CONF_BASE}/ports.ini" ]]; then
        error "ports.ini missing."
        exit 1
    fi

    for PORT_DEFINE in `sed 's/#.*$//g; /^ *$/d' "${CONF_BASE}/ports.ini"`; do
        NAME=`echo ${PORT_DEFINE} | cut -d'=' -f1`
        NAME=${NAME## }
        NAME=${NAME%% }
        PORT=`echo ${PORT_DEFINE} | cut -d'=' -f2`
        PORT=${PORT## }
        PORT=${PORT%% }
        PORTS[${NAME}]=${PORT}
    done
}
