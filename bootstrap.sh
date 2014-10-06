#!/usr/bin/env bash
set -e

function run {
    echo " >> $@"
    $@
}

function main {
    download_plugins
    symlink_to_home
    print_post_install_message
}

function print_post_install_message {
    echo
    echo "Done! The following steps need to be done manually:"
    echo " - open vim, then type :BundleInstall to install the packages"
    echo " - open emacs to install packages out of the box"
    echo
    echo
}

function download_plugins {
    echo
    echo "Downloading plugins"
    run git submodule update --init --recursive
}

function symlink_to_home {
    echo
    echo "Symlinking configuration to $HOME"
    echo " - vim (.vim, .vimrc)"
    ln -fs $PWD/vim/vim $HOME/.vim
    ln -fs $PWD/vim/vimrc $HOME/.vimrc

    echo " - zsh (.zshrc, .zsh)"
    ln -fs $PWD/zsh/zshrc $HOME/.zshrc
    rm $HOME/.zsh 2> /dev/null || true
    ln -fs $PWD/zsh/zsh $HOME/.zsh

    echo " - tmux (.tmux.conf)"
    ln -fs $PWD/tmux/.tmux.conf $HOME/.tmux.conf

    echo " - fish (.config/fish)"
    mkdir $HOME/.config > /dev/null 2> /dev/null || true
    rm $HOME/.config/fish 2> /dev/null || true
    ln -fs $PWD/fish $HOME/.config/fish

    echo " - emacs (.emacs.d)"
    rm $HOME/.emacs.d 2> /dev/null || true
    ln -fs $PWD/emacs/emacs.d $HOME/.emacs.d
    mkdir -p $HOME/Library/Preferences/Aquamacs\ Emacs; true
    ln -fs $PWD/emacs/emacs.d/init.el $HOME/Library/Preferences/Aquamacs\ Emacs/Preferences.el

    echo " - scripts (bin)"
    rm $HOME/bin 2> /dev/null || true
    ln -fs $PWD/bin $HOME/bin
}

function update {
    update_submodules
    # install gocode files
    echo "Re-downloading gocode vim files ..."
    run curl -L "https://raw.github.com/nsf/gocode/master/vim/autoload/gocomplete.vim" > $PWD/vim/vim/autoload/gocomplete.vim
    run curl -L "https://raw.github.com/nsf/gocode/master/vim/ftplugin/go.vim" > $PWD/vim/vim/ftplugin/go.vim

    print_post_install_message
}

function update_submodules {
    echo "Updating submodules ..."
    CWD=$PWD
    for i in `git submodule status | cut -f3 -d ' '`
    do
        echo "Updating $i ..."
        cd $CWD/$i
        run git reset --hard
        run git checkout master
        run git pull
        run git checkout master
    done
    cd $CWD
}

function osx {
    brew install python
    brew install rbenv --HEAD
    brew install macvim --with-cscope --with-lua --override-system-vim
    brew install emacs --cocoa --srgb
    brew install fish
    brew linkapps

    brew install caskroom/cask/brew-cask
    brew cask install google-chrome
    brew cask install alfred
    brew cask install dropbox
    brew cask install caffeine
    brew cask install sublime-text
    brew cask install appcode
    brew cask install hopper-disassembler
    brew cask install virtualbox
    brew cask install shiftit
    brew cask install skype
    brew cask install dropbox
    brew cask install onepassword
    brew cask install evernote
    brew cask install steam
    brew cask install flux

    echo "Switch default to fish shell. Requires sudo. Abort to skip"
    if [ "$(cat /etc/shells | grep -q $(which fish))" = "0" ]; then
        echo "Fish shell already in /etc/shells"
    else
        which fish | sudo tee -a /etc/shells > /dev/null
    fi
}

function help {
    echo "Usage: $0 COMMAND"
    echo
    echo "Commands:"
    echo "  install   Symlinks files to home directory (overwrites existing)."
    echo "  osx       Installs various OSX Applications"
    echo "  update    Updates all submodules & gocode. Changes the repository."
    echo "  help      This help"
}

case "$1" in
    "install") main;;
    "osx") osx;;
    "upgrade"|"update") update;;
    "help") help;;
    *) echo "Invalid command. Use '$0 help' for help";;
esac
