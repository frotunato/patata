#!/bin/bash
pids=$(pgrep patata)

if [ "${pids}" != "" ]; then
        usage=$(ps -p "$pids" -o %cpu | tail -n +2 | cut -c 2-)
                proyecto=$(hostname -d)
                wTime=$(uptime -s)
                curl --data "instance=$HOSTNAME&project=$proyecto&usage=$usage&mail=$1&uptime=$wTime" 51.254.143.175:8083/check
        if [ $usage -lt 400 ]; then
                sudo halt
        fi
else
        sudo halt
fi
