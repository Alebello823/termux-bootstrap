#!/data/data/com.termux/files/usr/bin/bash


INPUT="$1"


if [ ! -f "$INPUT" ]; then
    echo "[ERROR] File missing"
    exit 1
fi


echo "SERVICE INVENTORY"
echo "================="


grep "/tcp" "$INPUT" | grep open
