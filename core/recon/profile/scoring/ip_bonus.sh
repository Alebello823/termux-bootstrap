#!/data/data/com.termux/files/usr/bin/bash


CLUSTER_FILE="$1"
TARGET_IP="$2"


get_count()
{
    grep "^$TARGET_IP," "$CLUSTER_FILE" \
    | awk -F',' '{print $NF}'
}


COUNT=$(get_count)


if [ -z "$COUNT" ]; then
    echo "0"
    exit
fi


if [ "$COUNT" -gt 1 ]; then
    echo "$COUNT"
else
    echo "0"
fi
