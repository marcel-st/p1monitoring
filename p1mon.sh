## P1 Monitor Zabbix script
##
## Written by Marcel Stangenberger
## For usage with P1 Monitor by Security Brother
## P1 Monitor download : https://www.ztatz.nl/

PWR_API="http://$1/api/v1/smartmeter?limit=1"
GAS_API="http://$1/api/v1/powergas/minute?limit=1"
WTR_API="http://$1/api/v2/watermeter/minute?limit=1"
TMP=$(/usr/bin/mktemp -q)
BIN=/usr/bin/wget

case $2 in
	production)
		$BIN -q -O $TMP $PWR_API
		cat $TMP | cut -f 10 -d ","
		rm -f $TMP
	;;
	consumption)
		$BIN -q -O $TMP $PWR_API
		cat $TMP | cut -f 9 -d ","
		rm -f $TMP
	;;
	gas)
		$BIN -q -O $TMP $GAS_API
		cat $TMP | cut -f 11 -d ","
		rm -f $TMP
	;;
	water)
		$BIN -q -O $TMP $WTR_API
		cat $TMP | cut -f 5 -d ","
		rm -f $TMP
	;;
	*)
		echo "This script is suppossed to be called from a Zabbix template"
		echo "Manual operation is possible though"
		echo "usage : $0 <P1 IP> (production/comsumption/gas/water)"
		echo
	;;
esac

exit 0
