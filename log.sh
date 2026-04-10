#!/bin/bash

# strict mode
set -Eeuo pipefail

# rm tmp files function
function rm_tmp_files {
    :
}

# Cleanup function
function cleanup {
    local exit_code="$?"
    echo "Script log.sh interrupted or failed. Cleaning up..."

    # remove tmp files
    rm_tmp_files
    # exit the script, preserving the exit code
    exit "$exit_code"
}

# trap errors
trap 'echo "Error on line $LINENO in log.sh: command \"$BASH_COMMAND\" exited with status $?" >&2' ERR
# trap signals
trap 'cleanup' INT TERM ERR

# calculate the output mode with the -v and -s flags
function calc_output_mode {
    output_mode=$(($output_mode + $1))
}

# parse the args
# s = silent (no output except errors) output_mode=-1
# default (no s nor v): only prints errors and the current dir processed in the given file output_mode=0
# v = errors and info
# vv = errors, info and debug
function parse_flags {
    output_mode=0
    while getopts "sv" flag; do
        case "${flag}" in
        s) calc_output_mode -1 ;;
        v) calc_output_mode 1 ;;
        *) echo "The options are '-v' for verbose output and '-s' for silent output" && exit 1 ;;
        esac
    done
    shift "$((OPTIND - 1))"
    export ARGS="$@"
    export OUTPUT_MODE="$output_mode"
}

# logs the output depending on the output_mode
# args:
# 1. loglevel (DEBUG, INFO, WARNING, ERROR, CRITICAL)
# 2. logmessage
# 3. min. output_mode
#
# output modes for loglevels:
# ERROR: -1
# WARNING: 0
# INFO: 1
# DEBUG 2
function log {
    if [[ "$3" -le "$OUTPUT_MODE" ]]; then
        echo "${1}: $2"
    fi
}
