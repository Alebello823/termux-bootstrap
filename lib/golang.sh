setup_go(){

echo "[+] Configurando Go"

mkdir -p "$HOME/go/bin"

export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

if command -v go >/dev/null 2>&1; then
    echo "[OK] Go instalado"
    go version
else
    echo "[ERROR] Go no encontrado"
fi

}
