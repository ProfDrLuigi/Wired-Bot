#!/bin/bash
#

ScriptHome=$(echo $HOME)

function _helpDefaultWrite()
{
    VAL=$1
    local VAL1=$2

    if [ ! -z "$VAL" ] || [ ! -z "$VAL1" ]; then
    defaults write "${ScriptHome}/Library/Preferences/wiredbot.istation.pw.plist" "$VAL" "$VAL1"
    fi
}

song=$( osascript -e 'if application "Spotify" is running then' -e 'tell application "Spotify"' -e 'if player state is playing then' -e 'set a to (get artist of current track)' -e 'set b to (get name of current track)' -e 'return a & " - " & b' -e 'end if' -e 'end tell' -e 'end if' )

_helpDefaultWrite "CurrentlyPlaying" "$song"



