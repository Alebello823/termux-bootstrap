#!/data/data/com.termux/files/usr/bin/bash

echo "PERMISSIONS CHECK"
echo "----------------"

PERM=$(stat -c "%a" "$HOME")

if [ "$PERM" = "700" ]; then
    echo "[OK] Home permissions secure: $PERM"
else
    echo "[WARN] Home permissions: $PERM"
fi
