#!/bin/sh
set -e

echo "Waiting for MySQL to accept TCP connections..."

until mysqladmin ping \
  -h mysql-server-1 \
  -P 3306 \
  -u root \
  -pmysql \
  --silent
do
  sleep 2
done

echo "MySQL is ready. Running mysqlsh script..."

mysqlsh \
  --js \
  -h mysql-server-1 \
  -P 3306 \
  -u root \
  -pmysql \
  --file /scripts/SetupCluster.js

echo "Cluster setup complete. Waiting for MySQL Router..."

# Wait for mysql-router to be ready
until mysqladmin ping \
  -h mysql-router \
  -P 6446 \
  -u root \
  -pmysql \
  --silent
do
  echo "Waiting for mysql-router to be ready..."
  sleep 5
done

echo "MySQL Router is ready. Creating Akaunting database..."

# Create database through the router
mysql \
  -h mysql-router \
  -P 6446 \
  -u root \
  -pmysql \
  -e "CREATE DATABASE IF NOT EXISTS akaunting CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; \
      CREATE USER IF NOT EXISTS 'akaunting'@'%' IDENTIFIED BY 'akaunting_password'; \
      GRANT ALL PRIVILEGES ON akaunting.* TO 'akaunting'@'%'; \
      FLUSH PRIVILEGES;"

echo "Akaunting databases and user created successfully."