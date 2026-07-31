#!/data/data/com.termux/files/usr/bin/bash

# =====================================
# Termux Bootstrap Logger
# Core Module
# =====================================


LOG_DIR="$HOME/termux-bootstrap/logs"
LOG_FILE="$LOG_DIR/tb.log"


mkdir -p "$LOG_DIR"


_timestamp(){
    date "+%Y-%m-%d %H:%M:%S"
}


_write_log(){

    LEVEL="$1"
    MESSAGE="$2"

    TIME=$(_timestamp)

    echo "[$TIME] [$LEVEL] $MESSAGE" | tee -a "$LOG_FILE"

}


log_info(){

    _write_log "INFO" "$1"

}


log_success(){

    _write_log "OK" "$1"

}


log_warn(){

    _write_log "WARN" "$1"

}


log_error(){

    _write_log "ERROR" "$1"

}


log_debug(){

    _write_log "DEBUG" "$1"

}
