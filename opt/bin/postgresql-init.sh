#!/bin/sh

: "${svc_d:=/etc/systemd/system/postgresql.service.d}"
: "${db_d:=/srv/db}"

set -e -x
mkdir -p "$svc_d"

test "$(sysctl -n kernel.shmmax)" -ge 268435456 || sysctl kernel.shmmax=268435456 || true
test -e "$db_d" || install -d -o 1000 "$db_d"
test -e "$db_d/PG_VERSION" || chpst -u $(stat -L -c :%u:%g "$db_d") env LANG=en_US.utf8 $(find /opt/postgres/lib/postgresql -path "*/bin/initdb" | sort -nr | head -1) "$db_d"
PG_VERSION=$(cat "$db_d/PG_VERSION")

cat >"$svc_d/exec.conf" <<EOF
[Service]
Environment="PATH=/opt/postgres/lib/postgresql/$PG_VERSION/bin:$PATH"
User=$(stat -c %U "$db_d")
Group=$(stat -c %G "$db_d")
ExecStart=/opt/postgres/lib/postgresql/$PG_VERSION/bin/pg_ctl start -l '$db_d/postgres.log' -w -D '$db_d'
ExecStop=/opt/postgres/lib/postgresql/$PG_VERSION/bin/pg_ctl stop -D '$db_d'
ExecReload=/opt/postgres/lib/postgresql/$PG_VERSION/bin/pg_ctl reload -D '$db_d'
EOF

systemctl daemon-reload
