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

exec mysqlsh \
  --js \
  -h mysql-server-1 \
  -P 3306 \
  -u root \
  -pmysql \
  --file /scripts/SetupCluster.js
