#!/data/data/com.termux/files/usr/bin/bash

DIR="$1"

echo "MERGING SOURCES"
echo "---------------"

OUT="$DIR/merged.txt"

> "$OUT"

for FILE in \
"$DIR/subfinder.txt" \
"$DIR/hackertarget.txt"
do

    [ -f "$FILE" ] || continue

    NAME=$(basename "$FILE" .txt)

    while read LINE
    do

        [ -z "$LINE" ] && continue

        echo "$LINE,$NAME" >> "$OUT"

    done < "$FILE"

done

sort -u "$OUT" -o "$OUT"

echo "[INFO] Entries: $(wc -l < "$OUT")"

echo "[OK] Merge completed"
