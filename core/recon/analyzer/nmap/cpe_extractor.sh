#!/data/data/com.termux/files/usr/bin/bash

BASE_DIR="$HOME/termux-bootstrap"

TARGET="$1"

if [ -z "$TARGET" ]; then
    echo "[ERROR] Target missing"
    exit 1
fi


REPORT_DIR="$BASE_DIR/reports/recon/$TARGET/nmap"

XML="$REPORT_DIR/services.xml"
OUTPUT="$REPORT_DIR/cpe_inventory.txt"


if [ ! -f "$XML" ]; then
    echo "[ERROR] services.xml not found"
    exit 1
fi


echo "================================"
echo " CPE INVENTORY"
echo "================================"


echo "TARGET: $TARGET" > "$OUTPUT"
echo >> "$OUTPUT"


grep -o 'cpe:/[^"]*' "$XML" | sort -u | while read cpe
do

    echo "[CPE] $cpe" | tee -a "$OUTPUT"

done


echo
echo "[OK] CPE inventory generated"
echo "$OUTPUT"
