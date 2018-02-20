#!/bin/sh

for sql;do
  test -r "$sql" || continue
  test ! -d "$sql" || {
    find "$sql/" -name "*.sql" -exec "$0" {} +
    continue
  }
  dbn="$(basename "$sql" .sql)"
  psql -A -t -c "select 'yes' from pg_database where datname='$dbn'" postgres | grep -q yes || {
    dbo="$(stat -c %U "$sql")"
    psql -A -t -c "select 'yes' from pg_user where usename='$dbo'" postgres | grep -q yes || {
      psql postgres -c "create role \"$dbo\" login"
    }
    psql -c "create database \"$dbn\" owner \"$dbo\"" postgres
    psql -U "$dbo" "$dbn" < "$sql"
  }
done
