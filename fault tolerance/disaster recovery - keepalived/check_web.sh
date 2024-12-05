#!/bin/bash

WEB_PORT=80
INDEX_FILE="/var/www/html/index.nginx-debian.html"

# Проверка доступности порта
if ! nc -z 192.168.56.30 $WEB_PORT; then
    exit 1
fi

# Проверка наличия файла index.html
if [ ! -f "$INDEX_FILE" ]; then
    exit 1
fi

# Если всё в порядке
exit 0
