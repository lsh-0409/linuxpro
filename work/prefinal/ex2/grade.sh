#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <data_file>"
    exit 1
fi

# [변경] 헤더에 "Gr"(Grade) 열 추가
printf "%-6s %3s %4s %5s %4s %4s\n" "" "mid" "quiz" "final" "sum" "Gr"
echo "      ------------------------"

total_mid=0; total_quiz=0; total_final=0; total_sum=0
max_mid=0; max_quiz=0; max_final=0; max_sum=0
count=0

while IFS=':' read -r mid quiz final
do
    sum=$((mid + quiz + final))
    
    # [추가] 개인별 평균 계산 및 학점 판정
    avg=$((sum / 3))
    if (( avg >= 90 )); then grade="A"
    elif (( avg >= 80 )); then grade="B"
    elif (( avg >= 70 )); then grade="C"
    else grade="F"
    fi

    # [변경] 맨 끝에 학점($grade) 출력 추가
    printf "%-6s %3d %4d %5d %4d %4s\n" "" "$mid" "$quiz" "$final" "$sum" "$grade"
    
    ((total_mid += mid)); ((total_quiz += quiz))
    ((total_final += final)); ((total_sum += sum))

    if (( mid > max_mid )); then max_mid=$mid; fi
    if (( quiz > max_quiz )); then max_quiz=$quiz; fi
    if (( final > max_final )); then max_final=$final; fi
    if (( sum > max_sum )); then max_sum=$sum; fi

    ((count++))
done < "$1"

# 푸터 출력 (기존과 동일)
echo "      ------------------------"
printf "%-6s %3d %4d %5d %4d\n" "Total" "$total_mid" "$total_quiz" "$total_final" "$total_sum"
printf "%-6s %3d %4d %5d %4d\n" "Max" "$max_mid" "$max_quiz" "$max_final" "$max_sum"

if [ $count -gt 0 ]; then
    avg_mid=$((total_mid / count))
    avg_quiz=$((total_quiz / count))
    avg_final=$((total_final / count))
    avg_sum=$((total_sum / count))
    printf "%-6s %3d %4d %5d %4d\n" "Avg" "$avg_mid" "$avg_quiz" "$avg_final" "$avg_sum"
fi
