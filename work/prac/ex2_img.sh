#!/bin/bash

src_dir="$1"   # ./img
dest_dir="$2"  # ./new-img

# 목적지 디렉터리가 없으면 생성
if [ ! -d "$dest_dir" ]; then
    mkdir -p "$dest_dir"
fi

count=1

# 소스 디렉터리의 모든 파일에 대해 루프
for file in "$src_dir"/*
do
    # 파일명과 확장자 추출
    filename=$(basename "$file")   # 경로 제외한 파일명 (fedora-logo.png)
    # 또는 parameter expansion 사용시: filename=${file##*/}
    
    # 복사 실행 (형식: 번호-파일명)
    cp "$file" "$dest_dir/$count-$filename"
    
    # 카운트 증가
    ((count++))
done
exit 0
