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
    echo "Script <script name> interrupted or failed. Cleaning up..."

    # remove tmp files
    rm_tmp_files
    # exit the script, preserving the exit code
    exit "$exit_code"
}

# trap errors
trap 'echo "Error on line $LINENO in <script name>: command \"$BASH_COMMAND\" exited with status $?" >&2' ERR
# trap signals
trap 'cleanup' INT TERM ERR

function check_args {
    :
}

function calc_output_mode {
    # calculate the output mode with the -v and -s flags
    output_mode=$(($output_mode + $1))
}

function parse_flags {
    # parse the args
    # s = silent (no output except errors) output_mode=-1
    # default (no s nor v): only prints errors and the current dir processed in the given file output_mode=0
    # v = all errors, all filenames from -> to changed output_mode=1
    # vv = all errors, all filenames from --> to changed, also which filenames did not change output_mode=2
    output_mode=0
    while getopts "sv" flag; do
        case "${flag}" in
        s) calc_output_mode -1 ;;
        v) calc_output_mode 1 ;;
        *) echo "The options are '-v' for verbose output and '-s' for silent output" && exit 1 ;;
        esac
    done
    shift "$((OPTIND - 1))"
    export args="$@"
}

function log {
    # logs the output depending on the output_mode
    # args:
    # 1. loglevel (DEBUG, INFO, WARNING, ERROR, CRITICAL)
    # 2. logmessage
    # 3. min. output_mode
    if [[ "$3" -le "$output_mode" ]]; then
        echo "${1}: $2"
    fi
}

function init {
    :
}

function main {
    parse_flags "$@"
    check_args "$args"
    init "$args"
    export OUTPUT_MODE="$output_mode"

}

# call main with all args, as given
main "$@"
