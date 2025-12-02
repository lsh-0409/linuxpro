#!/bin/bash

url="https://www.google.com"

protocol=${url%%:*}
address=${url##*/}

echo "url : $url"
echo "protocol : $protocol"
echo "address : $address"
