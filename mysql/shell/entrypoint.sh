#!/bin/sh
set -e

echo "Waiting for mysql-server-1 to accept connections..."
until mysqladmin ping -h mysql-server-1 -P 3306 -u root -pmysql --silent; do
  sleep 2
done

echo "mysql-server-1 is up. Running SetupCluster.js..."
mysqlsh --js -h mysql-server-1 -P 3306 -u root -pmysql --file /scripts/SetupCluster.js

echo "Cluster setup finished. Creating ninja DB/user on mysql-server-1 (no router)..."

# Sometimes right after cluster setup the node may need a moment to be ready for writes.
until mysql -h mysql-server-1 -P 3306 -u root -pmysql -e "
CREATE DATABASE IF NOT EXISTS ninja CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'ninja'@'%' IDENTIFIED BY 'ninja';
GRANT ALL PRIVILEGES ON ninja.* TO 'ninja'@'%';
FLUSH PRIVILEGES;
" ; do
  echo "DB not ready yet, retrying..."
  sleep 3
done

echo "ninja database and user created successfully."
