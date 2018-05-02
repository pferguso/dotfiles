

# If not running interactively, don't do anything
[ -z "$PS1" ] && return



# Source global definitions (if any)
[ -f /etc/bashrc ] && . /etc/bashrc


[ -f $HOME/.debug ] && echo "*** Running .bashrc"


hname=`uname -n`
hname=${hname%%.*}
export hname



#-------------------------------------------------------------
# Shell settings
#-------------------------------------------------------------


set -o notify
set -o noclobber
set -o ignoreeof
set -o emacs


shopt -s cdspell
shopt -s cdable_vars
shopt -s checkhash
shopt -s checkwinsize
shopt -s sourcepath
shopt -s no_empty_cmd_completion
shopt -s cmdhist
shopt -s histappend histreedit histverify
shopt -s extglob
shopt -s hostcomplete
shopt -s execfail


shopt -u mailwarn
unset MAILCHECK


export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'
export HISTIGNORE="&:bg:fg:ll:h"
export HISTTIMEFORMAT="$(echo -e ${BCyan})[%d/%m %H:%M:%S]$(echo -e ${NC}) "
export HISTCONTROL=ignoredups


#-------------------------------------------------------------
# Colors
#-------------------------------------------------------------



# Normal Colors
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White

# Bold
BBlack='\e[1;30m'       # Black
BRed='\e[1;31m'         # Red
BGreen='\e[1;32m'       # Green
BYellow='\e[1;33m'      # Yellow
BBlue='\e[1;34m'        # Blue
BPurple='\e[1;35m'      # Purple
BCyan='\e[1;36m'        # Cyan
BWhite='\e[1;37m'       # White

# Background
On_Black='\e[40m'       # Black
On_Red='\e[41m'         # Red
On_Green='\e[42m'       # Green
On_Yellow='\e[43m'      # Yellow
On_Blue='\e[44m'        # Blue
On_Purple='\e[45m'      # Purple
On_Cyan='\e[46m'        # Cyan
On_White='\e[47m'       # White

NC="\e[m"               # Color Reset


ALERT=${BWhite}${On_Red} # Bold White on red background



#-------------------------------------------------------------
# PATH
#-------------------------------------------------------------

PATH=.:$HOME/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
export PATH

#-------------------------------------------------------------
# Aliases
#-------------------------------------------------------------


alias mkdir='mkdir -p'
alias rf='rm -rf'
alias p='ps -fu $LOGNAME'
alias h='history'
alias j='jobs -l'
alias which='type -a'
alias cx='chmod +x'
alias c='clear'
alias untar='tar xvf'
alias ..='cd ..'
alias ...='cd ..; cd ..'
alias c-='cd -'


alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'


alias du='du -kh'
alias df='df -kTh'
alias dus='du -s * |sort -n'

export QUOTING_STYLE=shell

alias ls='ls -hF --color=auto'
alias l='ls'
alias lx='ls -lXB'          #  Sort by extension.
alias lsz='ls -lSr --group-directories-first'         #  Sort by size, biggest last.
alias lc='ls -ltcr'         #  Sort by/show change time,most recent last.
alias lu='ls -ltur'         #  Sort by/show access time,most recent last.
alias la='ls -A'            #  Show hidden files.
alias ll="ls -lv --time-style=long-iso"
alias lr='ll -tr'           #  Sort by date, most recent last.
alias lld="ll --group-directories-first"
alias lrd="lr --group-directories-first"
alias lm='ll |more'         #  Pipe through 'more'
alias llr='ll -R'           #  Recursive ls.

alias tree='tree -Csuh'

alias m='more'
alias mo='more'
alias mor='more'
alias moer='more'

alias grep='grep --color=auto'

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


#-------------------------------------------------------------
# Functions
#-------------------------------------------------------------

gps() {

  local psargs='-efw'
  
  if [ -z "$1" ]; then
    ps $psargs
  else       
    echo "-- Searching for \"$1\" in all running processes --"
    echo "UID        PID  PPID  C STIME TTY          TIME CMD"
    ps $psargs | grep "$1" | grep -v grep
    echo "----------------------------------------------------"
  fi
}


function mk() {
  mkdir -p "$@" && cd "$@"
}

#-------------------------------------------------------------
# Less
#-------------------------------------------------------------

alias more='less'
export PAGER=less
export LESSOPEN='|/usr/bin/lesspipe.sh %s 2>&-'
export LESS='-i -w  -z-4 -g -e -M -X -F -R -P%t?f%f \
:stdin .?pb%pb\%:?lbLine %lb:?bbByte %bb:-...'

export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'


#-------------------------------------------------------------
# Misc variables
#-------------------------------------------------------------

export EDITOR=vi
export ALTERNATE_EDITOR=emacs

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'



#-------------------------------------------------------------
# Prompt
#-------------------------------------------------------------

if [[ $- = *i* && -z "$LP_USER" && -d ~/liquidprompt  ]] ; then
    source ~/liquidprompt/liquidprompt
elif [ -f $HOME/.bashprompts ]; then
    . $HOME/.bashprompts
    regprompt
else
    PS1="\[\e]2;\h:\W\007\e[1;34m\]-(\u@\h)-(\w)\n-(\$(date +%H%M))- \[\e[0m\]"
fi

#-------------------------------------------------------------
# Bash completions
#-------------------------------------------------------------

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi



#-------------------------------------------------------------
# Tilix fix
#-------------------------------------------------------------

if [ $TILIX_ID ] || [ $VTE_VERSION ] ; then source /etc/profile.d/vte.sh; fi 


#-------------------------------------------------------------
# LS_COLORS
#-------------------------------------------------------------

if [ -f $HOME/.dircolors ]; then
    eval $(dircolors -b $HOME/.dircolors)
else
    LS_COLORS="no=00:fi=00:di=00;34:ln=00;36:pi=40;33:so=00;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=00;35:*.sh=00;32:*.gz=00;31:*.bz2=00;31:*.bz=00;31:*.tz=00;31:*.rpm=00;31:*.pm=00;36:*.pod=00;96:*.jpg=00;94:*.png=00;94:*.JPG=00;94:*.gif=00;94:*.pdf=00;91"
fi
export LS_COLORS

#-------------------------------------------------------------
# Machine-specific env files
#-------------------------------------------------------------

[ -z "$BASH_ENV" ] && export BASH_ENV=".bashrc"

# Source local definitions
[ -f $HOME/$BASH_ENV.${hname} ] && . $HOME/$BASH_ENV.${hname}






#-------------------------------------------------------------
# Start and end messages
#-------------------------------------------------------------
if [ -z "$DISPLAY" ]; then
   disp="${BRed}DISPLAY not set${NC}"
else
   disp="DISPLAY on ${BRed}$DISPLAY${NC}"
fi

echo -e "${BCyan}This is BASH ${BRed}${BASH_VERSION%.*}${BCyan} - $disp\n"
date
if [ -x /usr/games/fortune ]; then
    /usr/games/fortune -s
fi

function _exit()
{
    echo -e "${BRed}Hasta la vista, baby${NC}"
}
trap _exit EXIT
