#!/bin/bash

# strict mode
set -euo pipefail

# trap errors
trap 'echo "Error on line $LINENO: command \"$BASH_COMMAND\" exited with status $?" >&2' ERR

function check_args {
    echo 
}

function main {
    # go to target location
    cd ~/Videos/ytd/
    # download $1 as video

    yt-dlp \
      -f "bestvideo+bestaudio/best" \
      --merge-output-format mkv \
      --fragment-retries 10 \
      --retries 10 \
      "$1"
  }
# call main with all args, as given
main "$@"

