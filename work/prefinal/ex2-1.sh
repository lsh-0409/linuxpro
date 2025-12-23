#!/bin/bash

# 1. 헤더 출력
echo "mid quiz final  sum"
echo "-------------------"

# 2. 변수 초기화
# 합계 변수
total_mid=0
total_quiz=0
total_final=0
total_sum=0

# 최고점 변수 (0으로 초기화)
max_mid=0
max_quiz=0
max_final=0
max_sum=0

# 행 개수 카운트 (평균 계산용)
count=0

# 3. 파일 읽기
if [ $# -ne 1 ]; then
    echo "Usage: $0 <data_file>"
    exit 1
fi

while IFS=':' read -r mid quiz final
do
    # 3-1. 각 줄의 합계 계산
    sum=$((mid + quiz + final))
    
    # 3-2. 결과 출력
    printf "%3d %4d %5d %4d\n" "$mid" "$quiz" "$final" "$sum"
    
    # 3-3. 전체 합계 누적
    ((total_mid += mid))
    ((total_quiz += quiz))
    ((total_final += final))
    ((total_sum += sum))

    # 3-4. 최고점 갱신 로직 (if문 사용)
    if (( mid > max_mid )); then max_mid=$mid; fi
    if (( quiz > max_quiz )); then max_quiz=$quiz; fi
    if (( final > max_final )); then max_final=$final; fi
    if (( sum > max_sum )); then max_sum=$sum; fi

    # 3-5. 카운트 증가
    ((count++))

done < "$1"

# 4. 푸터 출력
echo "-------------------"

# (1) Total (총점) 출력
printf "%3d %4d %5d %4d\n" "$total_mid" "$total_quiz" "$total_final" "$total_sum"

# (2) Max (최고점) 출력
printf "%3d %4d %5d %4d\n" "$max_mid" "$max_quiz" "$max_final" "$max_sum"

# (3) Avg (평균) 계산 및 출력
# 0으로 나누기 방지 (데이터가 있을 때만 계산)
if [ $count -gt 0 ]; then
    avg_mid=$((total_mid / count))
    avg_quiz=$((total_quiz / count))
    avg_final=$((total_final / count))
    avg_sum=$((total_sum / count))
    
    printf "%3d %4d %5d %4d\n" "$avg_mid" "$avg_quiz" "$avg_final" "$avg_sum"
fi
