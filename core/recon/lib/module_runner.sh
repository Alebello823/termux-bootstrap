#!/data/data/com.termux/files/usr/bin/bash

BASE_DIR="$HOME/termux-bootstrap"


run_module_safe() {

    local NAME="$1"
    local SCRIPT="$2"

    echo
    echo "================================"
    echo " $NAME"
    echo "================================"

    if [ ! -f "$SCRIPT" ]; then
        echo "[WARN] Module not found: $SCRIPT"
        return 1
    fi

    chmod +x "$SCRIPT"

    local START=$(date +%s)

    # Tiempo individual por módulo
    case "$NAME" in
        WHOIS)
            LIMIT=20
            ;;
        DNS)
            LIMIT=20
            ;;
        HTTP)
            LIMIT=30
            ;;
        HEADERS)
            LIMIT=20
            ;;
        TLS)
            LIMIT=20
            ;;
        WHATWEB)
            LIMIT=40
            ;;
        NMAP)
            LIMIT=300
            ;;
        *)
            LIMIT=60
            ;;
    esac

RAW_DIR="$BASE_DIR/reports/recon/$TARGET/raw"
mkdir -p "$RAW_DIR"

timeout "$LIMIT" bash "$SCRIPT" "$TARGET" | tee "$RAW_DIR/${NAME,,}.txt"

    local EXIT_CODE=$?

    local END=$(date +%s)
    local ELAPSED=$((END-START))


    case "$EXIT_CODE" in
        0)
            echo "[OK] $NAME (${ELAPSED}s)"
            ;;
        124)
            echo "[TIMEOUT] $NAME (${ELAPSED}s)"
            ;;
        *)
            echo "[ERROR] $NAME (exit=$EXIT_CODE)"
            ;;
    esac
}
