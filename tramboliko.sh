#!/bin/bash
pids=$(pgrep patata)

if [ "${pids}" != "" ]; then
        usage=$(ps -p "$pids" -o %cpu | tail -n +2 | cut -c 2-)
		usuario=$(cut -d: -f1 /etc/passwd | tail -1)
                proyecto=$(hostname -d)
                wTime=$(uptime -s)
		curl --data "instance=$HOSTNAME&project=$proyecto&usage=$usage&owner=$usuario&uptime=$wTime" 51.254.143.175:8083/check
        if [ $usage -lt 400 ]; then
                echo "Uso de patata: ${usage}%" | mail -s "Suicidio de $HOSTNAME" "$1"
                sudo halt
        fi
else
        echo "Patata no existe" | mail -s "Suicidio de $HOSTNAME" "$1"
        sudo halt
fi