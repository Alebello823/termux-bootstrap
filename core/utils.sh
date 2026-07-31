#!/data/data/com.termux/files/usr/bin/bash

# =====================================
# Termux Bootstrap Utils
# Core Module
# =====================================


# Verificar si un comando existe

command_exists(){

    command -v "$1" >/dev/null 2>&1

}


# Pausa visual

pause(){

    read -p "Presiona Enter para continuar..."

}


# Reintentos automáticos

retry(){

    local attempts=$1
    shift

    local count=1

    until "$@"
    do

        if [ "$count" -ge "$attempts" ]
        then
            return 1
        fi

        echo "Intento $count falló. Reintentando..."

        count=$((count+1))

        sleep 3

    done

}


# Crear carpeta si no existe

ensure_dir(){

    mkdir -p "$1"

}


# Verificar conexión básica

check_internet(){

    ping -c 1 -W 3 8.8.8.8 >/dev/null 2>&1

}
