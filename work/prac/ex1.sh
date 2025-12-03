#!/bin/bash

url=$1

# 1. 전체 URL 출력
echo "url : $url"

# 2. Protocol 추출 (:// 앞부분)
# %%: 뒤에서부터 패턴(://*)과 일치하는 가장 긴 부분을 제거 [참고: 308-shell-img-etc.pptx, p.5, 10]
protocol=${url%%://*}
echo "protocol : $protocol"

# 남은 문자열 정의 (프로토콜 제거)
# #: 앞에서부터 패턴(*://)과 일치하는 가장 짧은 부분을 제거 [참고: 308-shell-img-etc.pptx, p.4]
url=${url#*://}

# 3. Host 추출 (: 앞부분)
# %%: 뒤에서부터 :로 시작하는 패턴 제거
host=${url%%:*}
echo "host : $host"

# 남은 문자열 갱신 (호스트 제거)
url=${url#*:}

# 4. Port 추출 (/ 앞부분)
# %%: 뒤에서부터 /로 시작하는 패턴 제거
port=${url%%/*}
echo "port : $port"

# 남은 문자열 갱신 (포트 제거)
url=${url#*/}

# 5. App 추출 (? 앞부분)
# ?: 와일드카드이므로 \?로 이스케이프 처리하여 리터럴 문자로 인식시킴
app=${url%%\?*}
echo "app : $app"

# 6. Query 추출 (? 뒷부분)
# #: 앞에서부터 ?까지 제거
query=${url#*\?}
echo "query : $query"
