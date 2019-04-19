function mysql_exec() {
    if [[ -z ${DB_HOST} ]]; then
        error "db host missing."
        exit 1
    fi

    cat | mysql -h${DB_HOST} \
                -P${DB_PORT:=3306} \
                -u${DB_USER:=root} \
                -p${DB_PASS:=quantdo123456} \
                --default-character-set=utf8mb4 $*
}

function mysql_create_user() {
    if [[ $# -ne 3 ]]; then
        error "invalid mysql create args: $*"
        exit 1
    fi

    local _DB_NAME
    local _DB_USER
    local _DB_PASS

    _DB_NAME=$1
    _DB_USER=$2
    _DB_PASS=$3

    cat <<EOF | mysql_exec
CREATE DATABASE IF NOT EXISTS ${_DB_NAME} DEFAULT CHARSET utf8mb4;

CREATE USER IF NOT EXISTS ${_DB_USER} IDENTIFIED BY '${_DB_PASS}';

GRANT SELECT ON ${_DB_NAME}.* TO ${DEFAULT_DB_USER}@localhost IDENTIFIED BY '${DEFAULT_DB_PASS}';
GRANT SELECT ON ${_DB_NAME}.* TO ${DEFAULT_DB_USER}@'%' IDENTIFIED BY '${DEFAULT_DB_PASS}';
GRANT ALL PRIVILEGES ON ${_DB_NAME}.* TO ${_DB_USER}@localhost IDENTIFIED BY '${_DB_PASS}';
GRANT ALL PRIVILEGES ON ${_DB_NAME}.* TO ${_DB_USER}@'%' IDENTIFIED BY '${_DB_PASS}';

FLUSH PRIVILEGES;
EOF
}

function mysql_shell() {
    LANG=utf-8
    mysql -h${DB_HOST} \
          -P${DB_PORT:=3306} \
          -u${DB_USER:=root} \
          -p${DB_PASS:=quantdo123456} \
          --default-character-set=utf8mb4 ${DB_NAME} $*
}
