SENTRY_DSN=

SENTRY_CONF="${CONF_BASE}/sentry.ini"

function get_sentry_dsn() {
    if [[ $# -ne 1 ]]; then
        error "sentry project name missing."
        exit 1
    fi

    check_env_true sentry_enable
    if [[ $? -ne 0 ]]; then
        warning "sentry log disabled."
        return
    fi

    if [[ ! -f "${SENTRY_CONF}" ]]; then
        warning "sentry config file[${SENTRY_CONF}] missing."
        return 1
    fi

    local _sentry_host
    local _sentry_port
    local _sentry_scheme
    local _project_id
    local _access_token

    which extract_ini_sec &>/dev/null
    if [[ $? -ne 0 ]]; then
        source "${MODULE_BASE}/config.sh" || exit 1
    fi

    for LINE in `extract_ini_sec sentry "${SENTRY_CONF}"`; do
        if [[ "$LINE" =~ [Hh]ost ]]; then
            _sentry_host=`get_ini_value ${LINE}`
            continue
        fi

        if [[ "$LINE" =~ [Pp]ort ]]; then
            _sentry_port=`get_ini_value ${LINE}`
            continue
        fi

        if [[ "$LINE" =~ [Ss]cheme ]]; then
            _sentry_scheme=`get_ini_value ${LINE}`
            continue
        fi
    done

    for LINE in `extract_ini_sec $1 "${SENTRY_CONF}"`; do
        if [[ ${LINE} =~ [Ii][Dd] ]]; then
            _project_id=`get_ini_value ${LINE}`
            continue
        fi

        if [[ ${LINE} =~ [Tt]oken ]]; then
            _access_token=`get_ini_value ${LINE}`
            continue
        fi
    done

    SENTRY_DSN="${_sentry_scheme}://${_access_token}@${_sentry_host}:${_sentry_port}/${_project_id}"
}
