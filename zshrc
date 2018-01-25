export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

eval $(dircolors -b $HOME/package/dircolors-solarized/dircolors.ansi-dark)
alias vim=nvim
