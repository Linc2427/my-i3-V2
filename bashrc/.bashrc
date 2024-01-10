# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
	export PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]\u\[$(tput setaf 2)\]@\[$(tput setaf 4)\]\h \[$(tput setaf 5)\]\W\[$(tput setaf 1)\]]\[$(tput setaf 7)\]\\$ \[$(tput sgr0)\]"

else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

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
#pfetch

###Powerline Shell###
#function _update_ps1() {
#	PS1=$(powerline-shell $?) }

#if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
#    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
#fi

#Aliases
# Enable colors and change prompt:
 autoload -U colors && colors	# Load colors
 PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "
 setopt autocd		# Automatically cd into typed directory.
 stty stop undef		# Disable ctrl-s to freeze terminal.
 setopt interactive_comments

# History in cache directory:
 HISTSIZE=10000000
 SAVEHIST=10000000
 HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"

# Basic auto/tab complete:
 autoload -U compinit
 zstyle ':completion:*' menu select
 zmodload zsh/complist
 compinit
 _comp_options+=(globdots)		# Include hidden files.

 bindkey -v
 export KEYTIMEOUT=1

 # Use vim keys in tab complete menu:
 bindkey -M menuselect 'h' vi-backward-char
 bindkey -M menuselect 'k' vi-up-line-or-history
 bindkey -M menuselect 'l' vi-forward-char
 bindkey -M menuselect 'j' vi-down-line-or-history
 bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
 function zle-keymap-select () {
     case $KEYMAP in
             vicmd) echo -ne '\e[1 q';;      # block
                     viins|main) echo -ne '\e[5 q';; # beam
                         esac
                         }
                         zle -N zle-keymap-select
                         zle-line-init() {
                             zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
                                 echo -ne "\e[5 q"
                                 }
                                 zle -N zle-line-init
                                 echo -ne '\e[5 q' # Use beam shape cursor on startup.
                                 preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Adding color
alias ls='ls -hN --color=auto --group-directories-first'
alias grep="grep --color=auto"
alias diff="diff --color=auto"

neofetch

#Aliases
alias up='sudo apt update && sudo apt upgrade -y'
alias v='vim'
alias sv='sudo vim'
alias fu='flatpak update'
alias za='zathura'
alias web='cd /var/www'
alias gc='git clone'
alias ta='cd ~/Documents/TA'
alias pkm='cd ~/Documents/PKM'
alias web='cd /var/www/html/'
alias nv='nvim'
alias snv='sudo nvim'
alias wall='cd ~/Pictures/Wallpaper'
alias vid='cd ~/Videos/'
alias jn='jupyter notebook'
alias jl='jupyter lab'
alias notebook='cd ~/Documents/Jupyter\ Notebook'
alias spot='ncspot'
alias news='newsboat'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias mkdir='mkdir -v'
alias grep='grep -i'
alias cp='cp -v'
alias rm='rm -v'
alias em='emacs -nw'
alias emacs='emacs -nw'
alias vps='ssh root@******'
alias ipvps='echo "*******"'
alias transfervps='rsync * -urvP root@******:/home'

apt() { 
  command nala "$@"
}
sudo() {
  if [ "$1" = "apt" ]; then
    shift
    command sudo nala "$@"
  else
    command sudo "$@"
  fi
}
#export PATH=$PATH:/home/kimp/.spicetify
source /home/kimp/git/zsh/zsh-syntax-highlighting.plugin.zsh
. "$HOME/.cargo/env"
#vim keybinding
#set -o vi

#fortune greetings
#fortune

apt() { 
  command nala "$@"
}
sudo() {
  if [ "$1" = "apt" ]; then
    shift
    command sudo nala "$@"
  else
    command sudo "$@"
  fi
}

. "$HOME/.cargo/env"
