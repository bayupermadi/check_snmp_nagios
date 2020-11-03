#!/bin/bash

help() {
  echo ""
  echo "Check the CPU Utilization"
  echo ""
  echo "-H <hostname or ip address > (str)"
  echo "-p <snmp community> (str)"
  echo "-w <warning level in percent> (int)"
  echo "-c <critical level in percent> (int)"
  echo "-h <help>"
  echo ""
  echo ""
  echo "This plugin use the 'snmpwalk' command."
  echo "Make sure you have activated OID .1.3.6.1.4.1.2021.11.10 for CPU system percent"
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

value=`snmpwalk -On -v 2c $hostname -c $community .1.3.6.1.4.1.2021.11.10  | awk '{print $4}'`
echo "CPU Usage = $value% | cpu_usage=$value;$warning;$critical;0"
if [ $value -gt $critical ]; then
    exit 2
elif [ $value -gt $warning ]; then
    exit 1
else 
    exit 0
fi
