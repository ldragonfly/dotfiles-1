# Constants
MAX_THREAD_COUNT=$(grep -c ^processor /proc/cpuinfo)
DOTFILES_DIR=$(realpath $(dirname "$0"))

# Get sudo credential at the start of the script.
sudo true

if [ ! $(command -v zsh) ]; then
    sudo apt install zsh
fi

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# install base16-shell (terminal color theme)
if [ ! -d $HOME/.config/base16-shell ]; then
    git clone https://github.com/chriskempson/base16-shell ~/.config/base16-shell

    echo -e '\n# Base16 Shell' >> ~/.zshrc
    echo 'BASE16_SHELL="HOME/.config/base16-shell"' >> ~/.zshrc
    echo '[ -n "$PS1" ] && \' >> ~/.zshrc
    echo '    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \' >> ~/.zshrc
    echo '        eval "$("$BASE16_SHELL/profile_helper.sh")"' >> ~/.zshrc
    echo 'base16_google-dark' >> ~/.zshrc
fi

if [ ! -d $HOME/.config/fonts ]; then
    # clone
    git clone https://github.com/powerline/fonts.git $HOME/.config/fonts --depth=1
    # install
    sh $HOME/.config/fonts/install.sh
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
    sh -c "cd neovim; make -j$MAX_THREAD_COUNT CMAKE_BUILD_TYPE=RelWithDebInfo; sudo make install"
fi

# check if we should install tmux
if [ ! $(command -v tmux) ]; then
    INSTALL_TMUX=true
else
    # if tmux is already installed, check its version
    TMUX_VERSION=$(tmux -V | grep -o -P "\d+(\.\d+)?" | head -1)
    if [ -z "$TMUX_VERSION" ]; then
        INSTALL_TMUX=true
    else
        INSTALL_TMUX=$(zsh -c "autoload is-at-least; is-at-least 2.6 $TMUX_VERSION || echo true")
    fi
fi

# install tmux
if [ -n "$INSTALL_TMUX" ]; then
    echo "installing tmux.."

    # install build prerequisites
    if [ -x $(command -v apt) ]; then
        sudo apt install libevent-dev libncurses5-dev
    elif [ -x $(command -v pacman) ]; then
        sudo pacman -S libevent ncurses
    fi

    # download tmux tarball
    # https://gist.github.com/steinwaywhw/a4cd19cda655b8249d908261a62687f8
    rm -rf tmux*
    curl -s https://api.github.com/repos/tmux/tmux/releases/latest \
        | grep "browser_download_url.*tar.gz" \
        | cut -d : -f 2,3 \
        | tr -d \" \
        | wget -i - -O tmux.tar.gz
    tar xvf tmux.tar.gz
    sh -c "cd tmux-*; ./configure; make -j$MAX_THREAD_COUNT; sudo make install"
fi

if [ ! -d $HOME/.config/nvim ]; then
    mkdir -p $HOME/.config/nvim
fi
cp $DOTFILES_DIR/init.vim $HOME/.config/nvim/init.vim
cp $DOTFILES_DIR/tmux.conf $HOME/.tmux.conf
cp $DOTFILES_DIR/zshrc $HOME/.zshrc.lyhan

zsh -c \
"
if ! [[ \$(cat ~/.zshrc) =~ (^|\$'\\n')\\\\s*source\\ ~\\/\\.zshrc\\.lyhan\\\\s*(\$|\$'\\n') ]]; then
    echo 'source ~/.zshrc.lyhan' >> ~/.zshrc
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

if [ ! -f $HOME/.local/share/nvim/site/autoload/plug.vim ]; then
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
nvim +:PlugInstall
