#!/bin/bash

#
# Copyright (C) 2024-2025 Unitrix Kernel
#

#
# Set environment variable
#
set -e

#
# Filter in precise actions
#
function parse_parameters()
{
    while (($#)); do
        case $1 in
		stable | devel | v*) action=$1 ;;
		*) exit 33 ;;
	esac
	shift
    done
}

#
# Checkout branch of last release
#
function do_stable()
{
   if ! [ -d $KERNELSUNEXT ]; then
       git clone https://github.com/GhostMaster69-dev/KernelSU-Next.git $KERNELSUNEXT > /dev/null 2>&1
       git -C $KERNELSUNEXT checkout $(git -C $KERNELSUNEXT describe --abbrev=0 --tags) > /dev/null 2>&1
   fi
}

#
# Checkout main development branch
#
function do_devel()
{
   if ! [ -d $KERNELSUNEXT ]; then
       git clone https://github.com/GhostMaster69-dev/KernelSU-Next.git $KERNELSUNEXT > /dev/null 2>&1
   fi
}

#
# Checkout any specific older release
#
function do_older()
{
   if ! [ -d $KERNELSUNEXT ]; then
       git clone https://github.com/GhostMaster69-dev/KernelSU-Next.git $KERNELSUNEXT > /dev/null 2>&1
       git -C $KERNELSUNEXT checkout $action > /dev/null 2>&1
   fi
}

#
# Remove existing KernelSU-Next directory
#
rm -rf $KERNELSUNEXT

#
# Parse user parameters
#
parse_parameters $@

#
# Check action and call appropriate function
#
if [ $action = "stable" ] || [ $action = "devel" ]; then
do_$action
else
do_older
fi

# ksud: Remove functions for auto detect KMI version from kernel and boot
for release in "v1.0.3" "v1.0.4"; do
if [ $(git -C $KERNELSUNEXT describe --abbrev=0 --tags) = $release ]; then
    git -C $KERNELSUNEXT cherry-pick -n --no-gpg-sign 3c62cade0e4c72afcf9097feba96a6293d76dacf
fi
done
