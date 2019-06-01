#!/bin/bash

[[ -L $0 ]] && SCRIPT_FILE=`readlink -fn $0` || SCRIPT_FILE=$0
pushd `dirname "${SCRIPT_FILE}"` >/dev/null
BASE_DIR=`pwd`
popd >/dev/null

RUNNING_IN_DOCOKER=

source "${BASE_DIR}/module.d/common.sh"
check_env_true RUNNING_IN_DOCOKER
if [[ $? -ne 0 ]]; then
    check_env || exit 1
fi

FUNC_FILE_CONFIG="${BASE_DIR}/module.d/template.sh"
import_functions

MODULE_LIST=(qmarket qwsfront marketserver)

for MODULE in ${MODULE_LIST[@]}; do
    HELP_COMMANDS["${MODULE}"]="Start ${MODULE} module."
done

DAEMON=0

function _check_qmarket_env() {
    if [[ ${USER_CHECK:=false} == "true" && ! -f "${USER_FILE:=UserMap.csv}" ]]; then
        error "user login check set, but user file missing."
        exit 1
    fi

    if [[ x"${KFK_SERVERS}" == "x" ]]; then
        error "kafka connection info missing."
        exit 1
    fi

    cat<<EOF | info
All starting variables:
qmarket:  tcp://${MARKET_ADDR:=127.0.0.1}:${MARKET_PORT:=30007}

kafka brokers:    ${KFK_SERVERS}
kafka group name: ${KFK_GROUP:=qmarket}
kafka partions:   ${KFK_PARTITIONS:=3}
kafka topics: 
    1. checkpoint topic: ${KFK_CHECKPOINT_TOPIC:=MATCH-JSON-SS}
    2. increment topic:  ${KFK_INCREMENT_TOPIC:=MATCH-JSON-SS-INCREMENT}
    3. notify topic:     ${KFK_NOTIFY_TOPIC:=NOTIFY-CLIENT}
EOF
}

function _check_qwsfront_env() {
    if [[ x"${WS_LISTEN_ADDR}" == "x" ]]; then
        error "websocket listen address missing."
        exit 1
    fi

    if [[ x"${TRADE_FRONT}" == "x" ]]; then
        error "trade front address mising."
        exit 1
    elif [[ ! "${TRADE_FRONT}" =~ ^http ]]; then
        TRADE_FRONT="http://${TRADE_FRONT}"
    fi

    cat<<EOF | info
All starting variables:
qmarket:  tcp://${MARKET_ADDR:=127.0.0.1}:${MARKET_PORT:=30007}
qwsfront: ws://${WS_LISTEN_ADDR}:${WS_PORT:=9988}

trade front: ${TRADE_FRONT}
EOF
}

function _check_marketserver_env() {
    if [[ x"${KFK_SERVERS}" == "x" ]]; then
        error "kafka connection info missing."
        exit 1
    fi

    if [[ x"${TRADE_FRONT}" == "x" ]]; then
        error "trade front address mising."
        exit 1
    elif [[ ! "${TRADE_FRONT}" =~ ^http ]]; then
        TRADE_FRONT="http://${TRADE_FRONT}"
    fi

    get_id `uname -n` || exit 1

        cat<<EOF | info
All starting variables:
listen: ws://${LISTEN_ADDR:=0.0.0.0}:${WS_PORT:=9988}

kafka brokers:    ${KFK_SERVERS}
kafka group name: marketserver${ID}
kafka topics: 
    1. checkpoint topic: ${KFK_CHECKPOINT_TOPIC:=MATCH-JSON-SS}
    2. increment topic:  ${KFK_INCREMENT_TOPIC:=MATCH-JSON-SS-INCREMENT}
    3. notify topic:     ${KFK_NOTIFY_TOPIC:=NOTIFY-CLIENT}

trade front: ${TRADE_FRONT}
EOF
}

