setup_python(){

echo "[+] Configurando Python"

if command -v python >/dev/null 2>&1; then

    python --version

    mkdir -p "$HOME/projects"

    if [ ! -d "$HOME/projects/venv" ]; then
        python -m venv "$HOME/projects/venv" || true
    fi

    echo "[OK] Python preparado"

else

    echo "[ERROR] Python no instalado"

fi

}
