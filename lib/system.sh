check_system(){

echo "[+] Sistema"

echo "Android:"
getprop ro.build.version.release

echo "Arquitectura:"
uname -m

echo "Termux:"
echo $PREFIX

echo "Espacio:"
df -h $HOME | tail -1

echo "Memoria:"
cat /proc/meminfo | grep MemAvailable

}
