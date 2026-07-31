#!/data/data/com.termux/files/usr/bin/bash

REPORT_DIR="$(dirname "$0")/../../reports"
REPORT="$REPORT_DIR/system_report.txt"

mkdir -p "$REPORT_DIR"

echo "==============================" > "$REPORT"
echo " TERMUX BOOTSTRAP REPORT" >> "$REPORT"
echo "==============================" >> "$REPORT"
echo "" >> "$REPORT"

echo "[+] HARDWARE" >> "$REPORT"
bash "$(dirname "$0")/hardware.sh" >> "$REPORT" 2>&1

echo "" >> "$REPORT"
echo "[+] NETWORK" >> "$REPORT"
bash "$(dirname "$0")/network.sh" >> "$REPORT" 2>&1

echo "" >> "$REPORT"
echo "[+] TOOLS" >> "$REPORT"
bash "$(dirname "$0")/tools.sh" >> "$REPORT" 2>&1


echo ""
echo "[OK] Report generated:"
echo "$REPORT"
