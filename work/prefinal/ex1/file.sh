#!/bin/bash

file="backup.tar.gz"

# 1. 순수 파일명 추출 (확장자 전체 날리기)
# %% : 뒤에서부터 패턴과 일치하는 부분을 "가장 길게" 제거
# .* : .tar.gz 전체가 매칭됨 (가장 왼쪽의 .부터 끝까지)
filename=${file%%.*}
# 결과: "backup"
# (만약 %.* 를 썼다면 가장 오른쪽 .gz만 날아가서 "backup.tar"가 됨 -> 오답)

# 2. 전체 확장자 추출 (파일명만 날리기)
# #  : 앞에서부터 패턴과 일치하는 부분을 "가장 짧게" 제거
# *. : "backup." 까지 매칭됨 (가장 왼쪽의 .까지)
extension=${file#*.}
# 결과: "tar.gz"
# (만약 ##*. 를 썼다면 가장 오른쪽 .까지 날아가서 "gz"만 남음)

echo "Filename : $filename"
echo "Extension : $extension"
