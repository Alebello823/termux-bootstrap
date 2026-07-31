#!/data/data/com.termux/files/usr/bin/bash

TARGET="$1"

echo "HEADERS CHECK"
echo "-------------"

curl -s -I "https://$TARGET" | grep -Ei \
"server|strict-transport|content-security|x-frame|x-content|referrer"
