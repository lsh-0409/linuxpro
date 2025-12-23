#!/bin/bash

# contents.dir 파일을 읽어 각 디렉터리의 파일 개수, 
# 용량을 계산하고 천 단위 콤마, MB/KB 단위 변환 등 
# 고급 포맷팅을 적용해 출력합니다.

# 인자 확인
if [ $# -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

TARGET_DIR="${1%/}"  # 입력된 경로 끝의 슬래시(/) 제거 (안전성)
CONTENTS_FILE="$TARGET_DIR/contents.dir"

# contents.dir 파일 확인
if [ ! -f "$CONTENTS_FILE" ]; then
    echo "Error: contents.dir file not found in $TARGET_DIR"
    exit 1
fi

# [함수] 숫자에 천 단위 콤마(,) 찍기 (sed 정규식 활용)
format_number() {
    echo $1 | sed ':a;s/\B[0-9]\{3\}\>/,&/;ta'
}

# [함수] 바이트(Byte) 단위를 사람이 읽기 편하게(MB 등) 변환
human_readable() {
    local size=$1

    if [ $size -ge 1048576 ]; then  # 1MB 이상이면
        # bc 명령어로 소수점 계산 (scale=2: 소수점 2자리)
        local mb=$(echo "scale=2; $size/1048576" | bc)
        printf "%.1fM" "$mb"
    else
        # 1MB 미만이면 그냥 콤마 찍어서 출력
        format_number "$size"
    fi
}

# 헤더 출력 (타이틀 중앙 정렬 로직 포함)
TITLE="Disk Usages per ${TARGET_DIR}"
echo "--------------------------------------------------"
# 타이틀 좌우 공백 계산하여 중앙 정렬
printf "%*s%s%*s\n" $(( (50 - ${#TITLE}) / 2 )) '' "$TITLE" $(( (50 - ${#TITLE} + 1) / 2 )) ''
echo "--------------------------------------------------"
printf "%-17s%-18s%5s%10s\n" "Lecture" "Directory" "Files" "Used"
echo "--------------------------------------------------"

# 전체 통계 변수
total_dirs=0
total_files=0
total_size=0

# [함수] 디렉토리 처리 로직
process_directory() {
    local line="$1"
    # 문자열 자르기로 Lecture 이름과 디렉토리명 분리
    local lecture_name="${line%:*}" # 콜론 앞부분
    local dir_name="${line#*:}"    # 콜론 뒷부분
    local dir_path="$TARGET_DIR/$dir_name"

    # 디렉토리가 아니면 리턴
    [ ! -d "$dir_path" ] && return

    # 파일 개수 및 용량 계산
    local file_count=0
    local total_bytes=0
    declare -a files # 파일명 저장 배열
    declare -a sizes # 파일크기 저장 배열

    # ls 명령 결과를 정렬해서 하나씩 처리
    while IFS= read -r file; do
        local file_path="$dir_path/$file"
        if [ -f "$file_path" ]; then
            ((file_count++))
            # stat 명령어로 정확한 바이트 크기 구하기
            local size=$(stat --format=%s "$file_path")
            ((total_bytes += size))

            # 배열에 정보 저장
            files[$file_count]="$file"
            sizes[$file_count]="$size"
        fi
    done < <(ls -1 "$dir_path" | sort) # 프로세스 치환 사용

    # 파일이 없으면 처리 중단
    [ $file_count -eq 0 ] && return

    # 디렉토리 요약 정보 출력
    printf "%-17s%-18s%5d%10s\n" \
           "$lecture_name" "$dir_name" "$file_count" "$(human_readable $total_bytes)"

    # 개별 파일 리스트 출력 (들여쓰기)
    for ((i=1; i<=file_count; i++)); do
        local formatted_size
        if [ ${sizes[$i]} -ge 1048576 ]; then
            formatted_size=$(printf "%.1fM" "$(echo "scale=1; ${sizes[$i]}/1048576" | bc)")
        else
            formatted_size=$(format_number "${sizes[$i]}")
        fi
        printf "%40s%10s\n" "${files[$i]}" "$formatted_size"
    done

    # 전체 통계 누적
    ((total_dirs++))
    ((total_files += file_count))
    ((total_size += total_bytes))
}

# contents.dir 파일을 한 줄씩 읽어서 함수 호출
while IFS= read -r line; do
    process_directory "$line"
done < "$CONTENTS_FILE"

# 푸터(총계) 출력
echo "--------------------------------------------------"
printf "%-17s%-18d%5d%10s\n" \
       "Total : " "$total_dirs" "$total_files" "$(human_readable $total_size)"