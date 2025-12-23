#!/bin/bash
oper=$1
num1=$2
num2=$3
result=0


if [[ $# -ne 3 ]]; then 
	echo "입력: $(basename $0) [+][-][\*][/] 숫자 숫자 " >&2
	exit 1
fi

case $oper in
	+) result=$((num1 + num2)) ;;
	-) result=$((num1 - num2)) ;;
	\*) result=$((num1 * num2)) ;;
	/)
		if [[ $num2 -eq 0 ]]; then
			echo "0으로 나눌 수 없음 " >&2
			exit 1 
		fi 
		result=$((num1 / num2)) ;;
		
	*) echo "연산자 다시 입력: [+][-][\+][/] " >&2
	exit 1
esac

echo "계산결과: $result"
exit 0
