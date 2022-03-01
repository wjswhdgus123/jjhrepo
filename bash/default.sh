#!/bin/sh

 #LOCAlE SETTING

 function get_locale {
 echo  """
 _____________________________________________________________
 !							    !
 ! 1. UTF-8						    !
 !							    !
 ! 2. EUC_KR						    !
 !				     			    !
 !							    !
 !___________________________________________________________!
 """
 echo -n Select LOCALE :; read LOCALE
 case $LOCALE in
  1)
 localectl set-locale LANG=ko_KR.utf8
 localectl status
 ;;

  2)
 localectl set-locale LANG=ko_KR.euckr
 localectl status
 esac


 }

 function profile {
if [ ! -e /root/bashrc_origin ] ;then
 mv /root/.bashrc /root/bashrc_origin
else
echo 
fi
 echo """
 # .bashrc
 # Source global definitions
 if [ -f /etc/bashrc ]; then
 	. /etc/bashrc
 fi
 # Uncomment the following line if you don't like systemctl's auto-paging feature:
 # export SYSTEMD_PAGER=
 # User specific aliases and functions
 alias rm='rm -i'
 alias cp='cp -i'
 alias mv='mv -i'
 alias vi='vim'
 alias vi='vim'
 alias GIT='cd $GitDIR'
 export `cat /etc/locale.conf`
 PS1=\"[\\h:\\w] \\\\$ \"
 TMOUT=600
 """ > /etc/skel/.bashrc

 echo """
 set nu
 set shiftwidth=4
 set showmatch
 set smartcase
 set ruler
 set cursorline
 set hlsearch
 set tabstop=4
 syntax on
 set background=dark
 colorscheme delek
 """ > /etc/skel/.vimrc
 cp -a /etc/skel/.bashrc /root/
 cp -a /etc/skel/.vimrc /root/

 }

 function HOSTNAME_SETTING {
 echo "HOSTNAMME Insert :"
 read HOST
 echo $HOST
 HOSTNAME=$HOST
 if [ -n "$HOST" ]; then

 hostnamectl set-hostname $HOST

 else

 echo "HOSTNAME volume is Null"
 fi

 }

 function TIMESync {

 systemctl enable chronyd
 systemctl start chronyd
 timedatectl

 }

 function Resource {
 LOGDIR=/var/log
 Check=$(cat /etc/crontab |grep -w '/usr/bin/sar')

 if [ -z "$Check" ] ; then
 echo "0 * * * * root /usr/bin/sa 60 60  -o $LOGDIR/sar_CPU" >> /etc/crontab
 echo "0 * * * * root /usr/bin/sa -F 600 6  -o $LOGDIR/sar_DISK" >> /etc/crontab
 echo "0 * * * * root /usr/bin/sa -r 60 60  -o $LOGDIR/sar_DISK" >> /etc/crontab
 else

 echo 

 fi



 }

get_locale
profile
HOSTNAME_SETTING
TIMESync
Resource
