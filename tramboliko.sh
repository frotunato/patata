#!/bin/bash
pids=$(pgrep patata)

if [ "${pids}" != "" ]; then
        echo "$pids"
        usage=$(ps -p "$pids" -o %cpu | tail -n +2 | cut -c 2-)
		curl --data "instance=$HOSTNAME&project=`hostname -d`&usage=$usage&owner=`who | cut -d ' ' -f 1`" 51.254.143.175:8083/check
        if [ $usage -lt 700 ]; then
                echo "Uso de patata: ${usage}%" | mail -s "Suicidio de $HOSTNAME" "$1"
                sudo halt 
        fi
else 
        echo "Patata no existe" | mail -s "Suicidio de $HOSTNAME" "$1"
        sudo halt 
fi