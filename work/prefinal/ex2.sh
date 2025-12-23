#!/bin/bash

# 1. 헤더 출력
# 왼쪽에 6칸("%-6s")의 공백을 두어 라벨 들어갈 자리를 확보합니다.
printf "%-6s %3s %4s %5s %4s\n" "" "mid" "quiz" "final" "sum"
echo "       -------------------"

# 2. 변수 초기화
total_mid=0; total_quiz=0; total_final=0; total_sum=0

#Max 초기화 
max_mid=0; max_quiz=0; max_final=0; max_sum=0

# Min 초기화 (100점 만점 기준)
min_mid=100; min_quiz=100; min_final=100; min_sum=1000

count=0

# 3. 파일 읽기
if [ $# -ne 1 ]; then
    echo "Usage: $0 <data_file>"
    exit 1
fi

while IFS=':' read -r mid quiz final
do
    # 3-1. 합계 계산
    sum=$((mid + quiz + final))
    
    # 3-2. 결과 출력
    # 데이터 줄에도 맨 앞에 빈 문자열("")을 넣어 헤더와 줄을 맞춥니다.
    printf "%-6s %3d %4d %5d %4d\n" "" "$mid" "$quiz" "$final" "$sum"
    
    # 3-3. 누적 합계 (Total)
    ((total_mid += mid)); ((total_quiz += quiz))
    ((total_final += final)); ((total_sum += sum))

    # 3-4. 최고점 갱신
    if (( mid > max_mid )); then max_mid=$mid; fi
    if (( quiz > max_quiz )); then max_quiz=$quiz; fi
    if (( final > max_final )); then max_final=$final; fi
    if (( sum > max_sum )); then max_sum=$sum; fi

    # 4-5. Min 갱신
    if (( mid < min_mid )); then min_mid=$mid; fi
    if (( quiz < min_quiz )); then min_quiz=$quiz; fi
    if (( final < min_final )); then min_final=$final; fi
    if (( sum < min_sum )); then min_sum=$sum; fi

    ((count++))

done < "$1"

# 4. 푸터 출력
echo "       -------------------"

# (1) Total 출력 (라벨 "Total"을 왼쪽에 배치)
printf "%-6s %3d %4d %5d %4d\n" "Total" "$total_mid" "$total_quiz" "$total_final" "$total_sum"

# (2) Max 출력
printf "%-6s %3d %4d %5d %4d\n" "Max" "$max_mid" "$max_quiz" "$max_final" "$max_sum"

# (3) Min
printf "%-6s %3d %4d %5d %4d\n" "Min" "$min_mid" "$min_quiz" "$min_final" "$min_sum"

# (3) Avg 출력
if [ $count -gt 0 ]; then
    avg_mid=$((total_mid / count))
    avg_quiz=$((total_quiz / count))
    avg_final=$((total_final / count))
    avg_sum=$((total_sum / count))
    
    printf "%-6s %3d %4d %5d %4d\n" "Avg" "$avg_mid" "$avg_quiz" "$avg_final" "$avg_sum"
fi
