#!/bin/zsh

# Setup the Grid
# ==============
# 
# This scripts sets up rucio and panda so you can use these tools to access the
# Grid. It also sets your voms proxy (a prerequisite for Grid access)
# 
# Usage
# -----
# 
# $ source setup-grid.sh
# 
# Note
# ----
# 
# This scripts has to be 'sourced' instead of executed because what it does is
# set environment variables so you can use rucio/panda in your *current shell*.
# Executing it would set up these tools in a new shell and then exit (obviously
# not what you want).

voms-proxy-init -voms atlas
lsetup rucio
lsetup panda
