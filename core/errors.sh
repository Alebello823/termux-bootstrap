#!/data/data/com.termux/files/usr/bin/bash

# =====================================
# Termux Bootstrap Error Handler
# Core Module
# =====================================


TB_ERROR_CODE=0


error_set(){

    TB_ERROR_CODE="$1"

}


error_code(){

    echo "$TB_ERROR_CODE"

}


error_message(){

    case "$1" in

        1)
            echo "Error desconocido"
            ;;

        10)
            echo "Error de red"
            ;;

        20)
            echo "Error de permisos"
            ;;

        30)
            echo "Error de paquete"
            ;;

        40)
            echo "Espacio insuficiente"
            ;;

        *)
            echo "Error no definido"
            ;;

    esac

}


raise_error(){

    CODE="$1"

    error_set "$CODE"

    echo "[ERROR $CODE] $(error_message "$CODE")"

    return "$CODE"

}
