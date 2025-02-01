#!/usr/bin/env bash

# shellcheck source=$HOME/.local/bin/hyde-shell
# shellcheck disable=SC1091
if ! source "$(which hyde-shell)"; then
    echo "[wallbash] code :: Error: hyde-shell not found."
    echo "[wallbash] code :: Is HyDE installed?"
    exit 1
fi

confDir="${confDir:-$HOME/.config}"
gtkIcon="${gtkIcon:-Tela-circle-dracula}"
iconsDir="${iconsDir:-$XDG_DATA_HOME/icons}"
cacheDir="${cacheDir:-$XDG_CACHE_HOME/hyde}"
WALLBASH_SCRIPTS="${WALLBASH_SCRIPTS:-$hydeConfDir/wallbash/scripts}"
hypr_border=10
swayncDir="${confDir}/swaync"
# allIcons=$(find "${XDG_DATA_HOME:-$HOME/.local/share}/icons" -mindepth 1 -maxdepth 2 -name "icon-theme.cache" -print0 | xargs -0 -n1 dirname | xargs -n1 basename | paste -sd, -)

# regen conf
export hypr_border
envsubst < "${swayncDir}/swaync.conf" > "${swayncDir}/swaync.con"
envsubst < "${swayncDir}/wallbash.conf" >> "${swayncDir}/swaync.con"

# Check if swaync process is running
if pgrep -x "swaync" > /dev/null
then
    echo "swaync is running, killing it..."
    killall swaync
else
    echo "swaync is not running"
fi

# Restart swaync
swaync-client -R
swaync-client -rs
swaync-client -sw
swaync &