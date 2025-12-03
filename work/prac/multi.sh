#!/bin/bash
# read 명령어로 한 줄을 입력받아 변수 3개에 나누어 담습니다.
# 쉘 확장이 일어나지 않고 문자 그대로 입력됩니다.
read num1 op num2

if [ "$op" == "*" ]; then
    result=$((num1 * num2))
    echo "결과: $result"
    
else
    echo "지원하지 않는 연산자이거나 형식이 잘못되었습니다."
    exit 1
fi
exit 0
