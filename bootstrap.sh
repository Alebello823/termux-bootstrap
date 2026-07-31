#!/data/data/com.termux/files/usr/bin/bash

# =====================================
# Termux Bootstrap Loader
# Core Entry Point
# =====================================


TB_ROOT="$HOME/termux-bootstrap"


load_module(){

    MODULE="$1"

    if [ -f "$TB_ROOT/core/$MODULE" ]
    then
        source "$TB_ROOT/core/$MODULE"
    else
        echo "[ERROR] No existe módulo: $MODULE"
        return 1
    fi

}


# Cargar núcleo

load_module "constants.sh"
load_module "config.sh"
load_module "utils.sh"
load_module "logger.sh"
load_module "system.sh"
load_module "errors.sh"


log_success "Core cargado correctamente"


TB_READY=true
