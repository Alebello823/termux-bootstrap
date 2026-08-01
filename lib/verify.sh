verify_installation(){

echo "=============================="
echo " VERIFICACIÓN FINAL"
echo "=============================="


COMMANDS=(

nmap
go
python
subfinder
httpx
nuclei
dnsx
katana
ffuf
gobuster

)


for cmd in "${COMMANDS[@]}"
do

if command -v "$cmd" >/dev/null 2>&1
then
echo "[OK] $cmd"
else
echo "[--] $cmd no encontrado"
fi

done


echo "=============================="

}
