#!/bin/bash

# 입력 예시: id와 active 사이에 있는 no의 값(15)을 원함
query="id=admin&no=15&active=true"

# 1. 앞부분 쓰레기 제거 ('no=' 앞쪽 다 날리기)
# #   : 앞에서부터 제거
# *no=: "id=admin&no=" 까지의 패턴과 일치
temp=${query#*no=}
# 결과 temp: "15&active=true" (이제 숫자 15가 맨 앞에 옴)

# 2. 뒷부분 쓰레기 제거 (혹시 뒤에 이어지는 파라미터가 있다면 날리기)
# %%  : 뒤에서부터 "가장 길게" 제거 (뒤에 &가 여러 개일 수 있으므로 %% 권장)
# &* : "&active=true" 부분과 일치
value=${temp%%&*}
# 결과 value: "15" (뒤에 &가 없으면 원본 그대로 유지됨, 즉 안전함)

echo "Extracted Value : $value"
