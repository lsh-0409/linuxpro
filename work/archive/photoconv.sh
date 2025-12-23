#!/bin/bash

# 사용법 출력 함수
usage() {
    echo "사용법: $0 -t <변환타입> <소스디렉토리> <결과디렉토리>"
    echo "변환타입: id(증명사진), passport(여권사진), bw(흑백사진), light(순하게), dark(진하게), edge(외곽선)"
    exit 1
}

# 인자 개수 확인
if [ $# -ne 4 ]; then
    echo "오류: 잘못된 인자 개수입니다."
    usage
fi

# 옵션 파싱
while getopts "t:" opt; do
    case $opt in
        t) TYPE=$OPTARG ;;
        *) usage ;;
    esac
done

# 나머지 인자 처리
shift $((OPTIND-1))
SRC_DIR=$1
DEST_DIR=$2

# 변환 타입 검증
case $TYPE in
    id|passport|bw|light|dark|edge) ;;
    *) echo "오류: 잘못된 변환 타입입니다."; usage ;;
esac

# 디렉토리 존재 확인
if [ ! -d "$SRC_DIR" ]; then
    echo "오류: 소스 디렉토리가 존재하지 않습니다: $SRC_DIR"
    exit 1
fi

# 결과 디렉토리 생성
mkdir -p "$DEST_DIR"

# ImageMagick 설치 확인
if ! command -v magick &> /dev/null; then
    echo "오류: ImageMagick이 설치되어 있지 않습니다."
    exit 1
fi

# 이미지 파일 확인 함수
check_image() {
    local file=$1
    # file 명령어로 실제 이미지 파일인지 확인
    if ! file "$file" | grep -qiE 'image|bitmap'; then
        return 1
    fi
    return 0
}

# 디스크 공간 확인 함수
check_disk_space() {
    local dir=$1
    local required_space=$2
    local available_space=$(df -k "$dir" | awk 'NR==2 {print $4}')
    if [ "$available_space" -lt "$required_space" ]; then
        return 1
    fi
    return 0
}

# 이미지 변환 함수
convert_image() {
    local input=$1
    local output=$2
    
    # 입력 파일 검증
    if [ ! -r "$input" ]; then
        echo "오류: 파일 읽기 권한이 없습니다: $input"
        return 1
    fi
    
    # 실제 이미지 파일인지 확인
    if ! check_image "$input"; then
        echo "오류: 유효하지 않은 이미지 파일입니다: $input"
        return 1
    }
    
    # 출력 디렉토리 쓰기 권한 확인
    if [ ! -w "$(dirname "$output")" ]; then
        echo "오류: 결과 디렉토리에 쓰기 권한이 없습니다"
        return 1
    }
    
    # 기존 파일 존재 여부 확인
    if [ -f "$output" ]; then
        echo "경고: 기존 파일을 덮어씁니다: $output"
    }
    
    # 변환 시도
    if ! timeout 300 magick "$input" -limit memory 1GB -limit map 2GB \
        convert_options "$output" 2>/dev/null; then
        echo "오류: 이미지 변환 실패: $input"
        return 1
    fi
    
    return 0
}

# 메인 처리 부분
echo "변환 시작..."
count=0
errors=0
skipped=0

# 최소 디스크 공간 확인 (예: 1GB)
if ! check_disk_space "$DEST_DIR" 1048576; then
    echo "오류: 디스크 공간이 부족합니다"
    exit 1
fi

# 파일 개수 제한 (예: 최대 1000개)
max_files=1000
file_count=$(find "$SRC_DIR" -maxdepth 1 -type f | wc -l)
if [ "$file_count" -gt "$max_files" ]; then
    echo "오류: 처리할 파일이 너무 많습니다 (최대: $max_files)"
    exit 1
fi

# 이미지 처리
for img in "$SRC_DIR"/*.{jpg,jpeg,png,JPG,JPEG,PNG}; do
    [ -f "$img" ] || continue
    
    filename=$(basename "$img")
    output="$DEST_DIR/${filename%.*}_${TYPE}.${filename##*.}"
    
    if convert_image "$img" "$output"; then
        ((count++))
        echo "변환 완료: $filename"
    else
        ((errors++))
        echo "변환 실패: $filename"
    fi
    
    # 주기적으로 프로그레스 표시
    if [ $((count % 10)) -eq 0 ]; then
        echo "진행 중... ($count 파일 처리됨)"
    fi
done

# 결과 출력
echo "처리 완료"
echo "성공: $count 파일"
echo "실패: $errors 파일"

if [ $count -eq 0 ]; then
    echo "경고: 처리된 이미지가 없습니다."
    exit 1
fi

exit 0

