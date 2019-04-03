#! /bin/bash

declare -A COLOR

COLOR=([black]='\033[0;30m' [red]='\033[0;31m' [green]='\033[0;32m' [oragnge]='\033[0;33m' [blue]='\033[0;34m' [purple]='\033[0;35m' [cyan]='\033[0;36m' [light_gray]='\033[0;37m' [dark_gray]='\033[1;30m' [light_red]='\033[1;31m' [light_green]='\033[1;32m' [yellow]='\033[1;33m' [light_blue]='\033[1;34m' [light_purple]='\033[1;35m' [light_cyan]='\033[1;36m' [white]='\033[1;37m' [nc]='\033[0m')

LOG_FILE=

function message() {
    local _LEVEL
    _LEVEL="$1"
    shift
    echo "[`printf "% 5s" $_LEVEL`] $*"
}

function info() {
    message "INFO" $*
}

function warning() {
    message "WARNI" $* >&2
}

function error() {
    message "ERROR" $* >&2
}

confirm() {
    local _MESSAGE
    local _ANS
    [[ $# -gt 0 ]] && _MESSAGE="$* (y|N) " || _MESSAGE="Confirmed? (y|N) "
    while true; do
        echo -ne "${_MESSAGE}"
        read -n1 -t 10 _ANS
        echo
        [[ -z ${_ANS} ]] && {
            echo -e "Timeout, default ${COLOR[cyan]}N${COLOR[nc]} answer selected."
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
        grep "[${_SEC_NAME}]" "${_INI_FILE}" &>/dev/null
        if [[ $? -ne 0 ]]; then
            error Invalid section name: ${_SEC_NAME}
            return 1
        fi
    fi
    
    sed 's/#.*//g' "${_INI_FILE}" | sed -n '/^\['"${_SEC_NAME}"'\]/,/^\[/ p' | sed '1d; $d; /^[ '"\t"']*$/d'
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
    sed 's/#.*$//g' /etc/hosts | grep -v -E "`uname -n`|localhost|^[ \t]*$" | awk '{printf("ssh://%s\n", $2)}'
}
