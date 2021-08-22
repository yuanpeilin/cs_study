# +----------------------------------+
# |         System Setting           |
# +----------------------------------+
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)

# If not running interactively, don't do anything ($- will output himBHs)
case $- in
    *i*) ;;
    *) return;;
esac

# check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s checkwinsize

# History
HISTSIZE=3000
HISTFILESIZE=6000
# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth
# format
HISTTIMEFORMAT='%F %T '
# append to the history file, don't overwrite it
# 多个终端的情况下, 改为追加命令(默认最后的终端会覆盖以前的)
shopt -s histappend

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi


# +----------------------------------+
# |             function             |
# +----------------------------------+
cd_git_project() {
    clear
    cd "$1"
    echo -e '\e[01m--------------------\e[00m'
    git log -9 --format="%C(yellow)%h%Creset %C(auto)%d%Creset %s %C(blue)(%cr) <%an>" --graph
    echo -e '\e[01m--------------------\e[00m'
    if [[ -z $(git stash list) ]]; then
        echo 'no stash'
    else
        git stash list
    fi
    echo -e '\e[01m--------------------\e[00m'
    git branch -vv
    echo -e '\e[01m--------------------\e[00m'
    if [[ -z $(git status -s) ]]; then
        echo 'No file changed'
    else
        git status -sb
    fi
    echo -e '\e[01m--------------------\e[00m'
}

color(){
    echo -e "\e[01m 01 \e[00m"
    echo -e "\e[02m 02 \e[00m"
    echo -e "\e[03m 03 \e[00m"
    echo -e "\e[04m 04 \e[00m"
    echo -e "\e[05m 05 \e[00m"
    echo -e "\e[06m 06 \e[00m"
    echo -e "\e[07m 07 \e[00m"
    echo -e "\e[08m 08 \e[00m"
    echo -e "\e[09m 09 \e[00m"
    echo -e "----------------"
    echo -e "\e[31m 31 \e[00m"
    echo -e "\e[32m 32 \e[00m"
    echo -e "\e[33m 33 \e[00m"
    echo -e "\e[34m 34 \e[00m"
    echo -e "\e[35m 35 \e[00m"
    echo -e "\e[36m 36 \e[00m"
    echo -e "\e[37m 37 \e[00m"
    echo -e "----------------"
    echo -e "\e[41m 41 \e[00m"
    echo -e "\e[42m 42 \e[00m"
    echo -e "\e[43m 43 \e[00m"
    echo -e "\e[44m 44 \e[00m"
    echo -e "\e[45m 45 \e[00m"
    echo -e "\e[46m 46 \e[00m"
    echo -e "\e[47m 47 \e[00m"
}

mkcd() {
    mkdir "$1"
    cd "$1"
}

plant_uml_server(){
    cd /opt/plantuml-server
    sudo mvn jetty:run -Djetty.port=9999 &>/dev/null &
}

sysinfo(){
    echo "Kernel:  $(uname -r)"
    echo "OS:  $(grep -E '^NAME=' /etc/os-release | cut -d '"' -f 2)"
    echo "OS Version:  $(grep -E '^VERSION=' /etc/os-release | cut -d '"' -f 2)"
    echo "CPU:  $(grep 'model name' /proc/cpuinfo | sort -u | tr '\t' ' ' | cut -d ' ' -f 4-)"
    echo "CPU Cores:  $(grep 'core id' /proc/cpuinfo | sort -u | wc -l)"
    echo "CPU Threads:  $(grep 'processor' /proc/cpuinfo | sort -u | wc -l)"
    echo ""
    free -h
    echo ""
    df -ht ext4
    df -hit ext4
}

# +----------------------------------+
# |          some GIT alias          |
# +----------------------------------+
alias g='clear && git log --format="%C(yellow)%h%Creset %C(auto)%d%Creset %s %C(blue)(%cr) <%an>" --graph -15 && echo ""'
alias gg='clear && git log --format="%C(yellow)%h%Creset %C(auto)%d%Creset %s %C(blue)(%cr) <%an>" --graph --all -15 && echo ""'
alias glo='git log --format="%C(yellow)%h%Creset %C(auto)%d%Creset %s %C(blue)(%cr) <%an>" --graph'
alias gloa='git log --format="%C(yellow)%h%Creset %C(auto)%d%Creset %s %C(blue)(%cr) <%an>" --graph --all'
alias gbr='git branch -vv'
alias gclone='git clone'
alias gca='git commit --amend'
alias gcma='git commit -a -m'
alias gcm='git commit -m'
alias gco='git checkout'
alias gdi='git diff'
alias gdc='git diff --cached'
alias gdn='git diff --name-status'
alias gds='git diff --stat --stat-width=150'
alias gft='git fetch'
alias gindex='git ls-files -s'
alias glast='git show --stat HEAD'
alias gmerge='git merge --no-ff -m'
alias gpprint='git cat-file -p'
alias gptags='git push origin --tags'
alias gpull='git pull'
alias gpush='git push'
alias grf='git reflog'
alias gre='git remote'
alias grev='git remote -v'
alias gsa='git stash --include-untracked'
alias gsapply='git stash apply --index '
alias gsclear='git stash clear'
alias gsdrop='git stash drop'
alias gslist='git stash list'
alias gspop='git stash pop --index'
alias gsshow='git stash show'
alias gst=' clear && git status -bs'
alias gtag='git tag'
alias gtree='git ls-tree -r'
alias gtype='git cat-file -t'

