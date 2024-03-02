#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-only
# Copyright (C) 2019 Dirk Brenken <dev@brenken.org>
# A tail -f wrapper in shell to read syslog messages

logfile="/var/log/messages"

if [ ! -f "${logfile}" ]
then
	printf "%s\n" "Error: logfile not found!"
	exit 2
fi

usage()
{
	printf "%s\n" "Usage: logread [options]"
	printf "%s\n" "Options:"
	printf "%5s %-10s%s\n" "-l" "<count>" "Got only the last 'count' messages"
	printf "%5s %-10s%s\n" "-e" "<pattern>" "Filter messages with a regexp"
	printf "%5s %-10s%s\n" "-f" "" "Follow log messages"
	printf "%5s %-10s%s\n" "-h" "" "Print this help message"
}

if [ -z "${1}" ]
then
	cat "${logfile}"
	exit 0
else
	while [ "${1}" ]
	do
		case "${1}" in
			-l)
				shift
				count="${1//[^0-9]/}"
				tail -n "${count:-50}" "${logfile}"
				exit 0
				;;
			-e)
				shift
				pattern="${1}"
				grep -E "${pattern}" "${logfile}"
				exit 0
				;;
			-f)
				tail -f "${logfile}"
				exit 0
				;;
			-fe)
				shift
				pattern="${1}"
				tail -f "${logfile}" | grep -E "${pattern}"
				exit 0
				;;
			-h|*)
				usage
				exit 1
				;;
		esac
		shift
	done
fi
