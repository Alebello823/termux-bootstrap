#!/data/data/com.termux/files/usr/bin/bash

echo "SSH CHECK"
echo "---------"

if [ -d "$HOME/.ssh" ]; then
    echo "[OK] SSH directory exists"

    if [ -f "$HOME/.ssh/id_ed25519" ]; then
        echo "[OK] ED25519 key detected"
    else
        echo "[INFO] No ED25519 key found"
    fi

else
    echo "[INFO] SSH directory not found"
fi
