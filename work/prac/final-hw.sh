#!/bin/bash

# 1. 인자 확인
if [ $# -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

BASE_DIR="$1"
CONTENTS_FILE="$BASE_DIR/contents.dir"

# 파일 존재 확인
if [ ! -f "$CONTENTS_FILE" ]; then
    echo "Error: contents.dir not found in $BASE_DIR"
    exit 1
fi

# 천 단위 콤마 설정을 위한 로케일 지정 (필수)
export LC_NUMERIC=en_US.UTF-8

# 전역 변수 초기화
total_dirs=0
total_files=0
target_dirs_list=""

# =========================================================
# 함수 정의: 파일 리스트 출력
# =========================================================
function print_file_list {
    local target_dir="$1"

    for file in "$target_dir"/*
    do
        if [ -f "$file" ]; then
            local fname=$(basename "$file")
            # ls -l의 5번째 필드(파일 크기) 가져오기
            local fsize=$(ls -l "$file" | awk '{print $5}')
            
            # [수정 1] 상세 리스트 정렬 너비 재계산
            # Lecture(16) + 공백(1) + Directory(15) + 공백(1) + Files(5) = 43칸
            # 파일명을 43칸으로 설정하여 Files 컬럼 끝라인에 맞춤
            printf "%38s %'15d\n" "$fname" "$fsize"
        fi
    done
}

# =========================================================
# 메인 로직
# =========================================================

# 헤더 출력
echo "------------------------------------------------------"
echo "               Disk Usages per Lecture                        "
echo "------------------------------------------------------"
# [수정 2] Lecture 너비를 20 -> 16으로 줄임 (4칸 축소)
printf "%-16s %-15s %5s %15s\n" "Lecture" "Directory" "Files" "Used"
echo "------------------------------------------------------"

# contents.dir 파일 읽기
while IFS=':' read -r lecture_name dir_name
do
    target_path="$BASE_DIR/$dir_name"
    
    if [ -d "$target_path" ]; then
        # 1. 파일 개수
        f_count=$(ls -1 "$target_path" | wc -l)
        
        # 2. 디렉터리 용량
        usage=$(du -sh "$target_path" | awk '{print $1}')
        
        # [수정 3] 데이터 출력 포맷도 헤더와 동일하게 16으로 변경
        printf "%-16s %-15s %5d %15s\n" "$lecture_name" "$dir_name" "$f_count" "$usage"
        
        # 4. 상세 파일 리스트 출력 함수 호출
        print_file_list "$target_path"
        
        # 5. Total 집계를 위한 누적
        ((total_dirs++))
        ((total_files += f_count))
        target_dirs_list="$target_dirs_list $target_path"
    fi
done < "$CONTENTS_FILE"

# =========================================================
# 하단 Total 출력
# =========================================================
echo "------------------------------------------------------"

# [수정 4] 5.00M 형식으로 출력하기 위한 계산 로직 변경
if [ -n "$target_dirs_list" ]; then
    # 1) du -ck로 킬로바이트(KB) 단위 합계를 구함
    total_kb=$(du -ck $target_dirs_list 2>/dev/null | tail -1 | awk '{print $1}')
    
    # 2) awk를 사용하여 MB로 변환하고 소수점 2자리까지 강제 포맷팅 (%.2fM)
    total_usage=$(awk -v kb="$total_kb" 'BEGIN {printf "%.2fM", kb/1024}')
else
    total_usage="0.00M"
fi

# [수정 5] Total 라인 포맷 (Lecture 부분 16으로 맞춤)
printf "%-16s %-15d %5d %15s\n" "Total :" "$total_dirs" "$total_files" "$total_usage"
echo "------------------------------------------------------"

exit 0
