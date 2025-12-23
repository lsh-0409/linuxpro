#!/bin/bash

# 입력 예시: ftp://korea:1234@myserver.com:8080/index.html
url="ftp://korea:1234@myserver.com:8080/index.html"

# 1. 프로토콜 제거 (:// 앞부분 날리기)
# #  : 앞에서부터 제거
# *:// : "ftp://" 부분과 일치
temp=${url#*://}
# 결과 temp: "korea:1234@myserver.com:8080/index.html"

# 2. 호스트 부분 제거 (뒷부분 날리기)
# %% : 뒤에서부터 "가장 길게" 제거 (마지막 @가 아님에 주의, 여기선 @가 하나라 상관없지만 습관적으로 %% 사용)
# @* : "@myserver..." 뒷부분 전체와 일치
auth_info=${temp%%@*}
# 결과 auth_info: "korea:1234" (이제 아이디:비번만 남음)

# 3. ID 분리 (: 뒷부분을 날림)
# %  : 뒤에서부터 제거 (짧게)
# :* : ":1234" 부분과 일치
user=${auth_info%:*}
# 결과 user: "korea"

# 4. PW 분리 (: 앞부분을 날림)
# #  : 앞에서부터 제거 (짧게)
# *: : "korea:" 부분과 일치
pass=${auth_info#*:}
# 결과 pass: "1234"

echo "User : $user"
echo "Pass : $pass"
