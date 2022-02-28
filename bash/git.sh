#!/bin/sh
function GitStting {
GitUSER='wjswhdgus123'
GitEMAIL='wjswhdgus123@naver.com'
export GitDIR='/SOURCE'
GitSSH='git@github.com:wjswhdgus123/jjhrepo.git'
Repo=`echo $GitSSH|awk -F '/' '{print $2}'|sed s/.git//g`
ScriptsDIR=bash
mkdir -p $GitDIR
git config --global user.name $GitUSER
git config --global user.email $GitEMAIL
cd $GitDIR
git init
#git remote add origin $GitSSH
git clone $GitSSH
}

GitStting
cd $GitDIR/$Repo/$ScriptsDIR
sh Pkg_install.sh

