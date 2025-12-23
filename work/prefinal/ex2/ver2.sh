#!/bin/bash

# ==============================================================================
# 1. 입력 인자 확인
# $# : 스크립트 실행 시 전달된 인자의 개수 (예: ./ex2.sh score.dat -> 1개)
# -ne : Not Equal (같지 않음). 인자가 1개가 아니면 오류 메시지 출력 후 종료.
# ==============================================================================
if [ $# -ne 1 ]; then
    echo "Usage: $0 <data_file>"
    exit 1
fi

# ==============================================================================
# 2. 헤더(제목 줄) 출력
# printf를 사용하여 열(Column)의 너비를 고정합니다.
# %-6s : 문자열을 왼쪽(-)으로 정렬하고 최소 6칸 확보 (라벨 들어갈 자리)
# %5s  : 문자열을 오른쪽으로 정렬하고 최소 5칸 확보
# ==============================================================================
printf "%-6s %5s %5s %6s %5s %5s %5s %5s\n" "" "mid" "quiz" "final" "sum" "avg" "max" "min"
echo "      ---------------------------------------------"

# ==============================================================================
# 3. 전역 변수 초기화
# ==============================================================================
# 누적 합계를 저장할 변수들 (0으로 초기화)
total_mid=0; total_quiz=0; total_final=0; total_sum=0; total_avg=0; total_max=0; total_min=0

# 전체 최고점(Max)을 저장할 변수들 (0으로 초기화 -> 더 큰 값이 나오면 교체)
max_mid=0; max_quiz=0; max_final=0; max_sum=0; max_avg=0; max_max=0; max_min=0

# [중요] 전체 최저점(Min)을 저장할 변수들 (100으로 초기화)
# -> 100점 만점이므로 가장 큰 값으로 시작해야, 나중에 작은 점수가 나왔을 때 교체됨.
# -> 만약 0으로 초기화하면 0보다 작은 점수는 없으므로 갱신되지 않음.
min_mid=100; min_quiz=100; min_final=100; min_sum=1000; min_avg=100; min_max=100; min_min=100

# 학생 수를 세기 위한 변수
count=0

# ==============================================================================
# 4. 파일 읽기 및 데이터 처리
# IFS=':' : 입력 데이터 구분자를 콜론(:)으로 지정 (예: 10:20:30)
# read -r : 한 줄씩 읽어서 mid, quiz, final 변수에 저장
# ==============================================================================
while IFS=':' read -r mid quiz final
do
    # ---------------------------------------------------
    # 4-1. [개인별] 합계 및 평균 계산
    # ---------------------------------------------------
    sum=$((mid + quiz + final))
    avg=$((sum / 3)) # 쉘 연산은 정수만 취급 (소수점 버림)

    # ---------------------------------------------------
    # 4-2. [개인별] 최고점(s_max) / 최저점(s_min) 찾기
    # ---------------------------------------------------
    # 일단 중간고사(mid)를 임시 최고/최저점으로 설정
    s_max=$mid
    s_min=$mid

    # 퀴즈 점수 비교
    if (( quiz > s_max )); then s_max=$quiz; fi
    if (( quiz < s_min )); then s_min=$quiz; fi

    # 기말 점수 비교
    if (( final > s_max )); then s_max=$final; fi
    if (( final < s_min )); then s_min=$final; fi

    # ---------------------------------------------------
    # 4-3. 데이터 한 줄 출력
    # %5d : 정수(Digit)를 5칸 너비에 맞춰 출력 (헤더와 줄 맞춤)
    # ---------------------------------------------------
    printf "%-6s %5d %5d %6d %5d %5d %5d %5d\n" "" "$mid" "$quiz" "$final" "$sum" "$avg" "$s_max" "$s_min"
    
    # ---------------------------------------------------
    # 4-4. [전체 통계] 누적 합계 계산 (+= 연산자)
    # ---------------------------------------------------
    ((total_mid += mid)); ((total_quiz += quiz)); ((total_final += final))
    ((total_sum += sum)); ((total_avg += avg))
    ((total_max += s_max)); ((total_min += s_min))

    # ---------------------------------------------------
    # 4-5. [전체 통계] Max(최고점) 갱신
    # ---------------------------------------------------
    if (( mid > max_mid )); then max_mid=$mid; fi
    if (( quiz > max_quiz )); then max_quiz=$quiz; fi
    if (( final > max_final )); then max_final=$final; fi
    if (( sum > max_sum )); then max_sum=$sum; fi
    if (( avg > max_avg )); then max_avg=$avg; fi
    if (( s_max > max_max )); then max_max=$s_max; fi
    if (( s_min > max_min )); then max_min=$s_min; fi

    # ---------------------------------------------------
    # 4-6. [전체 통계] Min(최저점) 갱신
    # ---------------------------------------------------
    if (( mid < min_mid )); then min_mid=$mid; fi
    if (( quiz < min_quiz )); then min_quiz=$quiz; fi
    if (( final < min_final )); then min_final=$final; fi
    if (( sum < min_sum )); then min_sum=$sum; fi
    if (( avg < min_avg )); then min_avg=$avg; fi
    if (( s_max < min_max )); then min_max=$s_max; fi
    if (( s_min < min_min )); then min_min=$s_min; fi

    # 처리한 학생 수 증가
    ((count++))

done < "$1" # while 루프의 입력을 첫 번째 인자 파일($1)로 설정

# ==============================================================================
# 5. 푸터(하단 결과) 출력
# ==============================================================================
echo "      ---------------------------------------------"

# (1) Total 행 출력
printf "%-6s %5d %5d %6d %5d %5d %5d %5d\n" "Total" "$total_mid" "$total_quiz" "$total_final" "$total_sum" "$total_avg" "$total_max" "$total_min"

# (2) Max 행 출력
printf "%-6s %5d %5d %6d %5d %5d %5d %5d\n" "Max" "$max_mid" "$max_quiz" "$max_final" "$max_sum" "$max_avg" "$max_max" "$max_min"

# (3) Min 행 출력
printf "%-6s %5d %5d %6d %5d %5d %5d %5d\n" "Min" "$min_mid" "$min_quiz" "$min_final" "$min_sum" "$min_avg" "$min_max" "$min_min"

# (4) Avg 행 출력
# count가 0일 때 나누기 에러 방지
if [ $count -gt 0 ]; then
    # 각 항목의 합계(Total)를 학생 수(count)로 나눔
    avg_mid=$((total_mid / count))
    avg_quiz=$((total_quiz / count))
    avg_final=$((total_final / count))
    avg_sum=$((total_sum / count))
    avg_avg=$((total_avg / count))
    avg_max=$((total_max / count))
    avg_min=$((total_min / count))
    
    printf "%-6s %5d %5d %6d %5d %5d %5d %5d\n" "Avg" "$avg_mid" "$avg_quiz" "$avg_final" "$avg_sum" "$avg_avg" "$avg_max" "$avg_min"
fi
