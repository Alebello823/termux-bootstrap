#!/data/data/com.termux/files/usr/bin/bash

BASE_DIR="$HOME/termux-bootstrap"
REPORT="$BASE_DIR/reports/security_report.txt"

mkdir -p "$BASE_DIR/reports"

echo "================================" > "$REPORT"
echo " TERMUX SECURITY REPORT" >> "$REPORT"
echo "================================" >> "$REPORT"

echo "" >> "$REPORT"
echo "[+] ENVIRONMENT" >> "$REPORT"
bash "$BASE_DIR/core/security/audit.sh" >> "$REPORT"

echo "" >> "$REPORT"
echo "[+] SECURITY SCORE" >> "$REPORT"
bash "$BASE_DIR/core/security/score.sh" >> "$REPORT"
echo "Generated:"
date >> "$REPORT"

echo "[OK] Security report generated:"
echo "$REPORT"
