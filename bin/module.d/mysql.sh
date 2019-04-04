function mysql_exec() {
    cat | mysql -h${DB_HOST:=mysql001} \
                -P${DB_PORT:=3306} \
                -u${DB_USER:=root} \
                -p${DB_PASS:=quantdo123456} \
                --default-character-set=utf8mb4 $*
}
