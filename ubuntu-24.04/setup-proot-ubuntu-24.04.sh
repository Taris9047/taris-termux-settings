#!/usr/bin/env bash
#
# This is a set up script supposed to be run in the proot
# Linux, in this case: Ubuntu 24.04
#

# Curtesy update
#
printf '>>>> In Proot: Running Curtesy Updates\n'
sudo apt update && sudo updgrade -y


