#!/bin/sh

function PKG_INSTALL {
LISTDIR=$GitDIR/bash/pkglist
dnf install -y epel-release 
dnf install -y sysstat net-tool fping curl wget bind-utils net-snmp net-snmp-utils strace lsof 

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
