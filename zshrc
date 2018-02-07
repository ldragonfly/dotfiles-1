export PYENV_ROOT="$HOME/.pyenv"
export PATH="$HOME/.local/bin:$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

eval $(dircolors -b $HOME/.didrod-dotfile-packages/dircolors-solarized/dircolors.ansi-dark)
alias vim=nvim
