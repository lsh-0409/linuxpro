#!/bin/bash

# 1. 입력된 모든 인자($*)를 하나의 변수에 저장
# 예: ./multi.sh "10 * 10" -> expression="10 * 10"
# 예: ./multi.sh 10 "*" 10 -> expression="10 * 10"
expression=$*

# 2. 입력값이 없는 경우 예외 처리
if [ -z "$expression" ]; then
    echo "사용법: $0 \"10 * 10\""
    exit 1
fi

# 3. 산술 확장 $(( )) 기능을 이용하여 문자열 수식을 바로 계산
# [참고: 305-shell-scripts.pptx p.16 - (( 산술표현식 ))]
result=$(("expression"))

# 4. 결과 출력
echo "곱셈: "expression" = $result"
