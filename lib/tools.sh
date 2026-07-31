TOOLS_GO=(
"github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest"
"github.com/projectdiscovery/httpx/cmd/httpx@latest"
"github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest"
"github.com/projectdiscovery/dnsx/cmd/dnsx@latest"
"github.com/projectdiscovery/katana/cmd/katana@latest"
"github.com/ffuf/ffuf/v2@latest"
"github.com/OJ/gobuster/v3@latest"
)


update_go_tools(){

echo "=============================="
echo " ACTUALIZANDO HERRAMIENTAS GO"
echo "=============================="


if ! command -v go >/dev/null 2>&1
then

    echo "[!] Go no encontrado"
    echo "[+] Instalando Go"

    pkg install golang -y

fi


export GOPATH="$HOME/go"
export PATH="$HOME/go/bin:$PATH"


echo "[+] Verificando Go"

go version || {
    echo "[ERROR] Go no disponible"
    return 1
}


mkdir -p "$HOME/go/bin"


for tool in "${TOOLS_GO[@]}"
do
    echo "[+] Instalando $tool"

    for retry in 1 2 3
    do
        go install "$tool" && break

        echo "[WARN] Intento $retry falló para $tool"

        sleep 10
    done

done

echo "[OK] Herramientas Go actualizadas"

}

