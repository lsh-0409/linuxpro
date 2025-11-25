#!/bin/bash

# 시작 위치 (0, 0)
x=0
y=0
i=0
if [[ $TERM != "xterm-256color" ]]; then
	echo "current terminal is not x-terminal"
	exit 1
fi

while [[ $i -lt 4 ]]; do
    # --geometry 옵션으로 위치를 변수($x, $y)로 지정
    # 40x12는 창 크기, +$x+$y는 위치
    gnome-terminal --geometry=40x12+$x+$y &
    
    # 다음 창은 50픽셀씩 오른쪽, 아래로 이동
    let "x += 50"
    let "y += 50"
    let "i += 1"
done

exit 0
