#!/bin/bash

if [ -z "$(ls -A "$PGDATA")" ]; then
  chown -R postgres "$PGDATA"

  /sbin/setuser postgres initdb

  sed -ri "s/^#(listen_addresses\s*=\s*)\S+/\1'*'/" "$PGDATA"/postgresql.conf

  { echo; echo 'host all all 0.0.0.0/0 trust'; } >> "$PGDATA"/pg_hba.conf

  # setup tables
  /sbin/setuser postgres postgres &
  POSTGRES_PID=$!
  sleep 2
  psql -U postgres -d postgres -a -f /root/migrate-postgres-v1.sql
  sleep 2
  kill $POSTGRES_PID
fi

exec /sbin/setuser postgres postgres >>/var/log/postgres.log 2>> /var/log/postgres-err.log
