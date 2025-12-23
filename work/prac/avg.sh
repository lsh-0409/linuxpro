#!/bin/bash

# 1. 인자 확인
if [ $# -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

BASE_DIR="$1"
CONTENTS_FILE="$BASE_DIR/contents.dir"

if [ ! -f "$CONTENTS_FILE" ]; then
    echo "Error: contents.dir not found in $BASE_DIR"
    exit 1
fi

export LC_NUMERIC=en_US.UTF-8

# 전역 변수 초기화
total_dirs=0
total_files=0
target_dirs_list=""

# 통계 변수들
max_fsize=0
max_fname=""
min_fsize=100000000000
min_fname=""

# [추가] 평균 계산을 위한 전체 바이트 합계 변수
total_bytes=0

# =========================================================
# 함수 정의
# =========================================================
function print_file_list {
    local target_dir="$1"

    for file in "$target_dir"/*
    do
        if [ -f "$file" ]; then
            local fname=$(basename "$file")
            local fsize=$(ls -l "$file" | awk '{print $5}')
            
            # [Max 갱신]
            if (( fsize > max_fsize )); then
                max_fsize=$fsize
                max_fname=$fname
            fi

            # [Min 갱신]
            if (( fsize < min_fsize )); then
                min_fsize=$fsize
                min_fname=$fname
            fi
            
            # [추가] 전체 용량 누적 (byte 단위)
            ((total_bytes += fsize))

            printf "%38s %'15d\n" "$fname" "$fsize"
        fi
    done
}

# =========================================================
# 메인 로직
# =========================================================

echo "------------------------------------------------------"
echo "               Disk Usages per Lecture                        "
echo "------------------------------------------------------"
printf "%-16s %-15s %5s %15s\n" "Lecture" "Directory" "Files" "Used"
echo "------------------------------------------------------"

while IFS=':' read -r lecture_name dir_name
do
    target_path="$BASE_DIR/$dir_name"
    if [ -d "$target_path" ]; then
        f_count=$(ls -1 "$target_path" | wc -l)
        usage=$(du -sh "$target_path" | awk '{print $1}')
        printf "%-16s %-15s %5d %15s\n" "$lecture_name" "$dir_name" "$f_count" "$usage"
        
        print_file_list "$target_path"
        
        ((total_dirs++))
        ((total_files += f_count))
        target_dirs_list="$target_dirs_list $target_path"
    fi
done < "$CONTENTS_FILE"

# =========================================================
# 하단 결과 출력
# =========================================================
echo "------------------------------------------------------"

if [ -n "$target_dirs_list" ]; then
    total_kb=$(du -ck $target_dirs_list 2>/dev/null | tail -1 | awk '{print $1}')
    total_usage=$(awk -v kb="$total_kb" 'BEGIN {printf "%.2fM", kb/1024}')
else
    total_usage="0.00M"
fi

printf "%-16s %-15d %5d %15s\n" "Total :" "$total_dirs" "$total_files" "$total_usage"
echo "------------------------------------------------------"

# [최대]
printf "%-16s  %-20s %'16d\n" "파일크기 최대 :" "$max_fname" "$max_fsize"

# [최소]
printf "%-16s  %-20s %'15d\n" "파일크기 최소 :" "$min_fname" "$min_fsize"

# [추가] 평균 출력 (총 바이트 / 총 파일 수)
if [ $total_files -gt 0 ]; then
    avg_fsize=$((total_bytes / total_files))
    printf "%-16s  %-20s %'16d\n" "파일크기 평균 :" "" "$avg_fsize"
fi

echo "------------------------------------------------------"

exit 0
