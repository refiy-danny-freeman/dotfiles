#!/bin/zsh

random_wallpaper=$(find "${WALLPAPER_HOME}" -type f | sort -R | head -1)

feh --bg-scale "${random_wallpaper}"
