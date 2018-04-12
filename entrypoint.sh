#!/bin/bash

# https://coderwall.com/p/fkfaqq/safer-bash-scripts-with-set-euxo-pipefail
set -eo pipefail

echo "[Entrypoint] MySQL Docker Image 5.7.21"

# Fetch value from server config
# We use mysqld --verbose --help instead of my_print_defaults because the
# latter only show values present in config files, and not server defaults
function _get_config() {
	local conf="$1"; shift
	"$@" --verbose --help --log-bin-index="$(mktemp -u)" 2>/dev/null | awk '$1 == "'${conf}'" { print $2; exit }'
}

# If command starts with an option, prepend mysqld
# This allows users to add command-line options without needing to specify the "mysqld" command
if [ "${1:0:1}" = '-' ]; then
	set -- mysqld "$@"
fi

if [ "$1" = 'mysqld' ]; then

	# Get config
	DATADIR="$(_get_config 'datadir' "$@")"
	SOCKET="$(_get_config 'socket' "$@")"

	if [ ! -d "$DATADIR/mysql" ]; then

		if [ -z "$MYSQL_ROOT_PASSWORD" -a -z "$MYSQL_ALLOW_EMPTY_PASSWORD" -a -z "$MYSQL_RANDOM_ROOT_PASSWORD" ]; then
			echo >&2 '[Entrypoint] No password option specified for new database.'
			echo >&2 '[Entrypoint]   A random onetime password will be generated.'
			MYSQL_RANDOM_ROOT_PASSWORD=true
			MYSQL_ONETIME_PASSWORD=true
		fi

#		mkdir -p "$DATADIR"
#		chown -R mysql:mysql "$DATADIR"

#		echo '[Entrypoint] Initializing database'
#		"$@" --initialize-insecure
#		echo '[Entrypoint] Database initialized'

		if command -v mysql_ssl_rsa_setup > /dev/null && [ ! -e "${DATADIR}server-key.pem" ]; then
			echo '[Entrypoint] Initializing certificates'
			mysql_ssl_rsa_setup --datadir="${DATADIR}"
      chown mysql:mysql ${DATADIR}*.pem
			echo '[Entrypoint] Certificates initialized'
		fi

		"$@" --daemonize --skip-networking --socket="${SOCKET}"

		# Define the client command used throughout the script
		# "SET @@SESSION.SQL_LOG_BIN=0;" is required for products like group replication to work properly
		mysql=( mysql --protocol=socket --user=root --host=localhost --socket="${SOCKET}" --init-command="SET @@SESSION.SQL_LOG_BIN=0;" )

		for i in {30..0}; do
			if echo 'SELECT 1' | "${mysql[@]}" &> /dev/null; then
				break
			fi
			echo '[Entrypoint] Waiting for server...'
			sleep 1
		done

		if [ "$i" = 0 ]; then
			echo >&2 '[Entrypoint] Timeout during MySQL init.'
			exit 1
		fi

		if [ -z "$MYSQL_INITDB_SKIP_TZINFO" ]; then
			mysql_tzinfo_to_sql /usr/share/zoneinfo | "${mysql[@]}" mysql
		fi

		if [ ! -z "$MYSQL_RANDOM_ROOT_PASSWORD" ]; then
			export MYSQL_ROOT_PASSWORD="$(pwmake 128)"
			echo "[Entrypoint] GENERATED ROOT PASSWORD: ${MYSQL_ROOT_PASSWORD}"
		fi

		if [ -z "$MYSQL_ROOT_HOST" ]; then
			ROOTCREATE="ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
		fi

		if [ "$MYSQL_DATABASE" ]; then
			echo "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;" | "${mysql[@]}"
			mysql+=( "$MYSQL_DATABASE" )
		fi

		if [ "$MYSQL_USER" -a "$MYSQL_PASSWORD" ]; then
			echo "CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';" | "${mysql[@]}"
			if [ "$MYSQL_DATABASE" ]; then
				echo "GRANT ALL ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';" | "${mysql[@]}"
			fi
			echo 'FLUSH PRIVILEGES ;' | "${mysql[@]}"
		elif [ "$MYSQL_USER" -a ! "$MYSQL_PASSWORD" -o ! "$MYSQL_USER" -a "$MYSQL_PASSWORD" ]; then
			echo '[Entrypoint] Not creating mysql user. MYSQL_USER and MYSQL_PASSWORD must be specified to create a mysql user.'
		fi

		echo

		for f in /docker-entrypoint-initdb.d/*; do
			case "$f" in
				*.sh)     echo "[Entrypoint] running $f"; . "$f" ;;
				*.sql)    echo "[Entrypoint] running $f"; "${mysql[@]}" < "$f" && echo ;;
				*.sql.gz) echo "[Entrypoint] running $f"; gunzip -c "$f" | "${mysql[@]}" && echo ;;
				*)        echo "[Entrypoint] ignoring $f" ;;
			esac
			echo
		done

		if [ ! -z "$MYSQL_ONETIME_PASSWORD" ]; then
			echo "[Entrypoint] Setting root user as expired. Password will need to be changed before database can be used."
			echo "ALTER USER 'root'@'localhost' PASSWORD EXPIRE;" | "${mysql[@]}"
			if [ ! -z "$MYSQL_ROOT_HOST" ]; then
				echo "ALTER USER 'root'@'${MYSQL_ROOT_HOST}' PASSWORD EXPIRE;" | "${mysql[@]}"
			fi
		fi

		echo '[Entrypoint] MySQL init process done. Ready for start up.'
	fi
	echo "[Entrypoint] Starting MySQL 5.7.21"
fi

exec "$@"
