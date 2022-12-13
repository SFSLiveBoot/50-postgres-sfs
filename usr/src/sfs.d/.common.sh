#!/bin/sh

: ${lbu:=/opt/LiveBootUtils}
. "$lbu/scripts/common.func"

: "${PGVER:=15}"
: "${dist:=$(lsb_release -cs)}"
: "${deb_arch:=$(dpkg --print-architecture)}"

: "${repo_url:=http://apt.postgresql.org/pub/repos/apt}"
: "${packages_url:=$repo_url/dists/${dist}-pgdg/main/binary-$deb_arch/Packages}"

: ${pg_pkgs:=postgresql-contrib-$PGVER libpq5 postgresql-client-$PGVER postgresql-$PGVER postgresql-server-dev-$PGVER postgresql-plpython3-$PGVER}

latest_version() {
  grep -e "^Package: postgresql-$PGVER\$" -e Version "$(dl_file "$packages_url")" |
    grep -A1 ^Package | grep ^Version | tr - " " | cut -f2 -d" "
}

current_version() {
  "$DESTDIR/opt/postgres/lib/postgresql/$PGVER/bin/postgres" --version | grep -o "\<$PGVER.*"
}
