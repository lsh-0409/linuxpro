
#!/bin/bash

src_dir="$1"
dest_dir="$2"

# 예외처리: 인자 개수 확인
if [ $# -ne 2 ]; then
    echo "Usage: $0 <source_dir> <dest_dir>"
    exit 1
fi

# 예외처리: 소스 디렉터리 존재 확인
if [ ! -d "$src_dir" ]; then
    echo "Error: $src_dir is not a directory."
    exit 1
fi

mkdir -p "$dest_dir"
count=1

# find 명령어로 파일만 검색 (서브디렉터리 포함)
# 여기서는 모든 파일을 찾고 루프 안에서 file 명령어로 이미지 여부 판별
find "$src_dir" -type f | while read file
do
    # 파일 타입 확인 (이미지인지 체크)
    # file 명령어의 결과에 "image" 텍스트가 있는지 확인 (grep)
    is_image=$(file -b --mime-type "$file" | grep "image")
    
    if [ -n "$is_image" ]; then
        filename=$(basename "$file")
        name_only=${filename%.*}
        ext=${filename##*.}
        
        # 대상 파일명 설정
        target_name="$count-$name_only.png"
        
        # 이미 png인 경우 변환 없이 복사, 아니면 convert
        if [ "$ext" == "png" ] || [ "$ext" == "PNG" ]; then
            cp "$file" "$dest_dir/$target_name"
        else
            magick "$file" "$dest_dir/$target_name"
        fi
        
        ((count++))
    fi
done
exit 0
