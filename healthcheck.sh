#!/bin/bash

# This code is in reference to the following official image.
# https://github.com/mysql/mysql-docker/blob/mysql-server/5.7/healthcheck.sh
# https://github.com/docker-library/healthcheck/blob/master/mysql/docker-healthcheck

if select="$(echo 'SELECT 1' | mysql "${args[@]}")" && [ "$select" = '1' ]; then
	exit 0
fi

exit 1
