#!/bin/zsh

# Setup Scripts
# =============
# 
# Setup the collection of scripts.
# 
# This setup script adds the scripts repository to your PATH by appending to
# your .zshrc login script.
# 
# It also sets the username for your CERN account and saves it to a file. The
# other scripts will then read in this username. This is to avoid publishing
# sensitive information to github and to avoid prompting for a username on each
# execution of a script. If you do not have a CERN account, simply hit enter. 

# Get path to repository
REPO="$( cd "$( dirname "${(%):-%N}" )" && pwd )"

# If repository is not in path, add it (and append to .zshrc)
if ! echo $PATH | grep -q "$REPO"; then
    echo "Adding $DIR to your PATH"
    export PATH=$PATH:$REPO

    echo "" >> ~/.zshrc
    echo "# Add 'scripts' repository to path" >> ~/.zshrc
    echo "export PATH=\$PATH:$REPO" >> ~/.zshrc
    echo
fi

# Get CERN username from user
vared -p 'Enter your CERN username: ' -c user

if [[ $user == "" ]]; then
    touch .username
else
    echo $user > .username
fi
