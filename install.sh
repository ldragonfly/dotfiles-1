# Constants
MAX_THREAD_COUNT=$(grep -c ^processor /proc/cpuinfo)

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
    echo "eval \$(dircolors -b \$HOME/package/dircolors-solarized/dircolors.ansi-dark)\n" >> $HOME/.zshrc
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
    echo "alias vim=nvim\n" >> $HOME/.zshrc
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
