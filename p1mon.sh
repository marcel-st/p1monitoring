#!/bin/bash

## P1 Monitor Zabbix script
##
## Written by Marcel Stangenberger
## For usage with P1 Monitor by Security Brother
## P1 Monitor download : https://www.ztatz.nl/

PWR_API="http://$1/api/v1/smartmeter?limit=1"
WTR_API="http://$1/api/v2/watermeter/minute?limit=1"
SLR_API="https://monitoringapi.solaredge.com/site/$3/overview?api_key=$4"
TMP=$(/usr/bin/mktemp -q)
TMPDIR=/tmp/p1mon
BIN=/usr/bin/wget
CALC=/usr/bin/bc

[[ ! -d $TMPDIR ]] && mkdir -p /tmp/p1mon

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
	generation)
		$BIN -q -O $TMP $SLR_API
		cat $TMP | awk '{ print $2 }' | cut -f 6 -d ","|cut -f 3 -d ":"|cut -f 1 -d "}"
		rm -f $TMP
	;;
	gas)
		$BIN -q -O $TMP $PWR_API
		[[ -f $TMPDIR/gas_val1.tmp ]] && cp -f $TMPDIR/gas_val1.tmp $TMPDIR/gas_val2.tmp
		cat $TMP | awk '{print $12}'|cut -f 1 -d "]" > $TMPDIR/gas_val1.tmp
		rm -f $TMP
		echo "$(cat $TMPDIR/gas_val1.tmp)-$(cat $TMPDIR/gas_val2.tmp)" | $CALC
		
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
