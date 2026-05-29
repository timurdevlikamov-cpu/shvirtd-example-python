#Создаем сеть 'my_app_network'
docker network create --subnet=172.20.0.0/16 my_app_network

#Запускаем контейнер с Mysql в сети 'my_app_network'. Благо вольюм сздается автоматически!
docker run -d --name db_mysql --network my_app_network --ip 172.20.0.10 -e MYSQL_ROOT_PASSWORD=password mysql:8.0

#Запускаем контейнер с wordpress в сети 'my_app_network'
docker run -d --name web_python --network my_app_network --ip 172.20.0.5 -p 8080:5000 my-python-app