gadd() {
    git add "${1:-.}"
    clear
    git status -bs
}

gproxy() {
    echo "before:"
    git config http.proxy
    git config https.proxy

    git config --global http.proxy 'socks5://127.0.0.1:1080'
    git config --global https.proxy 'socks5://127.0.0.1:1080'

    echo "after:"
    git config http.proxy
    git config https.proxy
}

gunproxy() {
    echo "before:"
    git config http.proxy
    git config https.proxy

    git config --global --unset http.proxy
    git config --global --unset https.proxy

    echo "after:"
    git config http.proxy
    git config https.proxy
}

# +----------------------------------+
# |           OTHER alias            |
# +----------------------------------+
alias ..='cd ..'
alias ...='cd ../..'
alias '.bashrc'='vim ~/.bashrc && source ~/.bashrc'
alias desktop='cd ~/Desktop && ls'
alias document='cd ~/Documents && ls'
alias download='cd ~/Downloads && ls'
alias '.gitconfig'='vim ~/.gitconfig'
alias grep='grep --color'

alias hgrep='history | grep'
alias jnotebook='jupyter notebook &>/dev/null &'
alias l='ls -F --color=auto'
alias la='ls -AF --color=auto'
alias ll='ls -Fhl --color=auto'
alias lla='ls -AFhl --color=auto'
alias manzh_CN='man -M /usr/share/man/zh_CN/'

alias profile='sudo vim /etc/profile && source /etc/profile'
alias s='source ~/.bashrc'
alias shadowsocks='sudo sslocal -c ~/Documents/ss.json -d restart'
alias 'ss.json'='vim ~/Documents/ss.json'
alias t1='tree -L 1'
alias t2='tree -L 2'
alias t3='tree -L 3'
alias t4='tree -L 4'
alias t5='tree -L 5'

alias update='sudo apt update'
alias upgrade='sudo apt full-upgrade'
alias .vimrc='vim ~/.vimrc'
alias ws='cd ~/workspace && ls'

# +----------------------------------+
# |           Start Script           |
# +----------------------------------+
clear

ln_check(){
    (( $# != 2 )) && echo "Parameter must be 2" && return 1

    local linked_count=$(ls -l "$1" | awk '{print $2}')
    if (( ${linked_count} != 2 )); then
        rm "$2"
        ln "$1" "$2"
        echo "link $2 has broken, delete it and link again. Source file path: $1"
    fi
}
ln_check /home/ypl/workspace/yuanpeilin.github.io/linux/bashrc.sh /home/ypl/.bashrc
ln_check /home/ypl/workspace/yuanpeilin.github.io/linux/todo.sh /usr/bin/todo
ln_check /home/ypl/workspace/yuanpeilin.github.io/linux/src/vimrc /home/ypl/.vimrc

todo -l

git_branch() {
    branch="`git branch 2>/dev/null | grep "^\*" | sed -e "s/^\*\ //"`"
    if [ "${branch}" != "" ];then
        if [ "${branch}" = "(no branch)" ];then
            branch="(`git rev-parse --short HEAD`...)"
        fi
        echo "($branch)"
    fi
}
PS1='\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\e[01;32m\]\u@\h\[\e[00m\] \[\e[01;34m\]\w$(git_branch)\[\e[00m\]\$ '

export JAVA_HOME='/opt/java8/jdk1.8.0_281'
export PATH=$JAVA_HOME/bin:$PATH

[[ -f ~/.bashrc.temp ]] && source ~/.bashrc.temp

# +----------------------------------+
# |            USER alias            |
# +----------------------------------+
export VULTR='144.202.89.76'
export V='144.202.89.76'

alias sv='ssh root@$VULTR'
alias svultr='ssh root@$VULTR'
alias yuanpeilin='cd_git_project ~/workspace/yuanpeilin.github.io'
alias sql="mysql -uroot -p980620 --prompt='\u@\h [\d]> ' --database=must"

mc() {
    fcitx_pids=$(ps -ef | grep fcitx | awk '{print $2}' | tr '\n' ' ')
    echo "${fcitx_pids}"
    for pid in $fcitx_pids; do
        kill $pid
    done
    unset fcitx_pids pid
    cd ~
    java -jar /opt/hmcl/HMCL-3.3.172.jar &>/dev/null &
}

