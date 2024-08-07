# add /opt/bin to the path even if not running interactively
export PATH="$PATH:/opt/bin"
export PATH="$PATH:~/Components/cmake-3.8.2/bin/mac/bin/"
export PATH="$PATH:~/Components/scons-3.0.1/bin/mac/bin/"
export PATH="$PATH:~/Components/gettext-0.19.8.1/dev/mac/bin/"
export PATH="$HOME/bin:$PATH"
#export PATH="$PATH:$HOME/bin"
#export PYTHONPATH="$(lldb -P):$PYTHONPATH"
export PATH="$PATH:$HOME/Components/BlamOSRPC-3.1/src/Host/PythonTools"

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# bash completion (incl git etc)
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

#allow messages
mesg y

# ls colours
export CLICOLOR='truecolor'
export LSCOLORS=gxfxcxdxbxeggdabaggebe

# git machete editor
export GIT_MACHETE_EDITOR=vim

eval "$(ssh-agent)" >/dev/null

#cd into previous directory (new terminals open in the same directory as last)
#cd "$(cat ~/.prev_dir)" || echo "couldn't cd into prvious dir"
#this is not a useless use of cat
	# cd < ~/.prev_dir
	# ^  does not work


#nethack options
export NETHACKOPTIONS=/home/angel/.nethackrc

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000000
HISTFILESIZE=20000000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

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

#default is gr[e|a]y
export BAT="cat /sys/class/power_supply/BAT0/capacity"

function getColour {
	if [ "$1" -le 10 ] ; then
		#dark red
		echo -e "\033[00;31m"
	elif [ "$1" -le 20 ] ; then
		#red
		echo -e "\033[01;31m"
	elif [ "$1" -le 40 ] ; then
		#dark yellow
		echo -e "\\033[00;33m"
	elif [ "$1" -le 60 ] ; then
		#yellow
		echo -e "\\033[01;33m"
	elif [ "$1" -le 80 ] ; then
		#green
		echo -e "\\033[00;32m"
	else
		#bright green
		echo -e "\\033[01;32m"
	fi
}

#PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w
if [ "$color_prompt" = yes ]; then
	#PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w$(echo -e $(getColour $($BAT)))[$($BAT)%]\[\033[00m\]\$ '
	PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
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

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

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
# ~/.bashrc: executed by bash(1) for non-login shells.

#PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w$(acpi | cut -d"," -f"2") \$ '

#alias ssh1='ssh s3543536@coreteaching01.csit.rmit.edu.au'
#alias ssh2='ssh s3543536@coreteaching02.csit.rmit.edu.au'
#alias ssh3='ssh s3543536@coreteaching03.csit.rmit.edu.au'
#
#alias sshfs1='sudo sshfs -o allow_other s3543536@coreteaching02.csit.rmit.edu.au: /mnt/core1'
#alias sshfs2='sudo sshfs -o allow_other s3543536@coreteaching02.csit.rmit.edu.au: /mnt/core2'
#alias sshfs3='sudo sshfs -o allow_other s3543536@coreteaching02.csit.rmit.edu.au: /mnt/core3'
#
#alias ct1='s3543536@coreteaching01.csit.rmit.edu.au'
#alias ct2='s3543536@coreteaching02.csit.rmit.edu.au'
#alias ct3='s3543536@coreteaching03.csit.rmit.edu.au'
#
#alias please='sudo $(history -p !!)'
#alias cunt='sudo $(history -p !!)'
#
#alias yesplease='sudo yes | $(history -p !!)'
#alias yescunt='sudo yes | $(history -p !!)'
#
##alias dc='cd'
##alias sl='ls'
#
#alias progass='cd ~/uni/prog/ass2'
#alias prog='cd ~/uni/prog'
#
#alias cls='clear;ls'
#
#alias gpp='g++'
#
##alias file='ranger'
#alias files='ranger'
#
#alias toggleLid='sudo sh ~/scripts/togglelid.sh'
#
#alias xclip='xclip -selection clip-board'
#
#alias sshg='ssh -i ~/.ssh/mykey angelenglish@35.201.16.82'
#
#alias mountPC='echo "sudo mount.cifs //192.168.1.2/c /mnt/myPc -o rw user=Angel"; sudo mount.cifs //192.168.1.2/c /mnt/myPc -o rw user=Angel'
#alias mountPD='echo "sudo mount.cifs //192.168.1.2/d /mnt/myPd -o rw user=Angel"; sudo mount.cifs //192.168.1.2/d /mnt/myPd -o rw user=Angel'
#alias apt-search='apt search'
#alias apricot='apropos'
#alias mkae='make'


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/angel/applications/google-cloud-sdk/path.bash.inc' ]; then source '/home/angel/applications/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/angel/applications/google-cloud-sdk/completion.bash.inc' ]; then source '/home/angel/applications/google-cloud-sdk/completion.bash.inc'; fi


#aliases
source ~/.bashal
#functions
source ~/.bashfunc



# fzf completion
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f /usr/share/fzf/completion.bash ] && source /usr/share/fzf/completion.bash
[ -f /usr/share/fzf/key-bindings.bash ] && source /usr/share/fzf/key-bindings.bash
# bmdbuild completion
[ -f ~/bmdbuild/Extras/bmdbuild_autocomplete.bash ] && source ~/bmdbuild/Extras/bmdbuild_autocomplete.bash
