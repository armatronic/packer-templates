#!/bin/bash

# Clear repo mirros
urpmi.removemedia -qa

# Manually add specific mirror
urpmi.addmedia -q --distrib http://mirror.internode.on.net/pub/mageia/distrib/cauldron/x86_64

# Adds default distributed mirrors
urpmi.addmedia -q --distrib --mirrorlist '$MIRRORLIST'

# Add cyprix mirror
#urpmi.addmedia -q --distrib rsync://cyprix.com.au/rpm/Mga2

# Update the mirrors
urpmi.update -qa

urpmi -q --auto kernel-server-latest kernel-server-devel-latest

reboot
sleep 60
exit
