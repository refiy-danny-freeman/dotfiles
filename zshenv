#!/bin/zsh

# Disable autocompletion setup by Google /etc/zshrc
# google_zsh_flysolo='I march to my own drum'

# General Settings
export LANG=en_US.UTF-8
export TERM="xterm-256color"
export ALTERNATE_EDITOR="emacs"
export EDITOR="emacsclient -a emacs"
export VISUAL="emacsclient -a emacs"
export FPP_EDITOR="emacsclient --no-wait -a emacs"
export WORKON_HOME="$HOME/.dotfiles/home/.virtualenvs"
export PROJECT_HOME="$HOME/prog"
export DOTFILES_HOME="${HOME}/.dotfiles"
export TMUXP_CONFIGDIR="${HOME}/.dotfiles/tmuxp"
export ZDOTDIR="${HOME}/.zsh"

# Go setup
export GOPATH="${HOME}/prog"

# NodeJS and NPM setup.
export NPM_PACKAGES="${HOME}/.npm-packages"
export NODE_PATH="${NPM_PACKAGES}/lib/node_modules:${NODE_PATH}"

# Ruby setup
export GEM_HOME="$HOME/.gems"

# Path Setup
#
# ZSH ties the $path array variable to the $PATH environmental variable via
#`typeset -T`.  We can make the $path array only have unique entries with
#`typeset -U`
typeset -U path
path=(
    ~/bin-system
    ~/bin
    ~/prog/bin
    ~/homebrew/bin
    ~/.cask/bin
    /usr/local/bin
    /usr/share/texmf-dist/scripts/texlive
    $path
)