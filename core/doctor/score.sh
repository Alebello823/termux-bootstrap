#!/data/data/com.termux/files/usr/bin/bash

REPORT="$HOME/termux-bootstrap/reports/system_report.txt"

TOTAL=100

echo "=============================="
echo " TERMUX HEALTH SCORE"
echo "=============================="

if grep -q "\[WARN\]" "$REPORT"
then
    TOTAL=$((TOTAL-10))
fi

if grep -q "\[ERROR\]" "$REPORT"
then
    TOTAL=$((TOTAL-30))
fi


echo ""
echo "System Health: $TOTAL/100"


if [ "$TOTAL" -ge 90 ]
then
    echo "Status: EXCELLENT"
elif [ "$TOTAL" -ge 70 ]
then
    echo "Status: GOOD"
elif [ "$TOTAL" -ge 50 ]
then
    echo "Status: WARNING"
else
    echo "Status: CRITICAL"
fi
