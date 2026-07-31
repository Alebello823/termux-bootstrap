repair_termux(){

echo "=============================="
echo " TERMUX REPAIR SYSTEM"
echo "=============================="

echo "[+] Revisando variables"

export LD_PRELOAD=""
export LD_LIBRARY_PATH=""

if [ ${#PATH} -gt 1000 ]; then

    echo "[WARN] PATH demasiado largo"

    export PATH="/data/data/com.termux/files/usr/bin:/system/bin"

else

    echo "[OK] PATH correcto"

fi


echo "[+] Revisando Go"

if [ -d "$HOME/go/bin" ]; then

    echo "[OK] Go directory existe"

else

    mkdir -p "$HOME/go/bin"

fi


echo "[+] Limpiando cache de paquetes"

apt clean || true


echo "[OK] Reparación terminada"

}
