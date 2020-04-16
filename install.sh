#!/bin/bash

. /etc/os-release

if [ -z "$ID_LIKE" ]; then
    OS=$ID
else
    OS=$ID_LIKE
fi

FONTS_FILE=https://github.com/SaurusXI/HandwritingParser/raw/master/assets/roboto.zip

if [ "$OS" = "arch" ]
then
    echo "Installing the HandWriter package"
    curl -O https://fbs.sh/SaurusXI/HandWriter/public-key.gpg && sudo pacman-key --add public-key.gpg && sudo pacman-key --lsign-key 29D5FDA07C763B56745B9E598AC59FA1ADE43023 && rm public-key.gpg
    echo -e '\n[HandWriter]\nServer = https://fbs.sh/SaurusXI/HandWriter/arch' | sudo tee -a /etc/pacman.conf
    sudo pacman -Syu handwriter
    echo "Installing fonts"
    curl $FONTS_FILE -o ~/roboto.zip -L
    unzip ~/roboto.zip -d ~/roboto-font
    mkdir ~/.local/share/fonts
    cp ~/roboto-font/* ~/.local/share/fonts/
    echo "Cleaning up"
    rm ~/roboto.zip && rm -r ~/roboto-fonts

elif [ "$OS" = "fedora" ]
then
    echo "not arch"

elif [ "$OS" = "debian" ]
then
    echo "Installing the HandWriter package"
    sudo apt-get install apt-transport-https
    wget -qO - https://fbs.sh/SaurusXI/HandWriter/public-key.gpg | sudo apt-key add -
    echo 'deb [arch=amd64] https://fbs.sh/SaurusXI/HandWriter/deb stable main' | sudo tee /etc/apt/sources.list.d/handwriter.list
    sudo apt-get update
    sudo apt-get install handwriter
    echo "Creating symlink"
    sudo mv /opt/HandWriter/libz.so.1 /opt/HandWriter/libz.so.1.old
    cd /opt/HandWriter/
    sudo ln -s /lib/x86_64-linux-gnu/libz.so.1
    cd
    echo "Installing fonts"
    wget $FONTS_FILE -O ~/roboto.zip
    unzip ~/roboto.zip -d ~/roboto-font
    mkdir ~/.local/share/fonts
    cp ~/roboto-font/* ~/.local/share/fonts/
    echo "Cleaning up"
    rm ~/roboto.zip && rm -r ~/roboto-fonts
fi