#!/bin/sh
# Shell script compatibility wrapper for /sbin/logread
#
# Copyright (C) 2019 Dirk Brenken <dev@brenken.org>
# SPDX-License-Identifier: GPL-2.0-or-later

count=
pattern=
follow=
help=

while getopts "l:e:fh" OPTION
do
	case $OPTION in
		l) count=$OPTARG;;
		e) pattern=$OPTARG;;
		f) follow="-f";;
		h) help=1;;
		*) echo "Unsupported option $OPTION"
		usage;;
	esac
done

logfile="/var/log/messages"

if [ ! -f "${logfile}" ]
then
	echo "Error: logfile not found!"
	exit 2
fi

usage()
{
	echo "Usage: logread [options]"
	echo "Options:"
	echo " -l <count>   Got only the last 'count' messages"
	echo " -e <pattern> Filter messages with a regexp"
	echo " -f           Follow log messages"
	echo " -h           Print this help message"
	exit 1
}

[ -n "$help" ] && usage

# if no count and follow then print from beginning
[ -z "$count$follow" ] && count="+1"
# if no count but follow then print only new lines
[ -z "$count" ] && count="0"

# shellcheck disable=SC2086
if [ -z "$pattern" ]; then
	echo tail -n "$count" $follow "$logfile"
	busybox tail -n "$count" $follow "$logfile"
else
	echo tail -n "$count" $follow "$logfile" | grep -E "$pattern"
	busybox tail -n "$count" $follow "$logfile" | grep -E "$pattern"
fi
