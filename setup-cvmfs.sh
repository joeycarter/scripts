#!/bin/zsh

# Set up CVMFS
# ============
#
# Set up CVMFS. See https://cvmfs.readthedocs.io/ for more information.
#
# usage: setup-cvmfs.sh [--help] [--docker]


# Script name
sname=${0##*/}

# Help message
show_help() {
cat <<EOF
usage: ${sname} [--help] [--docker]

Set up CVMFS. See https://cvmfs.readthedocs.io/ for more information.

optional arguments:
  -h, --help   Show this help message and exit
  --docker     Start default ATLAS docker container after setting up CVMFS
EOF
}


# ----- Parse input arguments -----#

START_DOCKER=false

while (( $# > 0 )); do
    opt="$1"

    case $opt in
        -h|--help)
            show_help
            exit 0
            ;;
        --docker)
            START_DOCKER=true
            shift
            ;;
        --) # End argument parsing
            shift
            break
            ;;
        -*)
            echo "error: unknown option '$opt'"
            show_help
            exit 1
            ;;
        *)
            ARGS=$opt
            shift
            ;;
    esac
done

sudo systemctl stop autofs

echo "Mounting '/cvmfs/atlas.cern.ch'..."
if grep -qs '/cvmfs/atlas.cern.ch' /proc/mounts; then
    echo " -> '/cvmfs/atlas.cern.ch' is already mounted"
else
    sudo mkdir -p /cvmfs/atlas.cern.ch
    sudo mount -t cvmfs atlas.cern.ch /cvmfs/atlas.cern.ch
fi

echo "Mounting '/cvmfs/atlas-condb.cern.ch'..."
if grep -qs '/cvmfs/atlas-condb.cern.ch' /proc/mounts; then
    echo " -> '/cvmfs/atlas-condb.cern.ch' is already mounted"
else
    sudo mkdir -p /cvmfs/atlas-condb.cern.ch
    sudo mount -t cvmfs atlas-condb.cern.ch /cvmfs/atlas-condb.cern.ch
fi

echo "Mounting '/cvmfs/atlas-nightlies.cern.ch'..."
if grep -qs '/cvmfs/atlas-nightlies.cern.ch' /proc/mounts; then
    echo " -> '/cvmfs/atlas-nightlies.cern.ch' is already mounted"
else
    sudo mkdir -p /cvmfs/atlas-nightlies.cern.ch
    sudo mount -t cvmfs atlas-nightlies.cern.ch /cvmfs/atlas-nightlies.cern.ch
fi

echo "Mounting '/cvmfs/sft.cern.ch'..."
if grep -qs '/cvmfs/sft.cern.ch' /proc/mounts; then
    echo " -> '/cvmfs/sft.cern.ch' is already mounted"
else
    sudo mkdir -p /cvmfs/sft.cern.ch
    sudo mount -t cvmfs sft.cern.ch /cvmfs/sft.cern.ch
fi

if [[ $START_DOCKER = true ]]; then
    echo "Starting docker container 'atlas/atlas_external_cvmfs'..."
    docker run --net host -i -t -v /cvmfs:/cvmfs -v $HOME:$HOME -v /tmp/.X11-unix:/tmp/.X11-unix \
        -e DISPLAY=$DISPLAY atlas/atlas_external_cvmfs
fi
