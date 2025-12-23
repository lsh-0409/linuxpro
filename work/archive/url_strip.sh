#!/bin/bash

# Store the URL from command line argument
url=$1

# Format string for printf
format="%-10s: %s\n"

# Print the full URL
printf "$format" "url" "$url"

# Extract protocol (remove everything after ://)
protocol=${url%%://*}
printf "$format" "protocol" "$protocol"

# Extract host (remove protocol:// from start, then everything after next : or /)
temp=${url#*://}
host=${temp%%[/:]*}
printf "$format" "host" "$host"

# Extract port (remove everything before : and after /)
temp=${url#*:}       # remove everything before first :
temp=${temp#*:}      # remove everything before second : (for protocol)
port=${temp%%/*}     # remove everything after /
printf "$format" "port" "$port"

# Extract app (remove everything before last / and after ?)
temp=${url##*/}      # remove everything before last /
app=${temp%%\?*}     # remove everything after ?
printf "$format" "app" "$app"

# Extract query (remove everything before ?)
query=${url#*\?}
printf "$format" "query" "$query"