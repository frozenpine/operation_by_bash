#!/bin/bash

[[ -L $0 ]] && SCRIPT_FILE=$(readlink -fn $0) || SCRIPT_FILE=$0
pushd $(dirname "${SCRIPT_FILE}") >/dev/null
BASE_DIR=$(pwd)
popd >/dev/null

source "${BASE_DIR}/module.d/common.sh"
check_env || exit 1

FUNC_FILE_CONFIG="${MODULE_BASE}/config.sh"
FUNC_FILE_REMOTE="${MODULE_BASE}/remote.sh"
import_functions

HELP_ARGS["u:user_name"]="optional,Specify user name used in ssh connection, if not specified, local user will be used."
HELP_ARGS["H:host_name"]="optional,Specify a ssh host to connect to."
HELP_ARGS["P:host_port"]="optional,Specify a ssh port to connect to, if not specified, default[22] port will be used."
HELP_ARGS["g:app_group"]="optional,Specify a application group name, if not specified, all hosts in \"/etc/hosts\" except localhost will be used."
HELP_ARGS["D"]="optional,Dry run command for test."

HELP_POSITION_ARGS[0]="PATH"
HELP_POSITION_ARGS[1]="optional,PATH..."

RECURSIVE=

while getopts :u:H:p:g:Drh FLAG; do
    case $FLAG in
    g)
        GROUP_NAME=${OPTARG}
        ;;
    D)
        DRY_RUN="echo"
        ;;
    u)
        REMOTE_USER=${OPTARG}
        ;;
    H)
        REMOTE_HOST=${OPTARG}
        ;;
    p)
        REMOTE_PORT=${OPTARG}
        ;;
    r)
        RECURSIVE="-r"
        ;;
    h)
        help_message >&2
        exit
        ;;
    *)
        error "invalid args: $*"
        help_message >&2
        exit 1
        ;;
    esac
done
shift $((OPTIND - 1))

[[ $# -lt 1 ]] && {
    echo "Invalid params." >&2
    exit 1
}

host_list | while read HOST_CONF; do
    parse_ssh ${HOST_CONF}
    if [[ $? -ne 0 ]]; then
        warning "Invalid config in group ${GROUP_NAME}: $HOST_CONF"
        continue
    fi
    remote_cp ${RECURSIVE} $*
done
