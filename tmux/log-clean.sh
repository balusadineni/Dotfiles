#!/bin/sh
# Strip ANSI escape codes and carriage returns before writing to log
perl -pe 's/\x1b\[[0-9;]*[a-zA-Z]//g; s/\r//g' >> "$1"
