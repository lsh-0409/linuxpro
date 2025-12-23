#!/bin/bash

# 와일드카드(*) 확장 비활성화
# set -f 명령을 미리 터미널에 입력
# 코드가 다 끝나면 set +f 명령 입력 

if [ $# -ne 3 ]; then
    echo "사용법: $(basename $0) 숫자 * 숫자"
    exit 1
fi

num1=$1
op=$2
num2=$3

if [ "$op" != "*" ]; then
    echo "연산자는 * 만 사용할 수 있습니다."
    exit 1
fi

result=$((num1 * num2))

echo "곱셈: $num1 * $num2 = $result"

