#!/bin/sh

#Удаляем старые конейнеры и сеть
docker rm -f db_mysql 2>/dev/null
docker rm -f web_python 2>/dev/null
docker network rm my_app_network || true

#Создаем сеть 'my_app_network'
docker network create --subnet=172.20.0.0/16 my_app_network

#Сборка обращза 
docker build -t my-python-app -f Dockerfile.python .

#Запуск контейнера с Mysql в сети 'my_app_network'. Благо вольюм сздается автоматически!
docker run -d --name db_mysql --network my_app_network --ip 172.20.0.10 -v 'db_data:/var/lib/mysql' -e 'MYSQL_ROOT_PASSWORD=YtReWq4321' -e 'MYSQL_DATABASE=virtd' -e 'MYSQL_USER=app' -e 'MYSQL_PASSWORD=QwErTy1234' mysql:8.0
echo "Ждём запуска БД"
sleep 30

#Запуск контейнера с wordpress в сети 'my_app_network'
docker run -d --name web_python --network my_app_network --ip 172.20.0.5 -p 8080:5000 my-python-app
