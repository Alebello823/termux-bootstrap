#!/data/data/com.termux/files/usr/bin/bash

####################################
# COMMON FUNCTIONS
####################################

print_title() {

    echo "================================"
    echo " $1"
    echo "================================"

}

print_section() {

    echo
    echo "[+] $1"
    echo "-----------------"

}

info() {

    echo "[INFO] $1"

}

ok() {

    echo "[OK] $1"

}

warn() {

    echo "[WARN] $1"

}

error() {

    echo "[ERROR] $1"

}

separator() {

    echo

}
