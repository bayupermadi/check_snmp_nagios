#!/bin/bash

help() {
  echo ""
  echo "Check the Process Availability"
  echo ""
  echo "-H <hostname or ip address > (str)"
  echo "-C <snmp community> (str)"
  echo "-p <process name> (str)"
  echo "-h <help>"
  echo ""
  echo ""
  echo "This plugin use the 'snmpwalk' command."
  echo "Make sure you have activated OID .1.3.6.1.2.1.25.4.2.1.2 for software / process run"
}

while getopts H:C:p:h OPT
do
    case $OPT in
        H) hostname="$OPTARG" ;;
        C) community="$OPTARG" ;;
        p) process="$OPTARG" ;;
        h) help ;;
    esac
done

value=`snmpwalk -On -v 2c $hostname -c $community .1.3.6.1.2.1.25.4.2.1.2  | grep $process`
if [ $? == 0 ]; then
    echo "$process is active | process=1"
    exit 0
elif [ $? == 1 ]; then
    echo "$process is inactive | process=0"
    exit 2
else 
    exit 3
fi
