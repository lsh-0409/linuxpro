#!/bin/bash
# 이미지 파일 변환 

for fname in $( ls $1 ) ; do
	echo $fname
	#new_fname="$(basename $fname .png)"
	# 변경: ${fname%.*} 구문은 파일의 마지막 점(.)과 그 뒤의 확장자를 모두 제거
	new_fname="${fname%.*}"
	echo $new_fname
	magick "$1"/"$fname" -resize "300x500!" "$2"/"$new_fname".png
	
	if [[ $? -eq 0 ]]; then
		echo "... 변환 성공"
	else
		echo "... 실패"
	fi
done
exit 0
