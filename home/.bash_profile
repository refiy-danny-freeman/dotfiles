echo "loading .bash_profile"

pathmunge () {
    if ! echo $PATH | grep -Eq "(^|:)$1($|:)" ; then
        if [ "$2" = "after" ] ; then
            PATH=$PATH:$1
        else
            PATH=$1:$PATH
        fi
    fi
}
path_remove ()  {
    PATH=`echo -n $PATH | awk -v RS=: -v ORS=: '$0 != "'$1'"' | sed 's/:$//'`;
}

pathmunge "/usr/local/bin"
pathmunge "/usr/local/sbin"
pathmunge "$HOME/bin"
pathmunge "$HOME/.rvm/bin"
pathmunge "$HOME/.cabal/bin"
pathmunge "."
pathmunge "/usr/share/texmf-dist/scripts/texlive"



if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx

