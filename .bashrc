# Prompt
NM="\[\033[0;38m\]" #means no background and white lines
HI="\[\033[0;37m\]" #change this for letter colors
HII="\[\033[0;31m\]" #change this for letter colors
SI="\[\033[0;33m\]" #this is for the current directory
IN="\[\033[0m\]"

C_RED="\[\033[0;31m\]"
C_GREEN="\[\033[0;32m\]"
C_LIGHT_GRAY="\[\033[0;37m\]"
C_BROWN="\[\033[0;33m\]"
C_BLUE="\[\033[0;34m\]"
C_PURPLE="\[\033[0;35m\]"
C_CYAN="\[\033[0;36m\] "
C_GRAY="\[\033[1;30m\]"
C_WHITE="\[\033[1;37m\]"
C_YELLOW="\[\033[1;33m\]"
C_BOLD_BLUE="\[\033[1;34m\]"
C_BOLD_CYAN="\[\033[1;36m\]"
C_BOLD_PURPLE="\[\033[1;35m\]"
C_BOLD_RED="\[\033[1;31m\]"
C_BOLD_GREEN="\[\033[1;32m\]"
C_BOLD="\[\033[1m\]"
C_RESET="\[\033[0m\]"

#export PS1="$NM[ $HI\u $HII\h $SI\W$NM ] $IN"

export MYPS='$(echo -n "${PWD/#$HOME/~}" | awk -F "/" '"'"'{if (length($0) > 14) { if (NF>4) print $1 "/" $2 "/.../" $(NF-1) "/" $NF; else if (NF>3) print $1 "/" $2 "/.../" $NF; else print $1 "/.../" $NF; } else print $0;}'"'"')'

# Don't know why it does not reevaluate MYPS all the time because the very same code works fine on Linux.
# Maybe some bash option?
#export PS1="$C_CYAN[$(eval echo ${MYPS})]$ $C_RESET"
export PS1="$C_CYAN[$C_GREEN\u@\h$C_CYAN \W]$C_RESET "

alias ll="ls -l"
alias la="ls -al"
alias rm='rm -i'                 # interactive
alias first='ls -lt | sed '1d' | head -n '
