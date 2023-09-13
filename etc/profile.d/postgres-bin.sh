#!/bin/sh

which psql > /dev/null || {
  for _pg_dir in $(find /opt/postgres/lib/postgresql -maxdepth 2 -name bin | sort -V | tac);do
    test ! -x "$_pg_dir/psql" -a ! -x "$_pg_dir/postgres" || {
      case ":$PATH:" in
        *:"$_pg_dir":*) ;;
        *) export PATH="$PATH:$_pg_dir" ;;
      esac
    }
  done
  for _pg_dir in $(find /opt/postgres/share/postgresql -maxdepth 2 -name man | sort -V | tac);do
    test ! -e "$_pg_dir/man1/psql.1.gz" || {
      case ":$MANPATH:" in
        *:"$_pg_dir":*) ;;
        *) export MANPATH="${MANPATH:-:}:$_pg_dir" ;;
      esac
    }
  done
  unset _pg_dir
}
