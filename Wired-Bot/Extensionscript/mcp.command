#!/bin/bash
#

function listening_to()
{

                artist=`osascript -e 'tell application "Music" to artist of current track as string'`;
                track=`osascript -e 'tell application "Music" to name of current track as string'`;
                echo "$artist - $track" > /private/tmp/track;

}

$1
