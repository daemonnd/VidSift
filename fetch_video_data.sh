#!/bin/bash
# file for fetching the transcript and the title of the video.
# It uses fabric for fetching the transcript and yt-dlp for fetching the title

# strict mode
set -Eeuo pipefail

# Cleanup function
function cleanup {
    local exit_code="$?"
    echo "Script fetch_video_data.sh interrupted or failed. Cleaning up..."

    # remove tmp files

    # exit the script, preserving the exit code
    exit "$exit_code"
}

# trap errors
trap 'echo "Error on line $LINENO in fetch_video_data.sh: command \"$BASH_COMMAND\" exited with status $?" >&2' ERR
# trap signals
trap 'cleanup' INT TERM ERR

function check_args {
    : "${1:?ERROR: The first arg that should contain the video url has not been set}"
}

# function to fetch the transcript of the video with fabric
function fetch_transcript {
    if ! transcript="$(fabric -y "$1" --yt-dlp-args="--cookies-from-browser firefox")"; then
        return 1
    else
        echo "$transcript" >/tmp/vidsift_transcript.txt
    fi
}

# function to fetxh the title of the video for later use as name for the summary file
function fetch_title {
    yt-dlp --skip-download --cookies-from-browser firefox -O '%(title)s' "$1" >/tmp/vidsift_title.txt
}

function main {
    fetch_transcript "$@"
    fetch_title "$@"
}

# call main with all args, as given
main "$@"
