#!/bin/sh

which psql > /dev/null || {
  for _d in $(echo /opt/postgres/lib/postgresql/*/bin | tr ' ' '\n' | sort -nr);do
    test ! -x "$_d/psql" -a ! -x "$_d/postgres" || {
      case "$PATH" in
        *:$_d|$_d:*|*:$_d:*) ;;
        *) export PATH="$PATH:$_d" ;;
      esac
    }
  done
}
