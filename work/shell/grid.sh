#!/bin/bash
# sudo dnf install xterm wmctrl로 패키지 설치 필요

i=0
if [[ $TERM != "xterm-256color" ]]; then
	echo "current terminal is not x-terminal"
	exit 1
fi

while [[ $i -lt 4 ]]; do
    # X좌표 계산, 짝수: 0번째, 2번째 창이면 x=0
    # 홀수: 1번째, 3번째 창이면 x=260
    if [[ $((i % 2)) -eq 0 ]]; then 
    	x=0 
    else 
    	x=260 
    fi
    
    # Y좌표 계산, 0번째, 1번째 창이면 y=0
    # 2번째, 3번째 창이면 y=230
    if [[ $i -lt 2 ]]; then 
    	y=0 
    else 
    	y=230
    fi

    # --- 터미널 실행 ---
    # gnome-terminal은 Wayland 보안 정책상 위치 이동이 막히므로,
    # 호환성이 좋은 xterm을 사용하여 창을 띄움
    # -geometry 40x12 : 40x12의 창 크기 지정
    xterm -geometry 40x12 &

    # --- 대기 ---
    # 창이 생성되고 OS가 창을 인식할 때까지 0.5초 대기
    # 이 시간이 없으면 wmctrl이 창을 찾지 못할 수 있음
    sleep 0.5

    # --- 창 위치 이동 ---
    # wmctrl : 윈도우 매니저 제어 도구
    # -r :ACTIVE: : 현재 포커스가 있는(방금 뜬) 창을 선택
    # -e 0,$x,$y,-1,-1 : 계산된 x, y 좌표로 이동 (-1은 크기 변경 안 함)
    wmctrl -r :ACTIVE: -e 0,$x,$y,-1,-1

    let "i += 1"

done

exit 0
