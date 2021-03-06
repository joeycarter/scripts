#!/bin/zsh

# Login to cedar
# ===============
#
# Login to Compute Canada's cedar server. You can login to either the first
# available node or to a specific node (which is useful if you have a screen/
# tmux session running on that node, as these sessions cannot be accessed from
# other nodes).
#
# usage: cedar [--help] [-n|--node <node>] [--no-x11] [-c|--check-host-key]


# Script name
sname=${0##*/}

# Help message
show_help() {
cat <<EOF
usage: ${sname} [--help] [-n|--node <node>] [--no-x11]

Login to Compute Canada's cedar server. You can login to either the first
available node or to a specific node (which is useful if you have a screen/
tmux session running on that node, as these sessions cannot be accessed from
other nodes).

optional arguments:
  -n <node>, --node <node>
               Login to this cedar node (e.g. 1, 2, etc.);
  --no-x11     Disable X11 forwarding (enabled by default)
  -c, --check-host-key
               Force strict checking of cedar host key (disabled by default)
  -s <args>, --ssh <args>
               Additional arguments to pass to the ssh command; wrap multiple
               arguments in quotes, e.g. 'cedar -s "-A -vv"'
  -h, --help   Show this help message and exit
EOF
}


# ----- Parse input arguments -----#

USE_X11=true
CHECK_HOST_KEY=false

while (( $# > 0 )); do
    opt="$1"

    case $opt in
        -h|--help)
            show_help
            exit 0
            ;;
        --no-x11)
            USE_X11=false
            shift
            ;;
        -n|--node)
            node="$2"
            shift
            shift
            ;;
        -c|--check-host-key)
            CHECK_HOST_KEY=true
            shift
            ;;
        -s|--ssh)
            ssh_args="$2"
            shift
            shift
            ;;
        --) # End argument parsing
            shift
            break
            ;;
        *)
            echo "error: unknown option '$opt'"
            show_help
            exit 1
            ;;
    esac
done


# Get username from scripts repository
USER="$( cd "$( dirname "${(%):-%N}" )" && cat $(pwd)/.username )"


# Get login path
if [[ -z $node ]]; then
    # No node given, let cedar decide
    login_path="${USER}@cedar.computecanada.ca"
else
    # Login to the specific node
    login_path="${USER}@cedar${node}.cedar.computecanada.ca"
fi

# Login (with or without X11 forwarding and with or without StrictHostKeyChecking)
if [[ $CHECK_HOST_KEY = false ]]; then
    if [[ $USE_X11 = true ]]; then
        echo ">>> ssh -X ${ssh_args} ${login_path}"
        ssh -X -o StrictHostKeyChecking=no ${ssh_args} "${login_path}"
    else
        echo ">>> ssh ${ssh_args} ${login_path}"
        ssh -o StrictHostKeyChecking=no ${ssh_args} "${login_path}"
    fi
else
    if [[ $USE_X11 = true ]]; then
        echo ">>> ssh -X -o StrictHostKeyChecking=yes ${ssh_args} ${login_path}"
        ssh -X -o StrictHostKeyChecking=yes ${ssh_args} "${login_path}"
    else
        echo ">>> ssh -o StrictHostKeyChecking=yes ${ssh_args} ${login_path}"
        ssh -o StrictHostKeyChecking=yes ${ssh_args} "${login_path}"
    fi
fi
