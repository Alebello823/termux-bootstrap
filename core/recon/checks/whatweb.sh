#!/data/data/com.termux/files/usr/bin/bash

TARGET="$1"

echo "WHATWEB CHECK"
echo "-------------"

WHATWEB="$HOME/WhatWeb/whatweb"

if [ ! -f "$WHATWEB" ]; then
    echo "[WARN] WhatWeb not found"
    exit 0
fi

IP=$(python - <<EOF
import socket
try:
    print(socket.gethostbyname("$TARGET"))
except:
    pass
EOF
)

if [ -z "$IP" ]; then
    echo "[WARN] Cannot resolve target"
    exit 0
fi

echo "[INFO] Target IP: $IP"

ruby "$WHATWEB" \
-H "User-Agent: Mozilla/5.0" \
-H "Host: $TARGET" \
"http://$IP"

echo
echo "[OK] WhatWeb completed"
