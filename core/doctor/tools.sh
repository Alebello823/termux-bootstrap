#!/data/data/com.termux/files/usr/bin/bash

source "$(dirname "$0")/../logger.sh"

echo "=============================="
echo " TOOLS CHECK"
echo "=============================="

check_tool(){
    if command -v "$1" >/dev/null 2>&1
    then
        echo "[OK] $1"
    else
        echo "[WARN] $1 missing"
    fi
}


TOOLS=(
git
go
python
python3
nuclei
subfinder
httpx
gobuster
ffuf
)


for tool in "${TOOLS[@]}"
do
    check_tool "$tool"
done


log_info "Tools check completed"
