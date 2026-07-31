#!/data/data/com.termux/files/usr/bin/bash

# =====================================
# Termux Bootstrap Constants
# Core Module
# =====================================


# Identidad del proyecto

TB_NAME="Termux Bootstrap"

TB_VERSION="0.1.0"

TB_AUTHOR="Alejandro Bello Dieguez"


# Directorios principales

TB_HOME="$HOME/termux-bootstrap"

TB_LOG_DIR="$TB_HOME/logs"

TB_CONFIG_DIR="$TB_HOME/config"

TB_BACKUP_DIR="$HOME/termux-backups"


# Configuración general

TB_DEFAULT_RETRIES=3

TB_DEFAULT_TIMEOUT=30


# Sistema

TB_PLATFORM="termux"

TB_ARCH="$(uname -m)"

TB_KERNEL="$(uname -r)"
