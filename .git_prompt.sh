function we_are_in_git_work_tree {
    git rev-parse --is-inside-work-tree &> /dev/null
}

# function truncate_prompt () {
#     prefix_length=5
#     string=$1
#     out_length=$2
#     length=${#string}
#     if [ ${length} > ${out_length} ]
#     then
#         echo ""
#         echo "(${string:0:$prefix_length}...${string:( ${length}-${out_length}-${prefix_length})})"
#     else
#         echo ""
#         echo -n "(@$string)"
#     fi
# }

function parse_git_branch {
    if we_are_in_git_work_tree
    then
    local BR=$(git rev-parse --symbolic-full-name --abbrev-ref HEAD 2> /dev/null)
    if [ "$BR" == HEAD ]
    then
        local NM=$(git name-rev --name-only HEAD 2> /dev/null)
        if [ "$NM" != undefined ] 
        then
            local length=${#NM}
            if [ $length -gt 30 ]
            then
                echo -n ${NM:0:4}...${NM:($length-25)}
            else
                echo -n "@$NM"
            fi
        else git rev-parse --short HEAD 2> /dev/null
        fi
    else
        local length=${#BR}
        if [ $length -gt 30 ]
        then
            echo ""
            echo "("${BR:0:4}"..."${BR:($length-25)}")"        
        else
            echo ""
            echo "("$BR")"
        fi
    fi
    fi
}

function parse_git_status {
    if we_are_in_git_work_tree
    then 
    local ST=$(git status --short 2> /dev/null)
    if [ -n "$ST" ]
    then echo -n " + "
    else echo -n " - "
    fi
    fi
}

function pwd_depth_limit_2 {
    if [ "$PWD" = "$HOME" ]
    then echo -n "~"
    else pwd | sed -e "s|.*/\(.*/.*\)|\1|"
    fi
}

function pwd_depth_limit_3 {
    if [ "$PWD" = "$HOME" ]
    then echo -n "~"
    else pwd | sed -e "s|.*/\(.*/.*/.*\)|\1|"
    fi
}

#TODO make the color scheme selectable in group_vars/all
COLOR_DIRS="\[\033[1;35m\]"
COLOR_GIT="\[\033[1;34m\]"
COLOR_USR="\[\033[1;30m\]"
COLOR_BRACKET="\[\033[1;34m\]"
COLOR_SPACE="\[\033[0m\]"

# export all these for subshells
export -f parse_git_branch parse_git_status we_are_in_git_work_tree pwd_depth_limit_3 pwd_depth_limit_2
export PS1="$COLOR_BRACKET[$COLOR_USR\u@\h$COLOR_SPACE:$COLOR_DIRS\$(pwd_depth_limit_3)$COLOR_BRACKET\$(parse_git_status)$COLOR_GIT\$(parse_git_branch)$COLOR_BRACKET]$COLOR_SPACE "
#export TERM="xterm-color"
# http://ricochen.wordpress.com/2011/07/23/mac-os-x-lion-terminal-color-remote-access-problem-fix/
# problem with nano can't open color term.
#[ "$TERM" = "xterm" ] && TERM="xterm-256color"
#alias ls='ls --color'
