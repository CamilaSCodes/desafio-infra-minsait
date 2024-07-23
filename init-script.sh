#!/bin/bash

# Atualiza a lista de pacotes disponíveis
sudo apt-get update -y

# Instala o Docker e o configura para iniciar automaticamente com o sistema
sudo apt-get install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker

# Instala o Docker Compose, necessário para orquestrar os containers 
sudo curl -L "https://github.com/docker/compose/releases/download/v2.12.2/docker-compose-$(uname -s)-$(uname -m)"  -o /usr/local/bin/docker-compose
sudo mv /usr/local/bin/docker-compose /usr/bin/docker-compose
sudo chmod +x /usr/bin/docker-compose

# Cria o arquivo .yml usado para configurar os serviços no Docker
# Instala o Docker e BD em containers separados
cat <<EOF > /home/adminuser/docker-compose.yml
version: '3.9'

services:
  db:
    image: mysql:5.7.16
    volumes:
      - db_data:/var/lib/mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: GAud4mZby8F3SD6P
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpress

  wordpress:
    depends_on:
       - db
    image: wordpress:latest
    volumes:
      - wordpress_data:/var/www/html
    ports:
      - "80:80"
    restart: always
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress
      WORDPRESS_DB_NAME: wordpress

volumes:
  wordpress_data:
  db_data:
EOF

# Implanta os containers a partir do .yml criado
sudo docker-compose -f /home/adminuser/docker-compose.yml up -d
