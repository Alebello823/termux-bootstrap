update_system(){

echo "=============================="
echo " TERMUX UPDATE"
echo "=============================="


echo "[+] Actualizando paquetes"

pkg update -y
pkg upgrade -y


echo "[+] Actualizando herramientas"

source "$HOME/termux-bootstrap/lib/tools.sh"

update_go_tools


echo "[+] Actualizando Nuclei"

if command -v nuclei >/dev/null 2>&1
then
    nuclei -update-templates
fi


echo "[+] Limpiando"

apt clean


echo "=============================="
echo " ACTUALIZACIÓN COMPLETA"
echo "=============================="


}
