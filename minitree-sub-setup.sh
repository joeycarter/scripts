#!/bin/zsh

# Set up Minitree Submission
# ==========================
#
# A convenience script to set up the environment on lxplus for minitree
# production submission to the Grid.
#
# NOTE: This scripts should be 'sourced' instead of executed.
#
# usage: source setup-minitree-sub.sh [--help]


# Script name
sname=${0##*/}

# Help message
show_help() {
cat <<EOF
usage: source ${sname} [--help]

A convenience script to set up the environment on lxplus for minitree
production submission to the Grid.

optional arguments:
  -h, --help   Show this help message and exit
EOF
}


# ----- Parse input arguments -----#

while (( $# > 0 )); do
    opt="$1"

    case $opt in
        -h|--help)
            show_help
            return 0
            ;;
        *)
            echo "error: unknown option '$opt'"
            show_help
            return 1
            ;;
    esac
done

cd "$(find $HOME -maxdepth 2 -type d -name HZZAnalRun2Code | head -1)/build"

asetup --restore

source x86_64-centos7-gcc62-opt/setup.sh

voms-proxy-init -valid 48:00 --voms atlas:/atlas/phys-higgs/Role=production

lsetup "rucio -w"
lsetup "panda"
lsetup "pyami"
