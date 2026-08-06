#!/data/data/com.termux/files/usr/bin/bash

# =========================================
# Target Profile Engine
# Centraliza toda la información del objetivo
# =========================================

BASE_DIR="$HOME/termux-bootstrap"

profile_init() {

    TARGET="$1"

    PROFILE_DIR="$BASE_DIR/reports/recon/$TARGET/profile"

    mkdir -p "$PROFILE_DIR"

    PROFILE_FILE="$PROFILE_DIR/profile.conf"

    cat > "$PROFILE_FILE" <<EOF
TARGET=$TARGET

HOSTNAME=
IP=

CDN=
CLOUDFLARE=false

ORIGIN_IP=
ORIGIN_CONFIDENCE=0

HTTP=false
HTTPS=false

SERVER=
PHP=
OPENSSL=
FRAMEWORK=

EOF

}

profile_set(){

KEY="$1"
VALUE="$2"

sed -i "s|^${KEY}=.*|${KEY}=${VALUE}|" "$PROFILE_FILE"

}

profile_get(){

KEY="$1"

grep "^${KEY}=" "$PROFILE_FILE" | cut -d= -f2-

}
