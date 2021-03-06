#!/bin/bash
#####################################################################
# Program: installer.sh
# Description: Install a new structure for vim config files.
# Includes syntax highlight, autocomplete and much more.
# Author: Wesley Rodrigues da Silva <wesley.it@gmail.com>
#####################################################################

## Define a timestamp
TIMESTAMP="$(date +'%Y%m%d_%H-%M-%S')"
LINE="\n-------------------------------------------------\n\n"

clear
echo "[ $TIMESTAMP ] Starting DevOps Vim Installer"
echo -e "$LINE"


echo Cloning vimfiles from Github Repository:
[ -e ~/.devops-vimfiles ] && mv ~/.devops-vimfiles ~/.devops-vimfiles-bkp-$TIMESTAMP
git clone https://github.com/wesleyit/vim_devops_dist ~/.devops-vimfiles
echo -e "$LINE"


echo Creating the vimrc and vim links:
for target in .vim .vimrc
do
    [ -e ~/$target ] && mv ~/$target ~/$target-bkp-$TIMESTAMP
    ln -s ~/.devops-vimfiles/$target ~/$target
done
echo -e "$LINE"


echo Installing custom fonts:
[ -e ~/.fonts/devops-vim ] || mkdir -p ~/.fonts/devops-vim
ln -s ~/.devops-vimfiles/vimfonts ~/.fonts/devops-vim/
echo -e "$LINE"


echo Creating shortcut:
[ -e ~/.local/share/applications/vim.desktop ] && rm -rf ~/.local/share/applications/vim.desktop
ln -s ~/.devops-vimfiles/.vim/vim.desktop ~/.local/share/applications/
echo -e "$LINE"


echo Creating alias for vim in bashrc:
alias | grep -q vim || cat >> ~/.bashrc << EOF

## vim must ignore global vimrc
alias vim='vim -u ~/.vimrc'

EOF
echo -e "$LINE"

echo Installing Vundle to download plugins:
git clone https://github.com/gmarik/Vundle.vim ~/.devops-vimfiles/.vim/bundle/Vundle.vim
vim +PluginInstall +qall 2> /dev/null
bash ~/.vim/bundle/fonts/install.sh
echo -e "$LINE"

echo Customizing the templates
NAME="$(grep name ~/.gitconfig | cut -d "=" -f 2 | cut -b 2-)"
MAIL="$(grep mail ~/.gitconfig | cut -d "=" -f 2 | cut -b 2-)"
if [ -z "$NAME" -o -z "$MAIL" ]
then
    echo "I am not able to guess your name and e-mail."
    echo "Please, personalize this information in ~/.vim/skel/*."
else
    for file in ~/.vim/skel/*
    do
        sed -i "s/NAME/$NAME/g" "$file"
        sed -i "s/MAIL/$MAIL/g" "$file"
    done
fi

echo 'Vimfiles installed. Enjoy!'
