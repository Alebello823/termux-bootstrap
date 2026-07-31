#!/data/data/com.termux/files/usr/bin/bash

REPORT="$HOME/termux-bootstrap/reports/security_report.txt"

SCORE=100

echo "================================"
echo " SECURITY SCORE"
echo "================================"

if grep -q "\[WARN\]" "$REPORT"
then
    SCORE=$((SCORE-10))
fi

if grep -q "\[ERROR\]" "$REPORT"
then
    SCORE=$((SCORE-25))
fi

echo
echo "Security Level: $SCORE/100"

if [ "$SCORE" -ge 90 ]
then
    echo "Status: HIGH"
elif [ "$SCORE" -ge 70 ]
then
    echo "Status: MEDIUM"
else
    echo "Status: LOW"
fi
