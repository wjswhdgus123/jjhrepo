#!/bin/sh
GitUSER='wjswhdgus123'
GitEMAIL='wjswhdgus123@naver.com'
export GitDIR='/SOURCE'
GitSSH='git@github.com:wjswhdgus123/jjhrepo.git'
Repo=`echo $GitSSH|awk -F '/' '{print $2}'|sed s/.git//g`
ScriptsDIR=bash

function GitStting {
mkdir -p $GitDIR
git config --global user.name $GitUSER
git config --global user.email $GitEMAIL
cd $GitDIR
git init
git remote add origin $GitSSH
git clone $GitSSH
}

function GeoGit{
Lic='g0Vcw6gp6PHPSYfe'
GeoDIR='GeoLite2xtables'
cd $GitDIR
git clone https://github.com/mschmitt/GeoLite2xtables
pwd
cd $GeoDIR

mv geolite2.license.example geolite2.license
sed -i s/asdfqwer1234/$Lic/g geolite2.license
}


GitStting
cd $GitDIR/$Repo/$ScriptsDIR
pwd
sh Pkg_install.sh
sh default.sh
