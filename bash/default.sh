#!/bin/sh
function GitStting {
GitUSER='wjswhdgus123'
GitEMAIL='wjswhdgus123@naver.com'
GitDIR='/SOURCE'
GitSSH='git@github.com:wjswhdgus123/jjhrepo.git'
mkdir -p $GitDIR
git config --global user.name $GitUSER
git config --global user.email $GitEMAIL
cd $GitDIR
git init
#git remote add origin $GitSSH
git clone $GitSSH
}

