#!/bin/bash

function NetWork_STATUS {
cat /dev/null > ative_ethenet.log
mkdir /CFGBAKUP
number=1
echo "Network Status Check"

STATUS=$(nmcli  con show  |awk '{print $3,$4}' |grep ether |awk '{print $2}')

for ethenet in $STATUS
do
NETSTATUS=$(mii-tool $STATUS )
Speed=$(echo $NETSTATUS|awk '{print $3}')
ONOFF=$(echo $NETSTATUS|awk '{print $6}')
ROUTE=0
if [ $ONOFF == "ok" ] ; then

echo "_______________________________________________________"
echo "Ethenet : $ethenet"
echo "LAN Connect Status : Active "
echo "LAN Speed : $Speed" 
echo "$ethenet" >> ative_ethenet.log
echo "_______________________________________________________"
ROUTE=1

else 
echo 
fi
done

if [ $ROUTE -eq 1 ] ;then

echo "_______________________________________________________"
echo "Start Ping Test"
ping -c 5 8.8.8.8 > pinglog
PSTATUS=$(tail -1 pinglog)
cat pinglog

echo "_______________________________________________________"
	if [ -z "$PSTATUS" ];then
		
echo "_______________________________________________________"
	else
	echo
	fi
fi
}
function NetWork_SETTING {
cat /dev/null > netlist
cat /dev/null > ipinfo
Check=$(cat ative_ethenet.log )
if [ ! -e /ative_ethenet.log  -o "-n" "$Check" ] ; then
echo "IP setting Start."
for ethenet in $(cat ative_ethenet.log)
do
	echo "$number.$ethenet"
	echo "$number.$ethenet" >> netlist
	number=$(($number+1))

done
	echo -n "Setting Ethenet Select: "
	read num
	grep "^$num" netlist|sed s/^$num.//g 
	Ethenet=$(grep -w "^$num" netlist | sed s/^$num.//g) 

	cat  /etc/sysconfig/network-scripts/ifcfg-$Ethenet  > ipinfo
	vim ipinfo
	cat ipinfo
	echo -n "select Information import?:(y/n)"
	read YN

	if [ $YN == "y" -o "$YN" == "Y" ] ; then
		mv /etc/sysconfig/network-scripts/ifcfg-$Ethenet /CFGBAKUP/ifcfg-$Ethenet"_orignal"
		cp -a ipinfo /etc/sysconfig/network-scripts/ifcfg-$Ethenet 
	elif [ $YN == "n" -o "$YN" == "N" ] ; then
		echo
	fi
else 
echo "상태 체크를 진행되지 않았습니다."
echo "스크립트를 다시 실행해 주세요"
exit 
fi
}

NetWork_SETTING
