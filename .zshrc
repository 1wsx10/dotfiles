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

source "$HOME/.bashal"

gits () {
	git "s$@"
}

# Autocomplete for ultrabuild
autoload bashcompinit
bashcompinit
source "$HOME/bmdbuild/Extras/bmdbuild_autocomplete.bash"

export PATH="$PATH:/home/angele/bin"
export PATH="$PATH:/home/angele/scripts"

source $HOME/.bmdcpt_force_host

export PYTHONPATH="$PYTHONPATH:$HOME/python_path"
