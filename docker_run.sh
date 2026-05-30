#!/bin/sh

#Удаляем старые конейнеры и сеть
###docker rm -f db_mysql web_python reverse_proxy ingress_proxy 2>/dev/null
###docker network rm shvirtd_network || true
###docker rm -f db_mysql web_python 2>/dev/null

#Создаем сеть 'shvirtd_network'
###docker network create --subnet=172.20.0.0/16 shvirtd_network

#Быстрый старт
###docker compose -f proxy.yaml up -d

#Сборка обращза 
###docker build -t shvirtd-app -f Dockerfile.python .

#Запуск контейнера с Mysql в сети 'my_app_network'. Благо вольюм сздается автоматически!
###docker run -d --name db_mysql --network shvirtd_network --ip 172.20.0.10 -v 'db_data:/var/lib/mysql' -e MYSQL_ROOT_PASSWORD="YtReWq4321" -e MYSQL_DATABASE="virtd" -e MYSQL_USER="app" -e MYSQL_PASSWORD="QwErTy1234" mysql:8.0
###docker run -d --name db_mysql --ip 172.20.0.10 -v 'db_data:/var/lib/mysql' -e MYSQL_ROOT_PASSWORD="YtReWq4321" -e MYSQL_DATABASE="virtd" -e MYSQL_USER="app" -e MYSQL_PASSWORD="QwErTy1234" mysql:8.0
###echo "Ждём запуска БД"
###sleep 30

#Запуск контейнера с wordpress в сети 'my_app_network'
###docker run -d --name web_python --network shvirtd_network --ip 172.20.0.5 -e MYSQL_ROOT_PASSWORD="YtReWq4321" -e MYSQL_DATABASE="virtd" -e MYSQL_USER="app" -e MYSQL_PASSWORD="QwErTy1234" shvirtd-app
###docker run -d --name web_python --ip 172.20.0.5 -e MYSQL_ROOT_PASSWORD="YtReWq4321" -e MYSQL_DATABASE="virtd" -e MYSQL_USER="app" -e MYSQL_PASSWORD="QwErTy1234" shvirtd-app

#Запуск Reverse Proxy
###docker run -d --name reverse_proxy -p 8080:80 nginx:alpine

#Запуск Ingress Proxy
###docker run -d --name ingress_proxy -p 8090:80 --add-host=host.docker.internal:host-gateway nginx:alpine

#Останавливаем текущие запущеные контейнерв
docker compose down

#Решение ошибки 'failed to create task for container'
###mkdir -p nginx/ingress haproxy/reverse
###touch nginx/ingress/default.conf nginx/ingress/nginx.conf haproxy/reverse/haproxy.cfg

#Сборка и запуск
###docker compose up --build -d
docker compose -f proxy.yaml -f compose.yaml up --build -d

#Ожидание запуска
echo "Ждём запуска БД"
sleep 30
