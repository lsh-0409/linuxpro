#!/bin/bash

for i; do
	if [[ ! -d "$i" ]]; then
		echo "$i is not a directory" >&2
		exit 1
	fi
	for f in `ls $i`; do
		file $i/$f | grep "ASCII\|script"
	done
done

exit 0
