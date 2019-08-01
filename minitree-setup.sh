#!/bin/zsh

# Set up Minitree Submission/Processing
# =====================================
#
# A convenience script to set up the environment on lxplus for H -> ZZ -> 4l
# minitree production submission to the Grid and post-processing.
#
# NOTE: This scripts should be 'sourced' instead of executed.
#
# usage: source setup-minitree-sub.sh [--help] [--submit|--process] [--ami]


# Script name
sname=${0##*/}

# Help message
show_help() {
cat <<EOF
usage: source ${sname} [--help]

A convenience script to set up the environment on lxplus for H -> ZZ -> 4l
minitree production submission to the Grid and post-processing. If no argument
is passed, it will set up for submission by default.

optional arguments:
  -h, --help     Show this help message and exit
  -s, --submit   Set up minitree submission
  -p, --process  Set up minitree post-processing
  -a, --ami      Also set up pyami (off by default)
EOF
}


# ----- Parse input arguments -----#

OPT_SUBMIT=false
OPT_PROCESS=false
OPT_AMI=false

while (( $# > 0 )); do
    opt="$1"

    case $opt in
        -h|--help)
            show_help
            return 0
            ;;
        -s|--sub*)
            OPT_SUBMIT=true
            shift
            ;;
        -p|--proc*)
            OPT_PROCESS=true
            shift
            ;;
        -a|--ami)
            OPT_AMI=true
            shift
            ;;
        *)
            echo "error: unknown option '$opt'"
            show_help
            return 1
            ;;
    esac
done

if [[ $OPT_SUBMIT = false && $OPT_PROCESS = false ]]; then
    echo "error: nothing to do..."
    show_help
    return 1
fi

if [[ $OPT_SUBMIT = true && $OPT_PROCESS = true ]]; then
    echo "warning: cannot set up for both; will set up for submission"
fi


CURRENT_DIR=$PWD
MINITREE_DIR=$(find $HOME -maxdepth 2 -type d -name HZZAnalRun2Code | head -1)

echo ">>> cd ${MINITREE_DIR}/build"
cd "${MINITREE_DIR}/build"

echo ">>> asetup --restore"
asetup --restore

source x86_64-centos7-gcc62-opt/setup.sh

echo ">>> voms-proxy-init"
voms-proxy-init -valid 48:00 --voms atlas:/atlas/phys-higgs/Role=production

echo ">>> lsetup [rucio,panda]"
lsetup "rucio -w"
lsetup "panda"

if [[ $OPT_AMI = true ]]; then
    echo ">>> lsetup pyami"
    lsetup "pyami"
fi

if [[ $OPT_SUBMIT = true ]]; then
    echo ">>> cd ${MINITREE_DIR}/source/HZZCommon/H4lGridSubmission"
    cd "${MINITREE_DIR}/source/HZZCommon/H4lGridSubmission"
elif [[ $OPT_PROCESS = true ]]; then
    echo ">>> cd $CURRENT_DIR"
    cd "$CURRENT_DIR"
fi
