#!/bin/bash
oper=$1
num1=$2
num2=$3
result=0

if [[ $# -ne 3 ]]; then
	echo "input: $(basename $0) [+][-][\*][/] num num " >&2
	exit 1
fi

case $oper in
	+) result=$(( num1 + num2 ));;
	-) result=$(( num1 - num2 ));;
	\*) result=$(( num1 * num2 ));;
	/) 
		if [[ $num2 -eq 0 ]]; then
			echo "error: not division " >&2
			exit 1
		fi
		result=$(( num1 / num2 ));;

	*) echo " input again, oper: [+][-][\*][/]" >&2
	exit 1
esac

echo "result: $result"
exit 0
