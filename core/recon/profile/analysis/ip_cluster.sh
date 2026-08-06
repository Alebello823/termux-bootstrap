#!/data/data/com.termux/files/usr/bin/bash

INPUT="$1"
OUTPUT="$2"


if [ ! -f "$INPUT" ]; then
    echo "[ERROR] Input missing"
    exit 1
fi


echo "IP,Assets,Count" > "$OUTPUT"


awk -F',' '
NR>1 && $2!="N/A" {
    ip[$2]=ip[$2]","$1
    count[$2]++
}

END {
    for (i in ip) {
        assets=substr(ip[i],2)
        print i",\""assets"\","count[i]
    }
}

' "$INPUT" >> "$OUTPUT"


echo "[OK] IP clustering completed"
