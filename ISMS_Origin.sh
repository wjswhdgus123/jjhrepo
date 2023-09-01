#!/bin/sh

DATE=`date +%Y%m%d`
OS=`cat /etc/os-release |grep  "^ID="|awk -F '=' '{print $2}'`
OS_Ver=`cat /etc/os-release |grep  "VERSION_ID="|awk -F '=' '{print $2}'|sed s/\"//g`
echo $OS $OS_Ver
if [ "$OS" = "ubuntu" -a $OS_Ver = "22.04" ]; then


ISMS_U01 () {
  echo "$OS/$OS_Ver already applied" 
}
ISMS_U02 () {
	cp /etc/login.defs /etc/login.defs_$DATE
	sed -i s/^PASS_MAX_DAYS/#PASS_MAX_DAYS/g /etc/login.defs
	sed -i s/^PASS_MIN_DAYS/#PASS_MIN_DAYS/g /etc/login.defs
	sed -i s/^PASS_WARN_AGE/#PASS_WARN_AGE/g /etc/login.defs
	sed -i'' -r -e "/^#PASS_WARN_AGE/a\PASS_MAX_DAYS   90" /etc/login.defs 
	sed -i'' -r -e "/^PASS_MAX_DAYS/a\PASS_MIN_DAYS   0" /etc/login.defs 
	sed -i'' -r -e "/^PASS_MIN_DAYS/a\PASS_WARN_AGE   7" /etc/login.defs 
	sed -i'' -r -e "/^PASS_WARN_AGE/a\PASS_MIN_LEN 8" /etc/login.defs 
}
ISMS_U03 () {
	tar cvzf /usr/local/src/PAM_$DATE.tar.gz /etc/pam.d
	sed -i'' -r -e "/pam_unix.so/i\auth       required                                      pam_faillock.so preauth silent audit deny=4 unlock_time=300"  /etc/pam.d/common-auth
	sed -i'' -r -e "/pam_unix.so/a\auth        \[default=die\]                                pam_faillock.so authfail audit deny=4 unlock_time=300"  /etc/pam.d/common-auth
	sed -i'' -r -e "/default=die/a\auth        sufficient                                    pam_faillock.so authsucc audit deny=4 unlock_time=300"  /etc/pam.d/common-auth
	sed -i'' -r -e "/# end of pam-auth-update config/a\account required                        pam_faillock.so"  /etc/pam.d/common-account
}
ISMS_U04 () {
  echo "$OS/$OS_Ver already applied" 
}
ISMS_U05 () {
  echo "$OS/$OS_Ver already applied" 
}
ISMS_U06 () {
   chmod 4750 `which su`
}

ISMS_U07 () {
  chmod 600 /etc/hosts
  chmod 400 /etc/shadow
  chmod 644 /etc/passwd
  chmod 640 /etc/rsyslog.conf
  chmod 644 /etc/services

}

ISMS_U08 () {
	echo "export TMOUT=600" >> /etc/profile
	source /etc/profile

}

USERADD () {

	for NAME in jhjeon2 ckhan yhjung3 ansible
	do
		if [ $NAME = "ansible" ]
		then
			useradd -d /home/$NAME -s /bin/bash -G sudo  -m $NAME
			echo "$NAME:dpebdnlf^^10!" |chpasswd
		else
			useradd -d /home/$NAME -s /bin/bash -G sudo -m $NAME
			echo "$NAME:qwer1234!" | chpasswd
		fi
	done
}

IFREWALL () {
	mkdir -p /firewall

	 cat <<EOF > /firewall/firewall.sh
#!/bin/bash
source /etc/profile

# INPUT Rules
iptables -F
iptables -X

# INPUT Rules
iptables -P OUTPUT      ACCEPT
iptables -P FORWARD     ACCEPT
iptables -P INPUT       ACCEPT

# Local
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
iptables -A INPUT -i eth0 -f -j LOG --log-prefix "ESTABLISHED"
iptables -A INPUT -p tcp -m tcp ! --tcp-flags SYN,ACK,FIN,RST SYN -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Office
#iptables -A INPUT -s 210.181.109.9/32 -j ACCEPT
#iptables -A INPUT -s 103.8.101.6/32 -j ACCEPT
#iptables -A INPUT -s 10.103.20.49/32 -j ACCEPT
# zabbix
iptables -A INPUT -m state --state NEW -m tcp -p TCP --dport 9999 -j ACCEPT

#
#iptables -A INPUT -m state --state NEW -m udp -p UDP --dport 161 -j ACCEPT
#iptables -A INPUT -m state --state NEW -m tcp -p TCP --dport 5051 -j ACCEPT

## SSH open
iptables -A INPUT -m state --state NEW -m tcp -p TCP -s 10.30.11.0/24 --dport 22 -j ACCEPT
iptables -A INPUT -m state --state NEW -m tcp -p TCP -s 10.30.12.0/24 --dport 22 -j ACCEPT
iptables -A INPUT -m state --state NEW -m tcp -p TCP -s 10.30.13.0/24 --dport 22 -j ACCEPT
#ansible
iptables -A INPUT -m state --state NEW -m tcp -p TCP -s 172.16.10.146/32 --dport 22 -j ACCEPT
#d-jen
iptables -A INPUT -m state --state NEW -m tcp -p TCP -s 172.16.10.130/32 --dport 22 -j ACCEPT





# ICMP
#iptables -A INPUT -p ICMP -j ACCEPT
iptables -A INPUT -p ICMP -s 10.30.11.0/24 -j ACCEPT
iptables -A INPUT -p ICMP -s 10.30.12.0/24 -j ACCEPT
iptables -A INPUT -p ICMP -s 10.30.13.0/24 -j ACCEPT

# DROP Rules
iptables -A INPUT -m state --state INVALID -j DROP
iptables -A INPUT -p tcp --syn -j REJECT
iptables -A INPUT -j REJECT --reject-with icmp-host-prohibited

#service iptables save
iptables-save -c >  /etc/iptables
sudo iptables-save -c
EOF

chmod +x /firewall/firewall.sh
sh /firewall/firewall.sh
printf '%s\n' '#!/bin/bash' 'sh /firewall/firewall.sh' 'exit 0' | sudo tee -a /etc/rc.local
chmod +x /etc/rc.local
cat << EOF >> /lib/systemd/system/rc-local.service

#[Install]
#WantedBy=multi-user.target
#EOF

#systemctl --now enable rc-local


}


#ISMS_U01
#ISMS_U02
#ISMS_U03
#ISMS_U04
#ISMS_U05
#ISMS_U06
#ISMS_U07
#ISMS_U08
#USERADD
IFREWALL

elif [ $OS = "ubuntu" -a $OS_Ver != "22.04" ] ; then
       echo 1 

elif [ $OS == "centos" -a $OS_Ver = "7" ] ; then
echo 

elif [ $OS == "centos" -a $OS_Ver = "8" ] ; then
echo 

else

echo "EOS OS  / OS Upgrade Plz "
fi

