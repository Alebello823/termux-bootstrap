#!/data/data/com.termux/files/usr/bin/bash

# =====================================
# Termux Bootstrap Recon Config
# Feature Flags para Módulos
# =====================================

# Módulos de reconocimiento pasivo
ENABLE_WHOIS=true
ENABLE_DNS=true

# Módulos de reconocimiento web
ENABLE_HTTP=true
ENABLE_HEADERS=true
ENABLE_TLS=true
ENABLE_WHATWEB=true

# Módulo de escaneo de puertos
ENABLE_NMAP=true

# Auto-análisis post-escaneo
ENABLE_ANALYSIS=true

# Módulos de explotación (requieren autorización)
ENABLE_BRUTEFORCE=false
ENABLE_EXPLOIT_SEARCH=true

# Web vulnerability scanner
ENABLE_WEBSCAN=true
