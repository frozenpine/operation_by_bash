function template() {
    cat $1 | sed -e 's/#.*$//g' -e '/^ *$/d' -e 's/[ "<>]/\\&/g' | while read -r line; do
        eval echo ${line}
    done >$2
}
