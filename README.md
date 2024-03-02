# logread
A tail -f wrapper in shell to read syslog messages

## Usage

    $ logread  -h
    Usage: logread [options]
    Options:
    -l <count>   Got only the last 'count' messages
    -e <pattern> Filter messages with a regexp
    -f           Follow log messages
    -h           Print this help message

The script has a compatibility with OpenWrt ubox /sbin/logread

## Copyright
Dirk Brenken <dev@brenken.org>
