#!/bin/bash
aflag=0
bflag=0

if [[ $# -ne 1 ]]; then
	echo "Usage: $(basename $0) arg" >&2
	exit 1
fi
case $1 in
	-a) aflag=1
		;;
	-b) bflag=1
		;;
	*) echo "Usage: $(basename $0) [-a][-b]" >&2
	exit 1
esac
echo "aflag=$aflag, bflag=$bflag"
exit 0

