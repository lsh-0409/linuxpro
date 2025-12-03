#!/bin/bash

# 1. 헤더 출력
echo "mid quiz final  sum"
echo "-------------------"

# 2. 전체 합계 변수 초기화
total_mid=0
total_quiz=0
total_final=0
total_sum=0

# 3. 파일 읽기 (IFS를 :로 설정하여 분리)
# score.dat 파일이 $1 인자로 들어온다고 가정 (./ex2.sh score.dat)
while IFS=':' read -r mid quiz final
do
    # 각 줄의 합계 계산
    sum=$((mid + quiz + final))
    
    # 결과 출력 (printf로 줄 맞춤)
    printf "%3d %4d %5d %4d\n" "$mid" "$quiz" "$final" "$sum"
    
    # 전체 합계 누적
    ((total_mid += mid))
    ((total_quiz += quiz))
    ((total_final += final))
    ((total_sum += sum))
done < "$1"

# 4. 푸터(전체 합계) 출력
echo "-------------------"
printf "%3d %4d %5d %4d\n" "$total_mid" "$total_quiz" "$total_final" "$total_sum"
