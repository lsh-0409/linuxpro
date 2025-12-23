#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <data_file>"
    exit 1
fi

# 1. 헤더 출력
printf "%-6s %3s %4s %5s %4s %4s\n" "" "mid" "quiz" "final" "sum" "avg"
echo "      -----------------------------"

# 2. 변수 초기화
total_mid=0; total_quiz=0; total_final=0; total_sum=0; total_avg=0
max_mid=0; max_quiz=0; max_final=0; max_sum=0; max_avg=0

# [추가] 최소값 변수 초기화 (시험 점수 만점인 100으로 설정)
# 100보다 작은 점수가 들어오면 그 값으로 갱신됨
min_mid=100; min_quiz=100; min_final=100; min_sum=1000; min_avg=100

count=0

# 3. 파일 읽기
while IFS=':' read -r mid quiz final
do
    # 3-1. 합계 및 평균 계산
    sum=$((mid + quiz + final))
    avg=$((sum / 3))

    # 3-2. 데이터 출력
    printf "%-6s %3d %4d %5d %4d %4d\n" "" "$mid" "$quiz" "$final" "$sum" "$avg"
    
    # 3-3. 누적 합계
    ((total_mid += mid)); ((total_quiz += quiz))
    ((total_final += final)); ((total_sum += sum)); ((total_avg += avg))

    # 3-4. Max 갱신
    if (( mid > max_mid )); then max_mid=$mid; fi
    if (( quiz > max_quiz )); then max_quiz=$quiz; fi
    if (( final > max_final )); then max_final=$final; fi
    if (( sum > max_sum )); then max_sum=$sum; fi
    if (( avg > max_avg )); then max_avg=$avg; fi

    # [추가] Min 갱신 로직 (현재 값이 min보다 작으면 교체)
    if (( mid < min_mid )); then min_mid=$mid; fi
    if (( quiz < min_quiz )); then min_quiz=$quiz; fi
    if (( final < min_final )); then min_final=$final; fi
    if (( sum < min_sum )); then min_sum=$sum; fi
    if (( avg < min_avg )); then min_avg=$avg; fi

    ((count++))

done < "$1"

# 4. 푸터 출력
echo "      -----------------------------"

# Total
printf "%-6s %3d %4d %5d %4d %4d\n" "Total" "$total_mid" "$total_quiz" "$total_final" "$total_sum" "$total_avg"

# Max
printf "%-6s %3d %4d %5d %4d %4d\n" "Max" "$max_mid" "$max_quiz" "$max_final" "$max_sum" "$max_avg"

# [추가] Min 출력 (Max 바로 아래)
printf "%-6s %3d %4d %5d %4d %4d\n" "Min" "$min_mid" "$min_quiz" "$min_final" "$min_sum" "$min_avg"

# Avg (전체 평균)
if [ $count -gt 0 ]; then
    class_avg_mid=$((total_mid / count))
    class_avg_quiz=$((total_quiz / count))
    class_avg_final=$((total_final / count))
    class_avg_sum=$((total_sum / count))
    class_avg_avg=$((total_avg / count))
    
    printf "%-6s %3d %4d %5d %4d %4d\n" "Avg" "$class_avg_mid" "$class_avg_quiz" "$class_avg_final" "$class_avg_sum" "$class_avg_avg"
fi
