#!/bin/bash

file="winbox.exe"
url="https://mt.lv/winbox"

if [[ ! $(wine --version) ]]
then
    echo "Wine not installed !"
    exit 1
fi

if [[ ! -f winbox.desktop ]]
then
cat << EOF > winbox.desktop
#!/usr/bin/env xdg-open
[Desktop Entry]
Name=Winbox
Exec=wine $winboxpath/winbox.exe
Type=Application
StartupNotify=true
Icon=$winboxpath/winbox.png
Comment=Mikrotik RouterOS GUI Configurator (wine)
EOF
fi

echo "Select Installer Mode"
echo "1 ) User Installer"
echo "2 ) System Installer"
echo -p "User / System (U/S) ?" installopt;
if [[ $installopt == "u" || $installopt == "U" ]]
then
    installpath="~/app"
    launcher="~/.local/share/applications/winbox.desktop"
    download_winbox
    user_installer
elif [[ $installopt == "s" || $installopt == "S" ]]
    installpath="/opt"
    launcher="/usr/share/applications/winbox.desktop"
    download_winbox
    system_installer
fi

echo "Winbox is finished installing in the $winboxpath"
echo "Winbox Launcher is finished installing in the $launcher"
echo "Now you can launch Winbox by select Winbox icon from Launcher"

download_winbox(){
    if [[ $(uname -a | grep -o "x86_64") ]]
    then
        url=${url}64
    fi
    if [[ ! -f $file ]]
    then
        echo "Downloading $file"
        wget -q -c -O $file $url
    else
        echo "$file Already Downloaded"
    fi
    winboxpath="$installpath/winbox"
    if [[ ! -d winbox ]]
    then
        mkdir winbox
    fi
    cp winbox.png winbox/
    cp winbox.exe winbox/
    echo "Installing Winbox"
}

user_installer(){
    if [[ ! -d $installpath ]]
    then
        mkdir $installpath
    fi
    mv winbox $installpath/
    mv winbox.desktop $launcher
}

system_installer(){
    if [[ $EUID -ne 0 ]]
    then
        if [[ ! -d $installpath ]]
        then
            sudo mkdir $installpath
        fi
        sudo mv winbox $installpath/
        sudo mv winbox.desktop $launcher
    fi
}