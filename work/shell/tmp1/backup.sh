#!/bin/bash

for fname in $( ls $1 ) ; do
	cp "$fname" "$2"/"$fname"
done
exit 0
