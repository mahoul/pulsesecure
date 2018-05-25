#!/bin/bash

#Preparing system for the pulse secure
cp /etc/hosts /etc/resolv.conf /tmp

su -c 'umount /etc/hosts /etc/resolv.conf' 

cp /tmp/hosts /tmp/resolv.conf /etc

#if [ $# -eq 0 ]; then
#  /usr/bin/env LD_LIBRARY_PATH=/usr/local/pulse:$LD_LIBRARY_PATH /usr/local/pulse/pulseUi
#else
  exec $*
#fi

