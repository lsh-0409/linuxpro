#!/bin/bash

# 입력 파일명
input_file=$1

# 결과를 저장할 변수들 초기화
mid_sum=0
quiz_sum=0
final_sum=0
total_sum=0

# 구분선 출력 함수
print_line() {
    printf "%s\n" "--------------------------------"
}

# 헤더 출력
printf "%-8s %-8s %-8s %-8s\n" "mid" "quiz" "final" "sum"
print_line

# 파일 읽기 및 처리
while IFS=':' read -r mid quiz final; do
    # 각 점수 추출
    mid_score=$mid
    quiz_score=$quiz
    final_score=$final

    # 행의 합계 계산
    row_sum=$((mid_score + quiz_score + final_score))

    # 열의 합계 누적
    mid_sum=$((mid_sum + mid_score))
    quiz_sum=$((quiz_sum + quiz_score))
    final_sum=$((final_sum + final_score))
    total_sum=$((total_sum + row_sum))

    # 각 행의 결과 출력
    printf "%-8d %-8d %-8d %-8d\n" "$mid_score" "$quiz_score" "$final_score" "$row_sum"
done < "$input_file"

# 구분선 출력
print_line

# 총합 출력
printf "%-8d %-8d %-8d %-8d\n" "$mid_sum" "$quiz_sum" "$final_sum" "$total_sum"