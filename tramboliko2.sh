#!/bin/bash
pids=$(pgrep patata2)

if [ "${pids}" != "" ]; then
        usage=$(ps -p "$pids" -o %cpu | tail -n +2 | cut -c 2-)
        if [ $usage -lt 400 ]; then
                sudo shutdown -h now
        fi
else
        sudo shutdown -h now
fi
