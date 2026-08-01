install_security_tools(){

echo "[+] Instalando herramientas de seguridad"

mkdir -p "$HOME/tools"

export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

TOOLS=(

github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

github.com/projectdiscovery/httpx/cmd/httpx@latest

github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest

github.com/projectdiscovery/dnsx/cmd/dnsx@latest

github.com/projectdiscovery/katana/cmd/katana@latest

github.com/ffuf/ffuf/v2@latest

github.com/OJ/gobuster/v3@latest

)

for tool in "${TOOLS[@]}"
do
    echo "[+] Instalando $tool"
    go install "$tool" || echo "[WARN] Falló $tool"
done


echo "[+] Instalando Nikto"

cd "$HOME/tools"

if [ ! -d nikto ]; then
    git clone https://github.com/sullo/nikto.git
fi


echo "[OK] Herramientas instaladas"

}
