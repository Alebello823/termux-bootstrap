#!/data/data/com.termux/files/usr/bin/bash

REPORT="$HOME/termux-bootstrap/reports/system_report.txt"

echo "================================"
echo " DOCTOR SUMMARY"
echo "================================"

echo

if grep -q "\[WARN\]" "$REPORT"; then
    echo "Warnings detected:"
    grep "\[WARN\]" "$REPORT"
else
    echo "No warnings detected"
fi

echo

grep "System Health" "$REPORT"
grep "Status" "$REPORT"
