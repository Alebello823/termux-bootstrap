backup_termux(){

BACKUP_DIR="$HOME/termux-backups/$(date +%Y-%m-%d_%H-%M)"

echo "=============================="
echo " TERMUX BACKUP"
echo "=============================="

mkdir -p "$BACKUP_DIR"

echo "[+] Guardando configuraciones"

cp ~/.bashrc "$BACKUP_DIR/bashrc" 2>/dev/null || true
cp ~/.profile "$BACKUP_DIR/profile" 2>/dev/null || true


echo "[+] Guardando lista de paquetes"

pkg list-installed > "$BACKUP_DIR/packages.txt"


echo "[+] Guardando herramientas Go"

if [ -d "$HOME/go/bin" ]; then
    ls "$HOME/go/bin" > "$BACKUP_DIR/go-tools.txt"
fi


echo "[+] Guardando información del sistema"

termux-info > "$BACKUP_DIR/termux-info.txt"


echo "[OK] Backup creado en:"
echo "$BACKUP_DIR"

}
