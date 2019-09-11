#!/bin/bash

[[ -L $0 ]] && SCRIPT_FILE=`readlink -fn $0` || SCRIPT_FILE=$0
pushd `dirname "${SCRIPT_FILE}"` >/dev/null
BASE_DIR=`pwd`
popd >/dev/null

source "${BASE_DIR}/module.d/common.sh"
check_env || exit 1

FUNC_FILE_CONFIG="${MODULE_BASE}/config.sh"
FUNC_FILE_REMOTE="${MODULE_BASE}/remote.sh"
import_functions

HELP_ARGS["u:user_name"]="optional,Specify user name used in ssh connection, if not specified, local user will be used."
HELP_ARGS["H:host_name"]="optional,Specify a ssh host to connect to."
HELP_ARGS["p:host_port"]="optional,Specify a ssh port to connect to, if not specified, default[22] port will be used."
HELP_ARGS["g:app_group"]="optional,Specify a ssh host group, if not specified, all hosts in \"/etc/hosts\" except localhost will be used."
HELP_ARGS["D"]="optional,Dry run command for test."

HELP_POSITION_ARGS[0]="COMMAND..."

FORCE=0

while getopts :u:H:p:g:fDh FLAG; do
    case $FLAG in
        g)
            GROUP_NAME=${OPTARG}
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
        D)
            DRY_RUN="echo"
        ;;
        f)
            FORCE=1
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

if [[ $# -lt 1 ]]; then
    error please input commands to execute.
    exit 1
fi

CMD_LINE=($*)

if [[ $1 == "sudo" ]]; then
    shift
fi

while read CMD; do
    if [[ "$*" =~ ^${CMD} ]]; then
        echo -e "${COLOR[red]}Command \`$1\` not supported by this script.${COLOR[nc]}" >&2
        error skip ${CMD_LINE[@]}
        exit 1
    fi
done <"${CONF_BASE}/.ignore"

if [[ ${FORCE} != 1 ]]; then
    for CMD in `cat "${CONF_BASE}/.dangerous"`; do
        if [[ "$*" =~ ^${CMD} ]]; then
            confirm "\`${COLOR[yellow]}$1${COLOR[nc]}\` command is ${COLOR[red]}dangeours${COLOR[nc]} to remote site, confirm?"

            if [[ $? -eq 0 ]]; then
                break
            else
                error skip ${CMD_LINE[@]}
                exit 1
            fi
        fi
    done
fi

host_list | while read HOST_CONF; do
    parse_ssh ${HOST_CONF}
    if [[ $? -ne 0 ]]; then
        warning "Invalid config in group ${GROUP_NAME}: $HOST_CONF"
        continue
    fi
    remote_exec ${CMD_LINE[@]}
done
