#!/bin/bash

# 사용법을 출력하는 함수
print_usage() {
    echo "사용법: $0 <파일명>"
    echo "파일의 종류를 확인하고 분석하는 스크립트입니다."
    exit 1
}

# 매개변수 체크
if [ $# -ne 1 ]; then
    print_usage
fi

FILE="$1"

# 파일 존재 여부 확인
if [ ! -e "$FILE" ]; then
    echo "에러: '$FILE' 이 존재하지 않습니다."
    exit 1
fi

echo "파일 분석 결과: $FILE"
echo "----------------------------------------"

# 파일의 기본 정보 가져오기 (BSD와 GNU 모두 지원)
if stat --version 2>/dev/null | grep -q GNU; then
    # GNU stat
    PERMS=$(stat -c "%A" "$FILE")
    OWNER=$(stat -c "%U:%G" "$FILE")
    MTIME=$(stat -c "%y" "$FILE")
else
    # BSD stat
    PERMS=$(stat -f "%Sp" "$FILE")
    OWNER=$(stat -f "%Su:%Sg" "$FILE")
    MTIME=$(stat -f "%Sm" "$FILE")
fi

# 파일 종류 확인
if [ -f "$FILE" ]; then
    echo "타입: 일반 파일"
    
    # file 명령어로 파일 종류 상세 분석
    FILE_TYPE=$(file -b "$FILE")
    echo "파일 종류: $FILE_TYPE"
    
    # 실행 권한 확인
    if [ -x "$FILE" ]; then
        echo "실행 권한: 있음"
    else
        echo "실행 권한: 없음"
    fi
    
    # 파일 크기 확인
    SIZE=$(stat -f "%z" "$FILE" 2>/dev/null || stat -c "%s" "$FILE")
    echo "파일 크기: $SIZE bytes"
    
    # 심볼릭 링크 확인
    if [ -L "$FILE" ]; then
        LINK_TARGET=$(readlink "$FILE")
        echo "심볼릭 링크 -> $LINK_TARGET"
    fi

elif [ -d "$FILE" ]; then
    echo "타입: 디렉토리"
    # 디렉토리 내 항목 수 계산 (숨김 파일 포함)
    FILE_COUNT=$(ls -A "$FILE" | wc -l | tr -d ' ')
    echo "포함된 항목 수: $FILE_COUNT"

elif [ -b "$FILE" ]; then
    echo "타입: 블록 장치"
    # 장치 정보 출력
    DEVICE_INFO=$(stat -c "%t,%T" "$FILE" 2>/dev/null || stat -f "%Hr,%Lr" "$FILE")
    echo "장치 번호: $DEVICE_INFO"

elif [ -c "$FILE" ]; then
    echo "타입: 문자 장치"
    # 장치 정보 출력
    DEVICE_INFO=$(stat -c "%t,%T" "$FILE" 2>/dev/null || stat -f "%Hr,%Lr" "$FILE")
    echo "장치 번호: $DEVICE_INFO"

elif [ -p "$FILE" ]; then
    echo "타입: 파이프"

elif [ -S "$FILE" ]; then
    echo "타입: 소켓"
fi

# 공통 정보 출력
echo "권한: $PERMS"
echo "소유자:그룹: $OWNER"
echo "마지막 수정: $MTIME"