#!/bin/bash
# 입력한 점수 평균계산
SCORE=0
AVERAGE=0
SUM=0
NUM=0

while true; do
	echo -n " 점수 입력 [0-100] "
	echo -n " ('q' for quit): "
	read SCORE;
	if (( $SCORE < 0 )) || (( $SCORE > 100 )); then
		echo "다시 입력하세요: "
	elif [[ $SCORE == "q" ]]; then
		echo "평균 = $AVERAGE"
		break
	else
		SUM=$(($SUM + $SCORE))
		NUM=$(($NUM + 1))	
		AVERAGE=$(($SUM / $NUM))
	fi
done
exit 0
