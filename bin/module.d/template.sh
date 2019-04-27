function template() {
    if [[ $# -lt 1 || $# -gt 2 ]]; then
        error "invalid template args: $*"
        exit 1
    fi

    local _template_file=$1
    local _dest_file

    if [[ ! -f "${_template_file}" ]]; then
        error "template file[${_template_file}] missing."
        exit 1
    fi

    if [[ x"$2" == "x" ]]; then
        _dest_file=${_template_file%%.template}
    else
        _dest_file=$2
    fi

    eval "cat<<EOF
$(<"${_template_file}")
EOF
" > "${_dest_file}"
    return $?
}
