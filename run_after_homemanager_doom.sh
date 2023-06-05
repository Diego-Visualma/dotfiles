#!/bin/bash

#refresh home-manager applications and configurations
home-manager switch

#check if doom-emacs is installed
if [ -f "$HOME/.config/emacs/bin/doom" ] ; then
    echo "Doom-Emacs detected"
    "${HOME}"/.config/emacs/bin/doom sync
else
    echo "Preparing to install doom emacs"
    git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
    "${HOME}"/.config/emacs/bin/doom install
    "${HOME}"/.config/emacs/bin/doom sync
fi
