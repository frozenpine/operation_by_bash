which git &>/dev/null || {
    echo "command \`git\` not found." >&2
    exit 1
}

BRANCH=master
COMMIT_ID=

function _get_commit() {
    local _commit=`git show | grep commit | awk '{print $NF}'`
    COMMIT_ID=${_commit:0:7}
}

function git_checkout() {
    local _GIT_UPDATE

    local OPTIND FLAG
    while getopts :b:c:u FLAG; do
        case ${FLAG} in
            b)
                BRANCH=${OPTARG}
            ;;
            c)
                COMMIT_ID=${OPTARG}
            ;;
            u)
                _GIT_UPDATE=1
            ;;
            *)
                echo "invalid args: $*"
                exit 1
            ;;
        esac
    done
    shift $((OPTIND - 1))

    git checkout .

    local _CURRENT_BRANCH=`git branch | grep "*" | cut -d' ' -f2`
    
    if [[ ${_CURRENT_BRANCH} != ${BRANCH} ]]; then
        warning "current branch is not ${BRANCH}, checkout to ${BRANCH}."
        git checkout ${BRANCH} || {
            # incase of branch not exist on local
            git fetch && git checkout ${BRANCH}
        }

        if [[ $? -ne 0 ]]; then
            error "check out to ${BRANCH} failed."
            exit 1
        fi
    fi

    if [[ x"${COMMIT_ID}" != "x" ]]; then
        git checkout ${COMMIT_ID}
        
        if [[ $? -ne 0 ]]; then
            error "checkout commit[${COMMIT_ID}] failed."
            exit 1
        fi

        return
    fi

    if [[ ${_GIT_UPDATE} -ne 1 ]]; then
        _get_commit
        return
    fi

    info "getting ${_project_base_name} latest version from git."

    git pull && _get_commit
}

function git_patch() {
    if [[ $# -lt 1 ]]; then
        error "project name missing in git patch."
        exit 1
    fi

    local _project_name=$1
    local _patch_file="${PATCH_BASE}/${_project_name}/patch.diff"
    
    if [[ ! -f "${_patch_file}" ]]; then
        info "no patch file found for project[${_project_name}]"
        return
    fi

    git apply --check "${_patch_file}" && git apply "${_patch_file}"
    if [[ $? -ne 0 ]]; then
        error "patch[${_patch_file}] failed for project[${_project_name}]."
        exit 1
    fi

    info "${_patch_file} applied successfully."
}
