#!/bin/bash

# =========================================================
# 1. 초기 설정 및 예외 처리
# =========================================================

# 스크립트 실행 시 인자(디렉토리 이름)가 1개가 아니면 사용법 출력 후 종료
if [ $# -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

BASE_DIR="$1"
CONTENTS_FILE="$BASE_DIR/contents.dir"

# contents.dir 파일이 존재하는지 확인
if [ ! -f "$CONTENTS_FILE" ]; then
    echo "Error: contents.dir not found in $BASE_DIR"
    exit 1
fi

# 숫자에 3자리마다 콤마(,)를 찍기 위해 로케일 설정 (printf 사용 시 필요)
export LC_NUMERIC=en_US.UTF-8

# 전체 요약(Total)을 위한 전역 변수
total_dirs_count=0      # 처리한 강의 디렉토리 총 개수
total_items_count=0     # 전체 파일 개수 합계
target_dirs_list=""     # 나중에 전체 용량을 한 번에 계산하기 위한 경로 리스트

# =========================================================
# [통계 변수 분리] - 파일과 디렉토리를 따로 계산
# =========================================================

# A. [파일용 통계 변수] (각 폴더 내부에 있는 개별 파일들 대상)
file_max_size=0
file_max_name=""
file_min_size=100000000000  # 최소값 비교를 위해 아주 큰 수로 초기화
file_min_name=""
file_sum_bytes=0            # 파일 크기 누적 합계 (평균 계산용)
file_count=0                # 파일 개수 (평균 계산용)

# B. [디렉토리용 통계 변수] (강의 디렉토리 자체 대상: shell, make 등)
dir_max_size=0
dir_max_name=""
dir_min_size=100000000000   # 최소값 비교를 위해 아주 큰 수로 초기화
dir_min_name=""
dir_sum_bytes=0             # 디렉토리 크기 누적 합계 (평균 계산용)
dir_count=0                 # 디렉토리 개수 (평균 계산용)

# =========================================================
# 함수 정의: 내부 파일 리스트 출력 및 파일 통계 집계
# =========================================================
function print_file_list {
    local target_dir="$1"

    # 해당 디렉토리 안의 모든 항목 중 '파일'만 골라서 순회
    for entry in "$target_dir"/*
    do
        if [ -f "$entry" ]; then
            local fname=$(basename "$entry")
            
            # ls -l의 5번째 필드(파일 크기 Byte) 추출
            local fsize=$(ls -l "$entry" | awk '{print $5}')
            
            # ---------------------------------
            # [파일 통계 업데이트 로직]
            # ---------------------------------
            ((file_sum_bytes += fsize))  # 전체 합계에 더하기
            ((file_count++))             # 파일 개수 증가

            # 파일 최대값(Max) 갱신 확인
            if (( fsize > file_max_size )); then
                file_max_size=$fsize
                file_max_name=$fname
            fi
            # 파일 최소값(Min) 갱신 확인
            if (( fsize < file_min_size )); then
                file_min_size=$fsize
                file_min_name=$fname
            fi

            # 개별 파일 정보 출력 (이름과 크기)
            # %'15d : 숫자에 콤마를 포함하여 우측 정렬
            printf "%38s %'15d\n" "$fname" "$fsize"
        fi
    done
}

# =========================================================
# 메인 로직 시작
# =========================================================

# 상단 헤더 출력
echo "------------------------------------------------------"
echo "               Disk Usages per Lecture                        "
echo "------------------------------------------------------"
printf "%-16s %-15s %5s %15s\n" "Lecture" "Directory" "Files" "Used"
echo "------------------------------------------------------"

# contents.dir 파일을 한 줄씩 읽음 (구분자 ':', 예: "Shell Script:shell")
while IFS=':' read -r lecture_name dir_name
do
    target_path="$BASE_DIR/$dir_name"
    
    # 실제 존재하는 디렉토리인 경우에만 실행
    if [ -d "$target_path" ]; then
        
        # 1. 파일 개수 세기 (폴더 내부 항목 수)
        item_count=$(ls -1 "$target_path" | wc -l)
        
        # 2. 화면 표시용 용량 (Human Readable: K, M, G 단위)
        usage_human=$(du -sh "$target_path" | awk '{print $1}')
        
        # 3. 통계 계산용 용량 (Byte 단위 정수)
        # du -sb: 해당 폴더와 내부 파일 전체의 바이트 크기 합계
        # 2>/dev/null: 권한 에러 메시지 숨김
        dir_size_bytes=$(du -sb "$target_path" 2>/dev/null | awk '{print $1}')
        
        # ---------------------------------
        # [디렉토리 통계 업데이트 로직]
        # ---------------------------------
        ((dir_sum_bytes += dir_size_bytes))
        ((dir_count++))

        # 디렉토리 최대값(Max) 갱신
        if (( dir_size_bytes > dir_max_size )); then
            dir_max_size=$dir_size_bytes
            dir_max_name=$dir_name
        fi
        # 디렉토리 최소값(Min) 갱신
        if (( dir_size_bytes < dir_min_size )); then
            dir_min_size=$dir_size_bytes
            dir_min_name=$dir_name
        fi
        
        # 강의 정보 한 줄 출력
        printf "%-16s %-15s %5d %15s\n" "$lecture_name" "$dir_name" "$item_count" "$usage_human"
        
        # [함수 호출] 내부 파일 리스트 출력 수행
        print_file_list "$target_path"
        
        # 전체 요약 변수 업데이트
        ((total_dirs_count++))
        ((total_items_count += item_count))
        target_dirs_list="$target_dirs_list $target_path"
    fi
done < "$CONTENTS_FILE"

# =========================================================
# 하단 결과 출력
# =========================================================
echo "------------------------------------------------------"

# 전체 용량 계산 (MB 단위 변환)
if [ -n "$target_dirs_list" ]; then
    # du -ck: 나열된 모든 폴더의 합계(total)를 KB 단위로 계산
    total_kb=$(du -ck $target_dirs_list 2>/dev/null | tail -1 | awk '{print $1}')
    # KB -> MB 변환 (소수점 2자리)
    total_usage=$(awk -v kb="$total_kb" 'BEGIN {printf "%.2fM", kb/1024}')
else
    total_usage="0.00M"
fi

# Total 라인 출력
printf "%-16s %-15d %5d %15s\n" "Total :" "$total_dirs_count" "$total_items_count" "$total_usage"
echo "------------------------------------------------------"

# ---------------------------------
# [결과 1] 파일 크기 통계 출력
# ---------------------------------
# 파일이 하나라도 있을 때만 평균 계산 (0으로 나누기 방지)
if [ $file_count -gt 0 ]; then
    file_avg=$((file_sum_bytes / file_count))
else
    file_avg=0
    file_min_size=0
fi

printf "%-16s  %-20s %'15d\n" "파일 크기 최대 :" "$file_max_name" "$file_max_size"
printf "%-16s  %-20s %'14d\n" "파일 크기 최소 :" "$file_min_name" "$file_min_size"
printf "%-16s  %-20s %'15d\n" "파일 크기 평균 :" "" "$file_avg"

echo "------------------------------------------------------"

# ---------------------------------
# [결과 2] 디렉토리 크기 통계 출력
# ---------------------------------
# 디렉토리가 하나라도 있을 때만 평균 계산
if [ $dir_count -gt 0 ]; then
    dir_avg=$((dir_sum_bytes / dir_count))
else
    dir_avg=0
    dir_min_size=0
fi

printf "%-16s  %-20s %'11d\n" "디렉토리 크기 최대 :" "$dir_max_name" "$dir_max_size"
printf "%-16s  %-20s %'11d\n" "디렉토리 크기 최소 :" "$dir_min_name" "$dir_min_size"
printf "%-16s  %-20s %'11d\n" "디렉토리 크기 평균 :" "" "$dir_avg"

echo "------------------------------------------------------"

exit 0
