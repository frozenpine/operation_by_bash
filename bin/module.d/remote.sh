SSH="ssh ${IDENTITY}"

function remote_exec() {
    local _USER
    local _HOST
    local _PORT
    local _CONN_STRING
    local _COMMAND
    local _CMD_LINE
    local _TMP_CMD

    [[ -n ${REMOTE_USER} ]] && _USER="${REMOTE_USER}" || _USER="${SSH_USER}"
    [[ -n ${REMOTE_HOST} ]] && _HOST="${REMOTE_HOST}" || _HOST="${SSH_HOST}"
    [[ -n ${REMOTE_PORT} ]] && _PORT="${REMOTE_PORT}" || _PORT="${SSH_PORT}"

    if [[ ${_PORT} -eq 22 ]]; then
        _CONN_STRING="${_USER}@${_HOST}"
    else
        _CONN_STRING="${_USER}@${_HOST}:${_PORT}"
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
    
    ${SSH} -n ${_USER}@${_HOST} -p${_PORT} "\
        export PATH=/sbin:/bin:/usr/bin:/user/sbin:/usr/local/bin:~/bin; \
        [[ -f ~/.bashrc ]] && source ~/.bashrc; \
        [[ -f ~/.bash_profile ]] && source ~/.bash_profile; \
        ${_CMD_LINE} $*"
    echo >&2
}
