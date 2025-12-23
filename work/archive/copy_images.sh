#!/bin/bash

# 입력 디렉토리와 출력 디렉토리
src_dir=$1
dst_dir=$2

# 출력 디렉토리가 없으면 생성
mkdir -p "$dst_dir"

# 카운터 초기화
count=1

# 재귀적으로 이미지 파일 찾기
find "$src_dir" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.gif" -o -name "*.tiff" -o -name "*.tif" \) | while read -r img; do
    # 파일 확장자 추출
    ext="${img##*.}"

    # 원본 파일명 추출 (경로 제외)
    filename="${img##*/}"
    # 확장자 제외한 파일명
    basename="${filename%.*}"

    # 새 파일명 생성
    # 원본파일명-원래이름-원래확장자 형식
    new_name="${count}-${basename}.${ext}"

    # 파일 복사
    cp "$img" "${dst_dir}/${new_name}"

    # 카운터 증가
    ((count++))
done