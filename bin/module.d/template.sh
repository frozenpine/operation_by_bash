function template() {
    local _template_file
    local _dest_file

    if [[ $# -lt 1 || $# -gt 2 ]]; then
        error "invalid template args: $*"
        exit 1
    fi

    _template_file=$1
    if [[ x"$2" == "x" ]]; then
        _dest_file=${_template_file%%.template}
    else
        _dest_file=$2
    fi

    eval "cat<<EOF
$(<"${_template_file}")
EOF
" > "${_dest_file}"
}
