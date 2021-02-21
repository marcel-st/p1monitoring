## P1 Monitor Zabbix script
##
## Written by Marcel Stangenberger
## For usage with P1 Monitor by Security Brother
## P1 Monitor download : https://www.ztatz.nl/

API="http://$1/api/v1/smartmeter?limit=1"
TMP=$(/usr/bin/mktemp -q)
BIN=/usr/bin/wget

$BIN -q -O $TMP $API

case $2 in
	production)
		$BIN -q -O $TMP $API
		cat $TMP | cut -f 10 -d ","
		rm -f $TMP
	;;
	consumption)
		$BIN -q -O $TMP $API
		cat $TMP | cut -f 9 -d ","
		rm -f $TMP
	;;
	*)
		echo "This script is suppossed to be called from a Zabbix template"
		echo "Manual operation is possible though"
		echo "usage : $0 <P1 IP> (production/comsumption)"
		echo
	;;
esac

exit 0
