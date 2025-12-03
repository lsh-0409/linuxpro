#!/bin/bash

src_dir="$1"  # data2
dest_dir="$2" # bmp

if [ ! -d "$dest_dir" ]; then
    mkdir "$dest_dir"
fi

for file in $src_dir/*
do
    # 파일명만 추출
    filename=$(basename "$file")

    # 확장자 제거 (이름만 추출)
    # [참고: 308-shell-img-etc.pptx, 3p, Slide 1105]
    # 뒤에서부터 .* 패턴을 제거하여 이름만 남김
    name_only=${filename%.*}

    # 변환 및 저장 (convert 명령어 사용, 혹은 단순 이름 변경 mv/cp)
    # 문제 의도가 '형식 변환'이므로 convert 명령(ImageMagick) 사용이 적절하나,
    # 교안 범위 내 명령어만 쓴다면 cp로 이름만 바꾸는 방식일 수 있음.
    # 여기서는 교안의 mvimg.sh(13p) 로직을 따라 cp 사용
    cp "$file" "$dest_dir/$name_only.bmp"
done
exit 0
