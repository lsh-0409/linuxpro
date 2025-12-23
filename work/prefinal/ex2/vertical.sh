#!/bin/bash

# 1. 입력 인자 확인
# $# : 스크립트 실행 시 뒤따라오는 인자의 개수
# 인자가 1개가 아니면(-ne 1) 사용법을 출력하고 종료
if [ $# -ne 1 ]; then
    echo "Usage: $0 <data_file>"
    exit 1
fi

# 2. 헤더(제목 줄) 출력
# %-6s : 문자열을 왼쪽 정렬(-)하여 최소 6칸 확보 (라벨 들어갈 공간 비워두기)
# %3s, %4s : 각 항목(mid, quiz...)을 해당 칸 수만큼 오른쪽 정렬로 출력
printf "%-6s %3s %4s %5s %4s %4s\n" "" "mid" "quiz" "final" "sum" "avg"
echo "      -----------------------------"

# 3. 변수 초기화
# 누적 합계(Total)를 저장할 변수들
total_mid=0; total_quiz=0; total_final=0; total_sum=0; total_avg=0
# 최댓값(Max)을 저장할 변수들
max_mid=0; max_quiz=0; max_final=0; max_sum=0; max_avg=0
# 학생 수를 세기 위한 카운터 변수
count=0

# 4. 파일 읽기 (한 줄씩 반복)
# IFS=':' : 입력 데이터가 콜론(:)으로 구분되어 있으므로 구분자 설정
# read -r : 백슬래시(\)를 해석하지 않고 그대로 읽음
while IFS=':' read -r mid quiz final
do
    # 4-1. 개인별 합계 및 평균 계산
    # $(( )) : 쉘에서의 산술 연산 문법
    sum=$((mid + quiz + final))
    avg=$((sum / 3))  # 정수 나눗셈 (소수점은 자동 버림)

    # 4-2. 데이터 출력
    # 계산된 값들을 포맷에 맞춰 한 줄에 출력
    printf "%-6s %3d %4d %5d %4d %4d\n" "" "$mid" "$quiz" "$final" "$sum" "$avg"
    
    # 4-3. [Total] 누적 합계 계산
    # += 연산자로 기존 값에 현재 줄의 값을 더함
    ((total_mid += mid))
    ((total_quiz += quiz))
    ((total_final += final))
    ((total_sum += sum))
    ((total_avg += avg))

    # 4-4. [Max] 최고점 갱신 로직
    # 현재 점수가 저장된 max값보다 크면, max값을 현재 점수로 교체
    if (( mid > max_mid )); then max_mid=$mid; fi
    if (( quiz > max_quiz )); then max_quiz=$quiz; fi
    if (( final > max_final )); then max_final=$final; fi
    if (( sum > max_sum )); then max_sum=$sum; fi
    if (( avg > max_avg )); then max_avg=$avg; fi

    # 학생 수 1 증가
    ((count++))

done < "$1"  # while 루프의 입력으로 첫 번째 인자($1, 즉 score.dat)를 사용

# 5. 푸터(하단 결과) 출력
echo "      -----------------------------"

# (1) Total 출력
# 맨 앞의 %-6s 자리에 "Total" 문자열을 출력하여 라벨 표시
printf "%-6s %3d %4d %5d %4d %4d\n" "Total" "$total_mid" "$total_quiz" "$total_final" "$total_sum" "$total_avg"

# (2) Max 출력
printf "%-6s %3d %4d %5d %4d %4d\n" "Max" "$max_mid" "$max_quiz" "$max_final" "$max_sum" "$max_avg"

# (3) Avg (전체 평균) 출력
# 학생 수가 0명일 경우 0으로 나누는 에러를 방지하기 위해 if문 사용
if [ $count -gt 0 ]; then
    # 각 과목의 총합(Total)을 학생 수(count)로 나누어 전체 평균 계산
    class_avg_mid=$((total_mid / count))
    class_avg_quiz=$((total_quiz / count))
    class_avg_final=$((total_final / count))
    class_avg_sum=$((total_sum / count))
    class_avg_avg=$((total_avg / count))
    
    printf "%-6s %3d %4d %5d %4d %4d\n" "Avg" "$class_avg_mid" "$class_avg_quiz" "$class_avg_final" "$class_avg_sum" "$class_avg_avg"
fi
