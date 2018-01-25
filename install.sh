# Constants
MAX_THREAD_COUNT=$(grep -c ^processor /proc/cpuinfo)
DOTFILES_DIR=$(realpath $(dirname "$0"))

# Get sudo credential at the start of the script.
sudo true

if [ ! -d $HOME/package ]; then
	mkdir $HOME/package
fi
cd $HOME/package

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# install dircolors-solarized
if [ ! -d dircolors-solarized ]; then
    git clone https://github.com/seebi/dircolors-solarized dircolors-solarized
fi

# install pyenv
if [ ! -d $HOME/.pyenv ]; then
    # https://github.com/pyenv/pyenv-installer#github-way-recommended
    curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash

    # https://github.com/pyenv/pyenv/wiki/Common-build-problems#requirements
    if [ -x $(command -v apt) ]; then
        sudo apt-get install make build-essential libssl-dev zlib1g-dev libbz2-dev \
        libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
        xz-utils tk-dev
    # https://aur.archlinux.org/packages/python-git#pkgdeps
    elif [ -x $(command -v pacman) ]; then
        sudo pacman -S bzip2 expat gdbm libffi openssl zlib bluez-libs git sqlite \
        valgrind xz tk libtirpc
    fi
fi

# install neovim
if [ ! $(command -v nvim) ]; then
    echo "installing neovim.."

    # install build prerequisites(https://github.com/neovim/neovim/wiki/Building-Neovim#build-prerequisites)
    if [ -x $(command -v apt) ]; then
        sudo apt install ninja-build libtool libtool-bin autoconf automake cmake g++ pkg-config unzip
    elif [ -x $(command -v pacman) ]; then
        sudo pacman -S base-devel cmake unzip ninja
    fi

    git clone https://github.com/neovim/neovim neovim
    sh -c "cd neovim; make -j$MAX_THREAD_COUNT; sudo make install"
fi

# install tmux
if [ ! $(command -v tmux) ]; then
    INSTALL_TMUX_GIT=true
else
    TMUX_VERSION=$(tmux -V | grep -o -P "\d+(\.\d+)?" | head -1)
    INSTALL_TMUX_GIT=$(zsh -c "autoload is-at-least; is-at-least 2.4 $TMUX_VERSION || echo true")
fi

if [ -n "$INSTALL_TMUX_GIT" ]; then
    echo "installing tmux from git.."

    # install build prerequisites
    if [ -x $(command -v apt) ]; then
        sudo apt install libevent-dev libncurses5-dev
    elif [ -x $(command -v pacman) ]; then
        sudo pacman -S libevent ncurses
    fi

    git clone https://github.com/tmux/tmux tmux
    sh -c "cd tmux; ./configure; make -j$MAX_THREAD_COUNT; sudo make install"
fi

cp $DOTFILES_DIR/init.vim $HOME/.config/nvim/init.vim
cp $DOTFILES_DIR/tmux.conf $HOME/.tmux.conf
cp $DOTFILES_DIR/zshrc $HOME/.zshrc.didrod

# check if ~/.zshrc has line matching "source ~/.zshrc.didrod"
# if not, append it to the last line of the file
zsh -c \
"
if ! [[ \$(cat ~/.zshrc) =~ (^|\$'\\n')\\\\s*source\\ ~\\/\\.zshrc\\.didrod\\\\s*(\$|\$'\\n') ]]; then
    echo 'source ~/.zshrc.didrod' >> ~/.zshrc
fi
"

PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"

if [ ! -d $HOME/.pyenv/versions/neovim2 ]; then
    pyenv install 2.7.14 --verbose
    pyenv virtualenv 2.7.14 neovim2
    pyenv activate neovim2
    pip install neovim
fi

if [ ! -d $HOME/.pyenv/versions/neovim3 ]; then
    pyenv install 3.6.4 --verbose
    pyenv virtualenv 3.6.4 neovim3
    pyenv activate neovim3
    pip install neovim
fi

curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
