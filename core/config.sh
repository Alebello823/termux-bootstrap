#!/data/data/com.termux/files/usr/bin/bash

# =====================================
# Termux Bootstrap Config Loader
# Core Module
# =====================================


TB_ROOT="$HOME/termux-bootstrap"


# Cargar constantes

if [ -f "$TB_ROOT/core/constants.sh" ]; then

    source "$TB_ROOT/core/constants.sh"

else

    echo "[ERROR] No se encontró constants.sh"
    return 1

fi


# Crear estructura necesaria

mkdir -p "$TB_LOG_DIR"
mkdir -p "$TB_CONFIG_DIR"
mkdir -p "$TB_HOME/cache"


# Estado del sistema

TB_CONFIG_LOADED=true
