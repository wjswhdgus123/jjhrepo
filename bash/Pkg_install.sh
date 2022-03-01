#!/bin/sh

function PKG_INSTALL {
LISTDIR=$GitDIR/bash/pkglist
#LISTDIR=/root/
dnf install -y epel-release 
dnf install -y sysstat net-tools fping curl wget bind-utils net-snmp net-snmp-utils strace lsof vim chrony make cmake
dnf install -y python39
if [ ! -e $LISTDIR -o "-s" "$LISTDIR" ]; then 

echo 
else

for PKG in `cat $LISTDIR`
do
dnf -y install $PKG
done

fi

dnf -y update 
}

function Pkg_GeoIP {
PKGDIR=$GitDIR/PKG
echo $PKGDIR
mkdir -p $PKGDIR
dnf install -y  gcc gcc-c++ make automake unzip zip kernel-devel-`uname -r` iptables-devel perl-CPAN libmnl* perl-NetAddr-IP perl-Text-CSV_XS
wget http://downloads.sourceforge.net/project/xtables-addons/Xtables-addons/xtables-addons-2.13.tar.xz  -P $PKGDIR
cd $PKGDIR
tar xvzf xtables-addons-2.13.tar.xz
cd xtables-addons-2.13
sed -i s/build_TARPIT=m/#build_TARPIT=m/g mconfig
./configure
make;make install

}


PKG_INSTALL
