#!/data/data/com.termux/files/usr/bin/bash

INPUT="$1"
OUTPUT="$2"

echo "NORMALIZE"
echo "---------"

if [ ! -f "$INPUT" ]; then
    echo "[ERROR] merged file not found"
    exit 1
fi

awk -F',' '
{

    subdomain=$1
    ip=""
    source=""

    if (NF==2) {
        source=$2
    }

    if (NF>=3) {
        ip=$2
        source=$3
    }

    key=subdomain

    if (!(key in ips))
        ips[key]=ip

    if (ips[key]=="" && ip!="")
        ips[key]=ip

    if (sources[key]=="")
        sources[key]=source
    else if (index(sources[key],source)==0)
        sources[key]=sources[key]"|"source

}

END{

    print "Subdomain,IP,Sources"

    for (k in sources)
        print k","ips[k]","sources[k]

}
' "$INPUT" | sort > "$OUTPUT"

echo "[INFO] Output: $OUTPUT"

echo "[OK] Normalize completed"
