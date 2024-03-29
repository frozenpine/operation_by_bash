function _normal_dry_run() {
    if [[ ${DRY_RUN} -eq 1 || ${DRY_RUN} =~ echo|[Tt]rue ]]; then
        DRY_RUN="echo"
        return
    fi

    DRY_RUN=$1
}

function _common_alias() {
    alias egrep='egrep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias grep='grep --color=auto'
    alias l.='ls -d .* --color=auto'
    alias ll='ls -l --color=auto'
    alias ls='ls --color=auto'
    alias scp='scp -i ~/.ssh/Jisheng-func-test.pem'
    alias ssh='ssh -i ~/.ssh/Jisheng-func-test.pem'
    alias vi='vim'
    alias which='alias | /usr/bin/which --tty-only --read-alias --show-dot --show-tilde'
}

function is_self() {
    if [[ $# -lt 1 ]]; then
        error "remote host missing in check self."
        exit 1
    fi

    local _host=$1
    local _self_ip

    _self_ip=$(grep ${_host} /etc/hosts | awk '{print $1}')

    for IP in $(ip address show | grep inet | grep -v inet6 | awk '{split($2, addr, "/"); print addr[1]}'); do
        if [[ ${IP} == ${_self_ip} ]]; then
            warning "Destination is same as localhost[${_self_ip}], skip."
            return 0
        fi
    done

    return 1
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

    check_env_true INDEPENDENT_CONFIG_NODE && is_self ${_HOST} &>/dev/null && return

    if [[ ${_PORT} -eq 22 ]]; then
        _CONN_STRING="${_USER}@${_HOST}"
        _ssh_args=(${_ssh_args[@]})
    else
        _CONN_STRING="${_USER}@${_HOST}:${_PORT}"
        _ssh_args=(${_ssh_args[@]} "-p" ${_PORT})
    fi

    _COMMAND=$1
    _CMD_LINE=$1
    shift

    # extend alias command recursively
    _common_alias &>/dev/null
    while true; do
        alias ${_COMMAND} &>/dev/null
        if [[ $? -eq 0 ]]; then
            _TMP_CMD=$(alias ${_COMMAND} |
                sed -e 's/^alias[^'"'"']*//g' -e 's/'"'"'//g' -e 's/--color=auto/--color/g')
            _CMD_LINE=${_CMD_LINE/${_COMMAND}/${_TMP_CMD}}

            _TMP_CMD=${_COMMAND}
            _COMMAND=$(echo ${_CMD_LINE} | awk '{print $1}')

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

    ${DRY_RUN} ssh ${_ssh_args[@]} ${_USER}@${_HOST} "\
        export PATH=/sbin:/bin:/usr/bin:/usr/sbin:/user/sbin:/usr/local/bin:~/bin; \
        [[ -f ~/.bashrc ]] && source ~/.bashrc; \
        [[ -f ~/.bash_profile ]] && source ~/.bash_profile; \
        ${SUDO} ${_CMD_LINE} $*"
    echo >&2
}

function remote_cp() {
    local _USER
    local _HOST
    local _PORT
    local _CONN_STRING
    local _HOST_IP
    local _EXTRA_ARGS
    local _SRC
    local _DST
    local _recursive

    if [[ $1 == "-r" ]]; then
        _scp_args=("-r")
        _recursive=1
        shift
    else
        _scp_args=()
    fi

    if [[ x"${IDENTITY_FILE}" != "x" ]]; then
        _scp_args=(${_scp_args[@]} "-i" "${IDENTITY_FILE}")
    fi

    [[ -n ${REMOTE_USER} ]] && _USER="${REMOTE_USER}" || _USER="${SSH_USER}"
    [[ -n ${REMOTE_HOST} ]] && _HOST="${REMOTE_HOST}" || _HOST="${SSH_HOST}"
    [[ -n ${REMOTE_PORT} ]] && _PORT="${REMOTE_PORT}" || _PORT="${SSH_PORT}"

    is_self ${_HOST} && return

    if [[ ${_PORT} -eq 22 ]]; then
        _CONN_STRING="${_USER}@${_HOST}"
    else
        _CONN_STRING="${_USER}@${_HOST}:${_PORT}"
        _scp_args=(${_scp_args[@]} "-P" ${_PORT})
    fi

    echo -e "${COLOR[cyan]}Transfer${COLOR[nc]} file to remote host[${COLOR[yellow]}${_CONN_STRING}${COLOR[nc]}]:" >&2

    if [[ $# -eq 1 ]]; then
        if [[ ${_recursive} -eq 1 ]]; then
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

    ${DRY_RUN} scp ${_scp_args[@]} ${_SRC} ${_USER}@${_HOST}:${_DST}
    echo >&2
}

function remote_sync() {
    if [[ $# -lt 2 ]]; then
        error "must specify src & dst in remote sync."
        exit 1
    fi

    local OPTIND FLAG
    while getopts :k FLAG; do
        case $FLAG in
        k)
            _keep_flag=1
            ;;
        *)
            error "invalid args: $*"
            exit 1
            ;;
        esac
    done
    shift $((OPTIND - 1))

    local _USER
    local _HOST
    local _PORT
    local _CONN_STRING
    local _HOST_IP
    local _EXTRA_ARGS
    local _remote_shell
    local _SRC=$1
    local _DST=$2
    local _keep_flag

    _rsync_args=(-rlptzv --progress --human-readable --chmod="D+rx,Fgo+r")

    if [[ ${_keep_flag} -ne 1 ]]; then
        _rsync_args=(${_rsync_args[@]} --delete)
    fi

    if [[ x"${IDENTITY_FILE}" != "x" ]]; then
        _remote_shell="ssh -i ${IDENTITY_FILE}"
    fi

    [[ -n ${REMOTE_USER} ]] && _USER="${REMOTE_USER}" || _USER="${SSH_USER}"
    [[ -n ${REMOTE_HOST} ]] && _HOST="${REMOTE_HOST}" || _HOST="${SSH_HOST}"
    [[ -n ${REMOTE_PORT} ]] && _PORT="${REMOTE_PORT}" || _PORT="${SSH_PORT}"

    if [[ ${_PORT} -eq 22 ]]; then
        _CONN_STRING="${_USER}@${_HOST}"
    else
        _CONN_STRING="${_USER}@${_HOST}:${_PORT}"
        _remote_shell="${_remote_shell} -P ${_PORT}"
    fi

    if [[ x"${_remote_shell}" != "x" ]]; then
        _rsync_args=(${_rsync_args[@]} "--rsh='${_remote_shell}'")
    fi

    if [[ -n ${SUDO} ]]; then
        _rsync_args=(${_rsync_args[@]} "--rsync-path='sudo rsync'")
    fi

    echo -e "${COLOR[cyan]}Sync${COLOR[nc]} file to remote host[${COLOR[yellow]}${_CONN_STRING}${COLOR[nc]}]:" >&2

    _normal_dry_run "eval"
    ${DRY_RUN} rsync "${_rsync_args[@]}" "${_SRC}" "${_USER}@${_HOST}:${_DST}"
}
