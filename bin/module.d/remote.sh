function _normal_dry_run() {
    if [[ ${DRY_RUN} -eq 1 ]]; then
        DRY_RUN="echo"
        return
    fi
    
    if [[ ${DRY_RUN} != "echo" || ${DRY_RUN} != "eval" ]]; then
        DRY_RUN="eval"
        return
    fi
}

function remote_exec() {
    local _USER
    local _HOST
    local _PORT
    local _CONN_STRING
    local _COMMAND
    local _CMD_LINE
    local _TMP_CMD

    _ssh_args=("-n")

    if [[ x"${IDENTITY_FILE}" != "x" ]]; then
        _ssh_args=(${_ssh_args[@]} "-i" "${IDENTITY_FILE}")
    fi

    [[ -n ${REMOTE_USER} ]] && _USER="${REMOTE_USER}" || _USER="${SSH_USER}"
    [[ -n ${REMOTE_HOST} ]] && _HOST="${REMOTE_HOST}" || _HOST="${SSH_HOST}"
    [[ -n ${REMOTE_PORT} ]] && _PORT="${REMOTE_PORT}" || _PORT="${SSH_PORT}"

    if [[ ${_PORT} -eq 22 ]]; then
        _CONN_STRING="${_USER}@${_HOST}"
        _ssh_args=(${_ssh_args[@]} "${_USER}@${_HOST}")
    else
        _CONN_STRING="${_USER}@${_HOST}:${_PORT}"
        _ssh_args=(${_ssh_args[@]} "-p" ${_PORT} "${_USER}@${_HOST}")
    fi

    _COMMAND=$1
    _CMD_LINE=$1
    shift
    
    # extend alias command recursively
    while true; do
        alias ${_COMMAND} &>/dev/null
        if [[ $? -eq 0 ]]; then
            _TMP_CMD=`alias ${_COMMAND} | \
                sed -e 's/^alias[^'"'"']*//g' -e 's/'"'"'//g' -e 's/--color=auto/--color/g'`
            _CMD_LINE=${_CMD_LINE/${_COMMAND}/${_TMP_CMD}}
            
            _TMP_CMD=${_COMMAND}
            _COMMAND=`echo ${_CMD_LINE} | awk '{print $1}'`

            # break alias recursive circle
            [[ ${_TMP_CMD} == ${_COMMAND} ]] && break
        else
            # alias | sed '1i command "'"${_COMMAND}"'" not in alias, available alias: ' | error
            # exit 1
            break
        fi
    done

    echo -e "${COLOR[cyan]}Results${COLOR[nc]} from remote host[${COLOR[yellow]}${_CONN_STRING}${COLOR[nc]}]:" >&2
    
    _normal_dry_run

    ${DRY_RUN} ssh "${_ssh_args[@]}" "\
        export PATH=/sbin:/bin:/usr/bin:/user/sbin:/usr/local/bin:~/bin; \
        [[ -f ~/.bashrc ]] && source ~/.bashrc; \
        [[ -f ~/.bash_profile ]] && source ~/.bash_profile; \
        ${_CMD_LINE} $*"
    echo >&2
}

function transfer_file() {
    local _USER
    local _HOST
    local _PORT
    local _CONN_STRING
    local _HOST_IP
    local _EXTRA_ARGS
    local _SRC
    local _DST

    _scp_args=("-r")

    if [[ x"${IDENTITY_FILE}" != "x" ]]; then
        _scp_args=(${_scp_args[@]} "-i" "${IDENTITY_FILE}")
    fi

    [[ -n ${REMOTE_USER} ]] && _USER="${REMOTE_USER}" || _USER="${SSH_USER}"
    [[ -n ${REMOTE_HOST} ]] && _HOST="${REMOTE_HOST}" || _HOST="${SSH_HOST}"
    [[ -n ${REMOTE_PORT} ]] && _PORT="${REMOTE_PORT}" || _PORT="${SSH_PORT}"

    _HOST_IP=`grep ${_HOST} /etc/hosts | awk '{print $1}'`

    for IP in `ip address show | grep inet | grep -v inet6 | awk '{split($2, addr, "/"); print addr[1]}'`; do
        if [[ ${IP} == ${_HOST_IP} ]]; then
            warning "Destination is same as localhost[${_HOST_IP}], skip."
            return 0
        fi
    done

    if [[ ${_PORT} -eq 22 ]]; then
        _CONN_STRING="${_USER}@${_HOST}"
    else
        _CONN_STRING="${_USER}@${_HOST}:${_PORT}"
        _scp_args=(${_scp_args[@]} "-P" ${_PORT})
    fi

    echo -e "${COLOR[cyan]}Transfer${COLOR[nc]} file to remote host[${COLOR[yellow]}${_CONN_STRING}${COLOR[nc]}]:" >&2

    if [[ $# -eq 1 ]]; then
        if [[ -n ${RECURSIVE} ]]; then
            error "must specify dest path in recursive mode."
            exit 1
        fi

        _SRC="$1"
        _DST="$1"
    else
        _DST="${!#}"
        _SRC="${*%%${_DST}}"
    fi
    
    _normal_dry_run

    ${DRY_RUN} scp "${_scp_args[@]}" ${_SRC} ${_USER}@${_HOST}:${_DST}
    echo >&2
}
