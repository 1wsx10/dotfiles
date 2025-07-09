# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt nomatch
unsetopt autocd beep extendedglob notify
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/angele/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# pyenv
# source /usr/share/pyenv/pyenv_user_setup.bash
# for some reason, the above file does not exist. and i can't find anything online about this..
eval "$(pyenv init -)"
#export PYTHONHOME="$HOME/.pyenv/versions/$( python -V | cut -d' ' -f2 )"

source "$HOME/.bashal"

gits () {
	git "s$@"
}

# vim-terminal: open in existing vim
vim ()
{
	if [ -z "$VIM_SERVERNAME" ]
	then
		command vim --servername a $@
	else
		command vim --servername "$VIM_SERVERNAME" --remote $@
	fi
}
tvim ()
{
	if [ -z "$VIM_SERVERNAME" ]
	then
		command vim --servername a $@
	else
		command vim --servername "$VIM_SERVERNAME" --remote-tab $@
	fi
}

lldb ()
{
	PYTHONHOME="$HOME/.pyenv/versions/$( python -V | cut -d' ' -f2 )" \
		command "$HOME/Components/BlamOSToolchain-9.2/bin/ubuntu/bin/lldb"
}

clangd ()
{
	command "$HOME/Components/BlamOSToolchain-9.2/bin/ubuntu/bin/clangd"
}

# emit a "OSC 7" escape sequence when we change dir
# this allows vim to follow the terminal; set 'autoshelldir'
if [[ -n "$VIM_TERMINAL" ]]; then
	autoload -Uz add-zsh-hook
	add-zsh-hook -Uz chpwd _vim_sync_PWD
	function _vim_sync_PWD() {
		printf '\033]7;file://%s\033\\' "$PWD"
	}
fi

# Autocomplete for ultrabuild
autoload bashcompinit
bashcompinit
source "$HOME/bmdbuild/Extras/bmdbuild_autocomplete.bash"
source "$HOME/scripts/setup_completion.sh"

export PATH="$PATH:$HOME/bin"
export PATH="$PATH:$HOME/scripts"

if [ "$(uname -s)" = "Darwin" ]; then
	export PATH="$PATH:$HOME/bin"
	alias bmdbuild='python3 /Users/angele/src/bmdbuild/bmdbuild.py'
fi

source $HOME/.bmdcpt_force_host

# export PYTHONPATH="$PYTHONPATH:$HOME/python_path"
export PYTHONPATH="$PYTHONPATH:$HOME/bin/BlackmagicTools/x86_64/Tools/PyBlamOSRPC"