function _check_env() {
    if [[ $# -lt 1 ]]; then
        error "module name missing in check env."
        exit 1
    fi

    eval "_check_$1_env"
}

function _status() {
    if [[ $# -lt 1 ]]; then
        error "module name missing in status."
        exit 1
    fi

    local _module_name
    local _module_base
    local _pid_file

    _module_name=$1
    shift
    _module_base="${BASE_DIR}/${_module_name}"
    _pid_file="${_module_base}/${_module_name}.pid"

    if [[ -f "${_pid_file}" ]]; then
        kill -0 `cat ${_pid_file}` &>/dev/null
        if [[ $? -eq 0 ]]; then
            info "${_module_name}[`cat ${_pid_file}`] is running."
        else
            warning "${_module_name} not running."
            rm -f "${_pid_file}"
            return 1
        fi
    else
        _pid_info=`ps -ef | grep ${_module_name} | grep -Ev "sh|vi|grep|nano"`
        if [[ $? -eq 0 ]]; then
            _pid=`echo ${_pid_info} | awk '{print $2}'`
            echo -n "${_pid}" > "${_pid_file}"
            info "${_module_name}[${_pid}] is running."
        else
            warning "${_module_name} not running."
            return 1
        fi
    fi
}

function _back_log() {
    if [[ ! -d "log" ]]; then
        warning "log dir not exists in current path: `pwd`"
        return 1
    fi

    local _archive_file="log_`date '+%Y%m%d%H%M%S'`.tar.gz"

    tar -czvf "${_archive_file}" log --remove
    if [[ $? -ne 0 ]]; then
        error "backup log files failed: `pwd`/${_archive_file}"
        return 1
    fi

    ls -l "${_archive_file}"
}

function _archive_logs() {
    if [[ $# -lt 1 ]]; then
        error "pid file not specified in archive logs"
        exit 1
    fi

    local _PID_FILE=$1
    shift

    while true; do
        kill -0 `cat ${_PID_FILE}` || break

        for _LOG_FILE in `ls *.log`; do
            lsof "${_LOG_FILE}" >&/dev/null
            # if file not opened by any process, lsof will return 1
            if [[ $? -eq 1 ]]; then
                gzip "${_LOG_FILE}"
            fi
        done

        sleep $((60*5))
    done
}

function _start() {
    if [[ $# -lt 1 ]]; then
        error "module name missing in start."
        exit 1
    fi

    local _module_name
    local _module_base
    local _template_file
    local _pid_file

    _module_name=$1
    shift
    _module_base="${BASE_DIR}/${_module_name}"
    # _template_file="${_module_base}/${_module_name}.ini.template"
    _pid_file="${_module_base}/${_module_name}.pid"

    _status ${_module_name} &>/dev/null
    if [[ $? -eq 0 ]]; then
        warning "${_module_name}[`cat ${_pid_file}`] is already running."
        return 1
    fi
    
    pushd "${_module_base}" >/dev/null
        _template_file=`find . -maxdepth 1 -type f -name "*.template" -exec basename {} \;`
        if [[ ! -f "${_template_file}" ]]; then
            error "${_module_name}'s template file missing."
            exit 1
        fi
        
        check_md5 "../conf/common.env"

        WS_LISTEN_ADDR=`ip address show eth0 | grep inet | grep -v inet6 | awk '{print $2}' | cut -d'/' -f1`

        _check_env ${_module_name}

        check_md5 ${_module_name}

        template "${_template_file}"

        for DIR in flow log; do
            if [[ ! -d ${DIR} ]]; then
                mkdir ${DIR}
            fi
        done

        export LD_LIBRARY_PATH="${BASE_DIR}/libs":${LD_LIBRARY_PATH}
        ulimit -c unlimited

        if [[ ${DEAMON} -eq 1 ]]; then
            ./${_module_name} -d

            sleep 3
        else
            nohup ./${_module_name} ${_deamon_arg} $* </dev/null &
            _pid=$!
            echo -n "${_pid}" > "${_pid_file}"

            sleep 1
        fi

        _status ${_module_name} &>/dev/null
        if [[ $? -ne 0 ]]; then
            error "starting ${_module_name} failed."
            rm -f "${_pid_file}"
            exit 1
        fi

        pushd log >/dev/null
            export -f _archive_logs
            nohup bash -c _archive_logs "${_pid_file}" &
        popd >/dev/null

        if [[ ${DEAMON} -ne 1 ]]; then
            info "watching pid[${_pid}]"
            wait ${_pid}
        fi
    popd >/dev/null
}

function _stop() {
    if [[ $# -lt 1 ]]; then
        error "module name missing in stop."
        exit 1
    fi

    local _module_name
    local _module_base
    local _pid_file

    _module_name=$1
    shift
    _module_base="${BASE_DIR}/${_module_name}"
    _pid_file="${_module_base}/${_module_name}.pid"

    _status ${_module_name} &>/dev/null
    if [[ $? -ne 0 ]]; then
        warning "${_module_name} is already stopped."
        return 1
    fi

    pushd "${_module_base}" >/dev/null
        _stop_count=1
        _pid=`cat "${_pid_file}"`
        info "stopping ${_module_base}[${_pid}]..."
        while true; do
            if [[ ${_stop_count} -eq 1 ]]; then
                kill ${_pid} &>/dev/null
            fi

            if [[ ${_stop_count} -gt 5 ]]; then
                warning "${_module_name}[${_pid}] stopping failed in $((_stop_count-1)) times, killing forcely."
                kill -9 ${_pid} &>/dev/null
                info "${_module_name}[${_pid}] ${_stop_count} times checking..."
            fi
            
            sleep 3
            
            kill -0 ${_pid} &>/dev/null
            if [[ $? -eq 0 ]]; then
                _stop_count=$((_stop_count+1))
            else
                break
            fi
        done

        info "${_module_name}[$_pid] stopped."
        rm -f "${_pid_file}" >/dev/null
        rm -f "${_module_name}.ini" >/dev/null

        info "start to backup up log files..."
        _back_log
        if [[ $? -ne 0 ]]; then
            error "backup log files failed."
            exit 1
        else
            info "all log files backuped."
        fi
    popd >/dev/null
}

while getopts :dh FLAG; do
    case $FLAG in
        d)
            DEAMON=1
        ;;
        h)
            help_message
            exit
        ;;
        *)
            help_message >&2
            exit 1
        ;;
    esac
done
shift $((OPTIND-1))

MODULE_NAME=$1
shift

if [[ x"$MODULE_NAME" == "x" ]]; then
    error "module name missing."
    exit 1
fi

if [[ ! ${MODULE_LIST[@]} =~ ${MODULE_NAME} ]]; then
    error "invalid module name: ${MODULE_NAME}, available: ${MODULE_LIST[@]}"
    exit 1
fi

ACTION=

if [[ $1 =~ start|stop|status|restart ]]; then
    ACTION=$1
    shift
else
    error "module action missing."
    exit
fi

case ${ACTION} in
    start)
        _start ${MODULE_NAME} $*
    ;;
    stop)
        _stop ${MODULE_NAME} $*
    ;;
    status)
        _status ${MODULE_NAME}
    ;;
    restart)
        if [[ $# -ge 1 ]]; then
            warning "can not specify args in restart action, please use stop & start individually."
            exit 1
        fi

        _stop ${MODULE_NAME}
        _start ${MODULE_NAME}
    ;;
esac
