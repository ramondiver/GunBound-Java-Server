#!/bin/bash
set -euo pipefail

DATADIR="${MYSQL_DATADIR:-/var/lib/mysql}"
mkdir -p /var/run/mysqld "$DATADIR"
chown -R mysql:mysql /var/run/mysqld "$DATADIR"

if [ ! -d "$DATADIR/mysql" ]; then
  echo "==> Initializing MariaDB datadir"
  mariadb-install-db --user=mysql --datadir="$DATADIR" --skip-test-db >/dev/null
fi

echo "==> Starting MariaDB"
mariadbd --user=mysql --datadir="$DATADIR" --bind-address=127.0.0.1 --skip-networking=0 &
for i in $(seq 1 60); do
  if mariadb -uroot -e "SELECT 1" >/dev/null 2>&1; then
    break
  fi
  sleep 1
done

mariadb -uroot <<'SQL'
CREATE DATABASE IF NOT EXISTS `gbth` CHARACTER SET latin1 COLLATE latin1_swedish_ci;
CREATE USER IF NOT EXISTS 'gunbound'@'localhost' IDENTIFIED BY 'gunbound';
CREATE USER IF NOT EXISTS 'gunbound'@'%' IDENTIFIED BY 'gunbound';
GRANT ALL PRIVILEGES ON `gbth`.* TO 'gunbound'@'localhost';
GRANT ALL PRIVILEGES ON `gbth`.* TO 'gunbound'@'%';
FLUSH PRIVILEGES;
SQL

if ! mariadb -uroot gbth -e "SHOW TABLES LIKE 'user'" | grep -q user; then
  echo "==> Importing schema"
  mariadb -uroot gbth < /app/sql/01-schema.sql
  mariadb -uroot gbth < /app/sql/02-seed.sql || true
fi

if [ -z "${SERVER_PUBLIC_IP:-}" ]; then
  SERVER_PUBLIC_IP="$(curl -4 -fsS --max-time 5 https://ifconfig.me || true)"
  export SERVER_PUBLIC_IP
  echo "==> Detected public IPv4: ${SERVER_PUBLIC_IP:-unknown}"
fi

if [ -n "${SERVER_PUBLIC_IP:-}" ]; then
  sed -i "s/^server.public.ip=.*/server.public.ip=${SERVER_PUBLIC_IP}/" /app/config/config.properties
fi
sed -i "s|^db.url=.*|db.url=jdbc:mariadb://127.0.0.1:3306/gbth?useSSL=false\&allowPublicKeyRetrieval=true|" /app/config/config.properties
sed -i "s/^db.user=.*/db.user=gunbound/" /app/config/config.properties
sed -i "s/^db.password=.*/db.password=gunbound/" /app/config/config.properties

echo "==> Starting GunBound  public=${SERVER_PUBLIC_IP:-} bind=0.0.0.0"
exec java ${JAVA_OPTS:-} -jar /app/gunbound-server.jar
