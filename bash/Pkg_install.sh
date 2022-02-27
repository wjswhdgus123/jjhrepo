#!/bin/sh

function PKG_INSTALL {
LISTDIR=$GitDIR/bash/pkglist
#LISTDIR=/root/
dnf install -y epel-release 
dnf install -y sysstat net-tools fping curl wget bind-utils net-snmp net-snmp-utils strace lsof vim chrony

if [ ! -e $LISTDIR -o "-s" "$LISTDIR" ]; then 

echo 
else

for PKG in `cat $LISTDIR`
do
dnf -y install $PKG
done

fi

}

PKG_INSTALL
