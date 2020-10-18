#!/bin/bash

while true; do
  sleep 3
  curl -s traefik:8080/api \
    | jq '..|.rule?|select(.!=null)' -r \
    | sed 's@Host:\(.*\)@<li><a href="http://\1">\1</a>@' \
    > /html/index.html
done