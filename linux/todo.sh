#!/bin/bash
path=/var/todo/todo

todo_list() {
    # 每行样式: D 2021/06/09 ggg
    local i status date content
    i=1
    while read -r line; do
        status=${line:0:1}
        date=${line:2:10}
        content=${line:13}
        [[ "$1" != "time" ]] && date=""
        if [[ "${status}" == "U" ]]; then
            printf "\e[01m %2s %s %s %s \n\e[00m" "${i}" "${date}" "[ ]" "${content}"
        elif [[ "$#" == 1 ]]; then
            printf "\e[09m %2s %s %s %s \n\e[00m" "${i}" "${date}" "[*]" "${content}"
        fi
        i=$((i + 1))
    done <"${path}"
}

todo_add() {
    local date
    date=$(date +'%Y/%m/%d')
    echo "U ${date} $2" >>"$path"
    todo_list
}

todo_clean() {
    local line i
    line_list=$(grep -nE --text '^D' "$path" | cut -d ":" -f 1)
    i=0
    for fixed_line_number in $line_list; do
        fixed_line_number=$((fixed_line_number - i))
        sed -i "${fixed_line_number}"d "${path}"
        i=$((i + 1))
    done
    unset fixed_line_number
    todo_list "time"
}

todo_done() {
    local temp
    temp="$2"'s/^U/D/'
    sed -i "${temp}" "${path}"
    todo_list
}

todo_help() {
    echo -e "\e[1m Usage: \e[0m"
    echo -e "    -a, --add <string>      add a task"
    echo -e "    -c, --clean             clear all finished tasks"
    echo -e "    -d, --done <number>     done a task"
    echo -e "    -h, --help              help"
    echo -e "    -i, --insert            insert data file: $path"
    echo -e "    -l, --list              list all unfinished tasks"
    echo -e "    -L, --LIST              list all tasks with time"
    echo -e "    -r, --remove <number>   remove the task"
}

todo_insert() {
    vim "${path}"
}

todo_remove() {
    sed -n "$2"p "${path}"
    echo ""
    sed -i "$2"d "${path}"
    todo_list
}

todo_getopt() {
    local parameters=$(getopt -o a:cd:hiLlr: --long add:,clean,done:,help,insert,LIST,list,remove: -n "$0" -- "$@" 2>/dev/null)

    [[ "$#" == 0 ]] && todo_help && exit 1

    while true; do
        case "$1" in
        -a | --add) todo_add "$@" && shift 2 ;;
        -c | --clean) todo_clean && shift ;;
        -d | --done) todo_done "$@" && shift 2 ;;
        -h | --help) todo_help && shift ;;
        -i | --insert) todo_insert && shift ;;
        -l | --list) todo_list && shift ;;
        -L | --LIST) todo_list "time" && shift ;;
        -r | --remove) todo_remove "$@" && shift 2 ;;
        --) break ;;
        *) break && exit 2 ;;
        esac
    done
}

main() {
    if [[ "$#" != 1 && "$#" != 2 ]]; then
        todo_help
        exit 3
    else
        todo_getopt "$@"
    fi
}

main "$@"
# 由于执行下面的unset之后$?会变成0, 所以此处需要一个临时变量记录main的$?
temp="$?"
unset path todo_list todo_add todo_clean todo_done todo_help todo_insert todo_remove todo_getopt main
exit "${temp}"
