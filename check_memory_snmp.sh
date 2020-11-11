#!/bin/bash

help() {
  echo ""
  echo "Check the Memory Utilization"
  echo ""
  echo "-H <hostname or ip address > (str)"
  echo "-p <snmp community> (str)"
  echo "-w <warning level in percent> (int)"
  echo "-c <critical level in percent> (int)"
  echo "-h <help>"
  echo ""
  echo ""
  echo "This plugin use the 'snmpwalk' command."
  echo "Make sure you have activated OID .1.3.6.1.4.1.2021.4 for Memory information"
}

while getopts H:C:w:c:h OPT
do
    case $OPT in
        H) hostname="$OPTARG" ;;
        C) community="$OPTARG" ;;
        w) warning=$OPTARG ;;
        c) critical=$OPTARG ;;
        h) help ;;
    esac
done

total=`snmpwalk -On -v 2c $hostname -c $community .1.3.6.1.4.1.2021.4.5  | awk '{print $4}'`
free=`snmpwalk -On -v 2c $hostname -c $community .1.3.6.1.4.1.2021.4.6  | awk '{print $4}'`
buffer=`snmpwalk -On -v 2c $hostname -c $community .1.3.6.1.4.1.2021.4.14  | awk '{print $4}'`
cache=`snmpwalk -On -v 2c $hostname -c $community .1.3.6.1.4.1.2021.4.15  | awk '{print $4}'`

available=$((free + buffer + cache))
used=$((total - available))
value=$((used * 100 / total ))
echo "Memory Usage = $value% | mem_usage=$value;$warning;$critical"
if [ $value -gt $critical ]; then
    exit 2
elif [ $value -gt $warning ]; then
    exit 1
elif [ $value -ge 0 ]; then
    exit 0
else 
    exit 3
fi
