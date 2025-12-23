#!/bin/bash

SUM_1=0
SUM_2=0
SUM_3=0
RESULT_COUNT=0
RESULT_RESPONSE=""

while true; do
    read -p "성적 정보 입력(끝내려면 공백 입력): " RAW_INPUT;
    IFS="," read -ra SCORE <<< "$RAW_INPUT";

    if [[ -z ${SCORE[0]} ]]; then
        break;
    fi

    if (( ${SCORE[1]} < 0 )) || (( ${SCORE[1]} > 100 )); then
        echo "잘못된 성적 정보입니다. 다시 입력하세요."
        continue;
    fi

    if (( ${SCORE[2]} < 0 )) || (( ${SCORE[2]} > 100 )); then
        echo "잘못된 성적 정보입니다. 다시 입력하세요."
        continue;
    fi

    if (( ${SCORE[3]} < 0 )) || (( ${SCORE[3]} > 100 )); then
        echo "잘못된 성적 정보입니다. 다시 입력하세요."
        continue;
    fi

    SUM_1=$((SUM_1 + ${SCORE[1]}))
    SUM_2=$((SUM_2 + ${SCORE[2]}))
    SUM_3=$((SUM_3 + ${SCORE[3]}))
    RESULT_COUNT=$((RESULT_COUNT + 1))

    SUM_RECORD=$((SCORE[1] + SCORE[2] + SCORE[3]))
    SUM_RECORD_AVERAGE=$((SUM_RECORD / 3))
    RESULT_RESPONSE="${RESULT_RESPONSE}\n${SCORE[0]}, ${SCORE[1]}, ${SCORE[2]}, ${SCORE[3]}, ${SUM_RECORD}, ${SUM_RECORD_AVERAGE}"
done

echo "--- 성적표 ---"
echo -n "이름, 성적1, 성적2, 성적3, 합, 평균"
echo -e "$RESULT_RESPONSE"

if (( RESULT_COUNT > 0 )); then
    echo "--- 과목별 성적평균 ---"
    echo "과목1, 과목2, 과목3"
    echo "$((SUM_1 / RESULT_COUNT)), $((SUM_2 / RESULT_COUNT)), $((SUM_3 / RESULT_COUNT))"
fi  