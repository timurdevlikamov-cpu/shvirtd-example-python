#!/bin/sh

#Удаляем старые конейнеры и сеть
docker rm -f db_mysql web_python reverse_proxy ingress_proxy 2>/dev/null
docker network rm shvirtd_network || true

#Создаем сеть 'shvirtd_network'
docker network create --subnet=172.20.0.0/16 shvirtd_network

#Сборка обращза 
docker build -t shvirtd_network -f Dockerfile.python .

#Запуск контейнера с Mysql в сети 'my_app_network'. Благо вольюм сздается автоматически!
docker run -d --name db_mysql --network shvirtd_network --ip 172.20.0.10 -v 'db_data:/var/lib/mysql' -e MYSQL_ROOT_PASSWORD="YtReWq4321" -e MYSQL_DATABASE="virtd" -e MYSQL_USER="app" -e MYSQL_PASSWORD="QwErTy1234" mysql:8.0
echo "Ждём запуска БД"
sleep 30

#Запуск контейнера с wordpress в сети 'my_app_network'
docker run -d --name web_python --network shvirtd_network --ip 172.20.0.5 -e MYSQL_ROOT_PASSWORD="YtReWq4321" -e MYSQL_DATABASE="virtd" -e MYSQL_USER="app" -e MYSQL_PASSWORD="QwErTy1234" shvirtd_network

#Запуск Reverse Proxy
docker run -d --name reverse_proxy -p 8080:80 nginx:alpine

#Запуск Ingress Proxy
docker run -d --name $INGRESS_PROXY_CONTAINER -p 8090:80 --add-host=host.docker.internal:host-gateway nginx:alpine

