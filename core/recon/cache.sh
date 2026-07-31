#!/data/data/com.termux/files/usr/bin/bash

BASE_DIR="$HOME/termux-bootstrap"

CACHE_DIR="$BASE_DIR/core/recon/cache"

mkdir -p "$CACHE_DIR"

cache_file() {

    local TARGET="$1"
    local MODULE="$2"

    mkdir -p "$CACHE_DIR/$TARGET"

    echo "$CACHE_DIR/$TARGET/$MODULE.txt"

}

cache_save() {

    local TARGET="$1"
    local MODULE="$2"

    cat > "$(cache_file "$TARGET" "$MODULE")"

}

cache_load() {

    local TARGET="$1"
    local MODULE="$2"

    cat "$(cache_file "$TARGET" "$MODULE")" 2>/dev/null

}

cache_exists() {

    local TARGET="$1"
    local MODULE="$2"

    [ -f "$(cache_file "$TARGET" "$MODULE")" ]

}

cache_remove() {

    local TARGET="$1"
    local MODULE="$2"

    rm -f "$(cache_file "$TARGET" "$MODULE")"

}
