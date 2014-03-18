#!/bin/bash
set -ex
if [ ! -d /var/lib/postgresql/9.3/main ]; then
  echo "Initial startup"
  mkdir -p /var/lib/postgresql/9.3/main
  chmod 0700 /var/lib/postgresql/9.3/main
  chown postgres /var/lib/postgresql/9.3/main
  su postgres -c "/usr/lib/postgresql/9.3/bin/initdb --pgdata /var/lib/postgresql/9.3/main"
  su postgres -c "/usr/lib/postgresql/9.3/bin/pg_ctl -D /var/lib/postgresql/9.3/main -o '-c config_file=/etc/postgresql/9.3/main/postgresql.conf' start"
  sleep 10
  if [ $DB_USER == "postgres" ]; then
    echo "ALTER USER postgres with encrypted password '$DB_PASSWORD';" | su postgres -c psql
  else
    echo "CREATE USER $DB_USER WITH SUPERUSER PASSWORD '$DB_PASSWORD';" | su postgres -c psql
  fi
  # su postgres -c "createdb -O docker docker" NOT USEFUL
  su postgres -c "/usr/lib/postgresql/9.3/bin/pg_ctl -D /var/lib/postgresql/9.3/main -o '-c config_file=/etc/postgresql/9.3/main/postgresql.conf' stop"
  sleep 10
fi
echo "Regular startup"
su postgres -c "/usr/lib/postgresql/9.3/bin/postgres -D /var/lib/postgresql/9.3/main -c config_file=/etc/postgresql/9.3/main/postgresql.conf"
